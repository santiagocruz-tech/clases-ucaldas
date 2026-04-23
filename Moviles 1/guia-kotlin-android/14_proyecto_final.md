# Capítulo 14: Proyecto final — MisFinanzas completa

## Objetivo

Repasar todo lo aprendido, pulir la app MisFinanzas y tener una referencia completa de buenas prácticas, convenciones y la estructura final del proyecto.

---

## 14.1 Lo que construimos

A lo largo de 14 capítulos, construimos **MisFinanzas** desde cero. Repasemos qué tiene la app:

| Funcionalidad | Capítulo | Tecnología |
|---------------|----------|------------|
| Proyecto base y "Hola Mundo" | 01 | Activity, View Binding |
| Cálculo de balance | 02 | Kotlin básico, funciones |
| Interfaz con tarjetas | 03 | LinearLayout, CardView, XML |
| Modelo de datos | 04 | Data classes, enums |
| Lista de transacciones | 05 | RecyclerView, Adapter |
| Agregar transacciones | 06 | Intents, navegación, formularios |
| Estado que sobrevive rotaciones | 07 | ViewModel, LiveData |
| Datos persistentes | 08 | Room (SQLite) |
| Validación de formularios | 09 | TextInputLayout, Material Design |
| Navegación por pestañas | 10 | Fragments, BottomNavigationView |
| Consulta de tasas de cambio | 11 | Retrofit, APIs REST |
| Arquitectura limpia | 12 | MVVM, Repository pattern |
| Código avanzado | 13 | Coroutines, sealed classes, lambdas |

---

## 14.2 Estructura final del proyecto

```
MisFinanzas/
├── app/
│   ├── build.gradle.kts
│   └── src/main/
│       ├── AndroidManifest.xml
│       ├── java/com/ejemplo/misfinanzas/
│       │   ├── MainActivity.kt              ← Activity con BottomNav
│       │   ├── AgregarActivity.kt           ← Formulario de nueva transacción
│       │   ├── MainViewModel.kt             ← ViewModel compartido
│       │   ├── Transaccion.kt               ← Entity de Room + modelo
│       │   ├── Categoria.kt                 ← Enum de categorías
│       │   ├── TransaccionDao.kt            ← DAO con consultas SQL
│       │   ├── AppDatabase.kt               ← Base de datos Room
│       │   ├── TransaccionRepository.kt     ← Repository (MVVM)
│       │   ├── TransaccionAdapter.kt        ← Adapter del RecyclerView
│       │   ├── InicioFragment.kt            ← Pestaña de inicio
│       │   ├── TransaccionesFragment.kt     ← Pestaña de movimientos
│       │   ├── EstadisticasFragment.kt      ← Pestaña de estadísticas
│       │   ├── Extensions.kt               ← Funciones de extensión
│       │   └── api/
│       │       ├── ApiService.kt            ← Endpoints de Retrofit
│       │       ├── RetrofitClient.kt        ← Configuración de Retrofit
│       │       ├── TasaCambioResponse.kt    ← Modelo de respuesta API
│       │       └── ResultadoApi.kt          ← Sealed class de estados
│       └── res/
│           ├── layout/
│           │   ├── activity_main.xml        ← Layout con FrameLayout + BottomNav
│           │   ├── activity_agregar.xml     ← Formulario
│           │   ├── fragment_inicio.xml      ← Resumen de balance
│           │   ├── fragment_transacciones.xml ← Lista completa
│           │   ├── fragment_estadisticas.xml  ← Estadísticas
│           │   └── item_transaccion.xml     ← Item del RecyclerView
│           ├── menu/
│           │   └── bottom_menu.xml          ← Menú de navegación
│           └── values/
│               ├── colors.xml               ← Colores de la app
│               ├── strings.xml              ← Textos de la app
│               └── themes.xml               ← Tema Material Design
├── build.gradle.kts                          ← Configuración global
├── settings.gradle.kts                       ← Módulos del proyecto
└── gradle.properties                         ← Propiedades de Gradle
```

---

## 14.3 Dependencias completas

