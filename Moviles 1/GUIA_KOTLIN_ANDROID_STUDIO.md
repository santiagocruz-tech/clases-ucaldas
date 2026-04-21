# Guía de Kotlin y Android Studio — Desde Cero
## Continuación del curso · Ingeniería de Informática

**Requisitos previos:** Haber completado la guía de Flutter (readme.md) y el taller introductorio de Android Studio con Kotlin. Tener Android Studio instalado y funcionando.

---

Esta guía es la continuación natural de lo que ya vimos con Flutter. La idea es que puedan hacer el salto a desarrollo nativo Android sin perderse. Van a notar que muchos conceptos son los mismos (listas, navegación, consumo de APIs, persistencia), solo cambia la forma de implementarlos.

Si ya hicieron el taller de la lista de tareas, acá vamos a profundizar en todo lo que quedó pendiente: navegación entre pantallas, consumo de APIs con Retrofit, bases de datos con Room, y la arquitectura MVVM que es el estándar en Android.

---

## Tabla de Contenidos

1. [Repaso rápido — Lo que ya saben del taller](#1-repaso-rápido)
2. [Kotlin más a fondo](#2-kotlin-más-a-fondo)
3. [El sistema de vistas de Android](#3-el-sistema-de-vistas-de-android)
4. [Layouts y diseño XML](#4-layouts-y-diseño-xml)
5. [Navegación entre pantallas](#5-navegación-entre-pantallas)
6. [Ciclo de vida y gestión de estado](#6-ciclo-de-vida-y-gestión-de-estado)
7. [Consumo de APIs con Retrofit](#7-consumo-de-apis-con-retrofit)
8. [Persistencia de datos](#8-persistencia-de-datos)
9. [Formularios y validación](#9-formularios-y-validación)
10. [RecyclerView a fondo](#10-recyclerview-a-fondo)
11. [Fragments](#11-fragments)
12. [Arquitectura MVVM](#12-arquitectura-mvvm)
13. [Buenas prácticas](#13-buenas-prácticas)
14. [Ejercicios](#14-ejercicios)
15. [Desarrollo Android sin Android Studio (hardware limitado)](#15-desarrollo-android-sin-android-studio)

---

## 1. Repaso rápido

Esto ya lo vieron en el taller, pero vale la pena tenerlo como referencia.

### Antes que nada: verificar que el SDK está bien

Este es el problema más común. Abren Android Studio, crean un proyecto, le dan Run y no pasa nada, o sale un error raro. Casi siempre es porque el SDK no se instaló completo o le falta algún componente.

#### Verificar desde Android Studio

Ir a **File → Settings → Languages & Frameworks → Android SDK** (en macOS: **Android Studio → Settings → ...**).

En la pestaña **SDK Platforms**, verificar que tengan al menos una versión instalada (el checkbox marcado). Recomendado: **Android 14.0 (API 34)**. Si no hay ninguna marcada, marcarla y darle **Apply**.

En la pestaña **SDK Tools**, verificar que estén instalados estos (todos con checkbox marcado):

| Componente | ¿Para qué sirve? |
|-----------|-------------------|
| Android SDK Build-Tools | Compila el código |
| Android SDK Platform-Tools | Herramientas como `adb` (conectar celular) |
| Android Emulator | El emulador (si van a usarlo) |
| Android SDK Command-line Tools | Herramientas de terminal |

Si falta alguno, marcarlo y darle **Apply**. Va a descargar lo que falte.

#### Verificar desde la terminal

Abrir una terminal (en Android Studio: **View → Tool Windows → Terminal**) y correr:

```bash
# Ver dónde está el SDK
echo $ANDROID_HOME
# o en Windows:
echo %ANDROID_HOME%
```

Si no muestra nada, el SDK no está configurado en las variables de entorno. Pueden ver la ruta del SDK en **File → Settings → Android SDK** arriba donde dice "Android SDK Location". Normalmente es:
- Windows: `C:\Users\TuUsuario\AppData\Local\Android\Sdk`
- macOS: `/Users/TuUsuario/Library/Android/sdk`
- Linux: `/home/TuUsuario/Android/Sdk`

Luego verificar que las herramientas existen:

```bash
# Verificar adb (para conectar celulares)
adb version
# Debería mostrar algo como: Android Debug Bridge version 1.0.41

# Verificar que hay plataformas instaladas
ls $ANDROID_HOME/platforms/
# Debería mostrar al menos una carpeta como: android-34
```

Si `adb` no se encuentra, es porque `platform-tools` no está instalado o no está en el PATH.

#### Aceptar las licencias

Esto es otro clásico. Gradle se niega a compilar porque no aceptaron las licencias del SDK:

```bash
# Desde la terminal de Android Studio o cualquier terminal:
sdkmanager --licenses
# Responder 'y' a todo lo que pregunte
```

Si `sdkmanager` no se encuentra, la ruta completa suele ser:
```bash
# Windows
C:\Users\TuUsuario\AppData\Local\Android\Sdk\cmdline-tools\latest\bin\sdkmanager --licenses

# Linux/macOS
~/Android/Sdk/cmdline-tools/latest/bin/sdkmanager --licenses
```

#### "No target device found" al darle Run

Esto significa que no tienen ni emulador ni celular conectado. Dos opciones:

**Opción A: Crear un emulador**
1. En Android Studio ir a **Device Manager** (icono de celular en la barra lateral derecha)
2. Click en **Create Device**
3. Elegir un dispositivo (Pixel 6 está bien)
4. Seleccionar una imagen del sistema — **descargar una si no hay ninguna** (click en el ícono de descarga junto a la versión)
5. Darle Finish y luego presionar el botón de Play del emulador

Si el emulador no arranca o va muy lento, probablemente necesitan activar la virtualización en la BIOS (Intel HAXM o AMD-V). Busquen "Enable virtualization" + la marca de su computador.

**Opción B: Conectar un celular físico (recomendado si tienen poca RAM)**
1. En el celular: **Ajustes → Acerca del teléfono → Tocar 7 veces "Número de compilación"** (esto activa las opciones de desarrollador)
2. Volver a Ajustes → **Opciones de desarrollador → Activar "Depuración USB"**
3. Conectar por USB
4. Aceptar la autorización que aparece en la pantalla del celular
5. En Android Studio debería aparecer el nombre del celular arriba junto al botón de Run

Si no aparece, verificar con:
```bash
adb devices
```
Si la lista está vacía, probar otro cable USB (algunos cables solo cargan, no transmiten datos) o instalar los drivers del celular.

#### Resumen rápido de diagnóstico

| Síntoma | Causa probable | Solución |
|---------|---------------|----------|
| "SDK location not found" | No se instaló el SDK | Instalar desde Settings → Android SDK |
| "No target device found" | No hay emulador ni celular | Crear emulador o conectar celular USB |
| "License not accepted" | No aceptaron licencias | `sdkmanager --licenses` |
| Gradle falla al sincronizar | Falta Build-Tools o Platform | Instalar desde SDK Tools |
| El emulador no arranca | Virtualización desactivada | Activar en BIOS (Intel HAXM / AMD-V) |
| `adb` no encontrado | platform-tools no instalado o no en PATH | Instalar desde SDK Tools |
| El celular no aparece | Cable malo o drivers faltantes | Probar otro cable, instalar drivers |

Si después de todo esto sigue sin funcionar, revisen la sección 15 de esta guía donde se explica cómo desarrollar sin Android Studio usando VS Code y la terminal.

### Crear un proyecto

**File → New → New Project → Empty Views Activity**

- Language: Kotlin
- Minimum SDK: API 24
- Build configuration language: Kotlin DSL

Esperar a que Gradle sincronice. La primera vez tarda.

### Estructura que importa

```
app/src/main/
├── java/com/ejemplo/miapp/    ← Código Kotlin (sí, la carpeta se llama "java" por legado)
│   └── MainActivity.kt
├── res/
│   ├── layout/                 ← XMLs de interfaz
│   ├── values/                 ← Strings, colores, temas
│   ├── drawable/               ← Imágenes y formas
│   └── menu/                   ← Menús
└── AndroidManifest.xml         ← Registro de Activities, permisos, etc.
```

### View Binding

Ya lo usaron en el taller. Recordar activarlo en `build.gradle.kts`:

```kotlin
android {
    buildFeatures {
        viewBinding = true
    }
}
```

Y en la Activity:

```kotlin
class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.tvTitulo.text = "Funciona"
    }
}
```

### Lo que ya saben de Kotlin

Del taller: `val`/`var`, null safety (`?`, `?:`, `!!`), funciones, `when`, colecciones (`filter`, `map`, `reduce`), data classes, y el patrón Adapter + RecyclerView.

Si necesitan repasar algo de eso, revisen el documento del taller. Acá vamos a ir más allá.

---

## 2. Kotlin más a fondo

Estas son las cosas de Kotlin que no alcanzamos a ver en el taller pero que van a necesitar para las apps más completas.

### Extension Functions

Esto les va a gustar. Pueden agregarle funciones a clases que ya existen, sin tocar su código fuente:

```kotlin
// Le agregamos una función a String
fun String.esPalindromo(): Boolean {
    val limpio = this.lowercase().replace(" ", "")
    return limpio == limpio.reversed()
}

println("anilina".esPalindromo())  // true
println("hola".esPalindromo())     // false

// Le agregamos una función a Int
fun Int.esPar(): Boolean = this % 2 == 0

println(4.esPar())   // true
println(7.esPar())   // false
```

En Android esto es muy útil para simplificar código que se repite mucho:

```kotlin
// Definir una vez
fun Activity.mostrarToast(mensaje: String) {
    Toast.makeText(this, mensaje, Toast.LENGTH_SHORT).show()
}

// Usar en cualquier Activity, sin tener que escribir todo el Toast.makeText cada vez:
mostrarToast("Guardado correctamente")
```

### Herencia

En Kotlin las clases son `final` por defecto (no se pueden heredar). Para permitir herencia hay que marcarlas como `open`:

```kotlin
open class Animal(val nombre: String) {
    open fun hacerSonido(): String = "..."
    fun dormir() = "$nombre está durmiendo"
}

class Perro(nombre: String, val raza: String) : Animal(nombre) {
    override fun hacerSonido(): String = "Guau guau"
}

class Gato(nombre: String) : Animal(nombre) {
    override fun hacerSonido(): String = "Miau"
}

val perro = Perro("Rex", "Labrador")
println(perro.hacerSonido())  // Guau guau
println(perro.dormir())        // Rex está durmiendo
```

Esto es diferente a Java donde todo es heredable por defecto. Kotlin prefiere que sean explícitos.

### Interfaces

Funcionan parecido a Java, pero en Kotlin pueden tener implementaciones por defecto:

```kotlin
interface Clickable {
    fun onClick()
    fun descripcion(): String = "Elemento clickeable"  // implementación por defecto
}

class Boton(val texto: String) : Clickable {
    override fun onClick() {
        println("Botón '$texto' presionado")
    }
    // descripcion() ya tiene implementación, no es obligatorio sobreescribirla
}
```

### Sealed Classes

Esto lo van a usar mucho cuando lleguen a MVVM. Sirven para representar un conjunto cerrado de estados:

```kotlin
sealed class ResultadoRed<out T> {
    data class Exito<T>(val datos: T) : ResultadoRed<T>()
    data class Error(val mensaje: String) : ResultadoRed<Nothing>()
    object Cargando : ResultadoRed<Nothing>()
}

// Cuando usan 'when' con una sealed class, el compilador les avisa si se les olvida un caso
fun manejarResultado(resultado: ResultadoRed<List<String>>) {
    when (resultado) {
        is ResultadoRed.Exito -> println("Datos: ${resultado.datos}")
        is ResultadoRed.Error -> println("Error: ${resultado.mensaje}")
        is ResultadoRed.Cargando -> println("Cargando...")
        // no necesita 'else' porque ya cubrimos todos los casos
    }
}
```

Piénsenlo como un `enum` pero donde cada opción puede tener datos diferentes.

### Coroutines

Las coroutines son la forma de manejar operaciones asíncronas en Kotlin. Si en Flutter usaban `async`/`await`, acá es parecido pero con `suspend` y `launch`:

```kotlin
// Agregar en build.gradle.kts:
// implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")

// Una función 'suspend' puede pausarse sin bloquear el hilo
suspend fun obtenerDatosDeAPI(): String {
    delay(2000)  // simula una llamada de red
    return "Datos obtenidos"
}

// En una Activity:
lifecycleScope.launch {
    binding.tvEstado.text = "Cargando..."
    try {
        val datos = obtenerDatosDeAPI()
        binding.tvEstado.text = datos
    } catch (e: Exception) {
        binding.tvEstado.text = "Error: ${e.message}"
    }
}
```

Lo importante: `lifecycleScope` se cancela automáticamente cuando la Activity se destruye, así que no hay riesgo de memory leaks. Nunca usen `GlobalScope` para cosas de UI.

Los **Dispatchers** controlan en qué hilo se ejecuta el código:

```kotlin
lifecycleScope.launch(Dispatchers.Main) {          // hilo principal (UI)
    val resultado = withContext(Dispatchers.IO) {   // hilo de I/O (red, disco)
        obtenerDatosDeAPI()
    }
    binding.tvResultado.text = resultado            // de vuelta en el hilo principal
}
```

La regla es simple: todo lo que toque la UI va en `Main`, todo lo que haga red o disco va en `IO`.

---

## 3. El sistema de vistas de Android

En Flutter todo es un Widget. En Android, el equivalente es una **View**. La diferencia principal es que en Android la interfaz se define en archivos XML separados del código Kotlin, y se conectan mediante View Binding.

Acá van las vistas que más van a usar.

### TextView

```xml
<TextView
    android:id="@+id/tvTitulo"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="Hola Mundo"
    android:textSize="24sp"
    android:textStyle="bold"
    android:textColor="#333333"
    android:maxLines="2"
    android:ellipsize="end" />
```

Desde Kotlin:
```kotlin
binding.tvTitulo.text = "Texto dinámico"
binding.tvTitulo.visibility = View.GONE  // VISIBLE, INVISIBLE, GONE
```

`INVISIBLE` oculta la vista pero sigue ocupando espacio. `GONE` la oculta y libera el espacio. Esto es algo que confunde al principio.

### EditText

```xml
<EditText
    android:id="@+id/etEmail"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:hint="Ingresa tu email"
    android:inputType="textEmailAddress"
    android:maxLines="1"
    android:padding="12dp" />
```

Los `inputType` más comunes: `text`, `textPassword`, `number`, `phone`, `textEmailAddress`, `textMultiLine`.

Desde Kotlin:
```kotlin
// Obtener el texto
val email = binding.etEmail.text.toString().trim()

// Escuchar cambios mientras el usuario escribe
binding.etEmail.addTextChangedListener(object : TextWatcher {
    override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
    override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
        binding.tvContador.text = "${s?.length ?: 0} caracteres"
    }
    override fun afterTextChanged(s: Editable?) {}
})
```

Sí, el `TextWatcher` es verboso. Es una de esas cosas de Android que no son bonitas pero funcionan. Más adelante van a ver que con Material Design hay formas más limpias.

### Botones

```xml
<Button
    android:id="@+id/btnEnviar"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:text="Enviar" />

<ImageButton
    android:id="@+id/btnEliminar"
    android:layout_width="48dp"
    android:layout_height="48dp"
    android:src="@android:drawable/ic_menu_delete"
    android:background="?attr/selectableItemBackgroundBorderless"
    android:contentDescription="Eliminar" />
```

```kotlin
binding.btnEnviar.setOnClickListener {
    enviarFormulario()
}

// Habilitar/deshabilitar
binding.btnEnviar.isEnabled = false
```

### CheckBox, Switch y RadioButton

```xml
<CheckBox
    android:id="@+id/cbAceptar"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="Acepto los términos" />

<Switch
    android:id="@+id/swNotificaciones"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="Notificaciones" />

<RadioGroup
    android:id="@+id/rgGenero"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:orientation="vertical">

    <RadioButton
        android:id="@+id/rbOpcion1"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Opción 1" />

    <RadioButton
        android:id="@+id/rbOpcion2"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Opción 2" />
</RadioGroup>
```

```kotlin
binding.cbAceptar.setOnCheckedChangeListener { _, isChecked ->
    binding.btnEnviar.isEnabled = isChecked
}

binding.rgGenero.setOnCheckedChangeListener { _, checkedId ->
    when (checkedId) {
        R.id.rbOpcion1 -> println("Opción 1")
        R.id.rbOpcion2 -> println("Opción 2")
    }
}
```

### Toast, Snackbar y AlertDialog

Estos tres son los que van a usar para dar feedback al usuario:

```kotlin
// Toast: mensaje breve que desaparece solo
Toast.makeText(this, "Guardado", Toast.LENGTH_SHORT).show()

// Snackbar: mensaje con opción de acción (necesita Material Design)
Snackbar.make(binding.root, "Elemento eliminado", Snackbar.LENGTH_LONG)
    .setAction("Deshacer") { /* lógica para deshacer */ }
    .show()

// AlertDialog: diálogo de confirmación
AlertDialog.Builder(this)
    .setTitle("Confirmar")
    .setMessage("¿Eliminar este elemento?")
    .setPositiveButton("Eliminar") { _, _ -> eliminarElemento() }
    .setNegativeButton("Cancelar", null)
    .show()
```

El Toast es el equivalente al `SnackBar` de Flutter. El AlertDialog es como el `showDialog()`.

---

## 4. Layouts y diseño XML

En Flutter armaban la UI anidando widgets en código Dart. Acá la UI se define en archivos XML dentro de `res/layout/`. Cada layout tiene un contenedor raíz que organiza a sus hijos.

### LinearLayout

El más simple. Organiza los hijos en una dirección: vertical u horizontal.

```xml
<LinearLayout
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="16dp">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Título"
        android:textSize="24sp" />

    <EditText
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:hint="Escribe algo..."
        android:layout_marginTop="16dp" />

    <Button
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="Enviar"
        android:layout_marginTop="8dp" />
</LinearLayout>
```

Para distribuir espacio proporcionalmente, usen `layout_weight` (parecido al `flex` de Flutter):

```xml
<LinearLayout
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="horizontal">

    <EditText
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_weight="1"
        android:hint="Buscar..." />

    <Button
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Buscar" />
</LinearLayout>
```

El truco: poner `width="0dp"` y dejar que `layout_weight` controle el tamaño. Esto ya lo vieron en el taller con el campo de texto y el botón "Agregar".

### ConstraintLayout

Es el layout más flexible. Posiciona las vistas con restricciones relativas (a los bordes del padre o a otras vistas). Es como si cada vista tuviera "imanes" que la conectan a otros elementos:

```xml
<androidx.constraintlayout.widget.ConstraintLayout
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:padding="16dp">

    <TextView
        android:id="@+id/tvTitulo"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:text="Mi App"
        android:textSize="28sp"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent" />

    <EditText
        android:id="@+id/etBuscar"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:hint="Buscar..."
        app:layout_constraintTop_toBottomOf="@id/tvTitulo"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toStartOf="@id/btnBuscar"
        android:layout_marginTop="16dp"
        android:layout_marginEnd="8dp" />

    <Button
        android:id="@+id/btnBuscar"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Buscar"
        app:layout_constraintTop_toTopOf="@id/etBuscar"
        app:layout_constraintBottom_toBottomOf="@id/etBuscar"
        app:layout_constraintEnd_toEndOf="parent" />
</androidx.constraintlayout.widget.ConstraintLayout>
```

Las restricciones se leen así: `constraintTop_toBottomOf="@id/tvTitulo"` significa "mi borde superior va pegado al borde inferior de tvTitulo". Cuando usen `0dp` en el ancho, la vista se estira según las restricciones laterales.

Android Studio tiene un editor visual para ConstraintLayout (la pestaña **Design**). Pueden arrastrar las vistas y conectarlas con el mouse, aunque a veces es más rápido escribir el XML directamente.

### ScrollView

Para cuando el contenido no cabe en pantalla:

```xml
<ScrollView
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <!-- Solo puede tener UN hijo directo -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="16dp">

        <!-- Todo el contenido acá -->
    </LinearLayout>
</ScrollView>
```

Es el equivalente al `SingleChildScrollView` de Flutter.

### CardView

Para tarjetas con sombra y bordes redondeados:

```xml
<com.google.android.material.card.MaterialCardView
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_margin="8dp"
    app:cardCornerRadius="12dp"
    app:cardElevation="4dp">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="16dp">

        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Título"
            android:textSize="18sp"
            android:textStyle="bold" />

        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Descripción de la tarjeta"
            android:layout_marginTop="8dp"
            android:textColor="#666666" />
    </LinearLayout>
</com.google.android.material.card.MaterialCardView>
```

### Unidades

Esto es importante y a veces genera confusión:

| Unidad | Para qué | Ejemplo |
|--------|----------|---------|
| `dp` | Dimensiones de vistas (independiente de densidad de pantalla) | `android:padding="16dp"` |
| `sp` | Tamaño de texto (respeta las preferencias de accesibilidad del usuario) | `android:textSize="16sp"` |
| `match_parent` | Ocupa todo el espacio del padre | |
| `wrap_content` | Solo el espacio que necesita | |

Siempre usen `sp` para texto y `dp` para todo lo demás. Nunca `px`.

### Recursos en values/

Los colores, strings y dimensiones se definen en archivos XML dentro de `res/values/`. Esto permite cambiarlos en un solo lugar:

```xml
<!-- res/values/strings.xml -->
<resources>
    <string name="app_name">Mi App</string>
    <string name="error_campo_vacio">Este campo es obligatorio</string>
</resources>

<!-- res/values/colors.xml -->
<resources>
    <color name="primary">#1976D2</color>
    <color name="text_secondary">#757575</color>
</resources>
```

```xml
<!-- Uso en XML -->
<TextView
    android:text="@string/error_campo_vacio"
    android:textColor="@color/text_secondary" />
```

```kotlin
// Uso en Kotlin
binding.tvError.text = getString(R.string.error_campo_vacio)
```

---

## 5. Navegación entre pantallas

En Flutter usaban `Navigator.push()` y `Navigator.pop()`. En Android se navega entre **Activities** usando **Intents**.

### Crear una nueva Activity

Click derecho en el paquete → **New → Activity → Empty Views Activity** → Nombre: `DetalleActivity`

Esto crea automáticamente el archivo Kotlin, el XML del layout, y la registra en el `AndroidManifest.xml`.

### Navegar a otra pantalla

```kotlin
binding.btnVerDetalle.setOnClickListener {
    val intent = Intent(this, DetalleActivity::class.java)
    startActivity(intent)
}
```

### Pasar datos entre pantallas

Esto es el equivalente a pasar parámetros en el constructor de un Widget en Flutter:

```kotlin
// Enviar datos
binding.btnVerDetalle.setOnClickListener {
    val intent = Intent(this, DetalleActivity::class.java).apply {
        putExtra("NOMBRE", "Juan")
        putExtra("EDAD", 25)
        putExtra("PRECIO", 99.99)
    }
    startActivity(intent)
}

// Recibir datos en DetalleActivity
class DetalleActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityDetalleBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val nombre = intent.getStringExtra("NOMBRE") ?: "Sin nombre"
        val edad = intent.getIntExtra("EDAD", 0)
        val precio = intent.getDoubleExtra("PRECIO", 0.0)

        binding.tvNombre.text = nombre
        binding.tvEdad.text = "Edad: $edad"
    }
}
```

Los `putExtra` son pares clave-valor. Usen nombres en mayúsculas como constantes para evitar errores de tipeo.

### Pasar objetos completos

Para pasar un objeto entero, la clase tiene que implementar `Serializable`:

```kotlin
data class Producto(
    val id: Int,
    val nombre: String,
    val precio: Double
) : java.io.Serializable

// Enviar
val producto = Producto(1, "Laptop", 2500000.0)
intent.putExtra("PRODUCTO", producto)

// Recibir
val producto = intent.getSerializableExtra("PRODUCTO") as? Producto
```

### Regresar con resultado

A veces necesitan que la segunda pantalla devuelva un dato a la primera (como cuando seleccionan algo de una lista). En Flutter esto se hacía con `Navigator.pop(context, resultado)`. Acá:

```kotlin
// En la primera Activity: registrar el callback
private val lanzarBusqueda = registerForActivityResult(
    ActivityResultContracts.StartActivityForResult()
) { resultado ->
    if (resultado.resultCode == RESULT_OK) {
        val ciudad = resultado.data?.getStringExtra("CIUDAD")
        binding.tvCiudad.text = ciudad
    }
}

// Lanzar la segunda Activity
binding.btnBuscar.setOnClickListener {
    lanzarBusqueda.launch(Intent(this, BuscarActivity::class.java))
}

// En la segunda Activity: devolver el resultado
binding.btnSeleccionar.setOnClickListener {
    val intent = Intent().apply {
        putExtra("CIUDAD", "Bogotá")
    }
    setResult(RESULT_OK, intent)
    finish()  // cierra esta Activity y regresa
}
```

### Botón de regreso en el AppBar

```kotlin
class DetalleActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // ... binding setup ...

        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.title = "Detalle"
    }

    override fun onSupportNavigateUp(): Boolean {
        finish()
        return true
    }
}
```

### Intents implícitos

Estos sirven para abrir otras apps del sistema. Muy útiles:

```kotlin
// Abrir URL en el navegador
startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://www.google.com")))

// Hacer una llamada
startActivity(Intent(Intent.ACTION_DIAL, Uri.parse("tel:+573001234567")))

// Compartir texto
val intent = Intent(Intent.ACTION_SEND).apply {
    type = "text/plain"
    putExtra(Intent.EXTRA_TEXT, "Mira esta app")
}
startActivity(Intent.createChooser(intent, "Compartir vía"))
```

---

## 6. Ciclo de vida y gestión de estado

### El ciclo de vida de una Activity

Esto es algo que en Flutter no se nota tanto porque el framework lo maneja por ustedes. En Android hay que ser más conscientes de cuándo la Activity está activa, pausada o destruida.

```
    onCreate()  →  onStart()  →  onResume()
                                      │
                                 [App en uso]
                                      │
                                 onPause()  →  onStop()  →  onDestroy()
                                                   │
                                              onRestart()  →  onStart()
```

En la práctica, lo que más van a usar:

```kotlin
class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Se llama UNA vez. Acá inicializan todo: binding, listeners, datos.
    }

    override fun onResume() {
        super.onResume()
        // La Activity está en primer plano. Reanudar cosas (sensores, animaciones).
    }

    override fun onPause() {
        super.onPause()
        // Otra Activity está tomando el foco. Pausar cosas.
    }

    override fun onDestroy() {
        super.onDestroy()
        // Se va a destruir. Limpiar recursos.
    }
}
```

¿Por qué importa? Porque cuando el usuario rota el teléfono, Android **destruye y recrea** la Activity. Si tenían un contador en 5, después de rotar vuelve a 0. Para evitar eso hay dos opciones.

### Opción 1: savedInstanceState

Guardar datos simples antes de que se destruya:

```kotlin
class ContadorActivity : AppCompatActivity() {
    private var contador = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityContadorBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Restaurar si existe
        contador = savedInstanceState?.getInt("CONTADOR", 0) ?: 0
        actualizarUI()

        binding.btnIncrementar.setOnClickListener {
            contador++
            actualizarUI()
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putInt("CONTADOR", contador)
    }

    private fun actualizarUI() {
        binding.tvContador.text = "Contador: $contador"
    }
}
```

### Opción 2: ViewModel (la recomendada)

El ViewModel sobrevive a rotaciones de pantalla. Es la forma moderna de manejar estado en Android y es lo que van a usar en la mayoría de los casos:

```kotlin
// Agregar en build.gradle.kts:
// implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0")

class ContadorViewModel : ViewModel() {
    var contador = 0
        private set

    fun incrementar() { contador++ }
    fun decrementar() { if (contador > 0) contador-- }
    fun reset() { contador = 0 }
}

// En la Activity
class ContadorActivity : AppCompatActivity() {
    private val viewModel: ContadorViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityContadorBinding.inflate(layoutInflater)
        setContentView(binding.root)

        actualizarUI()

        binding.btnIncrementar.setOnClickListener {
            viewModel.incrementar()
            actualizarUI()
        }
    }

    private fun actualizarUI() {
        binding.tvContador.text = "Contador: ${viewModel.contador}"
    }
}
```

Noten que el ViewModel no tiene referencia a la Activity. Eso es intencional: el ViewModel vive más tiempo que la Activity.

### LiveData: datos que se observan

LiveData es el complemento del ViewModel. Notifica automáticamente a la UI cuando los datos cambian, sin que tengan que llamar `actualizarUI()` manualmente:

```kotlin
// Agregar: implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.7.0")

class TareasViewModel : ViewModel() {
    private val _tareas = MutableLiveData<List<String>>(emptyList())
    val tareas: LiveData<List<String>> = _tareas

    private val _pendientes = MutableLiveData(0)
    val pendientes: LiveData<Int> = _pendientes

    fun agregarTarea(titulo: String) {
        val lista = _tareas.value?.toMutableList() ?: mutableListOf()
        lista.add(titulo)
        _tareas.value = lista
        _pendientes.value = lista.size
    }
}

// En la Activity: observar los cambios
viewModel.tareas.observe(this) { listaTareas ->
    // Esto se ejecuta CADA VEZ que la lista cambia
    actualizarLista(listaTareas)
}

viewModel.pendientes.observe(this) { cantidad ->
    binding.tvContador.text = "$cantidad tareas pendientes"
}
```

La convención es: `_tareas` (con guion bajo) es `MutableLiveData` y es privado. `tareas` (sin guion bajo) es `LiveData` de solo lectura y es público. Así la Activity puede observar pero no modificar directamente.

Esto es el equivalente al `Provider` + `Consumer` de Flutter, o al `setState` pero sin tener que llamarlo explícitamente.

---

## 7. Consumo de APIs con Retrofit

En Flutter usaban el paquete `http` o `dio`. En Android el estándar es **Retrofit**, que es bastante más estructurado.

### Configuración

Agregar en `build.gradle.kts`:

```kotlin
dependencies {
    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation("com.google.code.gson:gson:2.10.1")
}
```

Y en `AndroidManifest.xml` (fuera de `<application>`):

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

Sin ese permiso, las llamadas de red fallan silenciosamente. Es un error clásico.

### Paso 1: Modelo de datos

Igual que en Flutter, necesitan una clase que represente la respuesta del API:

```kotlin
// models/Usuario.kt
data class Usuario(
    val id: Int,
    val name: String,
    val email: String,
    val phone: String?
)

// Si los nombres del JSON no coinciden con los de la clase:
import com.google.gson.annotations.SerializedName

data class ClimaInfo(
    val temp: Double,
    @SerializedName("feels_like") val sensacionTermica: Double,
    @SerializedName("temp_min") val tempMin: Double,
    @SerializedName("temp_max") val tempMax: Double,
    val humidity: Int
)
```

`@SerializedName` es como decirle a Gson: "en el JSON este campo se llama `feels_like`, pero en mi clase lo quiero como `sensacionTermica`".

### Paso 2: Definir los endpoints

En Retrofit, los endpoints se definen como una interfaz. Cada método es un endpoint:

```kotlin
// api/ApiService.kt
import retrofit2.http.*

interface ApiService {

    @GET("users")
    suspend fun obtenerUsuarios(): List<Usuario>

    @GET("users/{id}")
    suspend fun obtenerUsuario(@Path("id") id: Int): Usuario

    @GET("weather")
    suspend fun obtenerClima(
        @Query("q") ciudad: String,
        @Query("appid") apiKey: String,
        @Query("units") unidades: String = "metric",
        @Query("lang") idioma: String = "es"
    ): Clima

    @POST("users")
    suspend fun crearUsuario(@Body usuario: Usuario): Usuario

    @DELETE("users/{id}")
    suspend fun eliminarUsuario(@Path("id") id: Int)
}
```

Noten que todas las funciones son `suspend`. Eso significa que Retrofit las ejecuta en segundo plano automáticamente.

- `@Path` reemplaza partes de la URL: `users/{id}` → `users/5`
- `@Query` agrega parámetros: `?q=Bogota&units=metric`
- `@Body` envía un objeto como JSON en el cuerpo de la petición

### Paso 3: Configurar Retrofit

```kotlin
// api/RetrofitClient.kt
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object RetrofitClient {
    private const val BASE_URL = "https://jsonplaceholder.typicode.com/"

    val apiService: ApiService by lazy {
        Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(ApiService::class.java)
    }
}
```

`object` en Kotlin es un singleton. `by lazy` significa que solo se crea cuando se usa por primera vez.

### Paso 4: Usar en un ViewModel

```kotlin
class UsuariosViewModel : ViewModel() {
    private val _usuarios = MutableLiveData<List<Usuario>>()
    val usuarios: LiveData<List<Usuario>> = _usuarios

    private val _cargando = MutableLiveData(false)
    val cargando: LiveData<Boolean> = _cargando

    private val _error = MutableLiveData<String?>()
    val error: LiveData<String?> = _error

    fun cargarUsuarios() {
        viewModelScope.launch {
            _cargando.value = true
            _error.value = null

            try {
                val resultado = RetrofitClient.apiService.obtenerUsuarios()
                _usuarios.value = resultado
            } catch (e: Exception) {
                _error.value = "Error al cargar: ${e.message}"
            } finally {
                _cargando.value = false
            }
        }
    }
}
```

### Paso 5: Conectar con la Activity

```kotlin
class UsuariosActivity : AppCompatActivity() {
    private lateinit var binding: ActivityUsuariosBinding
    private val viewModel: UsuariosViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityUsuariosBinding.inflate(layoutInflater)
        setContentView(binding.root)

        viewModel.cargando.observe(this) { cargando ->
            binding.progressBar.visibility = if (cargando) View.VISIBLE else View.GONE
        }

        viewModel.error.observe(this) { error ->
            if (error != null) {
                Snackbar.make(binding.root, error, Snackbar.LENGTH_LONG)
                    .setAction("Reintentar") { viewModel.cargarUsuarios() }
                    .show()
            }
        }

        viewModel.usuarios.observe(this) { usuarios ->
            // Actualizar el RecyclerView
            adapter.submitList(usuarios)
        }

        viewModel.cargarUsuarios()
    }
}
```

Comparen esto con el `FutureBuilder` de Flutter. La idea es la misma (manejar estados de cargando/éxito/error), pero acá se hace con LiveData + observe en lugar de un widget que se reconstruye.

### Manejo de errores de red

En producción hay que ser más específicos con los errores:

```kotlin
import retrofit2.HttpException
import java.net.UnknownHostException
import java.net.SocketTimeoutException

try {
    val datos = RetrofitClient.apiService.obtenerUsuarios()
    _usuarios.value = datos
} catch (e: UnknownHostException) {
    _error.value = "Sin conexión a internet"
} catch (e: SocketTimeoutException) {
    _error.value = "Tiempo de espera agotado"
} catch (e: HttpException) {
    when (e.code()) {
        401 -> _error.value = "No autorizado"
        404 -> _error.value = "No encontrado"
        500 -> _error.value = "Error del servidor"
        else -> _error.value = "Error HTTP: ${e.code()}"
    }
} catch (e: Exception) {
    _error.value = "Error inesperado: ${e.message}"
}
```

---

## 8. Persistencia de datos

### SharedPreferences (datos simples)

Para guardar configuraciones, tokens, preferencias. Es el equivalente al `SharedPreferences` de Flutter (sí, se llaman igual):

```kotlin
class PreferenciasHelper(context: Context) {
    private val prefs = context.getSharedPreferences("mi_app_prefs", Context.MODE_PRIVATE)

    fun guardarToken(token: String) = prefs.edit().putString("token", token).apply()
    fun obtenerToken(): String? = prefs.getString("token", null)

    fun guardarTemaOscuro(oscuro: Boolean) = prefs.edit().putBoolean("tema_oscuro", oscuro).apply()
    fun obtenerTemaOscuro(): Boolean = prefs.getBoolean("tema_oscuro", false)

    fun limpiarTodo() = prefs.edit().clear().apply()
}

// Uso
val prefs = PreferenciasHelper(this)
prefs.guardarToken("abc123")
val token = prefs.obtenerToken()
```

Usen `apply()` (asíncrono) en lugar de `commit()` (síncrono) para no bloquear el hilo principal.

### Room (base de datos local)

Room es el ORM oficial de Google para SQLite en Android. Es el equivalente a `sqflite` en Flutter, pero con mucha más estructura.

Agregar en `build.gradle.kts`:

```kotlin
plugins {
    // ... los que ya tienen
    id("kotlin-kapt")  // agregar este
}

dependencies {
    implementation("androidx.room:room-runtime:2.6.1")
    implementation("androidx.room:room-ktx:2.6.1")
    kapt("androidx.room:room-compiler:2.6.1")
}
```

Room tiene tres componentes: **Entity** (tabla), **DAO** (consultas), y **Database** (la base de datos).

#### Entity (la tabla)

```kotlin
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "tareas")
data class TareaEntity(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val titulo: String,
    val descripcion: String = "",
    val completada: Boolean = false,
    val fechaCreacion: Long = System.currentTimeMillis()
)
```

Cada propiedad es una columna. `@PrimaryKey(autoGenerate = true)` es el equivalente a `INTEGER PRIMARY KEY AUTOINCREMENT`.

#### DAO (las consultas)

```kotlin
import androidx.room.*

@Dao
interface TareaDao {
    @Query("SELECT * FROM tareas ORDER BY fechaCreacion DESC")
    fun obtenerTodas(): LiveData<List<TareaEntity>>

    @Query("SELECT * FROM tareas WHERE completada = 0")
    fun obtenerPendientes(): LiveData<List<TareaEntity>>

    @Insert
    suspend fun insertar(tarea: TareaEntity)

    @Update
    suspend fun actualizar(tarea: TareaEntity)

    @Delete
    suspend fun eliminar(tarea: TareaEntity)

    @Query("SELECT COUNT(*) FROM tareas WHERE completada = 0")
    fun contarPendientes(): LiveData<Int>
}
```

Noten que las funciones que retornan `LiveData` no necesitan ser `suspend` — Room las ejecuta en segundo plano automáticamente. Las que hacen escritura (`@Insert`, `@Update`, `@Delete`) sí necesitan `suspend`.

#### Database

```kotlin
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import android.content.Context

@Database(entities = [TareaEntity::class], version = 1)
abstract class AppDatabase : RoomDatabase() {
    abstract fun tareaDao(): TareaDao

    companion object {
        @Volatile
        private var INSTANCE: AppDatabase? = null

        fun obtenerInstancia(context: Context): AppDatabase {
            return INSTANCE ?: synchronized(this) {
                Room.databaseBuilder(
                    context.applicationContext,
                    AppDatabase::class.java,
                    "app_database"
                ).build().also { INSTANCE = it }
            }
        }
    }
}
```

El patrón Singleton con `synchronized` garantiza que solo exista una instancia de la base de datos.

#### Uso en ViewModel

```kotlin
class TareasViewModel(application: Application) : AndroidViewModel(application) {
    private val dao = AppDatabase.obtenerInstancia(application).tareaDao()

    val tareas: LiveData<List<TareaEntity>> = dao.obtenerTodas()
    val pendientes: LiveData<Int> = dao.contarPendientes()

    fun agregarTarea(titulo: String) {
        viewModelScope.launch {
            dao.insertar(TareaEntity(titulo = titulo))
        }
    }

    fun completarTarea(tarea: TareaEntity) {
        viewModelScope.launch {
            dao.actualizar(tarea.copy(completada = !tarea.completada))
        }
    }

    fun eliminarTarea(tarea: TareaEntity) {
        viewModelScope.launch {
            dao.eliminar(tarea)
        }
    }
}
```

Noten que usamos `AndroidViewModel` en lugar de `ViewModel` porque necesitamos el `Application` context para crear la base de datos.

---

## 9. Formularios y validación

### TextInputLayout (Material Design)

Es la versión mejorada del EditText. Muestra el hint como label flotante, tiene soporte para errores, contadores, y el ícono de mostrar/ocultar contraseña:

```xml
<com.google.android.material.textfield.TextInputLayout
    android:id="@+id/tilEmail"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:hint="Correo electrónico"
    app:startIconDrawable="@android:drawable/ic_dialog_email"
    style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox">

    <com.google.android.material.textfield.TextInputEditText
        android:id="@+id/etEmail"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:inputType="textEmailAddress" />
</com.google.android.material.textfield.TextInputLayout>

<!-- Para contraseñas, con el ojo para mostrar/ocultar -->
<com.google.android.material.textfield.TextInputLayout
    android:id="@+id/tilPassword"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:hint="Contraseña"
    app:endIconMode="password_toggle"
    android:layout_marginTop="16dp"
    style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox">

    <com.google.android.material.textfield.TextInputEditText
        android:id="@+id/etPassword"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:inputType="textPassword" />
</com.google.android.material.textfield.TextInputLayout>
```

### Validación

```kotlin
private fun validarFormulario(): Boolean {
    var esValido = true

    val email = binding.etEmail.text.toString().trim()
    if (email.isEmpty()) {
        binding.tilEmail.error = "El email es obligatorio"
        esValido = false
    } else if (!android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
        binding.tilEmail.error = "Email inválido"
        esValido = false
    } else {
        binding.tilEmail.error = null  // limpiar el error
    }

    val password = binding.etPassword.text.toString()
    if (password.isEmpty()) {
        binding.tilPassword.error = "La contraseña es obligatoria"
        esValido = false
    } else if (password.length < 6) {
        binding.tilPassword.error = "Mínimo 6 caracteres"
        esValido = false
    } else if (!password.any { it.isUpperCase() }) {
        binding.tilPassword.error = "Debe tener al menos una mayúscula"
        esValido = false
    } else {
        binding.tilPassword.error = null
    }

    return esValido
}

// Uso
binding.btnRegistrar.setOnClickListener {
    if (validarFormulario()) {
        registrarUsuario()
    }
}
```

El `TextInputLayout.error` muestra el mensaje en rojo debajo del campo y pone el borde en rojo. Cuando ponen `error = null` se limpia. Es bastante más elegante que lo que se logra con un EditText normal.

---

## 10. RecyclerView a fondo

Ya usaron RecyclerView en el taller con la lista de tareas. Acá vamos a ver algunas cosas que quedaron pendientes.

### Layout del item con CardView

En el taller usaron un LinearLayout simple. En una app real, cada item suele ir dentro de un CardView:

```xml
<!-- res/layout/item_producto.xml -->
<com.google.android.material.card.MaterialCardView
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_margin="8dp"
    app:cardCornerRadius="8dp"
    app:cardElevation="2dp">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="horizontal"
        android:padding="16dp"
        android:gravity="center_vertical">

        <LinearLayout
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:orientation="vertical">

            <TextView
                android:id="@+id/tvNombre"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:textSize="16sp"
                android:textStyle="bold" />

            <TextView
                android:id="@+id/tvPrecio"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:textSize="14sp"
                android:textColor="#666666" />
        </LinearLayout>

        <ImageButton
            android:id="@+id/btnEliminar"
            android:layout_width="40dp"
            android:layout_height="40dp"
            android:src="@android:drawable/ic_menu_delete"
            android:background="?attr/selectableItemBackgroundBorderless"
            android:contentDescription="Eliminar" />
    </LinearLayout>
</com.google.android.material.card.MaterialCardView>
```

### Adapter con lambdas para eventos

El patrón es el mismo del taller, pero acá agregamos un click en el item completo además del botón de eliminar:

```kotlin
class ProductoAdapter(
    private val productos: MutableList<Producto>,
    private val onClick: (Producto) -> Unit,
    private val onEliminar: (Int) -> Unit
) : RecyclerView.Adapter<ProductoAdapter.ProductoViewHolder>() {

    inner class ProductoViewHolder(val binding: ItemProductoBinding) :
        RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ProductoViewHolder {
        val binding = ItemProductoBinding.inflate(
            LayoutInflater.from(parent.context), parent, false
        )
        return ProductoViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ProductoViewHolder, position: Int) {
        val producto = productos[position]

        holder.binding.tvNombre.text = producto.nombre
        holder.binding.tvPrecio.text = "$${producto.precio}"

        holder.itemView.setOnClickListener { onClick(producto) }
        holder.binding.btnEliminar.setOnClickListener { onEliminar(position) }
    }

    override fun getItemCount(): Int = productos.size
}
```

### Configurar en la Activity

```kotlin
private fun configurarRecyclerView() {
    adapter = ProductoAdapter(
        productos = listaProductos,
        onClick = { producto ->
            val intent = Intent(this, DetalleActivity::class.java)
            intent.putExtra("PRODUCTO", producto)
            startActivity(intent)
        },
        onEliminar = { posicion ->
            listaProductos.removeAt(posicion)
            adapter.notifyItemRemoved(posicion)
            adapter.notifyItemRangeChanged(posicion, listaProductos.size)
        }
    )

    binding.rvProductos.layoutManager = LinearLayoutManager(this)
    binding.rvProductos.adapter = adapter

    // Para una cuadrícula en vez de lista:
    // binding.rvProductos.layoutManager = GridLayoutManager(this, 2)
}
```

### ListAdapter con DiffUtil

Para listas que cambian frecuentemente (por ejemplo, cuando vienen de una base de datos o API), `ListAdapter` con `DiffUtil` es más eficiente que el Adapter manual. Calcula las diferencias y solo actualiza lo que cambió:

```kotlin
class ProductoAdapter(
    private val onClick: (Producto) -> Unit
) : ListAdapter<Producto, ProductoAdapter.ProductoViewHolder>(DiffCallback()) {

    class DiffCallback : DiffUtil.ItemCallback<Producto>() {
        override fun areItemsTheSame(old: Producto, new: Producto) = old.id == new.id
        override fun areContentsTheSame(old: Producto, new: Producto) = old == new
    }

    inner class ProductoViewHolder(val binding: ItemProductoBinding) :
        RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ProductoViewHolder {
        val binding = ItemProductoBinding.inflate(
            LayoutInflater.from(parent.context), parent, false
        )
        return ProductoViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ProductoViewHolder, position: Int) {
        val producto = getItem(position)
        holder.binding.tvNombre.text = producto.nombre
        holder.itemView.setOnClickListener { onClick(producto) }
    }
}

// En la Activity, actualizar la lista así:
viewModel.productos.observe(this) { lista ->
    adapter.submitList(lista)
}
```

La ventaja: no tienen que llamar `notifyItemInserted`, `notifyItemRemoved`, etc. `submitList()` se encarga de todo.

---

## 11. Fragments

### ¿Qué son?

Un Fragment es una porción reutilizable de UI que vive dentro de una Activity. Piénsenlo como una "sub-pantalla". En Flutter no hay un equivalente directo porque allá todo son widgets que se componen libremente.

¿Para qué sirven?
- Reutilizar la misma UI en diferentes Activities
- Implementar navegación por pestañas (Bottom Navigation)
- Adaptar la UI a tablets (mostrar lista y detalle lado a lado)

### Crear un Fragment

```kotlin
class ListaFragment : Fragment() {
    private var _binding: FragmentListaBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentListaBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.tvTitulo.text = "Lista de elementos"
        binding.btnAccion.setOnClickListener {
            Toast.makeText(requireContext(), "Click", Toast.LENGTH_SHORT).show()
        }
    }

    // Importante: limpiar el binding para evitar memory leaks
    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
```

El patrón del binding en Fragments es un poco diferente al de Activities. Se usa `_binding` (nullable) y `binding` (non-null) porque el Fragment puede existir sin vista (entre `onDestroyView` y `onDestroy`). Si no limpian `_binding` en `onDestroyView`, van a tener memory leaks.

### Agregar un Fragment a una Activity

En el layout de la Activity, poner un contenedor:

```xml
<FrameLayout
    android:id="@+id/fragmentContainer"
    android:layout_width="match_parent"
    android:layout_height="match_parent" />
```

En el código:

```kotlin
// Solo si no existe (evita duplicados al rotar)
if (savedInstanceState == null) {
    supportFragmentManager.beginTransaction()
        .replace(R.id.fragmentContainer, ListaFragment())
        .commit()
}

// Cambiar de Fragment
fun navegarADetalle() {
    supportFragmentManager.beginTransaction()
        .replace(R.id.fragmentContainer, DetalleFragment())
        .addToBackStack(null)  // permite regresar con el botón back
        .commit()
}
```

### Bottom Navigation con Fragments

Este es el caso de uso más común. Tres pestañas abajo, cada una muestra un Fragment diferente:

```xml
<!-- res/menu/bottom_menu.xml (crear esta carpeta si no existe) -->
<menu xmlns:android="http://schemas.android.com/apk/res/android">
    <item
        android:id="@+id/nav_inicio"
        android:icon="@android:drawable/ic_menu_compass"
        android:title="Inicio" />
    <item
        android:id="@+id/nav_buscar"
        android:icon="@android:drawable/ic_menu_search"
        android:title="Buscar" />
    <item
        android:id="@+id/nav_perfil"
        android:icon="@android:drawable/ic_menu_myplaces"
        android:title="Perfil" />
</menu>
```

```xml
<!-- activity_main.xml -->
<LinearLayout
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical">

    <FrameLayout
        android:id="@+id/fragmentContainer"
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1" />

    <com.google.android.material.bottomnavigation.BottomNavigationView
        android:id="@+id/bottomNav"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        app:menu="@menu/bottom_menu" />
</LinearLayout>
```

```kotlin
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        if (savedInstanceState == null) {
            cargarFragment(InicioFragment())
        }

        binding.bottomNav.setOnItemSelectedListener { item ->
            when (item.itemId) {
                R.id.nav_inicio -> cargarFragment(InicioFragment())
                R.id.nav_buscar -> cargarFragment(BuscarFragment())
                R.id.nav_perfil -> cargarFragment(PerfilFragment())
            }
            true
        }
    }

    private fun cargarFragment(fragment: Fragment) {
        supportFragmentManager.beginTransaction()
            .replace(R.id.fragmentContainer, fragment)
            .commit()
    }
}
```

Esto es el equivalente al `BottomNavigationBar` de Flutter con `IndexedStack` o con páginas que cambian según el índice.

---

## 12. Arquitectura MVVM

MVVM (Model-View-ViewModel) es el patrón que Google recomienda para Android. Ya lo han estado usando sin darse cuenta en las secciones anteriores. Acá lo formalizamos.

```
┌──────────────┐     observa      ┌──────────────┐     usa       ┌──────────────┐
│     VIEW     │ ◄──────────────  │  VIEWMODEL   │ ────────────► │    MODEL     │
│  (Activity/  │                  │              │               │  (Repository │
│   Fragment)  │  ──────────────► │  LiveData    │ ◄──────────── │   Room, API) │
│              │   eventos UI     │  Coroutines  │   datos       │              │
└──────────────┘                  └──────────────┘               └──────────────┘
```

- **View** (Activity/Fragment): Solo muestra datos y captura eventos del usuario. No tiene lógica de negocio.
- **ViewModel**: Intermediario. Expone datos con LiveData, maneja la lógica de presentación.
- **Model** (Repository, Room, Retrofit): Datos y lógica de negocio. Acceso a base de datos y APIs.

### Estructura de carpetas

```
app/src/main/java/com/ejemplo/miapp/
├── MainActivity.kt
├── data/
│   ├── local/
│   │   ├── AppDatabase.kt
│   │   └── NotaDao.kt
│   ├── remote/
│   │   ├── ApiService.kt
│   │   └── RetrofitClient.kt
│   ├── model/
│   │   └── Nota.kt
│   └── repository/
│       └── NotaRepository.kt
├── ui/
│   ├── home/
│   │   ├── HomeActivity.kt
│   │   └── HomeViewModel.kt
│   ├── detalle/
│   │   ├── DetalleActivity.kt
│   │   └── DetalleViewModel.kt
│   └── adapters/
│       └── NotaAdapter.kt
└── utils/
    └── Extensions.kt
```

La idea es que cada capa solo conozca a la de abajo. La Activity no sabe nada de Room ni de Retrofit. Solo habla con el ViewModel. El ViewModel habla con el Repository. El Repository decide si los datos vienen de la base de datos local o del API.

### Ejemplo completo: App de Notas

Vamos a armar una app de notas con MVVM, Room y RecyclerView. Esto junta todo lo que hemos visto.

#### Model + Entity:
```kotlin
// data/model/Nota.kt
@Entity(tableName = "notas")
data class Nota(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val titulo: String,
    val contenido: String,
    val fecha: Long = System.currentTimeMillis()
)
```

#### DAO:
```kotlin
// data/local/NotaDao.kt
@Dao
interface NotaDao {
    @Query("SELECT * FROM notas ORDER BY fecha DESC")
    fun obtenerTodas(): LiveData<List<Nota>>

    @Insert
    suspend fun insertar(nota: Nota)

    @Update
    suspend fun actualizar(nota: Nota)

    @Delete
    suspend fun eliminar(nota: Nota)
}
```

#### Repository:
```kotlin
// data/repository/NotaRepository.kt
class NotaRepository(private val dao: NotaDao) {
    val todasLasNotas: LiveData<List<Nota>> = dao.obtenerTodas()

    suspend fun insertar(nota: Nota) = dao.insertar(nota)
    suspend fun actualizar(nota: Nota) = dao.actualizar(nota)
    suspend fun eliminar(nota: Nota) = dao.eliminar(nota)
}
```

El Repository parece innecesario acá porque solo delega al DAO. Pero en una app real tendría lógica como: "si hay internet, traer del API; si no, usar la base de datos local". Es una capa de abstracción que vale la pena tener desde el principio.

#### ViewModel:
```kotlin
// ui/home/NotasViewModel.kt
class NotasViewModel(application: Application) : AndroidViewModel(application) {
    private val repository: NotaRepository

    val todasLasNotas: LiveData<List<Nota>>

    init {
        val dao = AppDatabase.obtenerInstancia(application).notaDao()
        repository = NotaRepository(dao)
        todasLasNotas = repository.todasLasNotas
    }

    fun insertar(titulo: String, contenido: String) {
        viewModelScope.launch {
            repository.insertar(Nota(titulo = titulo, contenido = contenido))
        }
    }

    fun eliminar(nota: Nota) {
        viewModelScope.launch {
            repository.eliminar(nota)
        }
    }
}
```

#### Activity:
```kotlin
// ui/home/NotasActivity.kt
class NotasActivity : AppCompatActivity() {
    private lateinit var binding: ActivityNotasBinding
    private val viewModel: NotasViewModel by viewModels()
    private lateinit var adapter: NotaAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityNotasBinding.inflate(layoutInflater)
        setContentView(binding.root)

        adapter = NotaAdapter(
            onClick = { nota -> /* navegar a detalle */ },
            onEliminar = { nota -> viewModel.eliminar(nota) }
        )
        binding.rvNotas.layoutManager = LinearLayoutManager(this)
        binding.rvNotas.adapter = adapter

        // Esto es lo bonito de MVVM + LiveData:
        // la UI se actualiza sola cuando los datos cambian
        viewModel.todasLasNotas.observe(this) { notas ->
            adapter.submitList(notas)
            binding.tvVacio.visibility = if (notas.isEmpty()) View.VISIBLE else View.GONE
        }

        binding.fabAgregar.setOnClickListener {
            mostrarDialogoNuevaNota()
        }
    }

    private fun mostrarDialogoNuevaNota() {
        val dialogBinding = DialogNuevaNotaBinding.inflate(layoutInflater)

        AlertDialog.Builder(this)
            .setTitle("Nueva Nota")
            .setView(dialogBinding.root)
            .setPositiveButton("Guardar") { _, _ ->
                val titulo = dialogBinding.etTitulo.text.toString().trim()
                val contenido = dialogBinding.etContenido.text.toString().trim()
                if (titulo.isNotEmpty()) {
                    viewModel.insertar(titulo, contenido)
                }
            }
            .setNegativeButton("Cancelar", null)
            .show()
    }
}
```

Fíjense que la Activity no sabe nada de Room ni de SQL. Solo llama `viewModel.insertar()` y observa `viewModel.todasLasNotas`. Esa separación es la gracia de MVVM.

---

## 13. Buenas prácticas

### Convenciones de nombres

| Elemento | Convención | Ejemplo |
|----------|-----------|---------|
| Clases | PascalCase | `MainActivity`, `ProductoAdapter` |
| Funciones y variables | camelCase | `obtenerUsuarios()`, `listaProductos` |
| Constantes | UPPER_SNAKE_CASE | `BASE_URL`, `MAX_INTENTOS` |
| Layouts XML | snake_case | `activity_main.xml`, `item_producto.xml` |
| IDs en XML | camelCase con prefijo | `tvTitulo`, `etEmail`, `btnEnviar`, `rvLista` |

Los prefijos para IDs que usamos en el curso:
- `tv` → TextView
- `et` → EditText
- `btn` → Button
- `iv` → ImageView
- `rv` → RecyclerView
- `til` → TextInputLayout
- `pb` → ProgressBar
- `cb` → CheckBox
- `sw` → Switch
- `fab` → FloatingActionButton

### Cosas que sí y cosas que no

```kotlin
// ✅ Usar val siempre que se pueda
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

// ✅ Usar lifecycleScope o viewModelScope
lifecycleScope.launch { ... }
viewModelScope.launch { ... }

// ❌ Usar GlobalScope (no se cancela, causa memory leaks)
GlobalScope.launch { ... }

// ✅ Limpiar binding en Fragments
override fun onDestroyView() {
    super.onDestroyView()
    _binding = null
}

// ✅ Usar submitList() con ListAdapter
adapter.submitList(nuevaLista)

// ❌ Usar notifyDataSetChanged() (reconstruye toda la lista)
adapter.notifyDataSetChanged()
```

---

## 14. Ejercicios

### Ejercicio 1: App de Lista de Tareas con Room

Tomar la app del taller y mejorarla:
- Agregar persistencia con Room (que las tareas no se pierdan al cerrar la app)
- Usar ViewModel + LiveData en lugar de manejar la lista directamente en la Activity
- Agregar la opción de editar el título de una tarea (con un AlertDialog)

### Ejercicio 2: App del Clima con Retrofit

Consumir la API de OpenWeatherMap (la misma que usaron en la evaluación de Flutter):
- Pantalla de búsqueda con EditText y botón
- Mostrar temperatura, humedad, viento, descripción
- Manejar estados: cargando (ProgressBar), éxito (datos), error (mensaje)
- Usar ViewModel + LiveData + Retrofit

### Ejercicio 3: App de Notas completa

Implementar el ejemplo de MVVM de la sección 12 completo:
- CRUD (Crear, Leer, Actualizar, Eliminar)
- Room para persistencia
- RecyclerView con ListAdapter y DiffUtil
- Navegación a pantalla de detalle/edición

### Ejercicio 4: App con Bottom Navigation

Crear una app con 3 pestañas usando Fragments:
- Pestaña 1: Lista de contactos (RecyclerView)
- Pestaña 2: Formulario para agregar contacto (con validación)
- Pestaña 3: Perfil del usuario (SharedPreferences)

---

## 15. Desarrollo Android sin Android Studio

Si su computador es viejo o tiene poca RAM (4GB o menos), Android Studio va a ser una tortura. El IDE solo consume entre 2 y 4GB, y si le suman el emulador se van a 6-8GB fácilmente. Pero eso no significa que no puedan desarrollar para Android. Acá les explico cómo montar un entorno ligero que funciona.

### Para los ejercicios de Kotlin puro (secciones 1-2 del taller)

No necesitan instalar nada. Usen el playground en línea:

- [play.kotlinlang.org](https://play.kotlinlang.org) — corre en el navegador, escriben código y le dan Run. Sirve para todo lo que es sintaxis, funciones, clases, colecciones, etc.

Con eso pueden hacer todos los ejercicios de la Parte 2 y Parte 3 del taller sin problema.

### Para desarrollar apps Android: VS Code + SDK por terminal

Esta es la alternativa real a Android Studio. VS Code consume mucha menos RAM (~300-500MB vs 2-4GB de Android Studio).

#### Paso 1: Instalar el JDK

Necesitan JDK 17 o superior. Si no lo tienen:

**Windows:**
```
# Descargar de https://adoptium.net/ (Temurin 17)
# Correr el instalador, marcar "Set JAVA_HOME variable"
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install openjdk-17-jdk
```

**macOS:**
```bash
brew install openjdk@17
```

Verificar que quedó bien:
```bash
java -version
# Debería mostrar algo como: openjdk version "17.x.x"
```

#### Paso 2: Instalar Android SDK (sin Android Studio)

Esto es lo clave. Se puede instalar solo el SDK sin el IDE completo.

1. Ir a [developer.android.com/studio#command-line-tools-only](https://developer.android.com/studio#command-line-tools-only)
2. Descargar **Command line tools only** para su sistema operativo (~150MB en vez de ~2GB)
3. Crear una carpeta para el SDK:

**Windows:**
```
mkdir C:\Android\sdk
mkdir C:\Android\sdk\cmdline-tools
```
Extraer el zip descargado dentro de `C:\Android\sdk\cmdline-tools\` y renombrar la carpeta extraída a `latest`. Debería quedar así:
```
C:\Android\sdk\cmdline-tools\latest\bin\sdkmanager.bat
```

**Linux/macOS:**
```bash
mkdir -p ~/Android/sdk/cmdline-tools
# Extraer el zip descargado
unzip commandlinetools-*.zip -d ~/Android/sdk/cmdline-tools/
mv ~/Android/sdk/cmdline-tools/cmdline-tools ~/Android/sdk/cmdline-tools/latest
```

4. Configurar las variables de entorno:

**Windows** (agregar en Variables de entorno del sistema):
```
ANDROID_HOME = C:\Android\sdk
PATH += C:\Android\sdk\cmdline-tools\latest\bin
PATH += C:\Android\sdk\platform-tools
```

**Linux/macOS** (agregar al final de `~/.bashrc` o `~/.zshrc`):
```bash
export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

5. Instalar los componentes necesarios:
```bash
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

6. Aceptar las licencias:
```bash
sdkmanager --licenses
# Responder 'y' a todo
```

Verificar:
```bash
sdkmanager --list | head -20
```

#### Paso 3: Instalar VS Code con extensiones

1. Descargar VS Code de [code.visualstudio.com](https://code.visualstudio.com/) si no lo tienen
2. Instalar estas extensiones:
   - **Kotlin** (de mathiasfrohlich) — resaltado de sintaxis y autocompletado básico
   - **Gradle for Java** (de Microsoft) — para manejar el build
   - **XML** (de Red Hat) — para los layouts

Eso es todo. No necesitan más extensiones.

#### Paso 4: Crear un proyecto

Acá viene lo diferente. Sin Android Studio no tienen el wizard de "New Project", pero hay varias formas de hacerlo.

**Opción A: Crear el proyecto desde la terminal (sin depender de nadie)**

Se puede armar un proyecto Android completo desde cero con unos cuantos archivos. Parece mucho, pero solo hay que hacerlo una vez y después lo reutilizan como plantilla.

Crear la estructura de carpetas:

```bash
mkdir -p MiApp/app/src/main/java/com/ejemplo/miapp
mkdir -p MiApp/app/src/main/res/layout
mkdir -p MiApp/app/src/main/res/values
mkdir -p MiApp/gradle/wrapper
cd MiApp
```

Crear `settings.gradle.kts`:
```bash
cat > settings.gradle.kts << 'EOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "MiApp"
include(":app")
EOF
```

Crear `build.gradle.kts` (raíz del proyecto):
```bash
cat > build.gradle.kts << 'EOF'
plugins {
    id("com.android.application") version "8.2.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
}
EOF
```

Crear `app/build.gradle.kts`:
```bash
cat > app/build.gradle.kts << 'EOF'
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.ejemplo.miapp"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.ejemplo.miapp"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildFeatures {
        viewBinding = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
}
EOF
```

Crear `gradle.properties`:
```bash
cat > gradle.properties << 'EOF'
android.useAndroidX=true
org.gradle.jvmargs=-Xmx1536m
org.gradle.daemon=true
org.gradle.parallel=true
EOF
```

Crear `local.properties` (ajustar la ruta del SDK según su sistema):
```bash
# Linux/macOS:
echo "sdk.dir=$HOME/Android/sdk" > local.properties

# Windows (en Git Bash):
# echo "sdk.dir=C\:\\\\Android\\\\sdk" > local.properties
```

Crear `app/src/main/AndroidManifest.xml`:
```bash
cat > app/src/main/AndroidManifest.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:allowBackup="true"
        android:label="Mi App"
        android:theme="@style/Theme.MaterialComponents.Light.NoActionBar">

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
EOF
```

Crear `app/src/main/res/values/strings.xml`:
```bash
cat > app/src/main/res/values/strings.xml << 'EOF'
<resources>
    <string name="app_name">Mi App</string>
</resources>
EOF
```

Crear `app/src/main/res/layout/activity_main.xml`:
```bash
cat > app/src/main/res/layout/activity_main.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="16dp"
    android:gravity="center">

    <TextView
        android:id="@+id/tvTitulo"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Hola Mundo"
        android:textSize="24sp" />
</LinearLayout>
EOF
```

Crear `app/src/main/java/com/ejemplo/miapp/MainActivity.kt`:
```bash
cat > app/src/main/java/com/ejemplo/miapp/MainActivity.kt << 'EOF'
package com.ejemplo.miapp

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.ejemplo.miapp.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.tvTitulo.text = "Funciona desde VS Code"
    }
}
EOF
```

Inicializar el Gradle Wrapper (necesitan tener Gradle instalado una vez para esto):
```bash
# Si tienen Gradle instalado:
gradle wrapper --gradle-version 8.2

# Si NO tienen Gradle, descargar el wrapper manualmente:
# Ir a https://gradle.org/releases/ y descargar la versión 8.2
# O copiar los archivos gradle/wrapper/ de cualquier proyecto Android existente
```

Compilar:
```bash
./gradlew assembleDebug
```

La primera vez va a tardar varios minutos porque descarga Gradle, los plugins y todas las dependencias. Las siguientes compilaciones son mucho más rápidas.

Si todo salió bien, el APK queda en `app/build/outputs/apk/debug/app-debug.apk`.

**Opción B: Usar un proyecto creado por un compañero**

Si lo anterior les parece mucho, la opción más práctica:

1. Un compañero que tenga Android Studio crea el proyecto (Empty Views Activity, Kotlin, API 24)
2. Lo sube a GitHub
3. Ustedes lo clonan y lo abren con VS Code
4. Compilan con `./gradlew assembleDebug`

El proyecto ya viene con toda la configuración de Gradle. Solo necesitan el SDK para compilar.

**Opción C: Clonar un proyecto plantilla**

```bash
git clone https://github.com/RichardBolanos/android-template-vscode.git MiApp
cd MiApp
./gradlew assembleDebug
```

#### Paso 5: Compilar y correr desde la terminal

Olvidarse del botón de Play. Todo se hace con Gradle desde la terminal:

```bash
# Compilar (genera el APK)
./gradlew assembleDebug

# El APK queda en:
# app/build/outputs/apk/debug/app-debug.apk

# Compilar e instalar directamente en el celular conectado
./gradlew installDebug

# Ver los logs (equivalente a Logcat)
adb logcat | grep "com.ejemplo.miapp"

# Solo ver errores
adb logcat *:E | grep "com.ejemplo.miapp"
```

En Windows usen `gradlew.bat` en lugar de `./gradlew`.

La primera compilación tarda bastante porque Gradle descarga todas las dependencias. Las siguientes son más rápidas.

#### Paso 6: Conectar un celular físico

Esto es obligatorio si no tienen Android Studio (porque el emulador se maneja desde ahí). Pero honestamente, un celular físico es mejor que el emulador en máquinas con poca RAM.

1. En el celular: **Ajustes → Acerca del teléfono → Tocar 7 veces "Número de compilación"**
2. Volver a Ajustes → **Opciones de desarrollador → Activar "Depuración USB"**
3. Conectar el celular por USB
4. Aceptar la autorización que aparece en el celular
5. Verificar que lo detecta:

```bash
adb devices
# Debería mostrar algo como:
# List of devices attached
# ABC123DEF456    device
```

Si no aparece, revisar que tengan los drivers USB del celular instalados (en Windows a veces hay que instalarlos manualmente).

#### Paso 7: Genymotion como emulador alternativo (si no tienen celular físico)

Si no tienen un celular Android para conectar por USB, hay una alternativa al emulador de Android Studio que consume menos recursos: **Genymotion Desktop**.

Genymotion es un emulador Android basado en VirtualBox. Es más rápido que el emulador oficial en máquinas con poca RAM porque usa virtualización x86 en lugar de emular ARM. Tiene una versión gratuita para uso personal que funciona bien para lo que necesitamos.

**Instalación:**

1. Crear una cuenta gratuita en [genymotion.com](https://www.genymotion.com/)
2. Ir a [la página de descarga](https://www.genymotion.com/download/) y descargar **Genymotion Desktop**
   - En Windows y Linux viene con VirtualBox incluido (elegir el instalador "with VirtualBox")
   - En macOS necesitan instalar VirtualBox por separado primero
3. Instalar y abrir Genymotion
4. Cuando pregunte por la licencia, elegir **"Personal Use"** (es gratis)
5. Crear un dispositivo virtual: click en **"+"**, elegir uno (ej: Google Pixel con Android 11 o 12), y darle **Install**

**Conectar Genymotion con su proyecto:**

Genymotion se conecta por ADB, igual que un celular físico. Cuando el dispositivo virtual está corriendo:

```bash
# Verificar que adb lo detecta
adb devices
# Debería mostrar algo como:
# 192.168.56.101:5555    device

# Instalar la app
./gradlew installDebug
# o manualmente:
adb install app/build/outputs/apk/debug/app-debug.apk
```

Si `adb devices` no muestra el dispositivo de Genymotion, hay que configurar la ruta del ADB dentro de Genymotion:

1. En Genymotion ir a **Settings → ADB**
2. Seleccionar **"Use custom Android SDK tools"**
3. Poner la ruta de su SDK:
   - Windows: `C:\Android\sdk` (o donde lo hayan instalado)
   - Linux: `/home/usuario/Android/sdk`
   - macOS: `/Users/usuario/Library/Android/sdk`
4. Reiniciar el dispositivo virtual

**Si usan Android Studio (no VS Code):**

Genymotion tiene un plugin para Android Studio que agrega un botón directo en la barra de herramientas:

1. En Android Studio: **File → Settings → Plugins → Marketplace**
2. Buscar **"Genymotion"** e instalar
3. Reiniciar Android Studio
4. Aparece un ícono de Genymotion en la barra. Click ahí para iniciar un dispositivo
5. El dispositivo aparece en la lista de targets cuando le dan Run

**¿Cuánta RAM consume?**

Genymotion con un dispositivo virtual consume entre 1-2GB de RAM. Es menos que el emulador oficial (~2-4GB), pero sigue siendo bastante. Si tienen 4GB de RAM total, va a ir justo. Con 6GB funciona bien.

**Limitaciones de la versión gratuita:**
- No tiene Google Play Store (pueden instalar APKs manualmente arrastrándolos al emulador)
- No tiene todos los sensores (GPS, acelerómetro limitados)
- Solo para uso personal, no comercial
- No tiene las versiones más recientes de Android

Para lo que necesitamos en el curso (probar apps con UI, listas, APIs, Room), funciona perfecto.

#### Flujo de trabajo diario

Una vez que tienen todo configurado, el flujo es:

1. Abrir VS Code en la carpeta del proyecto
2. Editar los archivos `.kt` y `.xml`
3. Abrir una terminal en VS Code (`Ctrl + ñ` o `` Ctrl + ` ``)
4. Compilar e instalar: `./gradlew installDebug`
5. La app se abre automáticamente en el celular
6. Ver logs si algo falla: `adb logcat *:E`

No van a tener autocompletado tan bueno como en Android Studio, ni el editor visual de layouts. Pero pueden escribir todo el código y compilar sin problema.

#### Editar layouts XML sin el editor visual

Sin Android Studio no tienen el editor de arrastrar y soltar para los layouts. Pero honestamente, la mayoría de desarrolladores escriben el XML a mano de todas formas. Algunos tips:

- Copien los layouts de los ejemplos de esta guía y modifíquenlos
- Usen la extensión XML de Red Hat para autocompletado de atributos
- Para ver cómo queda el layout sin compilar, pueden usar [layoutinspector.com](https://www.layoutinspector.com/) (herramienta online, limitada pero útil)
- O simplemente compilen y vean en el celular. Con `./gradlew installDebug` tarda unos 15-30 segundos en compilaciones incrementales

### Resumen: ¿Qué necesito según mi hardware?

| RAM del PC | IDE | Emulador | Dispositivo de prueba |
|------------|-----|----------|----------------------|
| 8GB+ | Android Studio | Emulador oficial o Genymotion | Emulador o celular físico |
| 6GB | Android Studio | Genymotion (más ligero) | Genymotion o celular físico |
| 4GB | VS Code + terminal | No usar emulador | Celular físico por USB |
| 2-3GB | VS Code + terminal | No | Celular físico (si compila) |

Si no tienen celular Android ni RAM para emulador, la última opción es pedirle a un compañero que les preste el celular para probar, o trabajar en parejas.

### Problemas comunes

**"JAVA_HOME is not set"**
→ Verificar que instalaron el JDK y configuraron la variable de entorno. Cerrar y abrir la terminal después de configurarla.

**"SDK location not found"**
→ Crear un archivo `local.properties` en la raíz del proyecto con:
```
sdk.dir=C\:\\Android\\sdk
```
(En Linux/macOS: `sdk.dir=/home/usuario/Android/sdk`)

**"No connected devices"**
→ Revisar que la depuración USB está activada y que aceptaron la autorización en el celular. Probar desconectar y reconectar el USB.

**La compilación tarda mucho**
→ La primera vez es normal (descarga dependencias). Si sigue lento, agregar en `gradle.properties`:
```
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.jvmargs=-Xmx1536m
```

**"Could not determine java version"**
→ Verificar que tienen JDK 17. Algunas versiones de Gradle no funcionan con JDK 21.

---

## Equivalencias Flutter ↔ Android Nativo

Para los que vienen de la guía de Flutter, esta tabla les ayuda a mapear lo que ya saben:

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
| flutter run | Shift + F10 |
| Hot Reload | Apply Changes (más limitado) |

---

## Referencias

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

## Atajos de Android Studio

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
