# Capítulo 6: Consumo de APIs con HttpClient

## Objetivo

Conectar CineExplorer con la API real de TMDB usando HttpClient. Al final de este capítulo, la app mostrará películas reales con datos de internet.

---

## 6.1 Configurar HttpClient

HttpClient es el módulo de Angular para hacer peticiones HTTP. Reemplaza a `fetch()`.

### Paso 1: Proveer HttpClient en la configuración

✏️ Modificar `src/app/app.config.ts`:

```typescript
// app.config.ts
// Configuración global de la aplicación
import { ApplicationConfig } from '@angular/core';
import { provideRouter } from '@angular/router';
// provideHttpClient habilita HttpClient en toda la app
import { provideHttpClient } from '@angular/common/http';
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [
    // Habilitar el sistema de rutas
    provideRouter(routes),
    // Habilitar HttpClient para hacer peticiones HTTP
    provideHttpClient()
  ]
};
```

### Paso 2: Obtener API key de TMDB

1. Crear cuenta en [https://www.themoviedb.org/signup](https://www.themoviedb.org/signup)
2. Ir a Settings → API y solicitar una key (seleccionar "Developer")
3. Copiar la API key (v3 auth)

---

## 6.2 Crear el servicio TmdbService

✏️ Modificar `src/app/services/tmdb.service.ts`:

```typescript
// tmdb.service.ts
// Servicio que consume la API de TMDB para obtener datos de películas
import { Injectable, inject } from '@angular/core';
// HttpClient es el cliente HTTP de Angular
import { HttpClient } from '@angular/common/http';
// Observable es el tipo de retorno de las peticiones HTTP en Angular
import { Observable } from 'rxjs';
// Importar las interfaces que creamos en el capítulo 1
import { Movie, MovieResponse, MovieDetail, Credits, Genre } from '../models/movie';

@Injectable({ providedIn: 'root' })
export class TmdbService {
  // Inyectar HttpClient
  private http = inject(HttpClient);

  // URL base de la API de TMDB
  private apiUrl = 'https://api.themoviedb.org/3';
  // API key (después la moveremos a environment.ts en el capítulo 12)
  private apiKey = 'TU_API_KEY_AQUI';  // ← Reemplazar con tu key real

  // Obtener películas populares
  // Retorna un Observable<MovieResponse> — se suscribe desde el componente
  obtenerPopulares(page: number = 1): Observable<MovieResponse> {
    // http.get<T> hace una petición GET y tipa la respuesta como T
    // params: objeto con los query parameters (?api_key=...&language=...)
    return this.http.get<MovieResponse>(
      `${this.apiUrl}/movie/popular`,
      {
        params: {
          api_key: this.apiKey,
          language: 'es-ES',        // respuestas en español
          page: page.toString()     // número de página (paginación)
        }
      }
    );
  }

  // Obtener películas mejor valoradas
  obtenerTopRated(page: number = 1): Observable<MovieResponse> {
    return this.http.get<MovieResponse>(
      `${this.apiUrl}/movie/top_rated`,
      {
        params: { api_key: this.apiKey, language: 'es-ES', page: page.toString() }
      }
    );
  }

  // Obtener detalle completo de una película por su ID
  obtenerDetalle(id: number): Observable<MovieDetail> {
    return this.http.get<MovieDetail>(
      `${this.apiUrl}/movie/${id}`,
      {
        params: { api_key: this.apiKey, language: 'es-ES' }
      }
    );
  }

  // Buscar películas por texto
  buscar(query: string, page: number = 1): Observable<MovieResponse> {
    return this.http.get<MovieResponse>(
      `${this.apiUrl}/search/movie`,
      {
        params: {
          api_key: this.apiKey,
          query: query,             // texto de búsqueda
          language: 'es-ES',
          page: page.toString()
        }
      }
    );
  }

  // Obtener créditos (reparto) de una película
  obtenerCreditos(id: number): Observable<Credits> {
    return this.http.get<Credits>(
      `${this.apiUrl}/movie/${id}/credits`,
      {
        params: { api_key: this.apiKey }
      }
    );
  }

  // Obtener lista de géneros
  obtenerGeneros(): Observable<{ genres: Genre[] }> {
    return this.http.get<{ genres: Genre[] }>(
      `${this.apiUrl}/genre/movie/list`,
      {
        params: { api_key: this.apiKey, language: 'es-ES' }
      }
    );
  }
}
```

---

## 6.3 Usar el servicio en Home

✏️ Modificar `home.ts`:

```typescript
// home.ts
// Página principal que carga películas reales de la API
import { Component, OnInit, inject } from '@angular/core';
import { MovieCard } from '../../components/movie-card/movie-card';
import { TmdbService } from '../../services/tmdb.service';
import { FavoritesService } from '../../services/favorites.service';
import { Movie } from '../../models/movie';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [MovieCard],
  templateUrl: './home.html'
})
export class Home implements OnInit {
  // Inyectar los servicios
  private tmdbService = inject(TmdbService);
  private favoritesService = inject(FavoritesService);

  // Estado del componente
  peliculas: Movie[] = [];     // lista de películas cargadas
  cargando: boolean = true;    // indicador de carga
  error: string = '';          // mensaje de error (vacío = sin error)

  // ngOnInit se ejecuta al crear el componente — ideal para cargar datos
  ngOnInit(): void {
    this.cargarPeliculas();
  }

  // Cargar películas populares de la API
  cargarPeliculas(): void {
    this.cargando = true;   // mostrar spinner
    this.error = '';        // limpiar error anterior

    // subscribe() se suscribe al Observable que retorna el servicio
    // next: se ejecuta cuando llegan los datos
    // error: se ejecuta si la petición falla
    this.tmdbService.obtenerPopulares().subscribe({
      next: (response) => {
        // response es de tipo MovieResponse (tipado automático)
        this.peliculas = response.results;
        this.cargando = false;
      },
      error: (err) => {
        console.error('Error al cargar películas:', err);
        this.error = 'No se pudieron cargar las películas. Verifica tu conexión.';
        this.cargando = false;
      }
    });
  }

  esFavorita(id: number): boolean {
    return this.favoritesService.esFavorita(id);
  }

  toggleFavorito(movie: Movie): void {
    this.favoritesService.toggle(movie);
  }
}
```

✏️ Modificar `home.html`:

```html
<!-- home.html -->
<!-- Manejo de 3 estados: cargando, error, datos -->
<h2 class="mb-4">🔥 Películas populares</h2>

<!-- Estado: cargando -->
@if (cargando) {
  <div class="text-center py-5">
    <!-- Spinner de Bootstrap -->
    <div class="spinner-border text-primary" role="status">
      <span class="visually-hidden">Cargando...</span>
    </div>
    <p class="text-muted mt-2">Cargando películas...</p>
  </div>
}

<!-- Estado: error -->
@if (error) {
  <div class="alert alert-danger" role="alert">
    <!-- alert-danger: alerta roja de Bootstrap -->
    {{ error }}
    <button class="btn btn-outline-danger btn-sm ms-2" (click)="cargarPeliculas()">
      Reintentar
    </button>
  </div>
}

<!-- Estado: datos cargados -->
@if (!cargando && !error) {
  <div class="row g-4">
    @for (movie of peliculas; track movie.id) {
      <div class="col-sm-6 col-md-4 col-lg-3">
        <app-movie-card
          [movie]="movie"
          [esFavorita]="esFavorita(movie.id)"
          (toggleFavorito)="toggleFavorito($event)" />
      </div>
    } @empty {
      <p class="text-muted">No se encontraron películas</p>
    }
  </div>
}
```

---

## 6.4 Completar MovieDetail

En el capítulo 05 creamos un esqueleto. Ahora que tenemos HttpClient, lo completamos con datos reales.

✏️ Modificar `movie-detail.ts`:

```typescript
// movie-detail.ts
// Página de detalle que carga datos reales de la API
import { Component, OnInit, inject } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { TmdbService } from '../../services/tmdb.service';
import { FavoritesService } from '../../services/favorites.service';
import { MovieDetail, Credits } from '../../models/movie';

@Component({
  selector: 'app-movie-detail',
  standalone: true,
  imports: [RouterLink],
  templateUrl: './movie-detail.html'
})
export class MovieDetail implements OnInit {
  private route = inject(ActivatedRoute);
  private tmdbService = inject(TmdbService);
  private favoritesService = inject(FavoritesService);

  // Estado del componente
  pelicula: MovieDetail | null = null;  // null mientras carga
  creditos: Credits | null = null;
  cargando: boolean = true;
  error: string = '';

  ngOnInit(): void {
    // Leer el parámetro :id de la URL
    const id = +this.route.snapshot.params['id'];
    this.cargarPelicula(id);
    this.cargarCreditos(id);
  }

  // Cargar detalle de la película
  cargarPelicula(id: number): void {
    this.tmdbService.obtenerDetalle(id).subscribe({
      next: (data) => {
        this.pelicula = data;
        this.cargando = false;
      },
      error: () => {
        this.error = 'No se pudo cargar la película';
        this.cargando = false;
      }
    });
  }

  // Cargar créditos (reparto)
  cargarCreditos(id: number): void {
    this.tmdbService.obtenerCreditos(id).subscribe({
      next: (data) => this.creditos = data
    });
  }

  // Verificar si es favorita
  get esFavorita(): boolean {
    return this.pelicula ? this.favoritesService.esFavorita(this.pelicula.id) : false;
  }

  // Alternar favorito
  toggleFavorito(): void {
    if (this.pelicula) {
      this.favoritesService.toggle(this.pelicula);
    }
  }
}
```

✏️ Modificar `movie-detail.html`:

```html
<!-- movie-detail.html -->
<!-- Página de detalle con datos reales de la API -->

<!-- Estado: cargando -->
@if (cargando) {
  <div class="text-center py-5">
    <div class="spinner-border text-primary"></div>
  </div>
}

<!-- Estado: error -->
@if (error) {
  <div class="alert alert-danger">{{ error }}</div>
  <a routerLink="/" class="btn btn-outline-primary">← Volver al inicio</a>
}

<!-- Estado: datos cargados -->
@if (pelicula && !cargando) {
  <!-- Imagen de fondo -->
  <div class="position-relative mb-4" style="height: 300px; overflow: hidden;">
    <img [src]="'https://image.tmdb.org/t/p/original' + pelicula.backdrop_path"
         [alt]="pelicula.title"
         class="w-100 h-100"
         style="object-fit: cover; filter: brightness(0.5);">
    <!-- Título sobre la imagen -->
    <div class="position-absolute bottom-0 start-0 p-4 text-white">
      <h1>{{ pelicula.title }}</h1>
      @if (pelicula.tagline) {
        <p class="lead fst-italic">{{ pelicula.tagline }}</p>
      }
    </div>
  </div>

  <div class="row">
    <!-- Columna izquierda: póster -->
    <div class="col-md-4 mb-4">
      <img [src]="'https://image.tmdb.org/t/p/w500' + pelicula.poster_path"
           [alt]="pelicula.title"
           class="img-fluid rounded shadow">
      <!-- Botón de favorito -->
      <button class="btn w-100 mt-3"
              [class.btn-danger]="esFavorita"
              [class.btn-outline-danger]="!esFavorita"
              (click)="toggleFavorito()">
        {{ esFavorita ? '❤️ Quitar de favoritos' : '🤍 Agregar a favoritos' }}
      </button>
    </div>

    <!-- Columna derecha: información -->
    <div class="col-md-8">
      <h3>Sinopsis</h3>
      <p>{{ pelicula.overview }}</p>

      <!-- Datos técnicos -->
      <div class="row mb-3">
        <div class="col-6 col-md-3">
          <strong>Puntuación</strong>
          <p>⭐ {{ pelicula.vote_average }} / 10</p>
        </div>
        <div class="col-6 col-md-3">
          <strong>Duración</strong>
          <p>{{ pelicula.runtime }} min</p>
        </div>
        <div class="col-6 col-md-3">
          <strong>Estreno</strong>
          <p>{{ pelicula.release_date }}</p>
        </div>
        <div class="col-6 col-md-3">
          <strong>Idioma</strong>
          <p>{{ pelicula.original_language | uppercase }}</p>
        </div>
      </div>

      <!-- Géneros -->
      <div class="mb-3">
        <strong>Géneros: </strong>
        @for (genre of pelicula.genres; track genre.id) {
          <span class="badge bg-secondary me-1">{{ genre.name }}</span>
        }
      </div>

      <!-- Reparto -->
      @if (creditos && creditos.cast.length > 0) {
        <h4 class="mt-4">Reparto principal</h4>
        <div class="row g-3">
          <!-- Mostrar los primeros 6 actores -->
          @for (actor of creditos.cast.slice(0, 6); track actor.id) {
            <div class="col-4 col-md-2 text-center">
              @if (actor.profile_path) {
                <img [src]="'https://image.tmdb.org/t/p/w200' + actor.profile_path"
                     [alt]="actor.name"
                     class="rounded-circle mb-1"
                     style="width: 80px; height: 80px; object-fit: cover;">
              }
              <small class="d-block">{{ actor.name }}</small>
              <small class="text-muted">{{ actor.character }}</small>
            </div>
          }
        </div>
      }
    </div>
  </div>

  <!-- Botón volver -->
  <a routerLink="/" class="btn btn-outline-primary mt-4">← Volver al inicio</a>
}
```

💡 Necesitan agregar `UpperCasePipe` a los imports del componente para usar `| uppercase`, o importar `CommonModule`.

---

## 6.5 Completar SearchResults

✏️ Modificar `search-results.ts`:

```typescript
// search-results.ts
// Página que muestra resultados de búsqueda leyendo el query param "q"
import { Component, OnInit, inject } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { TmdbService } from '../../services/tmdb.service';
import { FavoritesService } from '../../services/favorites.service';
import { MovieCard } from '../../components/movie-card/movie-card';
import { Movie } from '../../models/movie';

@Component({
  selector: 'app-search-results',
  standalone: true,
  imports: [MovieCard],
  templateUrl: './search-results.html'
})
export class SearchResults implements OnInit {
  private route = inject(ActivatedRoute);
  private tmdbService = inject(TmdbService);
  private favoritesService = inject(FavoritesService);

  resultados: Movie[] = [];
  termino: string = '';
  cargando: boolean = false;

  ngOnInit(): void {
    // queryParams es un Observable que emite cuando los params cambian
    // Así si el usuario busca algo nuevo, se actualiza automáticamente
    this.route.queryParams.subscribe(params => {
      this.termino = params['q'] || '';
      if (this.termino) {
        this.buscar(this.termino);
      }
    });
  }

  buscar(termino: string): void {
    this.cargando = true;
    this.tmdbService.buscar(termino).subscribe({
      next: (response) => {
        this.resultados = response.results;
        this.cargando = false;
      },
      error: () => {
        this.cargando = false;
      }
    });
  }

  esFavorita(id: number): boolean {
    return this.favoritesService.esFavorita(id);
  }

  toggleFavorito(movie: Movie): void {
    this.favoritesService.toggle(movie);
  }
}
```

✏️ `search-results.html`:

```html
<!-- search-results.html -->
<h2 class="mb-4">🔍 Resultados para "{{ termino }}"</h2>

@if (cargando) {
  <div class="text-center py-5">
    <div class="spinner-border text-primary"></div>
  </div>
} @else if (resultados.length === 0 && termino) {
  <div class="text-center py-5">
    <p class="display-1">🎬</p>
    <h4 class="text-muted">No se encontraron resultados para "{{ termino }}"</h4>
  </div>
} @else {
  <div class="row g-4">
    @for (movie of resultados; track movie.id) {
      <div class="col-sm-6 col-md-4 col-lg-3">
        <app-movie-card
          [movie]="movie"
          [esFavorita]="esFavorita(movie.id)"
          (toggleFavorito)="toggleFavorito($event)" />
      </div>
    }
  </div>
}
```

---

## 6.6 Manejo de errores con catchError

Para manejar errores de forma centralizada en el servicio:

```typescript
// Agregar en tmdb.service.ts
import { Observable, catchError, throwError } from 'rxjs';

obtenerPopulares(page: number = 1): Observable<MovieResponse> {
  return this.http.get<MovieResponse>(
    `${this.apiUrl}/movie/popular`,
    { params: { api_key: this.apiKey, language: 'es-ES', page: page.toString() } }
  ).pipe(
    // catchError intercepta errores antes de que lleguen al componente
    catchError(error => {
      console.error('Error HTTP:', error);

      // Retornar un error más descriptivo según el código HTTP
      if (error.status === 0) {
        return throwError(() => new Error('Sin conexión a internet'));
      }
      if (error.status === 401) {
        return throwError(() => new Error('API key inválida'));
      }
      if (error.status === 404) {
        return throwError(() => new Error('Recurso no encontrado'));
      }

      return throwError(() => new Error('Error del servidor'));
    })
  );
}
```

---

## 6.7 Interceptores

Los interceptores modifican TODAS las peticiones HTTP automáticamente. Caso típico: agregar la API key a cada petición.

📁 Crear `src/app/interceptors/api-key.interceptor.ts`:

```typescript
// api-key.interceptor.ts
// Interceptor que agrega la API key a todas las peticiones a TMDB
// Así no hay que pasarla manualmente en cada método del servicio
import { HttpInterceptorFn } from '@angular/common/http';

// HttpInterceptorFn es el tipo para interceptores funcionales (Angular 15+)
export const apiKeyInterceptor: HttpInterceptorFn = (req, next) => {
  // Solo modificar peticiones a TMDB (no a otras APIs)
  if (req.url.includes('api.themoviedb.org')) {
    // clone() crea una copia de la petición (las peticiones son inmutables)
    // setParams agrega parámetros a la URL
    const clonedReq = req.clone({
      setParams: {
        api_key: 'TU_API_KEY_AQUI'  // después mover a environment.ts
      }
    });
    // next() envía la petición modificada al servidor
    return next(clonedReq);
  }

  // Si no es TMDB, enviar la petición sin modificar
  return next(req);
};
```

✏️ Registrar el interceptor en `app.config.ts`:

```typescript
// app.config.ts
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { apiKeyInterceptor } from './interceptors/api-key.interceptor';

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    // withInterceptors registra los interceptores
    provideHttpClient(withInterceptors([apiKeyInterceptor]))
  ]
};
```

💡 Con el interceptor, pueden quitar `api_key` de cada método del `TmdbService`.

---

## 6.8 Comparación: fetch vs. HttpClient

| Característica | fetch (JS nativo) | HttpClient (Angular) |
|---|---|---|
| Retorna | Promise | Observable |
| Tipado | Manual | Genéricos `get<T>()` |
| Interceptores | No tiene | Sí, built-in |
| Cancelación | AbortController | `unsubscribe()` |
| Params | Manual en URL | Objeto `params` |

---

## 6.9 Compilar y probar

▶️ Ejecutar `ng serve`. Deberían ver:
1. Un spinner mientras cargan las películas
2. Películas reales de TMDB con pósters, títulos y puntuaciones
3. Click en "Ver detalle" → página con sinopsis, reparto, géneros y botón de favorito
4. Buscar desde el navbar → página de resultados con películas encontradas
5. Si la API key es incorrecta, un mensaje de error con botón de reintentar

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| `HttpClient` | Hacer peticiones HTTP (GET, POST, PUT, DELETE) |
| `provideHttpClient()` | Habilitar HttpClient en la app |
| `http.get<T>()` | Petición GET tipada |
| `Observable` | Tipo de retorno de peticiones HTTP |
| `.subscribe()` | Suscribirse para recibir los datos |
| `catchError` | Manejar errores en el servicio |
| Interceptores | Modificar todas las peticiones automáticamente |
| Estados de carga | Spinner, error, datos (UX) |

---

**Anterior:** [← Capítulo 5 — Routing](05_routing.md) | **Siguiente:** [Capítulo 7 — RxJS →](07_rxjs.md)