🔧 `app/build.gradle.kts` final:

```kotlin
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // kapt: procesador de anotaciones para Room
    id("kotlin-kapt")
}

android {
    namespace = "com.ejemplo.misfinanzas"
    // compileSdk: versión del SDK para compilar
    compileSdk = 34

    defaultConfig {
        applicationId = "com.ejemplo.misfinanzas"
        // minSdk: versión mínima de Android soportada
        minSdk = 24
        // targetSdk: versión de Android para la que se optimiza
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    // Activar View Binding para acceder a vistas desde Kotlin
    buildFeatures {
        viewBinding = true
    }

    // Configurar compatibilidad con Java 17
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // Configurar Kotlin para usar JVM 17
    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    // AndroidX Core: extensiones de Kotlin para Android
    implementation("androidx.core:core-ktx:1.12.0")
    // AppCompat: compatibilidad con versiones antiguas de Android
    implementation("androidx.appcompat:appcompat:1.6.1")
    // Material Design: componentes de UI modernos
    implementation("com.google.android.material:material:1.11.0")
    // ConstraintLayout: layout flexible con restricciones
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")

    // ViewModel: componente que sobrevive a rotaciones
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0")
    // LiveData: datos observables
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.7.0")
    // Activity KTX: extensiones para viewModels()
    implementation("androidx.activity:activity-ktx:1.8.2")

    // Room: base de datos local (ORM sobre SQLite)
    implementation("androidx.room:room-runtime:2.6.1")
    implementation("androidx.room:room-ktx:2.6.1")
    kapt("androidx.room:room-compiler:2.6.1")

    // Retrofit: cliente HTTP para APIs REST
    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    // Gson: parseo de JSON
    implementation("com.google.code.gson:gson:2.10.1")

    // Coroutines: programación asíncrona
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
}
```

---

## 14.4 Convenciones de nombres

| Elemento | Convención | Ejemplo |
|----------|-----------|---------|
| Clases | PascalCase | `MainActivity`, `TransaccionAdapter` |
| Funciones y variables | camelCase | `obtenerTodas()`, `listaTransacciones` |
| Constantes | UPPER_SNAKE_CASE | `BASE_URL`, `MAX_DESCRIPCION` |
| Layouts XML | snake_case | `activity_main.xml`, `item_transaccion.xml` |
| IDs en XML | camelCase con prefijo | `tvTitulo`, `etMonto`, `btnGuardar` |
| Paquetes | minúsculas | `com.ejemplo.misfinanzas` |

### Prefijos para IDs en XML

| Prefijo | Tipo de vista | Ejemplo |
|---------|--------------|---------|
| `tv` | TextView | `tvBalance`, `tvNombre` |
| `et` | EditText | `etMonto`, `etDescripcion` |
| `btn` | Button | `btnGuardar`, `btnCancelar` |
| `iv` | ImageView | `ivFoto`, `ivIcono` |
| `rv` | RecyclerView | `rvTransacciones` |
| `til` | TextInputLayout | `tilEmail`, `tilMonto` |
| `sp` | Spinner | `spCategoria` |
| `cb` | CheckBox | `cbAceptar` |
| `sw` | Switch | `swNotificaciones` |
| `rb` | RadioButton | `rbGasto`, `rbIngreso` |
| `rg` | RadioGroup | `rgTipo` |
| `pb` | ProgressBar | `pbCargando` |
| `fab` | FloatingActionButton | `fabAgregar` |

---

## 14.5 Buenas prácticas

### Kotlin

