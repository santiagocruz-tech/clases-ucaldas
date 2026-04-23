# Capítulo 12: Arquitectura MVVM

## Objetivo

Refactorizar MisFinanzas siguiendo la arquitectura MVVM (Model-View-ViewModel) con el patrón Repository. Esto separa responsabilidades y hace el código más mantenible, testeable y escalable.

---

## 12.1 ¿Qué es MVVM?

MVVM (Model-View-ViewModel) es el patrón de arquitectura que Google recomienda para Android. Ya lo hemos estado usando parcialmente. Ahora lo formalizamos.

```
┌──────────────┐     observa      ┌──────────────┐     usa       ┌──────────────┐
│     VIEW     │ ◄──────────────  │  VIEWMODEL   │ ────────────► │    MODEL     │
│  (Activity/  │                  │              │               │  (Repository │
│   Fragment)  │  ──────────────► │  LiveData    │ ◄──────────── │   Room, API) │
│              │   eventos UI     │  Coroutines  │   datos       │              │
└──────────────┘                  └──────────────┘               └──────────────┘
```

### Las tres capas

| Capa | Responsabilidad | Archivos |
|------|----------------|----------|
| **View** | Mostrar datos y capturar eventos del usuario | Activities, Fragments, XML layouts |
| **ViewModel** | Intermediario. Expone datos con LiveData, maneja lógica de presentación | ViewModels |
| **Model** | Datos y lógica de negocio. Acceso a BD y APIs | Repository, Room DAO, Retrofit |

### Regla de oro

Cada capa solo conoce a la de abajo:
- La **View** solo habla con el **ViewModel** (nunca con Room ni Retrofit directamente)
- El **ViewModel** solo habla con el **Repository** (nunca con la View)
- El **Repository** habla con Room y Retrofit

---

## 12.2 Estructura de carpetas

Vamos a reorganizar el proyecto en carpetas por capa:

```
app/src/main/java/com/ejemplo/misfinanzas/
├── data/                          ← Capa de datos (Model)
│   ├── local/                     ← Base de datos local
│   │   ├── AppDatabase.kt
│   │   └── TransaccionDao.kt
│   ├── remote/                    ← API remota
│   │   ├── ApiService.kt
│   │   └── RetrofitClient.kt
│   ├── model/                     ← Modelos de datos
│   │   ├── Transaccion.kt
│   │   ├── Categoria.kt
│   │   └── TasaCambioResponse.kt
│   └── repository/                ← Repositorios
│       └── TransaccionRepository.kt
├── ui/                            ← Capa de presentación (View + ViewModel)
│   ├── MainActivity.kt
│   ├── MainViewModel.kt
│   ├── AgregarActivity.kt
│   ├── fragments/
│   │   ├── InicioFragment.kt
│   │   ├── TransaccionesFragment.kt
│   │   └── EstadisticasFragment.kt
│   └── adapters/
│       └── TransaccionAdapter.kt
└── util/                          ← Utilidades
    ├── ResultadoApi.kt
    └── Extensions.kt
```

💡 No es obligatorio mover los archivos ahora. Lo importante es entender la separación de responsabilidades. Pueden reorganizar gradualmente.

---

## 12.3 El Repository: puente entre datos y ViewModel

El Repository es la pieza clave de MVVM. Abstrae el origen de los datos: el ViewModel no sabe si vienen de Room, de Retrofit o de memoria.

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/TransaccionRepository.kt`:

```kotlin
// TransaccionRepository.kt
// Repository que abstrae el acceso a datos
// El ViewModel usa el Repository sin saber si los datos vienen de Room o de la API
package com.ejemplo.misfinanzas

import androidx.lifecycle.LiveData
import com.ejemplo.misfinanzas.api.RetrofitClient
import com.ejemplo.misfinanzas.api.TasaCambioResponse

// El Repository recibe el DAO como dependencia (inyección de dependencias manual)
// Así es fácil de testear: en tests se puede pasar un DAO falso
class TransaccionRepository(private val dao: TransaccionDao) {

    // ===== DATOS LOCALES (Room) =====

    // Exponer los LiveData del DAO directamente
    // El Repository no agrega lógica aquí, solo delega
    // En una app más compleja, podría combinar datos de varias fuentes
    val todasLasTransacciones: LiveData<List<Transaccion>> = dao.obtenerTodas()
    val balance: LiveData<Double> = dao.obtenerBalance()
    val totalIngresos: LiveData<Double> = dao.obtenerTotalIngresos()
    val totalGastos: LiveData<Double> = dao.obtenerTotalGastos()
    val cantidad: LiveData<Int> = dao.obtenerCantidad()

