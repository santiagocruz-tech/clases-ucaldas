# Capítulo 13: Kotlin avanzado

## Objetivo

Aprender características avanzadas de Kotlin que hacen el código más limpio y expresivo: coroutines a fondo, sealed classes, extension functions, lambdas y scope functions. Aplicaremos todo en MisFinanzas.

---

## 13.1 Coroutines a fondo

Ya usamos coroutines con `viewModelScope.launch`. Ahora vamos a entender cómo funcionan.

### ¿Qué es una coroutine?

Una coroutine es una forma de ejecutar código de forma asíncrona sin bloquear el hilo principal. Es el equivalente a `async`/`await` en Dart/JavaScript.

```kotlin
// Una función "suspend" puede pausarse sin bloquear el hilo
// Solo se puede llamar desde otra función suspend o desde una coroutine
suspend fun obtenerDatos(): String {
    // delay pausa la coroutine por 2 segundos SIN bloquear el hilo
    // Es diferente a Thread.sleep() que SÍ bloquea el hilo
    delay(2000)
    return "Datos obtenidos"
}

// launch inicia una coroutine
// viewModelScope.launch se cancela automáticamente cuando el ViewModel se destruye
viewModelScope.launch {
    val datos = obtenerDatos()  // se pausa aquí 2 segundos
    // Cuando obtenerDatos() termina, continúa en el hilo principal
    binding.tvResultado.text = datos
}
```

### Dispatchers: en qué hilo se ejecuta

```kotlin
// Dispatchers.Main = hilo principal (UI)
// Usar para: actualizar vistas, mostrar datos
viewModelScope.launch(Dispatchers.Main) {
    binding.tvEstado.text = "Cargando..."
}

// Dispatchers.IO = hilo de entrada/salida
// Usar para: llamadas de red, lectura/escritura de archivos, base de datos
viewModelScope.launch(Dispatchers.IO) {
    val datos = apiService.obtenerDatos()
}

// Dispatchers.Default = hilo de cómputo
// Usar para: cálculos pesados, ordenamiento de listas grandes
viewModelScope.launch(Dispatchers.Default) {
    val ordenado = listaGrande.sortedBy { it.fecha }
}
```

### withContext: cambiar de hilo dentro de una coroutine

```kotlin
// withContext cambia temporalmente el hilo de ejecución
// Es la forma más común de combinar trabajo de UI con trabajo de red
viewModelScope.launch {
    // Estamos en Main (hilo principal)
    binding.progressBar.visibility = View.VISIBLE

    // Cambiar a IO para la llamada de red
    val resultado = withContext(Dispatchers.IO) {
        // Estamos en IO (hilo de red)
        apiService.obtenerUsuarios()
    }

    // Volvemos a Main automáticamente
    binding.progressBar.visibility = View.GONE
    // submitList() es un método de ListAdapter (una variante más avanzada del Adapter)
    // En nuestro TransaccionAdapter usamos recrear el adapter, pero en apps más grandes
    // se recomienda usar ListAdapter con DiffUtil para mejor rendimiento
    adapter.submitList(resultado)
}
```

### try/catch en coroutines

```kotlin
viewModelScope.launch {
    try {
        _estado.value = ResultadoApi.Cargando
        val datos = withContext(Dispatchers.IO) {
            repository.obtenerDatos()
        }
        _estado.value = ResultadoApi.Exito(datos)
    } catch (e: Exception) {
        // Si algo falla dentro del try, se captura aquí
        _estado.value = ResultadoApi.Error(e.message ?: "Error desconocido")
    }
}
```

---

## 13.2 Sealed classes a fondo

Ya usamos `ResultadoApi` como sealed class. Veamos más usos.

### Estado de la UI