```kotlin
// ✅ Usar val siempre que sea posible
val nombre = "Juan"

// ❌ Usar var cuando el valor nunca cambia
var nombre = "Juan"

// ✅ Usar .apply para configurar objetos
val intent = Intent(this, DetalleActivity::class.java).apply {
    putExtra("ID", 123)
    putExtra("NOMBRE", "Producto")
}

// ❌ Repetir la referencia
val intent = Intent(this, DetalleActivity::class.java)
intent.putExtra("ID", 123)
intent.putExtra("NOMBRE", "Producto")

// ✅ Usar safe calls y Elvis operator
val nombre = intent.getStringExtra("NOMBRE") ?: "Sin nombre"

// ❌ Usar !! (puede crashear)
val nombre = intent.getStringExtra("NOMBRE")!!

// ✅ Usar when con sealed class (el compilador verifica todos los casos)
when (estado) {
    is Estado.Cargando -> mostrarCarga()
    is Estado.Exito -> mostrarDatos(estado.datos)
    is Estado.Error -> mostrarError(estado.mensaje)
}

// ✅ Usar funciones de extensión para código repetitivo
fun Double.formatearCOP(): String = "$ ${String.format("%,.0f", this)}"
```

### Android

```kotlin
// ✅ Usar viewModelScope o lifecycleScope para coroutines
viewModelScope.launch { ... }

// ❌ Usar GlobalScope (no se cancela, causa memory leaks)
GlobalScope.launch { ... }

// ✅ Limpiar binding en Fragments
override fun onDestroyView() {
    super.onDestroyView()
    _binding = null
}

// ✅ Usar viewLifecycleOwner en Fragments para observar LiveData
viewModel.datos.observe(viewLifecycleOwner) { ... }

// ❌ Usar "this" en Fragments para observar LiveData
viewModel.datos.observe(this) { ... }

// ✅ Verificar savedInstanceState antes de cargar Fragment
if (savedInstanceState == null) {
    cargarFragment(InicioFragment())
}

// ✅ Usar Dispatchers.IO para operaciones de red y disco
withContext(Dispatchers.IO) { apiService.obtenerDatos() }

// ❌ Hacer llamadas de red en el hilo principal
val datos = apiService.obtenerDatos()  // CRASH: NetworkOnMainThreadException
```

---

## 14.6 Equivalencias Flutter - Android Nativo

Para los que vienen de Flutter, esta tabla mapea lo que ya saben:

| En Flutter (Dart) | En Android (Kotlin) |
|-------------------|---------------------|
| Widget | View |
| StatelessWidget | XML Layout + Activity |
| StatefulWidget + setState | Activity + ViewModel + LiveData |
| Column | LinearLayout (vertical) |
| Row | LinearLayout (horizontal) |
| Stack | FrameLayout |
| ListView.builder | RecyclerView + Adapter |
| Navigator.push | startActivity(Intent) |
| Navigator.pop | finish() |
| TextField | EditText / TextInputEditText |
| ElevatedButton | Button / MaterialButton |
| Card | MaterialCardView |
| Scaffold | Activity + AppBar + BottomNav |
| Provider / ChangeNotifier | ViewModel + LiveData |
| FutureBuilder | LiveData.observe() |
| SharedPreferences (Flutter) | SharedPreferences (Android) |
| sqflite | Room |
| http / dio | Retrofit |
| async / await | Coroutines (suspend / launch) |
| pubspec.yaml | build.gradle.kts |
| flutter run | Shift+F10 o `./gradlew installDebug` |

---

## 14.7 Atajos del IDE

### Android Studio / IntelliJ IDEA

| Atajo | Qué hace |
|-------|----------|
| `Shift + F10` | Correr la app |
| `Alt + Enter` | Quick fix / importar clase |
| `Ctrl + Space` | Autocompletar |
| `Ctrl + B` | Ir a la definición |
| `Ctrl + Shift + F` | Buscar en todo el proyecto |
| `Ctrl + Alt + L` | Formatear código |
| `Ctrl + D` | Duplicar línea |
| `Ctrl + /` | Comentar/descomentar |
| `Shift + Shift` | Buscar cualquier cosa |

### VS Code