    // Insertar una transacción
    // suspend porque es una operación de escritura que debe ir en segundo plano
    suspend fun insertar(transaccion: Transaccion) {
        dao.insertar(transaccion)
    }

    // Insertar múltiples transacciones
    suspend fun insertarTodas(transacciones: List<Transaccion>) {
        dao.insertarTodas(transacciones)
    }

    // Eliminar una transacción
    suspend fun eliminar(transaccion: Transaccion) {
        dao.eliminar(transaccion)
    }

    // Eliminar todas las transacciones
    suspend fun eliminarTodas() {
        dao.eliminarTodas()
    }

    // ===== DATOS REMOTOS (API) =====

    // Consultar tasas de cambio desde la API
    // suspend porque hace una llamada de red
    // Retorna el resultado directamente (el ViewModel maneja los estados)
    suspend fun obtenerTasasCambio(monedaBase: String = "USD"): TasaCambioResponse {
        return RetrofitClient.apiService.obtenerTasas(monedaBase)
    }
}
```

💡 **¿Por qué el Repository parece innecesario?** Ahora solo delega al DAO. Pero en una app real tendría lógica como:
- "Si hay internet, traer datos frescos de la API y guardarlos en Room"
- "Si no hay internet, usar los datos de Room"
- "Cachear resultados por X minutos"
- "Combinar datos de varias fuentes"

Es una capa de abstracción que vale la pena tener desde el principio.

---

## 12.4 Refactorizar el ViewModel con Repository

✏️ Modificar `MainViewModel.kt`:

```kotlin
// MainViewModel.kt
// ViewModel refactorizado usando el patrón Repository
package com.ejemplo.misfinanzas

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import com.ejemplo.misfinanzas.api.ResultadoApi
import com.ejemplo.misfinanzas.api.TasaCambioResponse
import java.net.UnknownHostException
import java.net.SocketTimeoutException

class MainViewModel(application: Application) : AndroidViewModel(application) {

    // Crear el Repository con el DAO de la base de datos
    // El ViewModel solo conoce al Repository, no al DAO directamente
    private val repository: TransaccionRepository

    // LiveData que vienen del Repository (y por debajo, de Room)
    val transacciones: LiveData<List<Transaccion>>
    val balance: LiveData<Double>
    val ingresos: LiveData<Double>
    val gastos: LiveData<Double>
    val cantidad: LiveData<Int>

    // LiveData para el resultado de la API
    private val _tasasCambio = MutableLiveData<ResultadoApi<TasaCambioResponse>>()
    val tasasCambio: LiveData<ResultadoApi<TasaCambioResponse>> = _tasasCambio

    // init se ejecuta al crear el ViewModel
    init {
        // Obtener el DAO y crear el Repository
        val dao = AppDatabase.obtenerInstancia(application).transaccionDao()
        repository = TransaccionRepository(dao)

        // Asignar los LiveData del Repository
        transacciones = repository.todasLasTransacciones
        balance = repository.balance
        ingresos = repository.totalIngresos
        gastos = repository.totalGastos
        cantidad = repository.cantidad
    }

    // ===== OPERACIONES LOCALES =====

    // Agregar una transacción
    fun agregarTransaccion(transaccion: Transaccion) {
        viewModelScope.launch {
            repository.insertar(transaccion)
        }
    }

    // Eliminar una transacción
    fun eliminarTransaccion(transaccion: Transaccion) {
        viewModelScope.launch {
            repository.eliminar(transaccion)
        }
    }

    // Insertar datos de prueba
    fun insertarDatosDePrueba() {
        viewModelScope.launch {
            repository.insertarTodas(Transaccion.datosDePrueba())
        }
    }

    // Eliminar todas las transacciones
    fun eliminarTodas() {
        viewModelScope.launch {
            repository.eliminarTodas()
        }
    }

    // ===== OPERACIONES REMOTAS =====

