# Capítulo 11: Consumo de APIs con Retrofit

## Objetivo

Agregar a MisFinanzas la capacidad de consultar tasas de cambio desde una API externa usando Retrofit. Aprenderemos a hacer peticiones HTTP, parsear JSON y manejar estados de carga/error.

---

## 11.1 ¿Qué es Retrofit?

Retrofit es la librería estándar para consumir APIs REST en Android. Convierte las respuestas JSON en objetos Kotlin automáticamente usando Gson.

| Concepto | En Flutter (http/dio) | En Android (Retrofit) |
|----------|----------------------|----------------------|
| Definir endpoints | Funciones sueltas | Interfaz con anotaciones |
| Parsear JSON | `jsonDecode` + `fromJson` | Gson + data class |
| Llamadas async | `async` / `await` | `suspend` / coroutines |
| Cliente HTTP | `http.Client` / `Dio` | `Retrofit.Builder()` |

---

## 11.2 Configurar dependencias

🔧 Agregar en `app/build.gradle.kts`:

```kotlin
dependencies {
    // ... las que ya tienen

    // Retrofit: cliente HTTP para consumir APIs
    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    // Converter Gson: convierte JSON a objetos Kotlin automáticamente
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    // Gson: librería de Google para parsear JSON
    implementation("com.google.code.gson:gson:2.10.1")
    // Coroutines Android: para ejecutar llamadas de red en segundo plano
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
}
```

Verificar que el permiso de internet esté en `AndroidManifest.xml`:

```xml
<!-- Fuera de <application>, dentro de <manifest> -->
<uses-permission android:name="android.permission.INTERNET" />
```

💡 Sin este permiso, las llamadas de red fallan silenciosamente. Es un error clásico.

---

## 11.3 Modelo de datos para la API

Vamos a usar una API gratuita de tasas de cambio. La respuesta JSON tiene esta estructura:

```json
{
  "base": "USD",
  "rates": {
    "COP": 4150.50,
    "EUR": 0.92,
    "GBP": 0.79
  }
}
```

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/api/TasaCambioResponse.kt`:

```kotlin
// TasaCambioResponse.kt
// Data class que representa la respuesta JSON de la API de tasas de cambio
package com.ejemplo.misfinanzas.api

// Gson convierte automáticamente los campos del JSON a propiedades de la clase
// Los nombres de las propiedades deben coincidir con las claves del JSON
// Si no coinciden, se usa @SerializedName para mapearlos
data class TasaCambioResponse(
    val base: String,                    // moneda base (ej: "USD")
    val rates: Map<String, Double>       // mapa de moneda -> tasa (ej: "COP" -> 4150.50)
    // Map<String, Double> porque "rates" es un objeto JSON con claves String y valores numéricos
)
```

---

## 11.4 Definir los endpoints

En Retrofit, los endpoints se definen como una interfaz. Cada función es un endpoint de la API.

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/api/ApiService.kt`:

```kotlin
// ApiService.kt
// Interfaz que define los endpoints de la API
package com.ejemplo.misfinanzas.api

// @GET indica que es una petición HTTP GET
import retrofit2.http.GET
// @Query agrega parámetros a la URL (?clave=valor)
import retrofit2.http.Query

// Cada función de esta interfaz es un endpoint de la API
// Retrofit genera la implementación automáticamente
interface ApiService {

    // @GET define la ruta relativa del endpoint
    // "latest" se concatena con la BASE_URL del RetrofitClient
    // suspend indica que se ejecuta en una coroutine (segundo plano)
    @GET("latest")
    suspend fun obtenerTasas(
        // @Query agrega parámetros a la URL
        // Resultado: /latest?base=USD
        @Query("base") monedaBase: String = "USD"
    ): TasaCambioResponse
    // El tipo de retorno es la data class que representa la respuesta JSON
    // Gson la convierte automáticamente
}
```

---

## 11.5 Configurar el cliente Retrofit

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/api/RetrofitClient.kt`:

```kotlin
// RetrofitClient.kt
// Singleton que configura y proporciona la instancia de Retrofit
package com.ejemplo.misfinanzas.api

// Retrofit es el builder principal
import retrofit2.Retrofit
// GsonConverterFactory convierte JSON a objetos Kotlin
import retrofit2.converter.gson.GsonConverterFactory

// "object" en Kotlin crea un Singleton (una sola instancia en toda la app)
// No se necesita crear instancias con "new" ni manejar el patrón manualmente
object RetrofitClient {

