# Capítulo 13: Proyecto final — CineExplorer completa

## Objetivo

Integrar todo lo aprendido, pulir la app y tener una referencia completa del proyecto terminado.

---

## 13.1 Lo que construimos

A lo largo de 13 capítulos, construimos **CineExplorer** desde cero:

| Funcionalidad | Capítulo | Tecnología |
|---|---|---|
| Proyecto base con Bootstrap | 00 | Angular CLI, Bootstrap |
| Interfaces tipadas | 01 | TypeScript, interfaces |
| Tarjeta de película | 02 | Componentes, data binding |
| Datos del padre al hijo | 03 | input(), output(), signals |
| Servicios de favoritos | 04 | Servicios, inyección de dependencias |
| Navegación entre páginas | 05 | Routing, RouterLink, parámetros |
| Datos reales de TMDB | 06 | HttpClient, interceptores |
| Buscador con debounce | 07 | RxJS, BehaviorSubject, operadores |
| Formulario de reseña | 08 | Reactive Forms, validación |
| Pipes personalizados | 09 | TruncatePipe, TmdbImagePipe, StarsPipe |
| Favoritos persistidos | 10 | localStorage, StorageService |
| Tema claro/oscuro | 11 | Variables CSS, Bootstrap, animaciones |
| Arquitectura profesional | 12 | core/shared/features, environments |

---

## 13.2 Estructura final del proyecto

```
cine-explorer/
├── src/
│   ├── app/
│   │   ├── core/
│   │   │   ├── services/
│   │   │   │   ├── tmdb.service.ts          ← Consumo de API TMDB
│   │   │   │   ├── favorites.service.ts     ← Favoritos con BehaviorSubject
│   │   │   │   ├── theme.service.ts         ← Tema claro/oscuro
│   │   │   │   └── storage.service.ts       ← Wrapper de localStorage
│   │   │   ├── interceptors/
│   │   │   │   └── api-key.interceptor.ts   ← Agrega API key automáticamente
│   │   │   └── models/
│   │   │       └── movie.ts                 ← Interfaces (Movie, Genre, Credits)
│   │   ├── shared/
│   │   │   ├── components/
│   │   │   │   ├── movie-card/              ← Tarjeta de película reutilizable
│   │   │   │   ├── navbar/                  ← Navbar con buscador y tema
│   │   │   │   └── spinner/                 ← Indicador de carga
│   │   │   └── pipes/
│   │   │       ├── truncate.pipe.ts         ← Truncar texto largo
│   │   │       ├── tmdb-image.pipe.ts       ← URLs de imágenes TMDB
│   │   │       └── stars.pipe.ts            ← Puntuación → estrellas
│   │   ├── features/
│   │   │   ├── home/                        ← Página principal (populares)
│   │   │   ├── movie-detail/                ← Detalle de película
│   │   │   ├── search-results/              ← Resultados de búsqueda
│   │   │   └── favorites/                   ← Películas favoritas
│   │   ├── app.component.ts                 ← Componente raíz
│   │   ├── app.routes.ts                    ← Definición de rutas
│   │   └── app.config.ts                    ← Configuración (HttpClient, Router)
│   ├── environments/
│   │   ├── environment.ts                   ← Variables de desarrollo
│   │   └── environment.prod.ts              ← Variables de producción
│   ├── assets/
│   │   └── no-image.png                     ← Imagen por defecto
│   └── styles.scss                          ← Estilos globales y temas
├── angular.json                             ← Configuración del proyecto
├── package.json                             ← Dependencias
└── tsconfig.json                            ← Configuración TypeScript
```

---

## 13.3 API: TMDB

### Obtener API key