```kotlin
// Sealed class para representar el estado completo de una pantalla
// Cada estado tiene los datos que necesita la UI para renderizarse
sealed class EstadoPantalla {
    // Pantalla cargando: no necesita datos
    object Cargando : EstadoPantalla()

    // Pantalla con contenido: tiene la lista y los totales
    data class Contenido(
        val transacciones: List<Transaccion>,
        val balance: Double,
        val ingresos: Double,
        val gastos: Double
    ) : EstadoPantalla()

    // Pantalla vacía: no hay transacciones
    object Vacio : EstadoPantalla()

    // Pantalla de error: tiene el mensaje
    data class Error(val mensaje: String) : EstadoPantalla()
}

// En el ViewModel:
private val _estado = MutableLiveData<EstadoPantalla>()
val estado: LiveData<EstadoPantalla> = _estado

// En el Fragment:
viewModel.estado.observe(viewLifecycleOwner) { estado ->
    // when con sealed class: el compilador verifica que cubramos todos los casos
    // Si agregamos un nuevo estado y olvidamos manejarlo, da error de compilación
    when (estado) {
        is EstadoPantalla.Cargando -> {
            binding.progressBar.mostrar()
            binding.rvTransacciones.ocultar()
            binding.tvVacio.ocultar()
            binding.tvError.ocultar()
        }
        is EstadoPantalla.Contenido -> {
            binding.progressBar.ocultar()
            binding.rvTransacciones.mostrar()
            binding.tvVacio.ocultar()
            binding.tvError.ocultar()
            // "is" hace smart cast: dentro de este bloque, estado es Contenido
            // Podemos acceder a estado.transacciones, estado.balance, etc.
            adapter.submitList(estado.transacciones)
            binding.tvBalance.text = estado.balance.formatearCOP()
        }
        is EstadoPantalla.Vacio -> {
            binding.progressBar.ocultar()
            binding.rvTransacciones.ocultar()
            binding.tvVacio.mostrar()
            binding.tvError.ocultar()
        }
        is EstadoPantalla.Error -> {
            binding.progressBar.ocultar()
            binding.rvTransacciones.ocultar()
            binding.tvVacio.ocultar()
            binding.tvError.mostrar()
            binding.tvError.text = estado.mensaje
        }
    }
}
```

💡 **¿Por qué sealed class y no un enum?** Porque cada estado puede tener datos diferentes. `Contenido` tiene una lista y totales, `Error` tiene un mensaje, `Cargando` no tiene nada. Un enum no permite eso.

---

## 13.3 Scope functions: let, apply, run, also, with

Las scope functions son funciones que ejecutan un bloque de código en el contexto de un objeto. Simplifican código repetitivo.

### let: ejecutar código si no es null

```kotlin
// Sin let:
val nombre = intent.getStringExtra("NOMBRE")
if (nombre != null) {
    binding.tvNombre.text = nombre
    binding.tvNombre.visibility = View.VISIBLE
}

// Con let: se ejecuta solo si no es null
// "it" es el valor no-null dentro del bloque
intent.getStringExtra("NOMBRE")?.let { nombre ->
    binding.tvNombre.text = nombre
    binding.tvNombre.visibility = View.VISIBLE
}

// Con "it" implícito (cuando el bloque es corto):
intent.getStringExtra("NOMBRE")?.let {
    binding.tvNombre.text = it
}
```

### apply: configurar un objeto

```kotlin
// Sin apply:
val intent = Intent(this, DetalleActivity::class.java)
intent.putExtra("ID", 123)
intent.putExtra("NOMBRE", "Producto")
intent.putExtra("PRECIO", 99.99)

// Con apply: "this" dentro del bloque es el objeto
// apply retorna el mismo objeto, así que se puede encadenar
val intent = Intent(this, DetalleActivity::class.java).apply {
    // Dentro de apply, "this" es el Intent
    // No necesitamos escribir "intent." antes de cada putExtra
    putExtra("ID", 123)
    putExtra("NOMBRE", "Producto")
    putExtra("PRECIO", 99.99)
}
```

### also: ejecutar una acción adicional

```kotlin
// also es como apply pero usa "it" en lugar de "this"
// Útil para logging o acciones secundarias
val transacciones = repository.obtenerTodas().also { lista ->
    // Acción secundaria: log para debugging
    Log.d("DEBUG", "Se cargaron ${lista.size} transacciones")
}
```

### run: ejecutar un bloque y retornar el resultado

```kotlin
// run ejecuta un bloque donde "this" es el objeto
// Retorna el resultado del bloque (no el objeto)
val longitud = "Hola Mundo".run {
    // "this" es el String "Hola Mundo"
    println("Procesando: $this")
    length  // retorna la longitud
}
// longitud = 10
```

### with: como run pero sin encadenar

