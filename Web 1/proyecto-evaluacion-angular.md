# Proyecto Final: CineExplorer

**Materia:** Desarrollo Frontend  
**Modalidad:** Individual  
**Fecha de entrega:** [POR DEFINIR]  
**Puntaje total:** 100 puntos

---

## Escala de calificación

Cada elemento del proyecto se califica de 0 a 5. Esa nota se multiplica por el peso del elemento para obtener los puntos.

| Nota | Qué significa |
|---|---|
| 0 | No está o no hay evidencia |
| 1 | Intento mínimo, con errores graves o muy incompleto |
| 2 | Funciona a medias o tiene problemas importantes |
| 3 | Cumple lo básico pero le faltan cosas o tiene detalles |
| 4 | Bien resuelto, cumple lo pedido con detalles menores |
| 5 | Completo, correcto y se nota que se trabajó con cuidado |

**Ejemplo:** Si en el elemento 3.1 (peso x1) sacás un 4, tu puntaje ahí es 4 × 1 = 4 de 5 posibles. Si en el elemento 6.1 (peso x1) sacás un 3, tu puntaje es 3 × 1 = 3 de 5 posibles. Se suman todos los elementos y el total es sobre 100.

---

## Contexto del proyecto

Van a construir una aplicación web con Angular que permita explorar películas usando la API pública de TMDB (The Movie Database). La idea es que apliquen todo lo que vimos en el curso.

Para obtener su API key:
1. Crear cuenta en https://www.themoviedb.org/signup
2. Ir a Settings > API y solicitar una key (seleccionar "Developer")
3. Documentación: https://developer.themoviedb.org/docs

Endpoints que van a necesitar:

| Endpoint | Para qué sirve |
|---|---|
| `GET /movie/popular` | Películas populares |
| `GET /movie/top_rated` | Mejor valoradas |
| `GET /movie/upcoming` | Próximos estrenos |
| `GET /search/movie?query=...` | Buscar películas por nombre |
| `GET /movie/{id}` | Detalle completo de una película |
| `GET /movie/{id}/credits` | Reparto (actores, director) |
| `GET /movie/{id}/similar` | Películas parecidas |
| `GET /genre/movie/list` | Catálogo de géneros |

Las imágenes se arman concatenando `https://image.tmdb.org/t/p/w500` + el campo `poster_path` o `backdrop_path`.

---

## Cómo arrancar

```bash
ng new cine-explorer --style=scss --routing
cd cine-explorer
npm install bootstrap
```

En `angular.json`, dentro de `architect > build > options`:
- En `styles`: `"node_modules/bootstrap/dist/css/bootstrap.min.css"` (antes de `src/styles.scss`)
- En `scripts`: `"node_modules/bootstrap/dist/js/bootstrap.bundle.min.js"`

API key en `src/environments/environment.ts`:
```typescript
export const environment = {
  tmdbApiKey: 'SU_KEY_ACÁ'
};
```

Estructura de carpetas sugerida (no obligatoria, pero necesito ver organización clara):

```
src/app/
├── core/               ← Servicios, interceptor, modelos
│   ├── services/
│   ├── interceptors/
│   └── models/
├── shared/             ← Componentes, pipes reutilizables
│   ├── components/
│   └── pipes/
├── features/           ← Una carpeta por cada página
│   ├── home/
│   ├── movie-detail/
│   ├── search-results/
│   ├── favorites/
│   └── genre-filter/
├── app.component.ts
├── app.routes.ts
└── app.config.ts
```

---

## Requerimientos y puntuación detallada

A continuación está todo lo que tiene que tener el proyecto. Cada elemento tiene su peso asignado. La nota (0-5) multiplicada por el peso da los puntos de ese elemento.

---

### 1. HTML SEMÁNTICO — 10 puntos

