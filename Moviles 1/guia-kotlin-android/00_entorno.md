# Capítulo 0: Configuración del entorno

## ¿Qué necesitamos?

Para desarrollar apps Android con Kotlin necesitamos tres cosas:
1. **Un JDK** (Java Development Kit) versión 17 o superior
2. **El Android SDK** (las herramientas para compilar apps Android)
3. **Un IDE** (editor de código) — Android Studio, IntelliJ IDEA, o VS Code

Y para probar la app:
4. **Un celular Android** conectado por USB, o un **emulador**

---

## Opción A: Android Studio (recomendado si tienen 8GB+ de RAM)

Android Studio es el IDE oficial de Google para Android. Trae todo incluido: editor, SDK, emulador, editor visual de layouts.

1. Descargar de [developer.android.com/studio](https://developer.android.com/studio)
2. Instalar con las opciones por defecto
3. En la primera ejecución, dejar que descargue el SDK y los componentes necesarios
4. Verificar en **File → Settings → Languages & Frameworks → Android SDK** que tengan:
   - **SDK Platforms:** Android 14.0 (API 34) marcado
   - **SDK Tools:** Build-Tools, Platform-Tools, Command-line Tools marcados

**Consumo de RAM:** Android Studio usa 2-4GB. Con el emulador sube a 6-8GB.

---

## Opción B: IntelliJ IDEA Community (6GB de RAM)

Android Studio es un fork de IntelliJ IDEA. La versión Community es gratis y más ligera.

1. Descargar de [jetbrains.com/idea/download](https://www.jetbrains.com/idea/download/) — columna **Community** (gratis)
2. Instalar con opciones por defecto
3. Instalar el Android SDK por separado (ver sección "Instalar Android SDK sin IDE" abajo)
4. Abrir un proyecto Android → IntelliJ detecta Gradle y sincroniza
5. Configurar SDK: **File → Project Structure → SDKs → + → Android SDK** → seleccionar la ruta del SDK

**Qué tiene:** Autocompletado completo de Kotlin, refactoring, debugging, terminal integrada.
**Qué NO tiene:** Editor visual de layouts, Device Manager, profiler.

**Consumo de RAM:** 1-2GB.

---

## Opción C: VS Code + Terminal (4GB de RAM o menos)

La opción más ligera. Se escribe código en VS Code y se compila desde la terminal.

### Paso 1: Instalar el JDK 17

**Windows:**
```
# Descargar de https://adoptium.net/ (Temurin 17)
# Ejecutar el instalador
# Marcar "Set JAVA_HOME variable"
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

Verificar:
```bash
java -version
# Debe mostrar: openjdk version "17.x.x"
```

### Paso 2: Instalar Android SDK sin IDE

1. Ir a [developer.android.com/studio#command-line-tools-only](https://developer.android.com/studio#command-line-tools-only)
2. Descargar **Command line tools only** (~150MB)
3. Crear la estructura de carpetas:

**Windows:**
```
mkdir C:\Android\sdk\cmdline-tools
```
Extraer el zip dentro de `C:\Android\sdk\cmdline-tools\` y renombrar la carpeta a `latest`.

**Linux/macOS:**
```bash
mkdir -p ~/Android/sdk/cmdline-tools
unzip commandlinetools-*.zip -d ~/Android/sdk/cmdline-tools/
mv ~/Android/sdk/cmdline-tools/cmdline-tools ~/Android/sdk/cmdline-tools/latest
```

4. Configurar variables de entorno:

**Windows** (Variables de entorno del sistema):
```
ANDROID_HOME = C:\Android\sdk
PATH += C:\Android\sdk\cmdline-tools\latest\bin
PATH += C:\Android\sdk\platform-tools
```

**Linux/macOS** (agregar a `~/.bashrc` o `~/.zshrc`):
```bash
export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

5. Instalar componentes y aceptar licencias:
```bash
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
sdkmanager --licenses
```

### Paso 3: Instalar VS Code con extensiones

1. Descargar de [code.visualstudio.com](https://code.visualstudio.com/)
2. Instalar estas extensiones:
   - **Kotlin** (mathiasfrohlich) — resaltado y autocompletado básico
   - **Gradle for Java** (Microsoft) — manejo del build
   - **XML** (Red Hat) — para los layouts

### Paso 4: Flujo de trabajo con VS Code

```bash
# Compilar el proyecto
./gradlew assembleDebug

# Compilar e instalar en el celular conectado
./gradlew installDebug

# Ver logs de la app
adb logcat | grep "com.ejemplo.misfinanzas"
```

En Windows usar `gradlew.bat` en lugar de `./gradlew`.

---

## Conectar un celular físico (todas las opciones)

1. En el celular: **Ajustes → Acerca del teléfono → Tocar 7 veces "Número de compilación"**
2. Volver a Ajustes → **Opciones de desarrollador → Activar "Depuración USB"**
3. Conectar por USB y aceptar la autorización en el celular
4. Verificar:
```bash
adb devices
# Debe mostrar el dispositivo con estado "device"
```

💡 Si no aparece: probar otro cable USB (algunos solo cargan) o instalar drivers del fabricante.

---

## Emulador alternativo: Genymotion

Si no tienen celular Android y el emulador oficial les pesa:

1. Crear cuenta en [genymotion.com](https://www.genymotion.com/)
2. Descargar **Genymotion Desktop** (con VirtualBox incluido)
3. Elegir licencia **Personal Use** (gratis)
4. Crear un dispositivo virtual (ej: Google Pixel con Android 11)
5. Configurar ADB: **Settings → ADB → Use custom Android SDK tools** → ruta del SDK

**Consumo de RAM:** 1-2GB. Con 6GB total funciona bien.

---

## Ejercicios de Kotlin puro (sin instalar nada)

Para practicar sintaxis de Kotlin sin necesidad de un proyecto Android:
- [play.kotlinlang.org](https://play.kotlinlang.org) — editor en el navegador

---

## Resumen según hardware

| RAM | IDE recomendado | Emulador | Dispositivo de prueba |
|-----|----------------|----------|----------------------|
| 8GB+ | Android Studio | Emulador oficial o Genymotion | Cualquiera |
| 6GB | IntelliJ IDEA o Android Studio | Genymotion | Genymotion o celular |
| 4-5GB | VS Code + terminal | No usar emulador | Celular físico |
| 2-3GB | VS Code + terminal | No | Celular físico |

---

## Problemas comunes

| Problema | Solución |
|----------|----------|
| "JAVA_HOME is not set" | Instalar JDK 17 y configurar la variable de entorno. Reiniciar terminal. |
| "SDK location not found" | Crear `local.properties` con `sdk.dir=RUTA_DEL_SDK` |
| "No connected devices" | Activar depuración USB, aceptar autorización, probar otro cable |
| Compilación muy lenta | Agregar en `gradle.properties`: `org.gradle.daemon=true` y `org.gradle.parallel=true` |
| "Could not determine java version" | Verificar que tienen JDK 17 (no 21) |
| "License not accepted" | Ejecutar `sdkmanager --licenses` y responder 'y' a todo |

---

**Siguiente:** [Capítulo 1 — Proyecto base →](01_proyecto_base.md)