```kotlin
// with es como run pero el objeto se pasa como parámetro
// Útil cuando se van a hacer muchas operaciones sobre el mismo objeto
with(binding) {
    // "this" es binding, no necesitamos escribir "binding." cada vez
    tvTitulo.text = "MisFinanzas"
    tvBalance.text = balance.formatearCOP()
    tvIngresos.text = ingresos.formatearCOP()
    tvGastos.text = gastos.formatearCOP()
    progressBar.ocultar()
}
```

### Resumen de scope functions

| Función | Referencia al objeto | Retorna | Uso típico |
|---------|---------------------|---------|------------|
| `let` | `it` | Resultado del bloque | Ejecutar si no es null |
| `apply` | `this` | El mismo objeto | Configurar un objeto |
| `also` | `it` | El mismo objeto | Acciones secundarias (logging) |
| `run` | `this` | Resultado del bloque | Transformar y retornar |
| `with` | `this` | Resultado del bloque | Múltiples operaciones sobre un objeto |

---

## 13.4 Lambdas y funciones de orden superior

Las lambdas son funciones anónimas que se pueden pasar como parámetros. Ya las hemos usado con `filter`, `map`, `setOnClickListener`, etc.

```kotlin
// Lambda básica: { parámetros -> cuerpo }
val sumar = { a: Int, b: Int -> a + b }
println(sumar(3, 5))  // 8

// Lambda con un solo parámetro: se puede usar "it"
val duplicar = { it: Int -> it * 2 }
// O más corto, si el tipo se infiere:
val numeros = listOf(1, 2, 3, 4, 5)
val dobles = numeros.map { it * 2 }  // [2, 4, 6, 8, 10]
```

### Funciones de orden superior

Una función de orden superior es una función que recibe otra función como parámetro:

```kotlin
// Función que recibe una lambda como parámetro
// (Transaccion) -> Boolean es el tipo de la lambda:
// recibe una Transaccion y retorna un Boolean
fun filtrarTransacciones(
    transacciones: List<Transaccion>,
    criterio: (Transaccion) -> Boolean  // lambda como parámetro
): List<Transaccion> {
    return transacciones.filter(criterio)
}

// Uso: pasar diferentes criterios sin cambiar la función
val soloIngresos = filtrarTransacciones(lista) { it.esIngreso() }
val soloComida = filtrarTransacciones(lista) { it.categoria == Categoria.COMIDA }
val grandesGastos = filtrarTransacciones(lista) { it.monto < -100000 }
```

### Trailing lambda

Cuando el último parámetro de una función es una lambda, se puede sacar fuera de los paréntesis:

```kotlin
// Estas dos formas son equivalentes:
binding.btnGuardar.setOnClickListener({ guardar() })
binding.btnGuardar.setOnClickListener { guardar() }  // trailing lambda (más limpio)

// Si la lambda es el ÚNICO parámetro, se pueden omitir los paréntesis:
numeros.filter { it > 0 }  // en lugar de numeros.filter({ it > 0 })
```

---

## 13.5 Operaciones funcionales sobre colecciones

Kotlin tiene un conjunto rico de operaciones funcionales sobre listas. Estas son las más útiles para MisFinanzas:

```kotlin
val transacciones = Transaccion.datosDePrueba()

// filter: filtra elementos que cumplan una condición
val gastos = transacciones.filter { !it.esIngreso() }

// map: transforma cada elemento
val descripciones = transacciones.map { it.descripcion }
// ["Salario mensual", "Almuerzo restaurante", ...]

// sumOf: suma aplicando una transformación
val totalGastos = gastos.sumOf { Math.abs(it.monto) }

// groupBy: agrupa por una clave
val porCategoria = transacciones.groupBy { it.categoria }
// Map<Categoria, List<Transaccion>>

// sortedBy / sortedByDescending: ordena
val porFecha = transacciones.sortedByDescending { it.fecha }
val porMonto = transacciones.sortedBy { it.monto }

// first / firstOrNull: obtener el primero
val primerIngreso = transacciones.firstOrNull { it.esIngreso() }

// any / all / none: verificar condiciones
val hayIngresos = transacciones.any { it.esIngreso() }       // true si al menos uno
val todosPositivos = transacciones.all { it.monto > 0 }      // true si todos
val sinGastos = transacciones.none { !it.esIngreso() }       // true si ninguno

// count: contar elementos que cumplen una condición
val numGastos = transacciones.count { !it.esIngreso() }

// maxByOrNull / minByOrNull: obtener el máximo/mínimo
val mayorGasto = transacciones.minByOrNull { it.monto }  // el más negativo
val mayorIngreso = transacciones.maxByOrNull { it.monto }

// take / drop: obtener los primeros N / saltar los primeros N
val ultimas5 = transacciones.take(5)
val sinPrimeras3 = transacciones.drop(3)

// distinctBy: eliminar duplicados por un criterio
val categoriasUnicas = transacciones.distinctBy { it.categoria }

// Encadenar operaciones (muy común en Kotlin)
val resumenGastos = transacciones
    .filter { !it.esIngreso() }                    // solo gastos
    .groupBy { it.categoria }                       // agrupar por categoría
    .mapValues { (_, lista) -> lista.sumOf { Math.abs(it.monto) } }  // sumar cada grupo
    .toList()                                       // convertir a lista de pares
    .sortedByDescending { it.second }               // ordenar de mayor a menor
    .take(3)                                        // top 3 categorías
```