| # | Elemento | Peso | Máx. | Qué se evalúa |
|---|---|---|---|---|
| 1.1 | Etiquetas semánticas | x1 | 5 | Usar `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<footer>`, `<figure>`, `<time>` donde corresponda en los templates de Angular. No todo puede ser un `<div>`. |
| 1.2 | Accesibilidad básica | x1 | 5 | Jerarquía de encabezados sin saltos (no pasar de `h1` a `h4`). Imágenes con `alt` descriptivo (no vale `alt="imagen"`). `<label>` en el buscador (puede ser visualmente oculto). Enlaces con texto significativo (nada de "click aquí"). |

---

### 2. CSS — LAYOUTS — 10 puntos

| # | Elemento | Peso | Máx. | Qué se evalúa |
|---|---|---|---|---|
| 2.1 | CSS Grid para tarjetas | x1 | 5 | El grid de tarjetas de películas usa CSS Grid con `repeat(auto-fit, minmax(280px, 1fr))` o similar. Se adapta al ancho disponible sin media queries adicionales para el grid en sí. |
| 2.2 | Flexbox + Grid en layout general | x1 | 5 | Navbar y footer usan Flexbox para distribuir elementos. Página de detalle usa Grid para organizar poster al lado de la información. |

---

### 3. CSS — RESPONSIVE DESIGN — 10 puntos

| # | Elemento | Peso | Máx. | Qué se evalúa |
|---|---|---|---|---|
| 3.1 | Mobile first con breakpoints | x1 | 5 | Enfoque mobile first (estilos base para celular, media queries para tablet ≥768px y desktop ≥1024px). En celular: 1 columna, navbar colapsado. Tablet: 2 columnas. Desktop: 3-4 columnas. |
| 3.2 | Tipografía fluida e imágenes | x1 | 5 | Tamaños de fuente con `clamp()`. Imágenes con `object-fit: cover` que no se deforman. El layout no se rompe en ningún ancho. |

---

### 4. CSS — ANIMACIONES Y TRANSICIONES — 5 puntos

| # | Elemento | Peso | Máx. | Qué se evalúa |
|---|---|---|---|---|
| 4.1 | Keyframes y transiciones | x0.5 | 2.5 | Animación de entrada en tarjetas (ej: `fadeInUp` con `@keyframes`). Transición suave en hover de tarjetas (escala, sombra, etc.). Spinner de carga animado. |
| 4.2 | Transición de tema y accesibilidad | x0.5 | 2.5 | El cambio de tema tiene transición en los colores (no cambio brusco). Incluye `@media (prefers-reduced-motion: reduce)` que desactiva animaciones para usuarios que lo necesitan. |

---

### 5. CSS — VARIABLES Y TEMAS — 5 puntos

| # | Elemento | Peso | Máx. | Qué se evalúa |
|---|---|---|---|---|
| 5.1 | Sistema de variables CSS | x0.5 | 2.5 | Variables en `:root` para: colores principales, fondo, texto, sombras (chica/mediana/grande), border-radius, espaciados y familia tipográfica. Se usan en todo el proyecto (no hay colores hardcodeados sueltos). |
| 5.2 | Tema claro/oscuro | x0.5 | 2.5 | Variantes de tema con `[data-theme="dark"]`. Toggle en el navbar que alterna el tema. Persiste en localStorage. Si es primera visita, respeta `prefers-color-scheme` del sistema. |

---

### 6. BOOTSTRAP — 10 puntos

| # | Elemento | Peso | Máx. | Qué se evalúa |
|---|---|---|---|---|
| 6.1 | Grid y navbar | x1 | 5 | Layout general con `container`/`row`/`col`. Navbar con `navbar-expand-lg`, dropdown para géneros, collapse con hamburguesa en móvil. Navbar sticky en la parte superior. |
| 6.2 | Componentes y utilidades | x1 | 5 | Cards como base para tarjetas. Badges para contador de favoritos y géneros. Modal para confirmación al eliminar favorito. Spinner para estados de carga. Pagination para resultados. Utilidades de spacing (`m-*`, `p-*`), colores (`text-muted`, `bg-light`) y display (`d-flex`, `d-none d-md-block`). Sin abuso de `!important`. |

---

### 7. CONSUMO DE API — HttpClient — 8 puntos

