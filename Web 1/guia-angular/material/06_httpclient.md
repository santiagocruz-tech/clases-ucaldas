# 6. Consumo de APIs con HttpClient

## Configurar HttpClient

HttpClient es el módulo de Angular para hacer peticiones HTTP. Reemplaza a `fetch()`.

### Paso 1: Proveer HttpClient en la configuración

```typescript
// app.config.ts
import { ApplicationConfig } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
    providers: [
        provideRouter(routes),
        provideHttpClient()   // Habilita HttpClient en toda la app
    ]
};
```

### Paso 2: Inyectar en un servicio

```typescript
import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class TmdbService {
    private http = inject(HttpClient);
    private apiUrl = 'https://api.themoviedb.org/3';
    private apiKey = 'TU_API_KEY';
}
```

---

## GET, POST, PUT, DELETE

### GET — Obtener datos

```typescript
// Obtener películas populares
obtenerPopulares(page: number = 1): Observable<MovieResponse> {
    return this.http.get<MovieResponse>(
        `${this.apiUrl}/movie/popular`,
        {
            params: {
                api_key: this.apiKey,
                language: 'es-ES',
                page: page.toString()
            }
        }
    );
}

// Obtener detalle de una película
obtenerDetalle(id: number): Observable<MovieDetail> {
    return this.http.get<MovieDetail>(
        `${this.apiUrl}/movie/${id}`,
        {
            params: {
                api_key: this.apiKey,
                language: 'es-ES'
            }
        }
    );
}

// Buscar películas
buscar(query: string, page: number = 1): Observable<MovieResponse> {
    return this.http.get<MovieResponse>(
        `${this.apiUrl}/search/movie`,
        {
            params: {
                api_key: this.apiKey,
                query: query,
                language: 'es-ES',
                page: page.toString()
            }
        }
    );
}
```

### POST — Enviar datos

```typescript
// Ejemplo con una API que acepta POST
crearRecurso(data: any): Observable<any> {
    return this.http.post<any>(
        `${this.apiUrl}/recurso`,
        data,  // Body de la petición
        {
            headers: {
                'Content-Type': 'application/json'
            }
        }
    );
}
```

### PUT — Actualizar datos

```typescript
actualizarRecurso(id: number, data: any): Observable<any> {
    return this.http.put<any>(`${this.apiUrl}/recurso/${id}`, data);
}
```

### DELETE — Eliminar datos

```typescript
eliminarRecurso(id: number): Observable<any> {
    return this.http.delete<any>(`${this.apiUrl}/recurso/${id}`);
}
```

---

## Tipar las respuestas con interfaces

Siempre tipar las respuestas. Nunca usar `any`.

```typescript
// models/movie.ts
export interface Movie {
    id: number;
    title: string;
    overview: string;
    poster_path: string;
    backdrop_path: string;
    vote_average: number;
    release_date: string;
    genre_ids: number[];
}

export interface MovieResponse {
    page: number;
    results: Movie[];
    total_pages: number;
    total_results: number;
}

export interface MovieDetail extends Movie {
    runtime: number;
    genres: Genre[];
    original_language: string;
    budget: number;
    revenue: number;
}

export interface Genre {
    id: number;
    name: string;
}

export interface Credits {
    cast: CastMember[];
    crew: CrewMember[];
}

export interface CastMember {
    id: number;
    name: string;
    character: string;
    profile_path: string | null;
}

export interface CrewMember {
    id: number;
    name: string;
    job: string;
}
```

### Usar las interfaces en el servicio

```typescript
obtenerPopulares(): Observable<MovieResponse> {
    return this.http.get<MovieResponse>(`${this.apiUrl}/movie/popular`, {
        params: { api_key: this.apiKey, language: 'es-ES' }
    });
}

obtenerCreditos(id: number): Observable<Credits> {
    return this.http.get<Credits>(`${this.apiUrl}/movie/${id}/credits`, {
        params: { api_key: this.apiKey }
    });
}
```

---

## Manejo de errores con catchError

```typescript
import { Observable, catchError, throwError } from 'rxjs';

obtenerPopulares(): Observable<MovieResponse> {
    return this.http.get<MovieResponse>(
        `${this.apiUrl}/movie/popular`,
        { params: { api_key: this.apiKey, language: 'es-ES' } }
    ).pipe(
        catchError(error => {
            console.error('Error al obtener películas:', error);

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

### Manejar el error en el componente

```typescript
export class HomeComponent implements OnInit {
    peliculas: Movie[] = [];
    cargando: boolean = true;
    error: string = '';

    constructor(private tmdbService: TmdbService) {}

    ngOnInit(): void {
        this.tmdbService.obtenerPopulares().subscribe({
            next: (data) => {
                this.peliculas = data.results;
                this.cargando = false;
            },
            error: (err) => {
                this.error = err.message;
                this.cargando = false;
            }
        });
    }
}
```

```html
@if (cargando) {
    <div class="text-center">
        <div class="spinner-border"></div>
    </div>
} @else if (error) {
    <div class="alert alert-danger">{{ error }}</div>
} @else {
    @for (pelicula of peliculas; track pelicula.id) {
        <app-movie-card [movie]="pelicula" />
    }
}
```

---

## Interceptores

Los interceptores modifican todas las peticiones HTTP antes de enviarlas o después de recibir la respuesta. Caso típico: agregar el token de autenticación.

### Interceptor funcional (Angular 15+)

```typescript
// interceptors/auth.interceptor.ts
import { HttpInterceptorFn } from '@angular/common/http';
import { environment } from '../../environments/environment';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
    // Solo agregar token a peticiones a TMDB
    if (req.url.includes('api.themoviedb.org')) {
        const clonedReq = req.clone({
            setHeaders: {
                Authorization: `Bearer ${environment.tmdbApiKey}`
            }
        });
        return next(clonedReq);
    }

    return next(req);
};
```

### Registrar el interceptor

```typescript
// app.config.ts
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { authInterceptor } from './interceptors/auth.interceptor';

export const appConfig: ApplicationConfig = {
    providers: [
        provideRouter(routes),
        provideHttpClient(withInterceptors([authInterceptor]))
    ]
};
```

Con el interceptor, ya no necesitás pasar `api_key` en cada petición del servicio.

---

## Comparación: fetch nativo vs. HttpClient

| Característica | fetch (JS nativo) | HttpClient (Angular) |
|---|---|---|
| Retorna | Promise | Observable |
| Tipado | Manual | Genéricos `get<T>()` |
| Interceptores | No tiene | Sí, built-in |
| Cancelación | AbortController | `unsubscribe()` automático |
| Params | Manual en URL | Objeto `params` |
| Testing | Más difícil | TestBed + HttpTestingController |

---

## Ejercicios

### Ejercicio 1: Servicio completo para PokeAPI
Crear un `PokemonService` con métodos:
- `obtenerLista(limit, offset): Observable<PokemonListResponse>`
- `obtenerDetalle(id): Observable<Pokemon>`
Tipar todas las respuestas con interfaces.

### Ejercicio 2: Manejo de errores
Agregar `catchError` al servicio del ejercicio 1. En el componente, mostrar un spinner mientras carga, un mensaje de error si falla, y los datos si todo sale bien.

### Ejercicio 3: Interceptor
Crear un interceptor de logging que imprima en consola la URL y el tiempo de cada petición HTTP.

### Ejercicio 4: CRUD completo
Usando JSONPlaceholder (`https://jsonplaceholder.typicode.com`), crear un servicio con GET, POST, PUT y DELETE para `/posts`. Crear un componente que liste posts y permita crear/editar/eliminar.
