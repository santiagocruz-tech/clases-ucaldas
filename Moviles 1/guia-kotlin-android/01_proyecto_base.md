# Capítulo 1: Proyecto base — Nuestro primer "Hola Mundo"

## Objetivo

Crear el proyecto **MisFinanzas** desde cero, entender la estructura de archivos de un proyecto Android, y mostrar un texto en pantalla.

---

## 1.1 Crear el proyecto

### En Android Studio

1. **File → New → New Project**
2. Seleccionar **Empty Views Activity**
3. Configurar:
   - **Name:** MisFinanzas
   - **Package name:** com.ejemplo.misfinanzas
   - **Save location:** donde prefieran
   - **Language:** Kotlin
   - **Minimum SDK:** API 24 (Android 7.0)
   - **Build configuration language:** Kotlin DSL
4. Click en **Finish**
5. Esperar a que Gradle sincronice (la primera vez tarda varios minutos)

### En VS Code o IntelliJ (crear desde terminal)

```bash
# Crear la estructura de carpetas del proyecto
mkdir -p MisFinanzas/app/src/main/java/com/ejemplo/misfinanzas
mkdir -p MisFinanzas/app/src/main/res/layout
mkdir -p MisFinanzas/app/src/main/res/values
mkdir -p MisFinanzas/app/src/main/res/drawable
mkdir -p MisFinanzas/app/src/main/res/menu
mkdir -p MisFinanzas/gradle/wrapper
```

Luego crear los archivos de configuración. Android Studio los genera automáticamente, pero si crean el proyecto desde terminal, pueden clonar un proyecto plantilla o pedirle a un compañero que tenga Android Studio que cree el proyecto y lo suba a un repositorio.

---

## 1.2 Estructura del proyecto

Después de crear el proyecto, esta es la estructura que importa:

```
MisFinanzas/
├── app/
│   ├── build.gradle.kts          ← Dependencias y configuración de la app
│   └── src/
│       └── main/
│           ├── AndroidManifest.xml    ← Registro de pantallas y permisos
│           ├── java/com/ejemplo/misfinanzas/
│           │   └── MainActivity.kt    ← Código Kotlin de la pantalla principal
│           └── res/
│               ├── layout/            ← Archivos XML de interfaz
│               │   └── activity_main.xml
│               ├── values/            ← Strings, colores, temas
│               │   ├── strings.xml
│               │   ├── colors.xml
│               │   └── themes.xml
│               ├── drawable/          ← Imágenes y formas
│               └── menu/              ← Menús de navegación
├── build.gradle.kts              ← Configuración global del proyecto
├── settings.gradle.kts           ← Módulos del proyecto
└── gradle.properties             ← Propiedades de Gradle
```

💡 **¿Por qué la carpeta se llama "java" si escribimos Kotlin?** Es por legado histórico. Android se creó con Java y la estructura de carpetas se mantuvo. Kotlin compila al mismo bytecode que Java, así que conviven en la misma carpeta.

---

## 1.3 Entender el archivo AndroidManifest.xml

📁 Este archivo ya existe. Vamos a entenderlo:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- AndroidManifest.xml -->
<!-- Este archivo es el "registro civil" de la app. -->
<!-- Aquí se declaran todas las pantallas (Activities), permisos, y configuración general. -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Permiso para acceder a internet (lo necesitaremos más adelante para APIs) -->
    <uses-permission android:name="android.permission.INTERNET" />

    <!-- Bloque principal de la aplicación -->
    <application
        android:allowBackup="true"
        android:label="MisFinanzas"
        android:theme="@style/Theme.MaterialComponents.Light.NoActionBar">

        <!-- Declaración de la pantalla principal -->
        <!-- android:exported="true" permite que el sistema la abra -->
        <!-- El intent-filter con MAIN + LAUNCHER la marca como pantalla de inicio -->
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <!-- MAIN = es la actividad principal -->
                <action android:name="android.intent.action.MAIN" />
                <!-- LAUNCHER = aparece en el menú de apps del celular -->
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>
</manifest>
```

💡 Cada vez que creemos una nueva pantalla (Activity), hay que registrarla aquí. Si no, la app crashea al intentar abrirla.

---

## 1.4 Activar View Binding

View Binding nos permite acceder a los elementos de la interfaz (botones, textos, etc.) desde Kotlin de forma segura, sin usar `findViewById`.

🔧 Abrir `app/build.gradle.kts` y agregar dentro del bloque `android`:

```kotlin
android {
    // ... lo que ya está (namespace, compileSdk, etc.)

    // Activar View Binding para acceder a las vistas desde Kotlin
    // Esto genera automáticamente una clase por cada archivo XML de layout
    buildFeatures {
        viewBinding = true
    }
}
```

💡 **Nota sobre AGP 9.x y Kotlin built-in:** A partir de Android Gradle Plugin 9.x, Kotlin viene integrado directamente en el plugin de Android. No necesitan agregar el plugin `org.jetbrains.kotlin.android` por separado. Si ven errores como `The 'kotlin-kapt' plugin is not compatible with built-in Kotlin`, es porque están usando un plugin de Kotlin que ya no es necesario.

Después de modificar `build.gradle.kts`:
- **Android Studio / IntelliJ:** Click en **"Sync Now"** en la barra amarilla
- **VS Code / Terminal:** Ejecutar `./gradlew build`

---

## 1.5 Nuestro primer layout

✏️ Abrir `app/src/main/res/layout/activity_main.xml` y reemplazar todo el contenido:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- activity_main.xml -->
<!-- Este es el layout (diseño) de la pantalla principal -->
<!-- LinearLayout organiza sus hijos en una dirección: vertical u horizontal -->
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="24dp"
    android:gravity="center">
    <!-- match_parent = ocupa todo el ancho/alto del padre -->
    <!-- orientation="vertical" = los hijos se apilan de arriba a abajo -->
    <!-- padding="24dp" = espacio interno de 24dp en todos los lados -->
    <!-- gravity="center" = centra los hijos dentro del layout -->

    <!-- TextView muestra texto en pantalla -->
    <!-- Es el equivalente al widget Text() de Flutter -->
    <TextView
        android:id="@+id/tvBienvenida"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Bienvenido a MisFinanzas"
        android:textSize="24sp"
        android:textStyle="bold"
        android:textColor="#1B5E20" />
    <!-- android:id = identificador único para acceder desde Kotlin -->
    <!-- wrap_content = ocupa solo el espacio que necesita el texto -->
    <!-- textSize en "sp" = escala con las preferencias de accesibilidad del usuario -->

    <!-- Segundo TextView para un subtítulo -->
    <TextView
        android:id="@+id/tvSubtitulo"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Tu app de finanzas personales"
        android:textSize="16sp"
        android:textColor="#666666"
        android:layout_marginTop="8dp" />
    <!-- layout_marginTop = espacio externo arriba de este elemento -->
    <!-- dp = density-independent pixels, se adapta a diferentes pantallas -->

</LinearLayout>
```

