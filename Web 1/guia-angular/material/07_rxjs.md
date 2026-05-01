# Capítulo 7: Programación reactiva con RxJS

## Objetivo

Entender Observables y operadores RxJS. Al final de este capítulo, CineExplorer tendrá un buscador con debounce en tiempo real y favoritos reactivos con BehaviorSubject.

---

## 7.1 ¿Qué es un Observable?

Un Observable es un flujo de datos que emite valores a lo largo del tiempo. Es como una Promise, pero puede emitir múltiples valores.

```
Promise:     ──────────────────► valor (uno solo)
Observable:  ──valor──valor──valor──valor──► (múltiples)
```

Angular usa Observables en: HttpClient, formularios reactivos, router, eventos del DOM.

---

## 7.2 Observable vs. Promise

| Característica | Promise | Observable |
|---|---|---|
| Valores | Uno solo | Múltiples |
| Ejecución | Inmediata | Lazy (solo al suscribirse) |
| Cancelación | No se puede | `unsubscribe()` |
| Operadores | `.then()`, `.catch()` | `pipe()` con operadores RxJS |

---

## 7.3 Operadores esenciales

Los operadores transforman los datos que emite un Observable. Se aplican con `pipe()`.

### map — Transformar datos

```typescript
import { map } from 'rxjs';

// Obtener solo los títulos de las películas (no el objeto completo)
obtenerTitulos(): Observable<string[]> {
  return this.http.get<MovieResponse>(`${this.apiUrl}/movie/popular`, {
    params: { api_key: this.apiKey }
  }).pipe(
    // map transforma la respuesta: de MovieResponse a string[]
    // response.results es Movie[], .map(m => m.title) extrae solo los títulos
    map(response => response.results.map(movie => movie.title))
  );
}
```

### filter — Filtrar emisiones

```typescript
import { filter } from 'rxjs';

// Solo emitir si hay resultados (ignorar respuestas vacías)
buscar(query: string): Observable<MovieResponse> {
  return this.http.get<MovieResponse>(`${this.apiUrl}/search/movie`, {
    params: { api_key: this.apiKey, query }
  }).pipe(
    // filter solo deja pasar emisiones que cumplan la condición
    filter(response => response.results.length > 0)
  );
}
```

### tap — Efecto secundario sin modificar datos

```typescript
import { tap } from 'rxjs';

// tap ejecuta código sin modificar los datos que pasan por el pipe
obtenerPopulares(): Observable<MovieResponse> {
  return this.http.get<MovieResponse>(`${this.apiUrl}/movie/popular`, {
    params: { api_key: this.apiKey }
  }).pipe(
    // tap es útil para logging, actualizar estado, etc.
    tap(response => console.log('Películas recibidas:', response.results.length))
  );
}
```

### switchMap — Encadenar Observables (cancela el anterior)

```typescript
import { switchMap } from 'rxjs';

// Cuando cambia el parámetro de ruta, cargar nueva película
// switchMap cancela la petición anterior si el parámetro cambia rápido
ngOnInit(): void {
  this.route.params.pipe(
    // switchMap: cuando llega un nuevo params, cancela la petición anterior
    // y ejecuta una nueva con el nuevo ID
    switchMap(params => this.tmdbService.obtenerDetalle(+params['id']))
  ).subscribe(pelicula => {
    this.pelicula = pelicula;
  });
}
```

---

## 7.4 Aplicar al proyecto: Buscador con debounce

Este es el patrón más importante para buscadores eficientes. Evita hacer una petición por cada tecla.

📁 Crear el componente de búsqueda:

```bash
ng g c features/search-results --skip-tests
```

✏️ Agregar un input de búsqueda en `navbar.html`:

```html
<!-- Agregar dentro del navbar, después de los links -->
<form class="d-flex ms-auto" role="search">
  <!-- [formControl] vincula el input a un FormControl reactivo -->
  <input
    [formControl]="searchControl"
    class="form-control me-2"
    type="search"
    placeholder="Buscar películas..."
    aria-label="Buscar">
</form>
```

✏️ Modificar `navbar.ts`:

