# Capítulo 0: Prerequisitos y entorno de desarrollo

## Objetivo

Instalar las herramientas necesarias, crear el proyecto CineExplorer y entender la estructura de un proyecto Angular.

---

## 0.1 Checklist de conocimientos previos

Antes de empezar con Angular, asegúrense de dominar estos temas:

- [ ] HTML semántico (header, nav, main, section, article, footer)
- [ ] CSS: Flexbox, Grid, media queries, variables CSS
- [ ] JavaScript: variables, funciones, arrays, objetos, destructuring, spread
- [ ] JavaScript asíncrono: Promises, async/await, fetch API
- [ ] Clases y herencia en JavaScript (ES6)
- [ ] Módulos ES6 (import/export)
- [ ] Bootstrap básico (grid, componentes, utilidades)
- [ ] Git básico (clone, add, commit, push)

Si alguno de estos temas no está claro, repásenlo antes de continuar. Angular construye sobre todo esto.

---

## 0.2 Instalación de Node.js y npm

Angular necesita Node.js para funcionar. npm (Node Package Manager) viene incluido.

```bash
# Verificar si ya están instalados
node --version    # Debe ser v18 o superior
npm --version     # Debe ser v9 o superior
```

Si no están instalados, descargar desde [https://nodejs.org](https://nodejs.org) (versión LTS).

---

## 0.3 Instalación de Angular CLI

Angular CLI es la herramienta de línea de comandos para crear y gestionar proyectos Angular.

```bash
# Instalar Angular CLI de forma global en el sistema
# -g = global, disponible desde cualquier carpeta
npm install -g @angular/cli

# Verificar que se instaló correctamente
ng version
# Debe mostrar la versión de Angular CLI (17 o superior)
```

💡 Se recomienda Angular 19 o superior para aprovechar todas las características modernas que cubre esta guía (signals, input/output funcional, sintaxis de control de flujo @for/@if).

---

## 0.4 Configuración del editor (VS Code)

### Extensiones recomendadas

| Extensión | Para qué sirve |
|---|---|
| Angular Language Service | Autocompletado en templates Angular, detección de errores |
| Prettier | Formateo automático de código al guardar |
| ESLint | Detección de errores y malas prácticas |
| Auto Rename Tag | Renombra etiquetas HTML de cierre automáticamente |
| Material Icon Theme | Íconos para archivos Angular (.component, .service, etc.) |

---

## 0.5 Crear el proyecto CineExplorer

```bash
# Crear el proyecto con SCSS y routing habilitado
# --style=scss: usa SCSS en lugar de CSS (más potente)
# --routing: crea el archivo de rutas automáticamente
ng new cine-explorer --style=scss --routing

# Opciones que pregunta el CLI:
# Which stylesheet format? → SCSS
# Do you want to enable Server-Side Rendering? → No

# Entrar a la carpeta del proyecto
cd cine-explorer

# Ejecutar en modo desarrollo
# ng serve compila el proyecto y abre un servidor local
ng serve
# Abrir en el navegador: http://localhost:4200
```

💡 `ng serve` tiene hot reload: cada vez que guardan un archivo, el navegador se actualiza automáticamente.

---

## 0.6 Estructura de archivos del proyecto

```
cine-explorer/
├── src/
│   ├── app/
│   │   ├── app.component.ts        ← Componente raíz (la "cáscara" de la app)
│   │   ├── app.component.html      ← Template HTML del componente raíz
│   │   ├── app.component.scss      ← Estilos del componente raíz
│   │   ├── app.component.spec.ts   ← Tests del componente raíz
│   │   ├── app.config.ts           ← Configuración global de la app
│   │   └── app.routes.ts           ← Definición de rutas (navegación)
│   ├── assets/                     ← Imágenes, fuentes, archivos estáticos
│   ├── environments/               ← Variables de entorno (API keys)
│   ├── index.html                  ← HTML principal (punto de entrada)
│   ├── main.ts                     ← Archivo de arranque de Angular
│   └── styles.scss                 ← Estilos globales (afectan toda la app)
├── angular.json                    ← Configuración del proyecto (build, estilos, scripts)
├── package.json                    ← Dependencias del proyecto (librerías)
├── tsconfig.json                   ← Configuración de TypeScript
└── README.md
```

### ¿Qué es cada cosa?

| Archivo/Carpeta | Para qué sirve |
|---|---|
| `src/app/` | Aquí vive toda la aplicación: componentes, servicios, rutas |
| `angular.json` | Configuración de build, estilos globales, scripts externos |
| `package.json` | Lista de dependencias. Se instalan con `npm install` |
| `tsconfig.json` | Configuración de TypeScript (Angular usa TypeScript, no JS puro) |
| `styles.scss` | Estilos que afectan a TODA la app (reset, variables, fuentes) |

---

## 0.7 Primer cambio: personalizar la app

✏️ Abrir `src/app/app.component.html`, borrar todo el contenido y reemplazar con:

```html
<!-- app.component.html -->
<!-- Este es el template del componente raíz -->
<!-- Todo lo que pongamos aquí se muestra en la pantalla -->
<h1>🎬 CineExplorer</h1>
<p>Explora las mejores películas del mundo</p>
```

▶️ Guardar y verificar que el navegador muestra el nuevo contenido automáticamente.

✏️ Abrir `src/app/app.component.ts` y verificar que se ve así:

```typescript
// app.component.ts
// Este es el componente raíz de la aplicación
// Todos los demás componentes se renderizan dentro de este

// import trae funcionalidades de Angular
import { Component } from '@angular/core';

// @Component es un decorador que le dice a Angular:
// "esta clase es un componente"
@Component({
  // selector: nombre de la etiqueta HTML para usar este componente
  // En index.html verán <app-root></app-root>
  selector: 'app-root',
  // standalone: true significa que este componente no necesita un módulo
  // Es la forma moderna de Angular (17+)
  standalone: true,
  // imports: otros componentes o módulos que este componente necesita
  imports: [],
  // templateUrl: ruta al archivo HTML del componente
  templateUrl: './app.component.html',
  // styleUrl: ruta al archivo de estilos del componente
  styleUrl: './app.component.scss'
})
// La clase contiene la lógica del componente (propiedades y métodos)
export class AppComponent {
  // Propiedad que se puede usar en el template con {{ titulo }}
  titulo: string = 'CineExplorer';
}
```

---

## 0.8 Comandos esenciales de Angular CLI

```bash
# Crear un componente nuevo
ng generate component nombre-componente
ng g c nombre-componente              # Atajo

# Crear un servicio nuevo
ng generate service nombre-servicio
ng g s nombre-servicio                # Atajo

# Crear un pipe nuevo
ng generate pipe nombre-pipe
ng g p nombre-pipe                    # Atajo

# Crear un guard nuevo
ng generate guard nombre-guard

# Compilar para producción (genera archivos optimizados en dist/)
ng build

# Ejecutar en modo desarrollo con hot reload
ng serve

# Ver ayuda de cualquier comando
ng help
ng generate --help
```

---

## 0.9 Instalar Bootstrap

🔧 Vamos a instalar Bootstrap como framework CSS para CineExplorer:

```bash
# Instalar Bootstrap como dependencia del proyecto
npm install bootstrap
```

✏️ Configurar en `angular.json` — buscar la sección `architect > build > options` y agregar:

```json
{
  "architect": {
    "build": {
      "options": {
        "styles": [
          "node_modules/bootstrap/dist/css/bootstrap.min.css",
          "src/styles.scss"
        ],
        "scripts": [
          "node_modules/bootstrap/dist/js/bootstrap.bundle.min.js"
        ]
      }
    }
  }
}
```

💡 El orden importa: Bootstrap primero, estilos personalizados después. Así podemos sobreescribir estilos de Bootstrap con los nuestros.

▶️ Reiniciar `ng serve` (Ctrl+C y volver a ejecutar) para que tome los cambios de `angular.json`.

✏️ Verificar que Bootstrap funciona modificando `app.component.html`:

```html
<!-- app.component.html -->
<!-- Verificamos que Bootstrap está funcionando con clases de utilidad -->
<div class="container text-center mt-5">
  <!-- container: centra el contenido con márgenes laterales -->
  <!-- text-center: centra el texto -->
  <!-- mt-5: margin-top grande -->
  <h1 class="display-4">🎬 CineExplorer</h1>
  <!-- display-4: tamaño de título grande de Bootstrap -->
  <p class="lead text-muted">Explora las mejores películas del mundo</p>
  <!-- lead: texto más grande para subtítulos -->
  <!-- text-muted: color gris suave -->
  <button class="btn btn-primary">Empezar a explorar</button>
  <!-- btn btn-primary: botón azul de Bootstrap -->
</div>
```

▶️ Si ven un botón azul con estilo, Bootstrap está funcionando correctamente.

---

## Resumen

| Concepto | Para qué |
|---|---|
| Node.js + npm | Ejecutar Angular y gestionar dependencias |
| Angular CLI (`ng`) | Crear proyectos, componentes, servicios, builds |
| `ng new` | Crear un proyecto nuevo |
| `ng serve` | Ejecutar en modo desarrollo con hot reload |
| `ng generate` / `ng g` | Generar componentes, servicios, pipes, guards |
| `angular.json` | Configuración del proyecto (estilos, scripts, build) |
| `package.json` | Lista de dependencias del proyecto |
| Bootstrap | Framework CSS para diseño rápido y responsive |

---

**Siguiente:** [Capítulo 1 — TypeScript para Angular →](01_typescript.md)