---

## 1.6 Nuestro primer código Kotlin

✏️ Abrir `app/src/main/java/com/ejemplo/misfinanzas/MainActivity.kt` y reemplazar todo:

```kotlin
// MainActivity.kt
// Este archivo contiene el código de la pantalla principal de la app

// El "package" indica a qué paquete pertenece esta clase
// Debe coincidir con la estructura de carpetas
package com.ejemplo.misfinanzas

// Importaciones: traemos las clases que necesitamos
// AppCompatActivity es la clase base para todas las pantallas en Android
import androidx.appcompat.app.AppCompatActivity
// Bundle es un contenedor de datos que Android usa para guardar/restaurar estado
import android.os.Bundle
// Importamos la clase generada por View Binding para este layout
// El nombre se genera automáticamente: activity_main.xml → ActivityMainBinding
import com.ejemplo.misfinanzas.databinding.ActivityMainBinding

// MainActivity hereda de AppCompatActivity
// Es nuestra pantalla principal, la que se abre al iniciar la app
class MainActivity : AppCompatActivity() {

    // "lateinit" significa que esta variable se inicializará después (no ahora)
    // "private" significa que solo esta clase puede acceder a ella
    // "binding" nos da acceso a todos los elementos del layout (tvBienvenida, tvSubtitulo, etc.)
    private lateinit var binding: ActivityMainBinding

    // onCreate se ejecuta UNA VEZ cuando la pantalla se crea
    // Es donde inicializamos todo: layout, listeners, datos
    // savedInstanceState contiene datos guardados si la pantalla se recreó (ej: rotación)
    override fun onCreate(savedInstanceState: Bundle?) {
        // Llamamos al onCreate del padre (AppCompatActivity) — obligatorio
        super.onCreate(savedInstanceState)

        // Inflamos el layout: convierte el XML en objetos que Android puede mostrar
        binding = ActivityMainBinding.inflate(layoutInflater)

        // Establecemos el layout como el contenido visible de esta pantalla
        setContentView(binding.root)

        // Ahora podemos acceder a cualquier vista del XML usando binding.idDelElemento
        // Cambiamos el texto del título desde código Kotlin
        binding.tvBienvenida.text = "¡Hola desde Kotlin!"

        // Cambiamos el subtítulo también
        binding.tvSubtitulo.text = "MisFinanzas v1.0"
    }
}
```

---

## 1.7 Compilar y probar

▶️ Es momento de ver nuestra app funcionando:

**Android Studio / IntelliJ:**
- Seleccionar el dispositivo (emulador o celular) en la barra superior
- Presionar **Shift + F10** o el botón ▶️ verde

**VS Code / Terminal:**
```bash
./gradlew installDebug
```

Deberían ver una pantalla blanca con el texto "¡Hola desde Kotlin!" centrado y debajo "MisFinanzas v1.0".

💡 **Si algo falla:** lean el error completo en la pestaña "Build" (Android Studio/IntelliJ) o en la terminal. Los errores más comunes en este punto son:
- SDK no encontrado → revisar Capítulo 00
- Gradle no sincroniza → verificar conexión a internet (descarga dependencias)
- "Unresolved reference: databinding" → verificar que activaron viewBinding en build.gradle.kts

---

## 1.8 ¿Qué acabamos de hacer?

Repasemos el flujo completo:

1. **Creamos un proyecto** con la estructura estándar de Android
2. **Definimos la interfaz** en un archivo XML (`activity_main.xml`) con dos textos
3. **Activamos View Binding** para conectar el XML con Kotlin de forma segura
4. **Escribimos código Kotlin** en `MainActivity.kt` que modifica los textos al iniciar
5. **Compilamos** y vimos el resultado en un dispositivo

Este es el ciclo que vamos a repetir en cada capítulo: diseñar la interfaz en XML, escribir la lógica en Kotlin, compilar y probar.

---

## Resumen de archivos creados/modificados

| Archivo | Acción | Propósito |
|---------|--------|-----------|
| `app/build.gradle.kts` | ✏️ Modificado | Activar viewBinding |
| `activity_main.xml` | ✏️ Modificado | Layout con dos TextViews |
| `MainActivity.kt` | ✏️ Modificado | Código que modifica los textos |

---

**Anterior:** [← Capítulo 0 — Entorno](00_entorno.md) | **Siguiente:** [Capítulo 2 — Kotlin básico →](02_kotlin_basico.md)
