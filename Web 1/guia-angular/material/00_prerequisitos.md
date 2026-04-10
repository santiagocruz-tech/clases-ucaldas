# 0. Prerequisitos y entorno de desarrollo

## Checklist de conocimientos previos

Antes de empezar con Angular, asegurate de dominar estos temas:

- [ ] HTML semántico (header, nav, main, section, article, footer)
- [ ] CSS: Flexbox, Grid, media queries, variables CSS, animaciones
- [ ] JavaScript: variables, funciones, arrays, objetos, destructuring, spread
- [ ] JavaScript asíncrono: Promises, async/await, fetch API
- [ ] Manipulación del DOM (querySelector, addEventListener, createElement)
- [ ] Clases y herencia en JavaScript (ES6)
- [ ] Módulos ES6 (import/export)
- [ ] localStorage
- [ ] Bootstrap básico (grid, componentes, utilidades)
- [ ] Git básico (clone, add, commit, push)

Si alguno de estos temas no está claro, repasalo antes de continuar. Angular construye sobre todo esto.

---

## Instalación de Node.js y npm

Angular necesita Node.js para funcionar. npm (Node Package Manager) viene incluido.

```bash
# Verificar si ya están instalados
node --version    # Debe ser v18 o superior
npm --version     # Debe ser v9 o superior
```

Si no están instalados, descargar desde [https://nodejs.org](https://nodejs.org) (versión LTS).

---

## Instalación de Angular CLI

Angular CLI es la herramienta de línea de comandos para crear y gestionar proyectos Angular.

```bash
# Instalar globalmente
npm install -g @angular/cli

# Verificar instalación
ng version
```

---

## Configuración del editor

### VS Code — Extensiones recomendadas

| Extensión | Para qué sirve |
|---|---|
| Angular Language Service | Autocompletado en templates Angular |
| Prettier | Formateo automático de código |
| ESLint | Detección de errores y malas prácticas |
| Auto Rename Tag | Renombra etiquetas HTML automáticamente |
| Material Icon Theme | Iconos para archivos Angular |

---

## Crear y ejecutar el primer proyecto

```bash
# Crear proyecto nuevo
ng new mi-primer-proyecto --style=scss --routing

# Opciones que pregunta:
# - Which stylesheet format? → SCSS
# - Do you want to enable Server-Side Rendering? → No (por ahora)

# Entrar al proyecto
cd mi-primer-proyecto

# Ejecutar en modo desarrollo
ng serve

# Abrir en el navegador: http://localhost:4200
```

---

## Estructura de archivos de un proyecto Angular

```
mi-primer-proyecto/
├── src/
│   ├── app/
│   │   ├── app.component.ts        ← Componente raíz
│   │   ├── app.component.html      ← Template del componente raíz
│   │   ├── app.component.scss      ← Estilos del componente raíz
│   │   ├── app.component.spec.ts   ← Tests del componente raíz
│   │   ├── app.config.ts           ← Configuración de la app
│   │   └── app.routes.ts           ← Definición de rutas
│   ├── assets/                     ← Imágenes, fuentes, archivos estáticos
│   ├── environments/               ← Variables de entorno
│   ├── index.html                  ← HTML principal (punto de entrada)
│   ├── main.ts                     ← Archivo de arranque de Angular
│   └── styles.scss                 ← Estilos globales
├── angular.json                    ← Configuración del proyecto Angular
├── package.json                    ← Dependencias del proyecto
├── tsconfig.json                   ← Configuración de TypeScript
└── README.md
```

### ¿Qué es cada cosa?

- `src/app/` → Aquí vive toda la aplicación. Componentes, servicios, rutas, todo.
- `angular.json` → Configuración de build, estilos globales, scripts externos.
- `package.json` → Lista de dependencias. Se instalan con `npm install`.
- `tsconfig.json` → Configuración de TypeScript (Angular usa TypeScript, no JavaScript puro).

---

## Comandos esenciales de Angular CLI

```bash
# Crear componente
ng generate component nombre-componente
ng g c nombre-componente              # Atajo

# Crear servicio
ng generate service nombre-servicio
ng g s nombre-servicio

# Crear pipe
ng generate pipe nombre-pipe
ng g p nombre-pipe

# Crear guard
ng generate guard nombre-guard

# Build de producción
ng build

# Ejecutar tests
ng test

# Ver ayuda
ng help
```

---

## Ejercicio 0: Verificar el entorno

1. Instalar Node.js, npm y Angular CLI.
2. Crear un proyecto nuevo con `ng new hola-angular --style=scss --routing`.
3. Ejecutar `ng serve` y abrir `http://localhost:4200`.
4. Modificar `app.component.html`: borrar todo el contenido y poner `<h1>Hola Angular</h1>`.
5. Verificar que el cambio se refleja automáticamente en el navegador (hot reload).
6. Explorar la estructura de carpetas y entender qué hace cada archivo.