```typescript
// navbar.ts
// Navbar con buscador reactivo que usa debounce
import { Component, inject } from '@angular/core';
import { RouterLink, RouterLinkActive, Router } from '@angular/router';
// FormControl es un control de formulario reactivo
import { FormControl, ReactiveFormsModule } from '@angular/forms';
// Operadores RxJS para el buscador
import { debounceTime, distinctUntilChanged, filter } from 'rxjs';
import { FavoritesService } from '../../services/favorites.service';

@Component({
  selector: 'app-navbar',
  standalone: true,
  // ReactiveFormsModule es necesario para usar [formControl]
  imports: [RouterLink, RouterLinkActive, ReactiveFormsModule],
  templateUrl: './navbar.html',
  styleUrls: ['./navbar.scss']
})
export class Navbar {
  private favoritesService = inject(FavoritesService);
  private router = inject(Router);

  // FormControl para el input de búsqueda
  // Cada vez que el usuario escribe, emite el nuevo valor como Observable
  searchControl = new FormControl('');

  get cantidadFavoritas(): number {
    return this.favoritesService.obtenerCantidad();
  }

  constructor() {
    // valueChanges es un Observable que emite cada vez que el input cambia
    this.searchControl.valueChanges.pipe(
      // debounceTime(300): espera 300ms después del último tecleo
      // Si el usuario sigue escribiendo, reinicia el timer
      debounceTime(300),
      // distinctUntilChanged: solo emite si el valor es diferente al anterior
      // Evita peticiones duplicadas si el usuario borra y reescribe lo mismo
      distinctUntilChanged(),
      // filter: solo emite si el texto tiene 2+ caracteres
      // Evita buscar con textos muy cortos
      filter(term => !!term && term.length >= 2)
    ).subscribe(term => {
      // Navegar a la página de resultados con el término como query param
      this.router.navigate(['/search'], { queryParams: { q: term } });
    });
  }
}
```

💡 **¿Qué hace cada operador?**
```
Usuario escribe: "b" → "ba" → "bat" → "batm" → "batman"
                  ↓
debounceTime(300): espera 300ms sin teclear → emite "batman"
                  ↓
distinctUntilChanged(): ¿es diferente al anterior? → sí → emite
                  ↓
filter(>=2): ¿tiene 2+ caracteres? → sí → emite
                  ↓
subscribe(): navega a /search?q=batman
```

---

## 7.5 Subject y BehaviorSubject

Los Subjects son Observables que también pueden emitir valores manualmente. Útiles para comunicación reactiva entre componentes a través de servicios.

### BehaviorSubject: tiene valor inicial y emite el último valor a nuevos suscriptores

💡 **Refactorización:** En el capítulo 04 creamos `FavoritesService` con un array simple. Ahora lo vamos a mejorar con `BehaviorSubject` para que sea reactivo: cuando cambian los favoritos, todos los componentes suscritos se actualizan automáticamente (por ejemplo, el badge del navbar). La API pública del servicio (`esFavorita()`, `toggle()`, `obtenerTodas()`, `obtenerCantidad()`) se mantiene igual, así que los componentes que ya lo usan no necesitan cambios.

✏️ Mejorar `FavoritesService` con BehaviorSubject:

```typescript
// favorites.service.ts
// Servicio reactivo de favoritos con BehaviorSubject
import { Injectable } from '@angular/core';
// BehaviorSubject: Observable que tiene un valor actual y emite a nuevos suscriptores
import { BehaviorSubject, Observable } from 'rxjs';
import { map } from 'rxjs';
import { Movie } from '../models/movie';

@Injectable({ providedIn: 'root' })
export class FavoritesService {
  // BehaviorSubject<Movie[]> con valor inicial: array vacío
  // Es privado: solo el servicio puede emitir nuevos valores
  private favoritasSubject = new BehaviorSubject<Movie[]>([]);

  // Observable público: los componentes se suscriben a este
  // asObservable() convierte el Subject en un Observable de solo lectura
  favoritas$: Observable<Movie[]> = this.favoritasSubject.asObservable();

  // Observable derivado: cantidad de favoritas
  // pipe(map(...)) transforma el array en su longitud
  cantidad$: Observable<number> = this.favoritas$.pipe(
    map(favs => favs.length)
  );

  agregar(movie: Movie): void {
    // .value obtiene el valor actual del BehaviorSubject
    const actuales = this.favoritasSubject.value;
    if (!actuales.find(m => m.id === movie.id)) {
      // .next() emite un nuevo valor a todos los suscriptores
      // Spread operator [...] crea un nuevo array (inmutabilidad)
      this.favoritasSubject.next([...actuales, movie]);
    }
  }

  eliminar(id: number): void {
    const nuevas = this.favoritasSubject.value.filter(m => m.id !== id);
    this.favoritasSubject.next(nuevas);
  }

  esFavorita(id: number): boolean {
    return this.favoritasSubject.value.some(m => m.id === id);
  }

  toggle(movie: Movie): void {
    if (this.esFavorita(movie.id)) {
      this.eliminar(movie.id);
    } else {
      this.agregar(movie);
    }
  }

  obtenerTodas(): Movie[] {
    return this.favoritasSubject.value;
  }

  obtenerCantidad(): number {
    return this.favoritasSubject.value.length;
  }
}
```

---

## 7.6 Evitar memory leaks

Cada `subscribe()` crea una suscripción activa. Si no se limpia, causa memory leaks.

### Opción 1: async pipe (recomendado)

El `async` pipe se suscribe y desuscribe automáticamente:

```typescript
// En el componente: exponer el Observable directamente
export class Home {
  // No llamamos subscribe(), exponemos el Observable
  peliculas$ = this.tmdbService.obtenerPopulares().pipe(
    map(response => response.results)
  );

  constructor(private tmdbService: TmdbService) {}
}
```

```html
<!-- En el template: async pipe se suscribe automáticamente -->
<!-- "as peliculas" guarda el valor en una variable local del template -->
@if (peliculas$ | async; as peliculas) {
  @for (pelicula of peliculas; track pelicula.id) {
    <app-movie-card [movie]="pelicula" />
  }
} @else {
  <!-- Mientras no hay datos, mostrar spinner -->
  <div class="spinner-border"></div>
}
```

### Opción 2: takeUntilDestroyed()

```typescript
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

export class Home {
  peliculas: Movie[] = [];

  constructor(private tmdbService: TmdbService) {
    this.tmdbService.obtenerPopulares().pipe(
      // takeUntilDestroyed: se desuscribe cuando el componente se destruye
      // DEBE llamarse en el constructor (no en ngOnInit)
      takeUntilDestroyed()
    ).subscribe(data => {
      this.peliculas = data.results;
    });
  }
}
```

💡 Las peticiones HTTP de `HttpClient` se completan automáticamente después de emitir un valor, así que técnicamente no necesitan limpieza. Pero es buena práctica hacerlo siempre.

---

## 7.7 Compilar y probar

▶️ Ejecutar `ng serve`. Deberían poder:
1. Escribir en el buscador del navbar
2. Después de 300ms sin teclear, navegar automáticamente a `/search?q=...`
3. Marcar favoritas y ver el badge actualizarse en el navbar

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| Observable | Flujo de datos que emite valores en el tiempo |
| `pipe()` | Encadenar operadores sobre un Observable |
| `map` | Transformar los datos emitidos |
| `filter` | Filtrar emisiones según condición |
| `tap` | Efecto secundario sin modificar datos |
| `switchMap` | Encadenar Observables (cancela el anterior) |
| `debounceTime` | Esperar X ms después del último evento |
| `distinctUntilChanged` | Solo emitir si el valor cambió |
| `BehaviorSubject` | Observable con valor actual, emite a nuevos suscriptores |
| `async` pipe | Suscripción automática en el template |
| `takeUntilDestroyed` | Limpieza automática al destruir componente |

---

**Anterior:** [← Capítulo 6 — HttpClient](06_httpclient.md) | **Siguiente:** [Capítulo 8 — Formularios →](08_formularios.md)
