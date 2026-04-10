# 7. Programación reactiva con RxJS

## ¿Qué es un Observable?

Un Observable es un flujo de datos que emite valores a lo largo del tiempo. Es como una Promise, pero puede emitir múltiples valores.

```
Promise:     ──────────────────► valor (uno solo)
Observable:  ──valor──valor──valor──valor──► (múltiples)
```

Angular usa Observables en:
- HttpClient (cada petición retorna un Observable).
- Formularios reactivos (cambios en inputs).
- Router (cambios de parámetros).
- Eventos del DOM.

---

## Observable vs. Promise

| Característica | Promise | Observable |
|---|---|---|
| Valores | Uno solo | Múltiples |
| Ejecución | Inmediata | Lazy (solo al suscribirse) |
| Cancelación | No se puede | `unsubscribe()` |
| Operadores | `.then()`, `.catch()` | `pipe()` con operadores RxJS |

```typescript
// Promise (fetch)
const datos = await fetch('/api/datos');
const json = await datos.json();

// Observable (HttpClient)
this.http.get<Datos>('/api/datos').subscribe(datos => {
    console.log(datos);
});
```

---

## Suscribirse a un Observable

```typescript
// Forma básica
this.tmdbService.obtenerPopulares().subscribe(data => {
    this.peliculas = data.results;
});

// Forma completa con manejo de errores
this.tmdbService.obtenerPopulares().subscribe({
    next: (data) => {
        this.peliculas = data.results;
    },
    error: (err) => {
        console.error('Error:', err);
    },
    complete: () => {
        console.log('Petición completada');
    }
});
```

---

## Operadores esenciales

Los operadores transforman los datos que emite un Observable. Se aplican con `pipe()`.

### map — Transformar datos

```typescript
import { map } from 'rxjs';

// Obtener solo los títulos de las películas
obtenerTitulos(): Observable<string[]> {
    return this.http.get<MovieResponse>(`${this.apiUrl}/movie/popular`, {
        params: { api_key: this.apiKey }
    }).pipe(
        map(response => response.results.map(movie => movie.title))
    );
}
```

### filter — Filtrar emisiones

```typescript
import { filter } from 'rxjs';

// Solo emitir si hay resultados
buscar(query: string): Observable<MovieResponse> {
    return this.http.get<MovieResponse>(`${this.apiUrl}/search/movie`, {
        params: { api_key: this.apiKey, query }
    }).pipe(
        filter(response => response.results.length > 0)
    );
}
```

### tap — Efecto secundario (sin modificar datos)

```typescript
import { tap } from 'rxjs';

obtenerPopulares(): Observable<MovieResponse> {
    return this.http.get<MovieResponse>(`${this.apiUrl}/movie/popular`, {
        params: { api_key: this.apiKey }
    }).pipe(
        tap(response => console.log('Películas recibidas:', response.results.length)),
        tap(() => this.cargando = false)
    );
}
```

### switchMap — Encadenar Observables (cancela el anterior)

Fundamental para búsquedas. Si el usuario escribe rápido, cancela la petición anterior y solo ejecuta la última.

```typescript
import { switchMap } from 'rxjs';

// Cuando cambia el parámetro de ruta, cargar nueva película
ngOnInit(): void {
    this.route.params.pipe(
        switchMap(params => this.tmdbService.obtenerDetalle(+params['id']))
    ).subscribe(pelicula => {
        this.pelicula = pelicula;
    });
}
```

### mergeMap — Encadenar Observables (ejecuta todos en paralelo)

```typescript
import { mergeMap } from 'rxjs';

// Obtener detalle y créditos de una película
obtenerPeliculaCompleta(id: number): Observable<{ detalle: MovieDetail; creditos: Credits }> {
    return this.obtenerDetalle(id).pipe(
        mergeMap(detalle =>
            this.obtenerCreditos(id).pipe(
                map(creditos => ({ detalle, creditos }))
            )
        )
    );
}
```

---

## debounceTime y distinctUntilChanged para búsquedas

Este es el patrón más importante para implementar un buscador eficiente.

```typescript
import { Component, OnInit, inject } from '@angular/core';
import { FormControl, ReactiveFormsModule } from '@angular/forms';
import { debounceTime, distinctUntilChanged, switchMap, filter } from 'rxjs';

@Component({
    selector: 'app-search',
    standalone: true,
    imports: [ReactiveFormsModule],
    template: `
        <input [formControl]="searchControl"
               class="form-control"
               placeholder="Buscar películas...">
    `
})
export class SearchComponent implements OnInit {
    searchControl = new FormControl('');
    resultados: Movie[] = [];

    private tmdbService = inject(TmdbService);

    ngOnInit(): void {
        this.searchControl.valueChanges.pipe(
            debounceTime(300),           // Espera 300ms después del último tecleo
            distinctUntilChanged(),       // Solo emite si el valor cambió
            filter(term => !!term && term.length >= 2),  // Mínimo 2 caracteres
            switchMap(term => this.tmdbService.buscar(term!))  // Cancela petición anterior
        ).subscribe(response => {
            this.resultados = response.results;
        });
    }
}
```

