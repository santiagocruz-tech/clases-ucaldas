# Capítulo 7: Ciclo de vida y ViewModel

## Objetivo

Entender el ciclo de vida de una Activity en Android y usar ViewModel + LiveData para que el estado de MisFinanzas sobreviva a rotaciones de pantalla y cambios de configuración.

---

## 7.1 El problema: rotación de pantalla

Cuando el usuario rota el teléfono, Android **destruye y recrea** la Activity. Esto significa que todas las variables se pierden. Si el usuario agregó 5 transacciones y rota el teléfono, la lista vuelve a los datos de ejemplo.

Esto no pasa en Flutter porque el framework maneja el estado de forma diferente. En Android hay que ser explícitos.

---

## 7.2 El ciclo de vida de una Activity

Cada Activity pasa por una serie de estados. Android llama a funciones específicas en cada transición:

```
    onCreate()  →  onStart()  →  onResume()
                                      │
                                 [App en uso]
                                      │
                                 onPause()  →  onStop()  →  onDestroy()
                                                   │
                                              onRestart()  →  onStart()
```

```kotlin
// Ejemplo: observar el ciclo de vida con logs
// Log.d escribe un mensaje en Logcat (la consola de Android)
// El primer parámetro es un "tag" para filtrar los mensajes
class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Se llama UNA vez cuando la Activity se crea
        // Aquí se inicializa todo: layout, listeners, datos
        Log.d("CICLO", "onCreate")
    }

    override fun onStart() {
        super.onStart()
        // La Activity se está haciendo visible
        Log.d("CICLO", "onStart")
    }

    override fun onResume() {
        super.onResume()
        // La Activity está en primer plano y recibiendo interacción
        // Reanudar animaciones, sensores, etc.
        Log.d("CICLO", "onResume")
    }

    override fun onPause() {
        super.onPause()
        // Otra Activity está tomando el foco (ej: diálogo, otra app)
        // Pausar animaciones, guardar datos temporales
        Log.d("CICLO", "onPause")
    }

    override fun onStop() {
        super.onStop()
        // La Activity ya no es visible
        Log.d("CICLO", "onStop")
    }

    override fun onDestroy() {
        super.onDestroy()
        // La Activity se va a destruir (rotación, back, o el sistema la mata)
        // Limpiar recursos
        Log.d("CICLO", "onDestroy")
    }
}
```

💡 **¿Cuándo se destruye una Activity?**
- Cuando el usuario presiona "Atrás"
- Cuando el usuario rota el teléfono (se destruye y se recrea)
- Cuando el sistema necesita memoria y la mata

---

## 7.3 Solución básica: savedInstanceState

Para datos simples (un número, un string), se puede guardar el estado antes de que se destruya:

```kotlin
// savedInstanceState guarda datos simples que sobreviven a la recreación
class ContadorActivity : AppCompatActivity() {
    // Variable que queremos preservar
    private var contador = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // ...

        // Restaurar el estado si existe
        // savedInstanceState es null la primera vez, pero tiene datos si se recreó
        // getInt busca un entero con la clave "CONTADOR", o usa 0 si no existe
        contador = savedInstanceState?.getInt("CONTADOR", 0) ?: 0
    }

    // Android llama a esta función ANTES de destruir la Activity
    // Aquí guardamos los datos que queremos preservar
    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        // putInt guarda un entero con una clave
        outState.putInt("CONTADOR", contador)
    }
}
```

💡 **Limitación:** savedInstanceState solo sirve para datos simples y pequeños. Para listas grandes o datos complejos, usamos ViewModel.

---

## 7.4 La solución real: ViewModel

El ViewModel es un componente que **sobrevive a rotaciones de pantalla**. Vive más tiempo que la Activity: se crea cuando la Activity se crea por primera vez y se destruye solo cuando la Activity se destruye definitivamente (no por rotación).

🔧 Agregar la dependencia en `app/build.gradle.kts`:

```kotlin
dependencies {
    // ... las que ya tienen

    // ViewModel: componente que sobrevive a rotaciones de pantalla
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0")
    // LiveData: datos observables que notifican cambios a la UI
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.7.0")
    // Activity KTX: extensiones para usar viewModels() de forma simple
    implementation("androidx.activity:activity-ktx:1.8.2")
}
```

Sincronizar Gradle después de agregar las dependencias.

---

## 7.5 Crear el ViewModel de MisFinanzas

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/MainViewModel.kt`:

```kotlin
// MainViewModel.kt
// ViewModel que maneja el estado de la pantalla principal
// Sobrevive a rotaciones de pantalla y cambios de configuración
package com.ejemplo.misfinanzas

// ViewModel es la clase base para ViewModels
import androidx.lifecycle.ViewModel
// LiveData es un contenedor de datos observable
// MutableLiveData permite modificar el valor, LiveData solo permite observar
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData

// MainViewModel hereda de ViewModel
// No recibe contexto ni referencia a la Activity (eso causaría memory leaks)
class MainViewModel : ViewModel() {

    // _transacciones es MutableLiveData: se puede modificar desde dentro del ViewModel
    // Es privado para que la Activity no lo modifique directamente
    // El guion bajo "_" es una convención para indicar que es la versión mutable privada
    private val _transacciones = MutableLiveData<List<Transaccion>>()

    // transacciones es LiveData (solo lectura): la Activity puede observar pero no modificar
    // Esta es la versión pública que expone el ViewModel
    val transacciones: LiveData<List<Transaccion>> = _transacciones

    // LiveData para el balance calculado
    private val _balance = MutableLiveData<Double>()
    val balance: LiveData<Double> = _balance

    // LiveData para los ingresos totales
    private val _ingresos = MutableLiveData<Double>()
    val ingresos: LiveData<Double> = _ingresos

    // LiveData para los gastos totales
    private val _gastos = MutableLiveData<Double>()
    val gastos: LiveData<Double> = _gastos

    // init se ejecuta cuando se crea el ViewModel (una sola vez)
    // Cargamos los datos de prueba iniciales
    init {
        // Cargar datos de ejemplo
        _transacciones.value = Transaccion.datosDePrueba()
        // Recalcular los totales
        recalcularTotales()
    }

    // Agrega una nueva transacción al inicio de la lista
    fun agregarTransaccion(transaccion: Transaccion) {
        // Obtener la lista actual (o una lista vacía si es null)
        val listaActual = _transacciones.value?.toMutableList() ?: mutableListOf()
        // Agregar al inicio (posición 0)
        listaActual.add(0, transaccion)
        // Actualizar el LiveData con la nueva lista
        // Al cambiar .value, todos los observadores son notificados automáticamente
        _transacciones.value = listaActual
        // Recalcular totales
        recalcularTotales()
    }

    // Elimina una transacción de la lista por su posición
    fun eliminarTransaccion(posicion: Int) {
        val listaActual = _transacciones.value?.toMutableList() ?: return
        // Verificar que la posición sea válida
        if (posicion in listaActual.indices) {
            listaActual.removeAt(posicion)
            _transacciones.value = listaActual
            recalcularTotales()
        }
    }

    // Recalcula balance, ingresos y gastos a partir de la lista actual
    private fun recalcularTotales() {
        val lista = _transacciones.value ?: emptyList()
        // sumOf aplica una transformación a cada elemento y suma los resultados
        _ingresos.value = lista.filter { it.esIngreso() }.sumOf { it.monto }
        _gastos.value = lista.filter { !it.esIngreso() }.sumOf { Math.abs(it.monto) }
        _balance.value = lista.sumOf { it.monto }
    }
}
```

---

## 7.6 LiveData: datos que se observan

LiveData es un contenedor de datos que **notifica automáticamente** a la UI cuando el valor cambia. La Activity se suscribe con `.observe()` y recibe actualizaciones sin tener que preguntar.

```kotlin
// Patrón de LiveData:
// 1. El ViewModel expone LiveData (solo lectura)
// 2. La Activity observa el LiveData con .observe()
// 3. Cuando el valor cambia, el bloque del observe se ejecuta automáticamente

// En el ViewModel:
private val _datos = MutableLiveData<String>()  // mutable, privado
val datos: LiveData<String> = _datos             // solo lectura, público