| # | Elemento | Peso | Máx. | Qué se evalúa |
|---|---|---|---|---|
| 7.1 | TmdbService | x0.8 | 4 | Servicio que centraliza todas las llamadas HTTP. Un método por endpoint (popular, top_rated, upcoming, search, detail, credits, similar, genres, moviesByGenre). Todos devuelven `Observable`. |
| 7.2 | Interceptor y manejo de errores | x0.8 | 4 | Interceptor funcional (`HttpInterceptorFn`) que agrega `Authorization: Bearer <token>` a las peticiones a TMDB. Manejo de errores HTTP (la app no se rompe si la API falla, muestra mensaje al usuario). Cada vista muestra estado de carga mientras espera respuesta. |

---

### 8. SERVICIOS Y ARQUITECTURA — 6 puntos

| # | Elemento | Peso | Máx. | Qué se evalúa |
|---|---|---|---|---|
| 8.1 | Servicios separados | x0.8 | 4 | Tres servicios con responsabilidad clara: TmdbService (API), FavoritesService (localStorage de favoritos con agregar/quitar/listar/verificar), ThemeService (preferencia de tema). Inyección de dependencias correcta (`providedIn: 'root'`). |
| 8.2 | Modelos y organización | x0.4 | 2 | Interfaces tipadas para los datos de la API (mínimo: `Movie`, `MovieDetail`, `MovieResponse`, `Genre`, `Credits`, `CastMember`). Carpetas organizadas (core/shared/features o estructura equivalente que tenga sentido). |

---

### 9. COMPONENTES Y BINDING — 6 puntos

| # | Elemento | Peso | Máx. | Qué se evalúa |
|---|---|---|---|---|
| 9.1 | MovieCardComponent reutilizable | x0.8 | 4 | Recibe datos por `@Input()`. Emite evento de favorito con `@Output()`. No conoce el origen de los datos ni qué pasa al tocar favorito (eso lo decide el padre). Se usa en home, búsqueda, favoritos y género sin modificaciones. |
| 9.2 | Pipes y ciclo de vida | x0.4 | 2 | Al menos dos pipes custom: uno para truncar texto largo, otro para armar la URL completa de imágenes TMDB. Uso correcto de `OnInit` y `OnDestroy` (o `takeUntilDestroyed()`). |

---

### 10. localStorage — 5 puntos

| # | Elemento | Peso | Máx. | Qué se evalúa |
|---|---|---|---|---|
| 10.1 | Favoritos persistentes | x0.5 | 2.5 | FavoritesService con métodos: agregar, quitar, obtener todos, verificar si es favorita. Los datos sobreviven al recargar la página. `JSON.parse` protegido con try/catch. |
| 10.2 | Tema persistente | x0.5 | 2.5 | ThemeService guarda preferencia en localStorage. Al recargar, aplica el último tema elegido. Si no hay nada guardado, usa `prefers-color-scheme` del navegador. |

---

### 11. ROUTING Y NAVEGACIÓN — 5 puntos

| # | Elemento | Peso | Máx. | Qué se evalúa |
|---|---|---|---|---|
| 11.1 | Rutas configuradas | x0.5 | 2.5 | Rutas: `/` (inicio), `/movie/:id` (detalle), `/search` con query param `q` (búsqueda), `/favorites`, `/genre/:id`, `**` redirige a inicio. Todas funcionan correctamente. |
| 11.2 | Navegación funcional | x0.5 | 2.5 | Se navega entre vistas sin recargar la página. `ActivatedRoute` para leer parámetros de ruta y query params. Links del navbar llevan a donde dicen. |

---

### 12. FUNCIONALIDADES COMPLETAS — 10 puntos

Esta sección evalúa que las funcionalidades de la aplicación estén completas y funcionen de punta a punta, no solo que existan los archivos.