### ¿Qué hace cada operador?

```
Usuario escribe: "b" → "ba" → "bat" → "batm" → "batman"
                  ↓
debounceTime(300): espera 300ms sin teclear → emite "batman"
                  ↓
distinctUntilChanged(): ¿es diferente al anterior? → sí → emite
                  ↓
filter(>=2): ¿tiene 2+ caracteres? → sí → emite
                  ↓
switchMap(): cancela petición anterior → hace GET /search?q=batman
                  ↓
subscribe(): recibe resultados
```

---

## Subject y BehaviorSubject

Los Subjects son Observables que también pueden emitir valores manualmente. Útiles para comunicación entre componentes a través de servicios.

### Subject

```typescript
import { Subject } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class NotificacionService {
    private notificacion$ = new Subject<string>();

    // Observable público (los componentes se suscriben)
    obtenerNotificaciones(): Observable<string> {
        return this.notificacion$.asObservable();
    }

    // Emitir notificación
    notificar(mensaje: string): void {
        this.notificacion$.next(mensaje);
    }
}
```

### BehaviorSubject

Igual que Subject pero tiene un valor inicial y emite el último valor a nuevos suscriptores.

```typescript
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class FavoritesService {
    private favoritasSubject = new BehaviorSubject<Movie[]>(this.cargarDeStorage());

    // Observable público
    favoritas$: Observable<Movie[]> = this.favoritasSubject.asObservable();

    agregar(movie: Movie): void {
        const actuales = this.favoritasSubject.value;
        if (!actuales.find(m => m.id === movie.id)) {
            const nuevas = [...actuales, movie];
            this.favoritasSubject.next(nuevas);
            this.guardarEnStorage(nuevas);
        }
    }

    eliminar(id: number): void {
        const nuevas = this.favoritasSubject.value.filter(m => m.id !== id);
        this.favoritasSubject.next(nuevas);
        this.guardarEnStorage(nuevas);
    }

    obtenerCantidad(): Observable<number> {
        return this.favoritas$.pipe(map(favs => favs.length));
    }

    private cargarDeStorage(): Movie[] {
        try {
            return JSON.parse(localStorage.getItem('favoritas') || '[]');
        } catch {
            return [];
        }
    }

    private guardarEnStorage(movies: Movie[]): void {
        localStorage.setItem('favoritas', JSON.stringify(movies));
    }
}
```

---

## Suscripciones y cómo evitar memory leaks

Cada `subscribe()` crea una suscripción activa. Si no se limpia, causa memory leaks.

### Opción 1: async pipe (recomendado)

El `async` pipe se suscribe y desuscribe automáticamente.

```typescript
export class HomeComponent {
    peliculas$ = this.tmdbService.obtenerPopulares().pipe(
        map(response => response.results)
    );

    constructor(private tmdbService: TmdbService) {}
}
```

```html
@if (peliculas$ | async; as peliculas) {
    @for (pelicula of peliculas; track pelicula.id) {
        <app-movie-card [movie]="pelicula" />
    }
} @else {
    <div class="spinner-border"></div>
}
```

### Opción 2: takeUntilDestroyed()

```typescript
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

export class HomeComponent {
    peliculas: Movie[] = [];

    constructor(private tmdbService: TmdbService) {
        this.tmdbService.obtenerPopulares().pipe(
            takeUntilDestroyed()  // Se desuscribe cuando el componente se destruye
        ).subscribe(data => {
            this.peliculas = data.results;
        });
    }
}
```

### Opción 3: DestroyRef (manual)

```typescript
import { DestroyRef, inject } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

export class HomeComponent implements OnInit {
    private destroyRef = inject(DestroyRef);

    ngOnInit(): void {
        this.tmdbService.obtenerPopulares().pipe(
            takeUntilDestroyed(this.destroyRef)
        ).subscribe(data => {
            this.peliculas = data.results;
        });
    }
}
```

**Nota:** Las peticiones HTTP de `HttpClient` se completan automáticamente después de emitir un valor, así que técnicamente no necesitan limpieza. Pero es buena práctica hacerlo siempre.

---

## Ejercicios

### Ejercicio 1: Buscador con debounce
Implementar un buscador de pokémon que use `debounceTime`, `distinctUntilChanged` y `switchMap`. Mostrar resultados en tiempo real.

### Ejercicio 2: BehaviorSubject para carrito
Crear un `CartService` con BehaviorSubject que emita la lista de items. El navbar muestra la cantidad total usando `async` pipe. La página del carrito muestra el detalle.

### Ejercicio 3: Encadenar peticiones
Usar `switchMap` para: primero obtener la lista de películas populares, luego obtener el detalle de la primera película de la lista.

### Ejercicio 4: Limpiar suscripciones
Refactorizar un componente que tenga múltiples `subscribe()` para usar `async` pipe o `takeUntilDestroyed()`.