    // Consultar tasas de cambio
    fun consultarTasas(monedaBase: String = "USD") {
        _tasasCambio.value = ResultadoApi.Cargando

        viewModelScope.launch {
            try {
                val respuesta = withContext(Dispatchers.IO) {
                    repository.obtenerTasasCambio(monedaBase)
                }
                _tasasCambio.value = ResultadoApi.Exito(respuesta)
            } catch (e: UnknownHostException) {
                _tasasCambio.value = ResultadoApi.Error("Sin conexión a internet")
            } catch (e: SocketTimeoutException) {
                _tasasCambio.value = ResultadoApi.Error("Tiempo de espera agotado")
            } catch (e: Exception) {
                _tasasCambio.value = ResultadoApi.Error("Error: ${e.message}")
            }
        }
    }
}
```

---

## 12.5 Diagrama del flujo de datos en MisFinanzas

```
┌─────────────────────────────────────────────────────────────┐
│                        VIEW (UI)                            │
│  InicioFragment  TransaccionesFragment  EstadisticasFragment│
│       │                  │                    │             │
│       └──────── observe ─┼──── observe ───────┘             │
│                          │                                  │
├──────────────────────────┼──────────────────────────────────┤
│                    VIEWMODEL                                │
│                   MainViewModel                             │
│            LiveData ↑    │ viewModelScope.launch            │
│                          ↓                                  │
├──────────────────────────┼──────────────────────────────────┤
│                    REPOSITORY                               │
│              TransaccionRepository                          │
│                    ↙          ↘                              │
│            Room (local)    Retrofit (remoto)                 │
│         TransaccionDao      ApiService                      │
│              ↓                  ↓                            │
│        SQLite (.db)      API REST (HTTP)                    │
└─────────────────────────────────────────────────────────────┘
```

---

## 12.6 Beneficios de esta arquitectura

| Sin MVVM | Con MVVM |
|----------|----------|
| La Activity hace todo: UI, lógica, datos | Cada capa tiene una responsabilidad |
| Difícil de testear | Fácil de testear cada capa por separado |
| Código duplicado entre pantallas | Repository reutilizable |
| Cambiar la fuente de datos requiere tocar la UI | Cambiar Room por otra BD solo toca el Repository |
| Estado se pierde al rotar | ViewModel sobrevive a rotaciones |

---

## 12.7 Extension functions útiles

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/Extensions.kt`:

```kotlin
// Extensions.kt
// Funciones de extensión reutilizables en toda la app
package com.ejemplo.misfinanzas

// Activity es la clase base de todas las pantallas
import android.app.Activity
// Toast muestra mensajes breves
import android.widget.Toast
// View es la clase base de todos los elementos de UI
import android.view.View

// Extension function para Activity: muestra un Toast de forma simple
// En lugar de escribir Toast.makeText(this, "mensaje", Toast.LENGTH_SHORT).show()
// se puede escribir: mostrarToast("mensaje")
fun Activity.mostrarToast(mensaje: String) {
    Toast.makeText(this, mensaje, Toast.LENGTH_SHORT).show()
}

// Extension function para View: muestra la vista
// En lugar de: binding.tvError.visibility = View.VISIBLE
// se puede escribir: binding.tvError.mostrar()
fun View.mostrar() {
    visibility = View.VISIBLE
}

// Extension function para View: oculta la vista (sin ocupar espacio)
fun View.ocultar() {
    visibility = View.GONE
}

// Extension function para View: oculta la vista (ocupando espacio)
fun View.invisible() {
    visibility = View.INVISIBLE
}

// Extension function para Double: formatea como moneda colombiana
// En lugar de: "$ ${String.format("%,.0f", monto)}"
// se puede escribir: monto.formatearCOP()
fun Double.formatearCOP(): String {
    return "$ ${String.format("%,.0f", this)}"
}

// Extension function para Double: formatea con signo
fun Double.formatearConSigno(): String {
    val signo = if (this >= 0) "+" else ""
    return "$signo$ ${String.format("%,.0f", this)}"
}
```

Uso en cualquier parte de la app:

```kotlin
// Antes:
Toast.makeText(this, "Guardado", Toast.LENGTH_SHORT).show()
binding.tvBalance.text = "$ ${String.format("%,.0f", balance)}"
binding.progressBar.visibility = View.GONE

// Después (con extension functions):
mostrarToast("Guardado")
binding.tvBalance.text = balance.formatearCOP()
binding.progressBar.ocultar()
```

---

## 12.8 Compilar y probar

▶️ Compilar y ejecutar. La app debería funcionar exactamente igual que antes. La diferencia es interna: el código está mejor organizado y es más mantenible.

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| MVVM | Patrón de arquitectura: View-ViewModel-Model |
| Repository | Abstrae el origen de datos (Room, API, etc.) |
| Separación de capas | Cada capa tiene una responsabilidad única |
| `AndroidViewModel` | ViewModel que recibe Application para acceder a datos |
| Extension functions | Agregar funciones a clases existentes sin modificarlas |
| Inyección de dependencias | Pasar dependencias por constructor (DAO al Repository) |
| Estructura de carpetas | Organizar por capa: data/, ui/, util/ |

---

**Anterior:** [← Capítulo 11 — Consumo de APIs con Retrofit](11_retrofit_api.md) | **Siguiente:** [Capítulo 13 — Kotlin avanzado →](13_kotlin_avanzado.md)