| # | Elemento | Peso | Máx. | Qué se evalúa |
|---|---|---|---|---|
| 12.1 | Página de inicio | x0.5 | 2.5 | Banner/hero con película destacada (imagen, título, sinopsis, botón a detalle). Tres secciones visibles: populares, mejor valoradas, próximos estrenos. Datos reales cargados desde la API. |
| 12.2 | Detalle de película | x0.5 | 2.5 | Muestra: backdrop, poster, sinopsis, géneros (como badges), duración, idioma, puntuación. Sección de reparto con fotos circulares y nombres. Sección de películas similares con tarjetas. Botón de favorito funcional. |
| 12.3 | Búsqueda con debounce | x0.5 | 2.5 | Barra en el navbar. Debounce de 300ms con `debounceTime`, `distinctUntilChanged` y `switchMap`. Resultados en `/search?q=...` con paginación funcional. Mensaje visible cuando no hay resultados. Input con `ReactiveFormsModule`. |
| 12.4 | Favoritos y filtro por género | x0.5 | 2.5 | Vista `/favorites`: tarjetas de favoritos, estado vacío si no hay ninguno, contador en navbar con badge, modal de confirmación al eliminar. Vista `/genre/:id`: películas filtradas por género, géneros accesibles desde dropdown o chips, paginación funcional. |

---

### 13. CALIDAD GENERAL — 10 puntos

| # | Elemento | Peso | Máx. | Qué se evalúa |
|---|---|---|---|---|
| 13.1 | Código y consola | x1 | 5 | Código limpio y legible. Sin errores ni warnings en la consola del navegador. Compila sin errores con `ng build`. Funciona en Chrome y Firefox. |
| 13.2 | Git y documentación | x1 | 5 | Historial de commits con mensajes descriptivos (no "fix", "update", "cambios"). Mínimo 10 commits que muestren progreso real. README del proyecto con: instrucciones de instalación y ejecución, y capturas de pantalla de las vistas principales. |

---

## Resumen de puntos por sección

| # | Sección | Puntos |
|---|---|---|
| 1 | HTML semántico | 10 |
| 2 | CSS — Layouts (Flexbox/Grid) | 10 |
| 3 | CSS — Responsive design | 10 |
| 4 | CSS — Animaciones y transiciones | 5 |
| 5 | CSS — Variables y temas | 5 |
| 6 | Bootstrap | 10 |
| 7 | Consumo de API (HttpClient) | 8 |
| 8 | Servicios y arquitectura | 6 |
| 9 | Componentes y binding | 6 |
| 10 | localStorage | 5 |
| 11 | Routing y navegación | 5 |
| 12 | Funcionalidades completas | 10 |
| 13 | Calidad general | 10 |
| | **Total** | **100** |

---

## Escala de aprobación

| Puntaje | Resultado |
|---|---|
| 90 – 100 | Sobresaliente |
| 80 – 89 | Notable |
| 70 – 79 | Aprobado |
| 60 – 69 | Aprobado con observaciones |
| < 60 | No aprobado |

---

## Penalizaciones

- **Copia o código generado por IA sin comprensión:** Si no pueden explicar su propio código en una revisión, la nota de los elementos afectados baja a 0.
- **Entrega fuera de plazo:** Se restan 5 puntos (sobre 100) por cada día de retraso.
- **No compila:** Si `ng build` falla, la nota máxima posible es 50. Se evalúa solo lo que se pueda revisar leyendo el código.

---

## Qué entregar

- Repositorio en GitHub/GitLab con historial de commits.
- README.md dentro del proyecto con instrucciones y capturas.
- La app debe compilar sin errores con `ng build`.
- Debe funcionar en Chrome y Firefox.

---

## Recomendaciones

Empiecen por el servicio HTTP. Hagan un `console.log` de lo que devuelve la API y asegúrense de que entienden la estructura de los datos antes de armar las vistas. Después construyan la tarjeta de película, porque la van a usar en todas las páginas. Configuren el routing temprano para poder ir navegando entre vistas mientras desarrollan. Hagan commits seguido — si algo se rompe, pueden volver atrás.

No dejen el responsive para el final. Si trabajan mobile first desde el principio, es mucho más fácil que tratar de "arreglar" todo al final.

---

**Cualquier duda, pregunten antes de la fecha de entrega. No el día anterior.**