---

## 13.6 Aplicar al proyecto: estadísticas mejoradas

✏️ Mejorar `EstadisticasFragment.kt` usando las técnicas avanzadas:

```kotlin
// Función mejorada usando operaciones funcionales
private fun mostrarEstadisticas(transacciones: List<Transaccion>) {
    // Top 3 categorías de gasto usando encadenamiento funcional
    val topGastos = transacciones
        .filter { !it.esIngreso() }
        .groupBy { it.categoria }
        .mapValues { (_, lista) -> lista.sumOf { Math.abs(it.monto) } }
        .toList()
        .sortedByDescending { it.second }
        .take(3)

    // Construir el texto del resumen usando buildString
    val resumen = buildString {
        appendLine("📊 Top categorías de gasto:")
        topGastos.forEachIndexed { index, (categoria, total) ->
            appendLine("${index + 1}. ${categoria.emoji} ${categoria.etiqueta}: ${total.formatearCOP()}")
        }

        appendLine()
        appendLine("📈 Resumen general:")
        appendLine("Total transacciones: ${transacciones.size}")

        // Calcular promedio de gastos usando let para manejar lista vacía
        transacciones
            .filter { !it.esIngreso() }
            .takeIf { it.isNotEmpty() }  // takeIf retorna null si la condición es false
            ?.let { gastos ->
                val promedio = gastos.sumOf { Math.abs(it.monto) } / gastos.size
                appendLine("Promedio por gasto: ${promedio.formatearCOP()}")
            }

        // Mayor ingreso
        transacciones
            .filter { it.esIngreso() }
            .maxByOrNull { it.monto }
            ?.let { mayor ->
                appendLine("Mayor ingreso: ${mayor.descripcion} (${mayor.montoFormateado()})")
            }

        // Mayor gasto
        transacciones
            .filter { !it.esIngreso() }
            .minByOrNull { it.monto }
            ?.let { mayor ->
                append("Mayor gasto: ${mayor.descripcion} (${mayor.montoFormateado()})")
            }
    }

    binding.tvTotalTransacciones.text = resumen
}
```

---

## 13.7 Compilar y probar

▶️ Compilar y ejecutar. La pestaña de Estadísticas ahora muestra información más detallada con el top de categorías, promedios y los mayores movimientos.

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| Coroutines (`launch`, `suspend`) | Código asíncrono sin bloquear el hilo |
| `Dispatchers.Main/IO/Default` | Controlar en qué hilo se ejecuta |
| `withContext` | Cambiar de hilo temporalmente |
| Sealed classes | Representar estados cerrados con datos diferentes |
| `let` | Ejecutar código si no es null |
| `apply` | Configurar un objeto |
| `also` | Acciones secundarias |
| `run` / `with` | Ejecutar bloque en contexto de un objeto |
| Lambdas | Funciones anónimas como parámetros |
| `filter`, `map`, `groupBy`, `sumOf` | Operaciones funcionales sobre colecciones |
| `buildString` | Construir strings de forma eficiente |
| `takeIf` / `takeUnless` | Retornar el objeto o null según condición |

---

**Anterior:** [← Capítulo 12 — Arquitectura MVVM](12_arquitectura_mvvm.md) | **Siguiente:** [Capítulo 14 — Proyecto final →](14_proyecto_final.md)