// En la Activity:
viewModel.datos.observe(this) { valor ->
    // Este bloque se ejecuta CADA VEZ que "datos" cambia
    // "this" es el LifecycleOwner (la Activity)
    // LiveData respeta el ciclo de vida: no notifica si la Activity está destruida
    binding.tvDatos.text = valor
}
```

💡 **¿Por qué LiveData y no una variable normal?** Porque LiveData:
- Notifica automáticamente cuando cambia (no hay que llamar `actualizarUI()`)
- Respeta el ciclo de vida (no notifica a Activities destruidas)
- Evita memory leaks
- Siempre muestra el último valor al suscribirse

---

## 7.7 Conectar el ViewModel con MainActivity

✏️ Modificar `MainActivity.kt`:

```kotlin
// MainActivity.kt
// Pantalla principal usando ViewModel y LiveData
package com.ejemplo.misfinanzas

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.content.Intent
import android.widget.Toast
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.activity.result.contract.ActivityResultContracts
// viewModels() es una extensión que crea o recupera el ViewModel
import androidx.activity.viewModels
import com.ejemplo.misfinanzas.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    // viewModels() crea el ViewModel la primera vez y lo recupera en recreaciones
    // "by viewModels()" es una delegación: la primera vez que se accede, se crea
    // En rotaciones de pantalla, devuelve el MISMO ViewModel (no crea uno nuevo)
    private val viewModel: MainViewModel by viewModels()

    // Adapter como propiedad para poder actualizarlo
    private lateinit var adapter: TransaccionAdapter

    // Callback para recibir el resultado de AgregarActivity
    private val lanzarAgregar = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { resultado ->
        if (resultado.resultCode == RESULT_OK) {
            val nueva = resultado.data?.getSerializableExtra("NUEVA_TRANSACCION") as? Transaccion
            if (nueva != null) {
                // Ahora delegamos al ViewModel en lugar de manejar la lista directamente
                viewModel.agregarTransaccion(nueva)
                // El RecyclerView se actualiza automáticamente gracias al observe
                binding.rvTransacciones.scrollToPosition(0)
                Toast.makeText(this, "Transacción agregada", Toast.LENGTH_SHORT).show()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Configurar el RecyclerView (sin datos todavía)
        configurarRecyclerView()

        // Observar los datos del ViewModel
        // Cada observe se ejecuta automáticamente cuando el dato cambia
        observarDatos()

        // Botón de agregar
        binding.btnAgregar.setOnClickListener {
            val intent = Intent(this, AgregarActivity::class.java)
            lanzarAgregar.launch(intent)
        }
    }

    private fun configurarRecyclerView() {
        // Inicialmente con lista vacía, se llenará cuando el observe notifique
        adapter = TransaccionAdapter(emptyList()) { transaccion ->
            Toast.makeText(
                this,
                "${transaccion.descripcion}: ${transaccion.montoFormateado()}",
                Toast.LENGTH_SHORT
            ).show()
        }
        binding.rvTransacciones.layoutManager = LinearLayoutManager(this)
        binding.rvTransacciones.adapter = adapter
    }

    // Suscribirse a los LiveData del ViewModel
    private fun observarDatos() {
        // Observar la lista de transacciones
        // Cada vez que la lista cambia, este bloque se ejecuta
        viewModel.transacciones.observe(this) { lista ->
            // Recrear el adapter con la nueva lista
            adapter = TransaccionAdapter(lista) { transaccion ->
                Toast.makeText(
                    this,
                    "${transaccion.descripcion}: ${transaccion.montoFormateado()}",
                    Toast.LENGTH_SHORT
                ).show()
            }
            binding.rvTransacciones.adapter = adapter
            // Actualizar el contador
            binding.tvNumTransacciones.text = "${lista.size}"
        }

        // Observar el balance
        viewModel.balance.observe(this) { balance ->
            binding.tvBalance.text = formatearMonto(balance)
        }

        // Observar los ingresos
        viewModel.ingresos.observe(this) { ingresos ->
            binding.tvIngresos.text = formatearMonto(ingresos)
        }

        // Observar los gastos
        viewModel.gastos.observe(this) { gastos ->
            binding.tvGastos.text = formatearMonto(gastos)
        }
    }

    private fun formatearMonto(monto: Double): String {
        return "$ ${String.format("%,.0f", monto)}"
    }
}
```

---

## 7.8 Compilar y probar

▶️ Compilar y ejecutar. Ahora:
1. Agregar algunas transacciones
2. Rotar el teléfono (Ctrl+F11 en el emulador)
3. Las transacciones **siguen ahí** porque el ViewModel sobrevive a la rotación

Sin ViewModel, la lista se perdería al rotar.

---

## 7.9 ¿Qué pasa con los datos al cerrar la app?

El ViewModel sobrevive a rotaciones, pero **no sobrevive al cierre de la app**. Si el usuario cierra MisFinanzas y la vuelve a abrir, los datos se pierden.

Para persistir datos de verdad necesitamos una base de datos. Eso lo veremos en el capítulo 8 con Room.

| Situación | ¿Se pierden los datos? | Solución |
|-----------|----------------------|----------|
| Rotación de pantalla | No (con ViewModel) | ViewModel |
| App en segundo plano | Depende (el sistema puede matarla) | ViewModel + SavedStateHandle |
| App cerrada por el usuario | Sí | Room (base de datos) |
| Reinicio del teléfono | Sí | Room (base de datos) |

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| Ciclo de vida | Entender cuándo la Activity se crea, pausa, destruye |
| `savedInstanceState` | Guardar datos simples que sobreviven a rotaciones |
| `ViewModel` | Componente que sobrevive a rotaciones, maneja el estado |
| `LiveData` | Datos observables que notifican cambios a la UI |
| `MutableLiveData` | Versión modificable de LiveData (privada en el ViewModel) |
| `.observe(this) { }` | Suscribirse a cambios de un LiveData |
| `by viewModels()` | Crear o recuperar un ViewModel en la Activity |
| Convención `_dato` / `dato` | Mutable privado / solo lectura público |

---

**Anterior:** [← Capítulo 6 — Navegación](06_navegacion.md) | **Siguiente:** [Capítulo 8 — Persistencia con Room →](08_persistencia_room.md)