1. Crear cuenta en [https://www.themoviedb.org/signup](https://www.themoviedb.org/signup)
2. Ir a Settings → API y solicitar una key (seleccionar "Developer")
3. Documentación: [https://developer.themoviedb.org/docs](https://developer.themoviedb.org/docs)

### Endpoints usados

| Endpoint | Para qué |
|---|---|
| `GET /movie/popular` | Películas populares (Home) |
| `GET /movie/top_rated` | Mejor valoradas |
| `GET /search/movie?query=...` | Buscar películas |
| `GET /movie/{id}` | Detalle de una película |
| `GET /movie/{id}/credits` | Reparto (actores, director) |
| `GET /genre/movie/list` | Catálogo de géneros |

Las imágenes se arman: `https://image.tmdb.org/t/p/w500` + `poster_path`

---

## 13.4 Guía paso a paso para completar

### Semana 1: Base
1. Crear proyecto con `ng new cine-explorer --style=scss --routing`
2. Instalar Bootstrap y configurar en `angular.json`
3. Crear interfaces en `models/movie.ts`
4. Crear `TmdbService` con `obtenerPopulares()`
5. Crear `MovieCardComponent` con input()/output()
6. Crear `HomeComponent` que muestre películas reales

### Semana 2: Navegación y búsqueda
1. Configurar rutas en `app.routes.ts`
2. Crear `NavbarComponent` con RouterLink
3. Crear `MovieDetailComponent` con parámetro `:id`
4. Agregar buscador con debounce en el navbar
5. Crear `SearchResultsComponent` con query params

### Semana 3: Favoritos y estilos
1. Crear `FavoritesService` con BehaviorSubject + localStorage
2. Crear vista `/favorites`
3. Crear pipes: TruncatePipe, TmdbImagePipe, StarsPipe
4. Definir variables CSS y tema oscuro
5. Agregar animaciones y verificar responsive

### Semana 4: Pulir y entregar
1. Reorganizar carpetas (core/shared/features)
2. Configurar `environment.ts` con API key
3. Crear interceptor para API key
4. Verificar `ng build` sin errores
5. Escribir README con instrucciones y capturas
6. Desplegar en Netlify/Vercel/GitHub Pages

---

## 13.5 Errores comunes

1. **No tipar las respuestas de la API.** Usar `any` en vez de interfaces hace que el editor no ayude y los errores aparezcan en runtime.

2. **Poner lógica de negocio en los componentes.** Los componentes deben ser delgados. La lógica va en servicios.

3. **No limpiar suscripciones.** Usar `async` pipe o `takeUntilDestroyed()`. Nunca dejar `subscribe()` sin limpieza.

4. **Dejar el responsive para el final.** Trabajar mobile first desde el principio.

5. **Commits genéricos.** "fix", "update" no dicen nada. Escribir qué se hizo: "feat: agregar búsqueda con debounce".

6. **No manejar errores HTTP.** La app no se puede romper si la API falla. Siempre mostrar un mensaje al usuario.

7. **Hardcodear la API key en el servicio.** Usar `environment.ts`.

8. **Usar `@Input()` y `@Output()` decoradores en vez de `input()` y `output()`.** La API de signals es la forma moderna y recomendada en Angular 17+. Los decoradores siguen funcionando pero no se recomiendan para proyectos nuevos.

9. **Olvidar los paréntesis al leer signals en el template.** `{{ movie.title }}` no funciona con `input()`, debe ser `{{ movie().title }}`.

---

## 13.6 Equivalencias con JavaScript puro

| JavaScript puro | Angular |
|---|---|
| `fetch()` | `HttpClient.get()` |
| `document.querySelector()` | Data binding `{{ }}`, `[prop]` |
| `addEventListener()` | Event binding `(click)` |
| `innerHTML` | Interpolación `{{ }}` |
| `<script src="...">` | `import { } from '...'` |
| Funciones sueltas | Servicios con `@Injectable` |
| `localStorage` directamente | `StorageService` wrapper |
| CSS global | Estilos encapsulados por componente |
| Múltiples HTML | Routing (SPA, una sola página) |

---

## 13.7 Referencias

- Documentación de Angular: [angular.dev](https://angular.dev)
- TypeScript: [typescriptlang.org](https://www.typescriptlang.org)
- RxJS: [rxjs.dev](https://rxjs.dev)
- Bootstrap: [getbootstrap.com](https://getbootstrap.com)
- TMDB API: [developer.themoviedb.org](https://developer.themoviedb.org)
- Angular CLI: [angular.dev/tools/cli](https://angular.dev/tools/cli)

---

## Felicitaciones

Si llegaron hasta aquí, tienen una base sólida en desarrollo web con Angular. Construyeron una app completa con:

- Componentes reutilizables con input()/output() (signals)
- Servicios con inyección de dependencias
- Navegación SPA con routing y lazy loading
- Consumo de API REST con HttpClient
- Programación reactiva con RxJS y BehaviorSubject
- Formularios reactivos con validación
- Pipes personalizados
- Persistencia con localStorage
- Tema claro/oscuro con variables CSS
- Arquitectura profesional (core/shared/features)
- Diseño responsive con Bootstrap
- Sintaxis moderna de templates (@for, @if, @switch)

El siguiente paso es practicar. Tomen esta app y agréguenle funcionalidades: paginación, filtro por género, lista de "ver después", compartir en redes, PWA. Cada feature nueva refuerza lo aprendido.

---

**Anterior:** [← Capítulo 12 — Arquitectura](12_arquitectura.md) | **Inicio:** [Guía principal →](../guia_angular_material.md)
