# 13. Proyecto integrador y evaluación

## Descripción del proyecto: CineExplorer

Construir una aplicación web con Angular que permita explorar películas usando la API pública de TMDB (The Movie Database). La idea es aplicar todo lo visto en el curso.

### API: TMDB

1. Crear cuenta en [https://www.themoviedb.org/signup](https://www.themoviedb.org/signup)
2. Ir a Settings > API y solicitar una key (seleccionar "Developer")
3. Documentación: [https://developer.themoviedb.org/docs](https://developer.themoviedb.org/docs)

### Endpoints necesarios

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
    tmdbApiKey: 'TU_KEY_ACÁ'
};
```

### Estructura sugerida

```
src/app/
├── core/
│   ├── services/
│   │   ├── tmdb.service.ts
│   │   ├── favorites.service.ts
│   │   └── theme.service.ts
│   ├── interceptors/
│   │   └── auth.interceptor.ts
│   └── models/
│       ├── movie.ts
│       ├── genre.ts
│       └── credits.ts
├── shared/
│   ├── components/
│   │   └── movie-card/
│   └── pipes/
│       ├── truncate.pipe.ts
│       └── tmdb-image.pipe.ts
├── features/
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

## Guía paso a paso

### Paso 1: Servicio HTTP (semana 1)
1. Crear las interfaces en `core/models/`.
2. Crear `TmdbService` con un método (`obtenerPopulares`).
3. Hacer `console.log` de la respuesta para entender la estructura.
4. Crear el interceptor para agregar el token.

### Paso 2: Tarjeta de película (semana 1)
1. Crear `MovieCardComponent` en `shared/components/`.
2. Recibe `Movie` por `@Input()`.
3. Emite evento de favorito con `@Output()`.
4. Crear los pipes `TruncatePipe` y `TmdbImagePipe`.

### Paso 3: Routing y páginas (semana 2)
1. Configurar rutas en `app.routes.ts`.
2. Crear `HomeComponent` con las 3 secciones (popular, top rated, upcoming).
3. Crear `MovieDetailComponent` con parámetro `:id`.
4. Crear navbar con `RouterLink`.

### Paso 4: Búsqueda (semana 2)
1. Agregar buscador en el navbar con `FormControl`.
2. Implementar `debounceTime` + `switchMap`.
3. Crear `SearchResultsComponent` con query params.
4. Agregar paginación.

### Paso 5: Favoritos y géneros (semana 3)
1. Crear `FavoritesService` con localStorage y BehaviorSubject.
2. Crear vista `/favorites`.
3. Crear vista `/genre/:id` con dropdown de géneros.
4. Badge de contador en navbar.

### Paso 6: Estilos y temas (semana 3)
1. Definir variables CSS en `:root`.
2. Implementar tema oscuro con `ThemeService`.
3. Agregar animaciones (fadeInUp, hover, spinner).
4. Verificar responsive en móvil, tablet y desktop.
5. Agregar `prefers-reduced-motion`.

### Paso 7: Pulir y entregar (semana 4)
1. Verificar que `ng build` compila sin errores.
2. Limpiar consola de errores y warnings.
3. Probar en Chrome y Firefox.
4. Escribir README con instrucciones y capturas.
5. Verificar historial de commits.

---

## Requerimientos y rúbrica de evaluación

### Resumen de puntos por sección

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

### Escala de calificación por elemento

| Nota | Qué significa |
|---|---|
| 0 | No está o no hay evidencia |
| 1 | Intento mínimo, con errores graves o muy incompleto |
| 2 | Funciona a medias o tiene problemas importantes |
| 3 | Cumple lo básico pero le faltan cosas o tiene detalles |
| 4 | Bien resuelto, cumple lo pedido con detalles menores |
| 5 | Completo, correcto y se nota que se trabajó con cuidado |

### Escala de aprobación

| Puntaje | Resultado |
|---|---|
| 90 – 100 | Sobresaliente |
| 80 – 89 | Notable |
| 70 – 79 | Aprobado |
| 60 – 69 | Aprobado con observaciones |
| < 60 | No aprobado |

---

## Penalizaciones

- **Copia o código generado por IA sin comprensión:** si no pueden explicar su propio código en una revisión, la nota de los elementos afectados baja a 0.
- **Entrega fuera de plazo:** se restan 5 puntos por cada día de retraso.
- **No compila:** si `ng build` falla, la nota máxima posible es 50.

---

## Qué entregar

- Repositorio en GitHub/GitLab con historial de commits.
- README.md dentro del proyecto con instrucciones y capturas.
- La app debe compilar sin errores con `ng build`.
- Debe funcionar en Chrome y Firefox.

---

## Errores comunes

1. **No tipar las respuestas de la API.** Usar `any` en vez de interfaces hace que el editor no ayude y los errores aparezcan en runtime.

2. **Poner lógica de negocio en los componentes.** Los componentes deben ser delgados. La lógica va en servicios.

3. **No limpiar suscripciones.** Usar `async` pipe o `takeUntilDestroyed()`. Nunca dejar `subscribe()` sin limpieza en componentes que se destruyen.

4. **Dejar el responsive para el final.** Trabajar mobile first desde el principio. Es mucho más fácil que "arreglar" todo al final.

5. **Commits genéricos.** "fix", "update", "cambios" no dicen nada. Escribir qué se hizo: "feat: agregar búsqueda con debounce", "fix: corregir paginación en búsqueda".

6. **No manejar errores HTTP.** La app no se puede romper si la API falla. Siempre mostrar un mensaje al usuario.

7. **Hardcodear la API key en el servicio.** Usar `environment.ts`.

---

## Recomendaciones

Empiecen por el servicio HTTP. Hagan un `console.log` de lo que devuelve la API y asegúrense de que entienden la estructura de los datos antes de armar las vistas. Después construyan la tarjeta de película, porque la van a usar en todas las páginas. Configuren el routing temprano para poder ir navegando entre vistas mientras desarrollan. Hagan commits seguido — si algo se rompe, pueden volver atrás.

**Cualquier duda, pregunten antes de la fecha de entrega. No el día anterior.**
