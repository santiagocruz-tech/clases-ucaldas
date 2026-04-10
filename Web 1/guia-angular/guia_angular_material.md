# Angular — Guía Completa desde Cero

**Enfoque:** aprender Angular de forma progresiva, asumiendo que el estudiante ya domina HTML, CSS, JavaScript y consumo de APIs con fetch.
Este material está diseñado para que los estudiantes:

1. Comprendan **la arquitectura y filosofía de Angular**.
2. Aprendan a **construir aplicaciones reales** con componentes, servicios, routing y formularios.
3. Dominen **el consumo de APIs con HttpClient** y programación reactiva con RxJS.
4. Apliquen **buenas prácticas** de organización, tipado y despliegue.

El curso mantiene un equilibrio aproximado de **40% teoría y 60% práctica**.

Cada sección incluye explicaciones conceptuales, ejemplos de código funcionales y ejercicios progresivos.

---

# Contenido del curso

## 0. Prerequisitos y entorno de desarrollo

> 📄 [material/00_prerequisitos.md](material/00_prerequisitos.md)

- Checklist de conocimientos previos (HTML, CSS, JS, TypeScript básico)
- Instalación de Node.js y npm
- Instalación de Angular CLI
- Configuración del editor (VS Code + extensiones recomendadas)
- Crear y ejecutar el primer proyecto Angular
- Estructura de archivos de un proyecto Angular
- Comandos esenciales de Angular CLI

---

## 1. TypeScript para Angular

> 📄 [material/01_typescript.md](material/01_typescript.md)

- ¿Por qué TypeScript?
- Tipos básicos: string, number, boolean, array, any, unknown
- Interfaces y types
- Clases con tipado
- Enums
- Generics básicos
- Módulos (import/export)
- Decoradores: qué son y por qué Angular los usa
- Ejercicios

---

## 2. Componentes

> 📄 [material/02_componentes.md](material/02_componentes.md)

- ¿Qué es un componente en Angular?
- Anatomía: decorator, clase, template, estilos
- Crear componentes con Angular CLI
- Data binding: interpolación, property binding, event binding, two-way binding
- Directivas estructurales: @if, @for, @switch (nueva sintaxis)
- Directivas de atributo: ngClass, ngStyle
- Ciclo de vida de un componente (OnInit, OnDestroy, OnChanges)
- Ejercicios

---

## 3. Comunicación entre componentes

> 📄 [material/03_comunicacion_componentes.md](material/03_comunicacion_componentes.md)

- @Input(): pasar datos de padre a hijo
- @Output() y EventEmitter: emitir eventos de hijo a padre
- Componentes inteligentes vs. componentes de presentación
- Proyección de contenido con ng-content
- ViewChild para acceder a componentes hijos
- Ejercicios

---

## 4. Servicios e inyección de dependencias

> 📄 [material/04_servicios.md](material/04_servicios.md)

- ¿Qué es un servicio y por qué usarlos?
- Crear servicios con Angular CLI
- providedIn: 'root' y el patrón singleton
- Inyección de dependencias en el constructor
- Separar lógica de negocio de los componentes
- Ejemplo práctico: servicio de carrito de compras
- Ejercicios

---

## 5. Routing y navegación

> 📄 [material/05_routing.md](material/05_routing.md)

- Configuración de rutas en app.routes.ts
- RouterLink y RouterOutlet
- Rutas con parámetros (:id)
- Query params
- Redirecciones y ruta wildcard (**)
- Lazy loading de rutas
- Guards: proteger rutas con canActivate
- Ejercicios

---

## 6. Consumo de APIs con HttpClient

> 📄 [material/06_httpclient.md](material/06_httpclient.md)

- Configurar HttpClient en Angular
- GET, POST, PUT, DELETE
- Tipar las respuestas con interfaces
- Manejo de errores con catchError
- Interceptores: agregar headers, tokens, logging
- Estados de carga y feedback al usuario
- Comparación: fetch nativo vs. HttpClient
- Ejercicios

---

## 7. Programación reactiva con RxJS

> 📄 [material/07_rxjs.md](material/07_rxjs.md)

- ¿Qué es un Observable?
- Observable vs. Promise
- Operadores esenciales: map, filter, tap, switchMap, mergeMap
- debounceTime y distinctUntilChanged para búsquedas
- Subject y BehaviorSubject
- Suscripciones y cómo evitar memory leaks (takeUntilDestroyed, async pipe)
- Ejercicios

---

## 8. Formularios

> 📄 [material/08_formularios.md](material/08_formularios.md)

- Template-driven forms vs. Reactive forms
- Reactive forms: FormControl, FormGroup, FormBuilder
- Validaciones built-in (required, minLength, pattern)
- Validaciones personalizadas
- Mostrar mensajes de error
- Formularios dinámicos con FormArray
- Ejercicios

---

## 9. Pipes

> 📄 [material/09_pipes.md](material/09_pipes.md)

- Pipes built-in: date, currency, uppercase, lowercase, json, async
- Crear pipes personalizados
- Pipes puros vs. impuros
- Pipe para truncar texto
- Pipe para transformar URLs de imágenes
- Ejercicios

---

## 10. Persistencia con localStorage

> 📄 [material/10_localstorage.md](material/10_localstorage.md)

- localStorage en Angular: cuándo y cómo usarlo
- Servicio wrapper para localStorage
- Guardar y recuperar objetos (JSON.parse/stringify con try/catch)
- Persistir favoritos y preferencias de usuario
- Persistir tema claro/oscuro
- Ejercicios

---

## 11. Estilos, temas y Bootstrap en Angular

> 📄 [material/11_estilos_bootstrap.md](material/11_estilos_bootstrap.md)

- Estilos globales vs. estilos por componente (encapsulación)
- Instalar y configurar Bootstrap en Angular
- Variables CSS y sistema de temas (claro/oscuro)
- Animaciones y transiciones CSS en componentes
- @media (prefers-reduced-motion) y accesibilidad
- Ejercicios

---

## 12. Arquitectura y buenas prácticas

> 📄 [material/12_arquitectura.md](material/12_arquitectura.md)

- Organización de carpetas: core, shared, features
- Componentes standalone vs. módulos (NgModule)
- Barrel exports (index.ts)
- Ambientes (environment.ts) para API keys
- Build de producción y despliegue
- Checklist de calidad de un proyecto Angular

---

## 13. Proyecto integrador y evaluación

> 📄 [material/13_proyecto_final.md](material/13_proyecto_final.md)

- Descripción del proyecto final (CineExplorer con TMDB API)
- Requerimientos funcionales y rúbrica de evaluación
- Guía paso a paso para arrancar el proyecto
- Recomendaciones y errores comunes
- Escala de calificación
