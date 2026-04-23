# Angular — Aprende Construyendo

## Proyecto: CineExplorer 🎬

Esta guía enseña Angular desde cero hasta nivel avanzado a través de **un único proyecto** que crece de forma incremental: una app de exploración de películas llamada **CineExplorer**, que consume la API pública de TMDB (The Movie Database).

Cada capítulo agrega funcionalidad real al proyecto. Cada línea de código está comentada. La dificultad sube gradualmente desde "Hola Angular" hasta una app completa con arquitectura profesional, consumo de APIs, programación reactiva y tema claro/oscuro.

---

## ¿Qué vamos a construir?

**CineExplorer** es una app web donde el usuario puede:
- Explorar películas populares, mejor valoradas y próximos estrenos
- Ver el detalle completo de cada película (sinopsis, reparto, puntuación)
- Buscar películas en tiempo real con debounce
- Guardar películas como favoritas (persistidas en localStorage)
- Filtrar películas por género
- Alternar entre tema claro y oscuro
- Navegar entre secciones sin recargar la página (SPA)

Al final del curso tendrán una app funcional y desplegable que demuestra todos los conceptos fundamentales de Angular.

---

## Índice de capítulos

| # | Capítulo | Qué se aprende | Qué se agrega al proyecto |
|---|---------|----------------|--------------------------|
| 00 | [Prerequisitos y entorno](material/00_prerequisitos.md) | Node.js, Angular CLI, VS Code, primer proyecto | Proyecto CineExplorer creado |
| 01 | [TypeScript para Angular](material/01_typescript.md) | Tipos, interfaces, clases, enums, generics | Interfaces de Movie, Genre, Credits |
| 02 | [Componentes](material/02_componentes.md) | Data binding, directivas, ciclo de vida | Componente MovieCard, página Home |
| 03 | [Comunicación entre componentes](material/03_comunicacion_componentes.md) | @Input, @Output, smart vs dumb components | MovieCard recibe datos, emite favorito |
| 04 | [Servicios e inyección de dependencias](material/04_servicios.md) | Servicios, singleton, separar lógica | TmdbService, FavoritesService |
| 05 | [Routing y navegación](material/05_routing.md) | Rutas, parámetros, lazy loading, guards | Navbar, páginas Home, Detalle, Favoritos |
| 06 | [Consumo de APIs con HttpClient](material/06_httpclient.md) | GET, tipado, errores, interceptores | Datos reales de TMDB en la app |
| 07 | [Programación reactiva con RxJS](material/07_rxjs.md) | Observables, operadores, BehaviorSubject | Buscador con debounce, favoritos reactivos |
| 08 | [Formularios](material/08_formularios.md) | Reactive forms, validación, FormArray | Formulario de reseña de película |
| 09 | [Pipes](material/09_pipes.md) | Pipes built-in y personalizados | TruncatePipe, TmdbImagePipe, StarsPipe |
| 10 | [Persistencia con localStorage](material/10_localstorage.md) | StorageService, BehaviorSubject, tema | Favoritos y tema persistidos |
| 11 | [Estilos, temas y Bootstrap](material/11_estilos_bootstrap.md) | Bootstrap, variables CSS, tema oscuro, animaciones | Diseño completo con tema claro/oscuro |
| 12 | [Arquitectura y buenas prácticas](material/12_arquitectura.md) | core/shared/features, environments, deploy | Proyecto reorganizado y desplegable |
| 13 | [Proyecto final y evaluación](material/13_proyecto_final.md) | Integración, rúbrica, checklist | App terminada y pulida |

---

## Requisitos previos

- HTML semántico, CSS (Flexbox, Grid, media queries)
- JavaScript: variables, funciones, arrays, objetos, destructuring, async/await, fetch
- Bootstrap básico (grid, componentes)
- Git básico (clone, add, commit, push)

---

## Cómo usar esta guía

1. **Sigan el orden.** Cada capítulo depende del anterior.
2. **Escriban el código ustedes mismos.** No copien y peguen.
3. **Lean los comentarios.** Cada línea tiene una explicación de por qué está ahí.
4. **Compilen después de cada cambio.** `ng serve` muestra errores en tiempo real.
5. **Si algo falla,** lean el error completo en la terminal. Angular da mensajes claros.

---

## Convenciones de esta guía

- 📁 indica que hay que crear un archivo nuevo
- ✏️ indica que hay que modificar un archivo existente
- 🔧 indica configuración o dependencias
- ▶️ indica que hay que compilar y probar
- 💡 indica un tip o nota importante