    // URL base de la API (todas las rutas se concatenan a esta)
    // Debe terminar en "/" para que Retrofit concatene correctamente
    private const val BASE_URL = "https://api.exchangerate-api.com/v4/"

    // "by lazy" significa que solo se crea cuando se usa por primera vez
    // Después de crearse, se reutiliza la misma instancia
    val apiService: ApiService by lazy {
        Retrofit.Builder()
            // URL base de todas las peticiones
            .baseUrl(BASE_URL)
            // Agregar el converter de Gson para parsear JSON automáticamente
            .addConverterFactory(GsonConverterFactory.create())
            // Construir la instancia de Retrofit
            .build()
            // Crear la implementación de la interfaz ApiService
            .create(ApiService::class.java)
    }
}
```

---

## 11.6 Sealed class para manejar estados

Antes de conectar con la UI, necesitamos una forma de representar los tres estados posibles de una llamada de red: cargando, éxito y error.

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/api/ResultadoApi.kt`:

```kotlin
// ResultadoApi.kt
// Sealed class que representa los posibles estados de una llamada a la API
package com.ejemplo.misfinanzas.api

// sealed class es como un enum pero donde cada opción puede tener datos diferentes
// El compilador verifica que se manejen todos los casos en un "when"
sealed class ResultadoApi<out T> {
    // T es un tipo genérico: puede ser cualquier tipo de dato

    // Estado de carga: la petición está en progreso
    // "object" porque no necesita datos adicionales
    object Cargando : ResultadoApi<Nothing>()

    // Estado de éxito: la petición terminó bien y tenemos datos
    // "data class" porque necesita guardar los datos recibidos
    data class Exito<T>(val datos: T) : ResultadoApi<T>()

    // Estado de error: la petición falló
    // Guarda el mensaje de error para mostrarlo al usuario
    data class Error(val mensaje: String) : ResultadoApi<Nothing>()
}
```

---

## 11.7 Agregar la funcionalidad al ViewModel

✏️ Agregar en `MainViewModel.kt` las funciones para consultar la API:

```kotlin
// Agregar estas propiedades y funciones dentro de la clase MainViewModel.
// También agregar estos imports al inicio del archivo:
import com.ejemplo.misfinanzas.api.RetrofitClient
import com.ejemplo.misfinanzas.api.ResultadoApi
import com.ejemplo.misfinanzas.api.TasaCambioResponse
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.net.UnknownHostException
import java.net.SocketTimeoutException

// --- Agregar dentro de la clase MainViewModel: ---

    // LiveData para el resultado de la consulta de tasas de cambio
    private val _tasasCambio = MutableLiveData<ResultadoApi<TasaCambioResponse>>()
    val tasasCambio: LiveData<ResultadoApi<TasaCambioResponse>> = _tasasCambio

    // Consulta las tasas de cambio desde la API
    fun consultarTasas(monedaBase: String = "USD") {
        // Indicar que estamos cargando
        _tasasCambio.value = ResultadoApi.Cargando

        viewModelScope.launch {
            try {
                // withContext(Dispatchers.IO) ejecuta el bloque en un hilo de I/O
                // Las llamadas de red SIEMPRE deben ir en Dispatchers.IO
                // No en el hilo principal (Main) porque bloquearía la UI
                val respuesta = withContext(Dispatchers.IO) {
                    RetrofitClient.apiService.obtenerTasas(monedaBase)
                }
                // Si llegamos aquí, la petición fue exitosa
                _tasasCambio.value = ResultadoApi.Exito(respuesta)

            } catch (e: UnknownHostException) {
                // No hay conexión a internet
                _tasasCambio.value = ResultadoApi.Error("Sin conexión a internet")
            } catch (e: SocketTimeoutException) {
                // La petición tardó demasiado
                _tasasCambio.value = ResultadoApi.Error("Tiempo de espera agotado")
            } catch (e: Exception) {
                // Cualquier otro error
                _tasasCambio.value = ResultadoApi.Error("Error: ${e.message}")
            }
        }
    }
```

---

## 11.8 Mostrar tasas de cambio en EstadisticasFragment

✏️ Agregar en `fragment_estadisticas.xml` una sección para tasas de cambio:

```xml
<!-- Agregar después del CardView de resumen -->

<!-- Tarjeta de tasas de cambio -->
<com.google.android.material.card.MaterialCardView
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_marginTop="16dp"
    app:cardCornerRadius="12dp"
    app:cardElevation="2dp">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="16dp">

        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="💱 Tasas de cambio (USD)"
            android:textSize="16sp"
            android:textStyle="bold" />

        <!-- ProgressBar se muestra mientras carga -->
        <ProgressBar
            android:id="@+id/progressTasas"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_gravity="center"
            android:layout_marginTop="8dp"
            android:visibility="gone" />

        <!-- Texto con las tasas o el error -->
        <TextView
            android:id="@+id/tvTasas"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:textSize="14sp"
            android:layout_marginTop="8dp" />

        <!-- Botón para consultar -->
        <Button
            android:id="@+id/btnConsultarTasas"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="Consultar tasas"
            android:layout_marginTop="8dp"
            style="@style/Widget.MaterialComponents.Button.OutlinedButton" />

    </LinearLayout>
</com.google.android.material.card.MaterialCardView>
```

✏️ Agregar en `EstadisticasFragment.kt` la observación de las tasas:

```kotlin
// Agregar estos imports en EstadisticasFragment.kt:
import android.view.View
import com.ejemplo.misfinanzas.api.ResultadoApi

// Agregar en onViewCreated de EstadisticasFragment:

// Observar el resultado de la consulta de tasas
viewModel.tasasCambio.observe(viewLifecycleOwner) { resultado ->
    // "when" con sealed class: el compilador verifica que cubramos todos los casos
    when (resultado) {
        is ResultadoApi.Cargando -> {
            // Mostrar el indicador de carga
            binding.progressTasas.visibility = View.VISIBLE
            binding.tvTasas.text = ""
        }
        is ResultadoApi.Exito -> {
            // Ocultar el indicador de carga
            binding.progressTasas.visibility = View.GONE
            // Mostrar las tasas relevantes
            val tasas = resultado.datos.rates
            val texto = buildString {
                // buildString construye un String de forma eficiente
                appendLine("1 USD = ${tasas["COP"] ?: "N/A"} COP")
                appendLine("1 USD = ${tasas["EUR"] ?: "N/A"} EUR")
                appendLine("1 USD = ${tasas["GBP"] ?: "N/A"} GBP")
                appendLine("1 USD = ${tasas["BRL"] ?: "N/A"} BRL")
                append("1 USD = ${tasas["MXN"] ?: "N/A"} MXN")
            }
            binding.tvTasas.text = texto
        }
        is ResultadoApi.Error -> {
            binding.progressTasas.visibility = View.GONE
            binding.tvTasas.text = resultado.mensaje
            binding.tvTasas.setTextColor(
                requireContext().getColor(R.color.rojo_gasto)
            )
        }
    }
}

// Botón para consultar tasas
binding.btnConsultarTasas.setOnClickListener {
    viewModel.consultarTasas()
}
```

---

## 11.9 Compilar y probar

▶️ Compilar y ejecutar. En la pestaña Estadísticas:
1. Presionar "Consultar tasas"
2. Debería aparecer un indicador de carga brevemente
3. Luego las tasas de cambio actuales
4. Si no hay internet, debería mostrar "Sin conexión a internet"

---

## 11.10 Resumen del flujo de una llamada API

```
Usuario presiona botón
    → ViewModel.consultarTasas()
        → _tasasCambio.value = Cargando
        → withContext(Dispatchers.IO) { RetrofitClient.apiService.obtenerTasas() }
            → Retrofit hace la petición HTTP GET
            → Gson convierte el JSON a TasaCambioResponse
        → _tasasCambio.value = Exito(respuesta)
    → Fragment observa el LiveData
        → when (Cargando) → mostrar ProgressBar
        → when (Exito) → mostrar datos
        → when (Error) → mostrar mensaje de error
```

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| Retrofit | Cliente HTTP para consumir APIs REST |
| `@GET`, `@POST` | Definir el método HTTP del endpoint |
| `@Query` | Agregar parámetros a la URL |
| `GsonConverterFactory` | Convertir JSON a objetos Kotlin automáticamente |
| `suspend` en ApiService | Ejecutar llamadas de red en coroutines |
| `Dispatchers.IO` | Hilo para operaciones de red y disco |
| `withContext` | Cambiar de hilo dentro de una coroutine |
| `sealed class` | Representar estados (Cargando/Exito/Error) |
| `object` (Singleton) | Una sola instancia del cliente Retrofit |
| `by lazy` | Inicialización perezosa (solo cuando se usa) |
| `ProgressBar` | Indicador visual de carga |

---

**Anterior:** [← Capítulo 10 — Fragments y Bottom Navigation](10_fragments_navegacion.md) | **Siguiente:** [Capítulo 12 — Arquitectura MVVM →](12_arquitectura_mvvm.md)
