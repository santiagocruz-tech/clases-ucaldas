# Taller — Android Studio con Kotlin

**Duración:** 4 horas | **Nivel:** 6° semestre, Ingeniería Informática

**Nombre:** __________________________________ **Fecha:** ______________

**Requisitos previos:** Tener conocimientos de programación orientada a objetos y haber trabajado con Java. Tener instalado Android Studio (versión estable reciente) y JDK 17 o superior.

---

## Distribución del tiempo

| Bloque | Contenido | Tiempo |
|--------|-----------|--------|
| 1 | Configuración del entorno y primer proyecto | 30 min |
| 2 | Sintaxis de Kotlin | 60 min |
| 3 | Ejercicios de práctica | 30 min |
| 4 | Receso | 15 min |
| 5 | Estructura de un proyecto Android | 25 min |
| 6 | Construcción de app: Lista de tareas | 70 min |
| 7 | Cierre y preguntas | 10 min |

---

## Parte 1 — Configuración del entorno (30 min)

### Instalación

Si no tienen Android Studio instalado todavía:

1. Descargarlo de [developer.android.com/studio](https://developer.android.com/studio)
2. Correr el instalador con las opciones por defecto
3. Al abrir por primera vez, elegir instalación **Standard**
4. Dejar que se descarguen los SDK (esto toma unos minutos)

### Primer proyecto

Abrir Android Studio y crear un proyecto nuevo:

- **New Project** → seleccionar **Empty Views Activity**
- Name: `MiPrimeraApp`
- Package name: `com.ejemplo.miprimeraapp`
- Language: **Kotlin**
- Minimum SDK: API 24 (Android 7.0)
- Build configuration language: Kotlin DSL

Darle **Finish** y esperar a que Gradle termine de sincronizar. Puede tardar un par de minutos la primera vez.

### Conociendo el IDE

Tómense un momento para ubicar estas zonas del IDE:

- A la izquierda está el **panel de proyecto** con la estructura de archivos
- En el centro el **editor** donde van a escribir código
- Abajo aparece **Logcat**, que muestra los logs cuando la app está corriendo
- El **Device Manager** sirve para crear y administrar emuladores

### Correr la app

1. Ir a **Device Manager → Create Device**, elegir un Pixel 6 con API 34 y darle Finish
2. Presionar el botón de play (o `Shift + F10`)
3. Debería aparecer el "Hello World!" en el emulador

Si el emulador va muy lento en su máquina, pueden conectar un celular físico por USB. Solo necesitan activar la depuración USB en Ajustes → Opciones de desarrollador.

---

## Parte 2 — Sintaxis de Kotlin (60 min)

Para ir probando los ejemplos pueden usar el REPL integrado (**Tools → Kotlin → Kotlin REPL**) o el playground en línea: [play.kotlinlang.org](https://play.kotlinlang.org)

### Variables

Kotlin maneja dos tipos de variables: `val` (inmutable, no se puede reasignar) y `var` (mutable).

```kotlin
val nombre: String = "Android"    // como 'final' en Java
val version: Int = 14
val pi: Double = 3.14159

var contador: Int = 0
contador = 1    // esto sí se puede porque es var

// Kotlin puede inferir el tipo, no siempre hay que escribirlo
val mensaje = "Hola Kotlin"   // infiere String
var edad = 22                  // infiere Int
```

A diferencia de Java, en Kotlin todo es un objeto. No hay tipos primitivos expuestos (`Int` en lugar de `int`), aunque internamente el compilador los optimiza.

### Null Safety

Esto es probablemente lo que más van a agradecer viniendo de Java. Kotlin obliga a manejar los nulls de forma explícita, así que los `NullPointerException` se atrapan en compilación, no en ejecución.

```kotlin
var nombre: String = "Kotlin"
// nombre = null   // no compila, String no acepta null

// Para permitir null hay que usar el ?
var apellido: String? = "García"
apellido = null   // ahora sí se puede

// Acceso seguro: si apellido es null, retorna null en vez de explotar
val longitud: Int? = apellido?.length

// Operador Elvis: da un valor por defecto cuando algo es null
val longitudSegura: Int = apellido?.length ?: 0

// El !! fuerza el valor (lanza excepción si es null, úsenlo con cuidado)
// val longitudForzada: Int = apellido!!.length
```

### Funciones

```kotlin
// Función normal
fun saludar(nombre: String): String {
    return "Hola, $nombre!"
}

// Si el cuerpo es una sola expresión, se puede simplificar
fun sumar(a: Int, b: Int): Int = a + b

// Los parámetros pueden tener valores por defecto
fun crearUsuario(nombre: String, edad: Int = 18, activo: Boolean = true): String {
    return "Usuario: $nombre, Edad: $edad, Activo: $activo"
}

// Y se pueden llamar con argumentos nombrados (muy útil para legibilidad)
val usuario = crearUsuario(nombre = "Ana", activo = false)
// Resultado: "Usuario: Ana, Edad: 18, Activo: false"

// Lambdas
val duplicar: (Int) -> Int = { numero -> numero * 2 }
val resultado = duplicar(5)  // 10

// Cuando la lambda tiene un solo parámetro, se puede usar 'it'
val triplicar: (Int) -> Int = { it * 3 }
```

### Condicionales y when

En Kotlin el `if` puede retornar un valor directamente (no necesitan operador ternario):

```kotlin
val edad = 20
val categoria = if (edad >= 18) "Adulto" else "Menor"
```

`when` reemplaza al `switch` de Java, pero es bastante más flexible:

```kotlin
val dia = 3
val nombreDia = when (dia) {
    1 -> "Lunes"
    2 -> "Martes"
    3 -> "Miércoles"
    4 -> "Jueves"
    5 -> "Viernes"
    6, 7 -> "Fin de semana"
    else -> "Día inválido"
}

// También se puede usar sin argumento, como una cadena de if-else
fun clasificarNota(nota: Double): String = when {
    nota >= 4.5 -> "Excelente"
    nota >= 3.5 -> "Bueno"
    nota >= 3.0 -> "Aceptable"
    else -> "Reprobado"
}
```

### Colecciones

```kotlin
// Lista inmutable (no se puede modificar después de crearla)
val frutas = listOf("Manzana", "Banana", "Cereza")

// Lista mutable
val tareas = mutableListOf("Estudiar", "Programar")
tareas.add("Descansar")
tareas.removeAt(0)

// Mapas (diccionarios)
val capitales = mapOf(
    "Colombia" to "Bogotá",
    "Perú" to "Lima",
    "Chile" to "Santiago"
)
val capital = capitales["Colombia"]  // "Bogotá"

// Operaciones funcionales (esto les va a gustar)
val numeros = listOf(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
val pares = numeros.filter { it % 2 == 0 }          // [2, 4, 6, 8, 10]
val dobles = numeros.map { it * 2 }                   // [2, 4, 6, ..., 20]
val suma = numeros.reduce { acc, num -> acc + num }    // 55
```

### Clases y Data Classes

```kotlin
// Clase con constructor primario
class Persona(val nombre: String, var edad: Int) {
    fun presentarse(): String = "Soy $nombre y tengo $edad años"
}

// Data class: Kotlin genera toString(), equals(), hashCode() y copy() automáticamente
data class Tarea(
    val id: Int,
    val titulo: String,
    var completada: Boolean = false
)

val tarea = Tarea(1, "Aprender Kotlin")
println(tarea)  // Tarea(id=1, titulo=Aprender Kotlin, completada=false)

// copy() crea una copia modificando solo lo que se indique
val tareaCompletada = tarea.copy(completada = true)
```

---

## Parte 3 — Ejercicios (30 min)

Trabajar en el Kotlin REPL o en [play.kotlinlang.org](https://play.kotlinlang.org).

**Ejercicio 1 — Null Safety**

Escribir una función `describirEstudiante` que reciba un nombre (`String`), una edad (`Int`) y un correo que puede ser null (`String?`). Debe retornar un String con este formato: `"Nombre: X, Edad: X, Correo: X"`. Si el correo es null, mostrar `"No registrado"`.

Pista: usar el operador Elvis `?:` y string templates.

Salida esperada:
```
describirEstudiante("Carlos", 22, "carlos@mail.com")
→ "Nombre: Carlos, Edad: 22, Correo: carlos@mail.com"

describirEstudiante("Ana", 21, null)
→ "Nombre: Ana, Edad: 21, Correo: No registrado"
```

```kotlin
// Solución:

```

---

**Ejercicio 2 — When**

Escribir una función `calcularDescuento` que reciba un tipo de cliente (`String`) y un monto (`Double`). Según el tipo de cliente se aplica un descuento:
- `"premium"` → 20%
- `"regular"` → 10%
- `"nuevo"` → 5%
- Cualquier otro → 0%

La función retorna el monto final (ya con el descuento aplicado).

Pista: usar `when` sobre `tipoCliente.lowercase()`.

Salida esperada:
```
calcularDescuento("premium", 100000.0) → 80000.0
calcularDescuento("regular", 50000.0)  → 45000.0
calcularDescuento("otro", 30000.0)     → 30000.0
```

```kotlin
// Solución:

```

---

**Ejercicio 3 — Colecciones**

Dada la siguiente lista de estudiantes, filtrar los que aprobaron (nota >= 3.0), ordenarlos de mayor a menor nota, y quedarse solo con los nombres.

```kotlin
data class Estudiante(val nombre: String, val nota: Double)

val estudiantes = listOf(
    Estudiante("María", 4.5),
    Estudiante("Pedro", 2.8),
    Estudiante("Laura", 3.9),
    Estudiante("Juan", 2.5),
    Estudiante("Sofía", 4.2)
)
```

Resultado esperado: `[María, Sofía, Laura]`

Pista: encadenar `.filter { }`, `.sortedByDescending { }` y `.map { }`.

```kotlin
// Solución:

```

---

**Ejercicio 4 — Data Classes**

Crear una data class `Producto` con propiedades `nombre` (String), `precio` (Double) y `cantidad` (Int). Luego escribir una función `resumenCarrito` que reciba una lista de productos y retorne un String con el total de artículos y el monto total.

Datos de prueba:
```kotlin
val carrito = listOf(
    Producto("Laptop", 2500000.0, 1),
    Producto("Mouse", 45000.0, 2),
    Producto("Teclado", 120000.0, 1)
)
```

Resultado esperado: `"Artículos: 4, Total: $2710000.00"`

Pista: `.sumOf { }` sirve para sumar sobre una propiedad calculada.

```kotlin
// Solución:

```

---

*Receso — 15 minutos*

---

## Parte 5 — Estructura de un proyecto Android (25 min)

Cuando crean un proyecto en Android Studio, la estructura relevante es esta:

```
app/
├── src/main/
│   ├── java/com/ejemplo/miapp/    ← Código Kotlin (sí, la carpeta se llama "java")
│   │   └── MainActivity.kt
│   ├── res/
│   │   ├── layout/                 ← XMLs de interfaz
│   │   │   └── activity_main.xml
│   │   ├── values/                 ← Strings, colores, temas
│   │   └── drawable/               ← Imágenes
│   └── AndroidManifest.xml         ← Configuración general de la app
├── build.gradle.kts                ← Dependencias del módulo
└── ...
```

### Los archivos que importan

El **AndroidManifest.xml** es donde se registra la app ante el sistema. Aquí se declaran las Activities, permisos, etc:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="Mi App"
        android:theme="@style/Theme.MiApp">
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
```

El **MainActivity.kt** es el punto de entrada. Cuando la app arranca, Android llama a `onCreate()`:

```kotlin
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
}
```

El **activity_main.xml** define la interfaz visual:

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="16dp">

    <TextView
        android:id="@+id/tvTitulo"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Hola Mundo"
        android:textSize="24sp" />
</LinearLayout>
```

### View Binding

En lugar de usar `findViewById` (que es propenso a errores y verboso), vamos a usar View Binding. Se activa en `build.gradle.kts` del módulo app:

```kotlin
android {
    buildFeatures {
        viewBinding = true
    }
}
```

Y se usa así en la Activity:

```kotlin
class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.tvTitulo.text = "Bienvenido"
    }
}
```

La ventaja es que el acceso a las vistas es type-safe y no hay riesgo de referenciar un ID que no existe.

---

## Parte 6 — App "Lista de Tareas" (70 min)

Ahora vamos a armar una app completa. Va a permitir agregar tareas, marcarlas como completadas (tachando el texto) y eliminarlas.

### 6.1 Crear el proyecto (5 min)

**File → New → New Project → Empty Views Activity**

- Name: `ListaDeTareas`
- Package: `com.ejemplo.listadetareas`
- Language: Kotlin
- Minimum SDK: API 24

### 6.2 Activar View Binding (2 min)

En `app/build.gradle.kts`, agregar dentro del bloque `android {}`:

```kotlin
buildFeatures {
    viewBinding = true
}
```

Presionar **Sync Now** en la barra que aparece arriba.

### 6.3 Modelo de datos (5 min)

Crear un archivo nuevo: click derecho en el paquete → **New → Kotlin Class/File → File**, nombre: `Tarea.kt`

Necesitamos una data class con tres propiedades:
- `id` (Int) — identificador
- `titulo` (String) — el texto de la tarea
- `completada` (Boolean, por defecto false)

Escribir la data class aquí (revisar la sección de Data Classes si no recuerdan la sintaxis):

```kotlin
package com.ejemplo.listadetareas

// Escribir la data class Tarea

```

### 6.4 Layout de cada tarea (10 min)

Click derecho en `res/layout` → **New → Layout Resource File**, nombre: `item_tarea.xml`

Este XML define cómo se ve cada fila de la lista. Tiene un CheckBox, un TextView para el título, y un botón para eliminar. Copiarlo tal cual:

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="horizontal"
    android:padding="12dp"
    android:gravity="center_vertical">

    <CheckBox
        android:id="@+id/cbCompletada"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content" />

    <TextView
        android:id="@+id/tvTitulo"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_weight="1"
        android:textSize="16sp"
        android:paddingStart="8dp"
        android:paddingEnd="8dp" />

    <ImageButton
        android:id="@+id/btnEliminar"
        android:layout_width="40dp"
        android:layout_height="40dp"
        android:src="@android:drawable/ic_menu_delete"
        android:background="?attr/selectableItemBackgroundBorderless"
        android:contentDescription="Eliminar tarea" />
</LinearLayout>
```

### 6.5 El Adapter (15 min)

El Adapter conecta los datos (la lista de objetos `Tarea`) con la interfaz (el XML de cada fila). Es el componente central de un RecyclerView.

Crear archivo: `TareaAdapter.kt`

El código base ya está armado. Hay que completar los `TODO` — son las partes donde ustedes conectan los datos con las vistas:

```kotlin
package com.ejemplo.listadetareas

import android.graphics.Paint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.ejemplo.listadetareas.databinding.ItemTareaBinding

class TareaAdapter(
    private val tareas: MutableList<Tarea>,
    private val onEliminar: (Int) -> Unit
) : RecyclerView.Adapter<TareaAdapter.TareaViewHolder>() {

    inner class TareaViewHolder(val binding: ItemTareaBinding) :
        RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TareaViewHolder {
        val binding = ItemTareaBinding.inflate(
            LayoutInflater.from(parent.context), parent, false
        )
        return TareaViewHolder(binding)
    }

    override fun onBindViewHolder(holder: TareaViewHolder, position: Int) {
        val tarea = tareas[position]

        // TODO 1: Asignar el título de la tarea al TextView
        // holder.binding.tvTitulo.text = ???

        // TODO 2: Asignar el estado de completada al CheckBox
        // holder.binding.cbCompletada.isChecked = ???

        actualizarEstiloTexto(holder, tarea.completada)

        // TODO 3: Listener del CheckBox — cuando cambie, actualizar tarea.completada
        //         y llamar a actualizarEstiloTexto con el nuevo estado
        holder.binding.cbCompletada.setOnCheckedChangeListener { _, isChecked ->

        }

        // TODO 4: Listener del botón eliminar — llamar a onEliminar(position)
        holder.binding.btnEliminar.setOnClickListener {

        }
    }

    override fun getItemCount(): Int = tareas.size

    // Esta función tacha o destacha el texto según el estado
    private fun actualizarEstiloTexto(holder: TareaViewHolder, completada: Boolean) {
        if (completada) {
            holder.binding.tvTitulo.paintFlags =
                holder.binding.tvTitulo.paintFlags or Paint.STRIKE_THRU_TEXT_FLAG
        } else {
            holder.binding.tvTitulo.paintFlags =
                holder.binding.tvTitulo.paintFlags and Paint.STRIKE_THRU_TEXT_FLAG.inv()
        }
    }
}
```

### 6.6 Layout principal (10 min)

Reemplazar todo el contenido de `activity_main.xml` con esto. Tiene un título, un campo de texto con botón para agregar, un contador de tareas pendientes, y el RecyclerView donde se muestra la lista:

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="16dp">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Mis Tareas"
        android:textSize="28sp"
        android:textStyle="bold"
        android:layout_marginBottom="16dp" />

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="horizontal"
        android:layout_marginBottom="16dp">

        <EditText
            android:id="@+id/etNuevaTarea"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:hint="Escribe una tarea..."
            android:inputType="text"
            android:imeOptions="actionDone" />

        <Button
            android:id="@+id/btnAgregar"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Agregar"
            android:layout_marginStart="8dp" />
    </LinearLayout>

    <TextView
        android:id="@+id/tvContador"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="0 tareas pendientes"
        android:textSize="14sp"
        android:textColor="#666666"
        android:layout_marginBottom="8dp" />

    <androidx.recyclerview.widget.RecyclerView
        android:id="@+id/rvTareas"
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1" />
</LinearLayout>
```

### 6.7 Lógica del MainActivity (15 min)

Reemplazar `MainActivity.kt` con el siguiente código. Completar los `TODO`:

```kotlin
package com.ejemplo.listadetareas

import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import com.ejemplo.listadetareas.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private val listaTareas = mutableListOf<Tarea>()
    private lateinit var adapter: TareaAdapter
    private var contadorId = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        configurarRecyclerView()
        configurarBotones()
    }

    private fun configurarRecyclerView() {
        // TODO 1: Crear el adapter pasando listaTareas y una lambda para eliminar
        // adapter = TareaAdapter(???) { posicion -> ??? }

        // TODO 2: Asignar un LinearLayoutManager al RecyclerView
        // binding.rvTareas.layoutManager = ???

        // TODO 3: Asignar el adapter al RecyclerView
        // binding.rvTareas.adapter = ???
    }

    private fun configurarBotones() {
        binding.btnAgregar.setOnClickListener {
            val texto = binding.etNuevaTarea.text.toString().trim()
            if (texto.isNotEmpty()) {
                agregarTarea(texto)
                binding.etNuevaTarea.text.clear()
            } else {
                Toast.makeText(this, "Escribe una tarea primero", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun agregarTarea(titulo: String) {
        // TODO 4: Incrementar contadorId
        // TODO 5: Crear una nueva Tarea con el id y titulo
        // TODO 6: Agregarla a listaTareas
        // TODO 7: Notificar al adapter con adapter.notifyItemInserted(listaTareas.size - 1)
        // TODO 8: Llamar a actualizarContador()
    }

    private fun eliminarTarea(posicion: Int) {
        // TODO 9: Remover la tarea en la posición dada
        // TODO 10: Notificar al adapter:
        //          adapter.notifyItemRemoved(posicion)
        //          adapter.notifyItemRangeChanged(posicion, listaTareas.size)
        // TODO 11: Llamar a actualizarContador()
    }

    private fun actualizarContador() {
        // TODO 12: Contar cuántas tareas tienen completada == false
        //          (pista: usar .count { } sobre la lista)
        // TODO 13: Actualizar binding.tvContador.text con "$pendientes tareas pendientes"
    }
}
```

### 6.8 Probar la app (8 min)

Correr la app y verificar que funcione:

- Agregar varias tareas escribiendo texto y presionando "Agregar"
- Marcar alguna como completada (el texto se debería tachar)
- Eliminar una tarea con el botón de basura
- Verificar que el contador de pendientes se actualiza bien
- Intentar agregar una tarea vacía (debería mostrar un Toast)

Si algo no compila, lo primero que hay que revisar es que el nombre del paquete sea el mismo en todos los archivos y que View Binding esté activado.

**Verificación:**

| Funcionalidad | OK |
|---|---|
| Se agregan tareas | |
| El texto se tacha al completar | |
| Se eliminan tareas | |
| El contador se actualiza | |
| No deja agregar tareas vacías | |

---

## Parte 7 — Cierre (10 min)

Responder brevemente:

1. ¿Cuál es la diferencia entre `val` y `var`?

   _______________________________________________

2. ¿Para qué sirve el operador `?:` (Elvis)?

   _______________________________________________

3. ¿Qué genera automáticamente una `data class` que una clase normal no?

   _______________________________________________

4. ¿Qué hace el Adapter en un RecyclerView?

   _______________________________________________

5. ¿Por qué usar View Binding en lugar de `findViewById`?

   _______________________________________________

---

### Para seguir practicando en casa

Algunas ideas para extender la app:

- Guardar las tareas con `SharedPreferences` para que persistan al cerrar la app
- Agregar la opción de editar el título de una tarea
- Poner categorías (Trabajo, Personal, Estudio) usando un Spinner
- Mejorar el diseño con `MaterialCardView` para cada item

---

### Referencias

- Documentación de Kotlin: [kotlinlang.org/docs](https://kotlinlang.org/docs/home.html)
- Kotlin Playground: [play.kotlinlang.org](https://play.kotlinlang.org)
- Codelabs de Android: [developer.android.com/courses](https://developer.android.com/courses)
- Guía de RecyclerView: [developer.android.com/develop/ui/views/layout/recyclerview](https://developer.android.com/develop/ui/views/layout/recyclerview)
- View Binding: [developer.android.com/topic/libraries/view-binding](https://developer.android.com/topic/libraries/view-binding)