| Atajo | Qué hace |
|-------|----------|
| `` Ctrl + ` `` | Abrir terminal |
| `Ctrl + Shift + P` | Paleta de comandos |
| `Ctrl + P` | Buscar archivo |
| `Ctrl + Shift + F` | Buscar en todo el proyecto |
| `Ctrl + /` | Comentar/descomentar |

---

## 14.8 Problemas comunes y soluciones

| Problema | Solución |
|----------|----------|
| "Unresolved reference" | `Alt + Enter` para importar la clase |
| "Cannot access database on the main thread" | Usar `suspend` + `viewModelScope.launch` |
| La lista no se actualiza | Verificar que el LiveData tiene un observer activo |
| Crash al rotar | Usar ViewModel en lugar de variables en la Activity |
| "No adapter attached" | Asignar el adapter al RecyclerView en onCreate |
| Binding null en Fragment | Verificar que se usa entre onCreateView y onDestroyView |
| "Activity not found" | Registrar la Activity en AndroidManifest.xml |
| Retrofit falla silenciosamente | Agregar permiso INTERNET en AndroidManifest.xml |
| Room no compila | Verificar que el plugin `kotlin-kapt` está agregado |
| Gradle no sincroniza | Verificar conexión a internet, limpiar con `./gradlew clean` |

---

## 14.9 ¿Qué sigue?

Temas que pueden explorar por su cuenta para seguir creciendo:

| Tema | Para qué | Recurso |
|------|----------|---------|
| Jetpack Compose | UI declarativa (el futuro de Android) | [developer.android.com/compose](https://developer.android.com/compose) |
| Navigation Component | Navegación más robusta entre Fragments | [developer.android.com/guide/navigation](https://developer.android.com/guide/navigation) |
| Hilt / Dagger | Inyección de dependencias automática | [developer.android.com/training/dependency-injection/hilt-android](https://developer.android.com/training/dependency-injection/hilt-android) |
| DataStore | Reemplazo moderno de SharedPreferences | [developer.android.com/topic/libraries/architecture/datastore](https://developer.android.com/topic/libraries/architecture/datastore) |
| WorkManager | Tareas en segundo plano | [developer.android.com/topic/libraries/architecture/workmanager](https://developer.android.com/topic/libraries/architecture/workmanager) |
| Testing | Pruebas unitarias y de UI | [developer.android.com/training/testing](https://developer.android.com/training/testing) |
| Firebase | Backend as a Service | [firebase.google.com](https://firebase.google.com) |

---

## 14.10 Referencias

- Documentación de Kotlin: [kotlinlang.org/docs](https://kotlinlang.org/docs/home.html)
- Kotlin Playground: [play.kotlinlang.org](https://play.kotlinlang.org)
- Codelabs de Android: [developer.android.com/courses](https://developer.android.com/courses)
- RecyclerView: [developer.android.com/develop/ui/views/layout/recyclerview](https://developer.android.com/develop/ui/views/layout/recyclerview)
- View Binding: [developer.android.com/topic/libraries/view-binding](https://developer.android.com/topic/libraries/view-binding)
- Room: [developer.android.com/training/data-storage/room](https://developer.android.com/training/data-storage/room)
- Retrofit: [square.github.io/retrofit](https://square.github.io/retrofit/)
- Coroutines: [kotlinlang.org/docs/coroutines-overview.html](https://kotlinlang.org/docs/coroutines-overview.html)
- Arquitectura Android: [developer.android.com/topic/architecture](https://developer.android.com/topic/architecture)

---

## Felicitaciones

Si llegaron hasta aquí, tienen una base sólida en desarrollo Android nativo con Kotlin. Construyeron una app completa con:

- Interfaz Material Design con tarjetas, listas y navegación por pestañas
- Modelo de datos con data classes y enums
- Persistencia local con Room (SQLite)
- Consumo de APIs con Retrofit
- Arquitectura MVVM con Repository pattern
- Manejo de estado con ViewModel y LiveData
- Código limpio con coroutines, extension functions y operaciones funcionales

El siguiente paso es practicar. Tomen esta app y agréguenle funcionalidades: filtros por fecha, gráficos, exportar a CSV, tema oscuro, notificaciones. Cada feature nueva es una oportunidad de reforzar lo aprendido.

---

**Anterior:** [← Capítulo 13 — Kotlin avanzado](13_kotlin_avanzado.md) | **Inicio:** [README →](README.md)
