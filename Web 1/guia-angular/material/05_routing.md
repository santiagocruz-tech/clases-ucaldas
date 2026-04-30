# Capítulo 5: Routing y navegación

## Objetivo

Configurar la navegación de CineExplorer para que tenga múltiples páginas sin recargar el navegador (SPA). Al final de este capítulo tendremos: navbar, página Home, página de detalle de película y página de favoritos.

---

## 5.1 ¿Cómo funciona el routing en Angular?

Angular usa un sistema de rutas para navegar entre vistas sin recargar la página. Cada ruta mapea una URL a un componente.

```
/                → HomeComponent
/movie/550       → MovieDetailComponent (con parámetro id=550)
/search?q=batman → SearchResultsComponent (con query param)
/favorites       → FavoritesComponent
```

---

## 5.2 Configurar rutas

✏️ Modificar `src/app/app.routes.ts`:

```typescript
// app.routes.ts
// Definición de todas las rutas de la aplicación
import { Routes } from '@angular/router';

// Importar los componentes de cada página
import { HomeComponent } from './features/home/home.component';

// Routes es un array de objetos que mapean URLs a componentes
export const routes: Routes = [
  // Ruta raíz: muestra HomeComponent cuando la URL es "/"
  { path: '', component: HomeComponent },

  // Ruta con parámetro dinámico: :id se reemplaza por el ID real
  // /movie/550 → MovieDetailComponent con params['id'] = '550'
  {
    path: 'movie/:id',
    // loadComponent: lazy loading — solo carga el código cuando se visita la ruta
    // Mejora el tiempo de carga inicial de la app
    loadComponent: () =>
      import('./features/movie-detail/movie-detail.component')
        .then(m => m.MovieDetailComponent)
  },

  // Ruta de búsqueda (usa query params: /search?q=batman)
  {
    path: 'search',
    loadComponent: () =>
      import('./features/search-results/search-results.component')
        .then(m => m.SearchResultsComponent)
  },

  // Ruta de favoritos
  {
    path: 'favorites',
    loadComponent: () =>
      import('./features/favorites/favorites.component')
        .then(m => m.FavoritesComponent)
  },

  // Ruta wildcard: cualquier URL no definida redirige al inicio
  // DEBE ir al final del array (Angular evalúa en orden)
  { path: '**', redirectTo: '' }
];
```

---

## 5.3 RouterOutlet y RouterLink

### RouterOutlet: dónde se renderizan las páginas

💡 **Cambio importante:** hasta ahora, `AppComponent` mostraba las películas directamente. A partir de este capítulo, `AppComponent` se convierte en un "contenedor" que solo tiene el navbar y el `<router-outlet>`. La lógica de mostrar películas se mueve a `HomeComponent` (una página dentro del router).

✏️ Modificar `app.component.html`:

```html
<!-- app.component.html -->
<!-- Layout principal de la app -->

<!-- Navbar (siempre visible) -->
<app-navbar />

<!-- RouterOutlet: aquí Angular renderiza el componente de la ruta actual -->
<!-- Cuando la URL cambia, Angular reemplaza el contenido dentro de router-outlet -->
<main class="container py-4">
  <router-outlet />
</main>
```

✏️ Modificar `app.component.ts`:

```typescript
// app.component.ts
// Componente raíz: contiene el navbar y el router-outlet
import { Component } from '@angular/core';
// RouterOutlet es necesario para que <router-outlet> funcione
import { RouterOutlet } from '@angular/router';
// Importar el navbar
import { NavbarComponent } from './components/navbar/navbar.component';

@Component({
  selector: 'app-root',
  standalone: true,
  // Importar RouterOutlet y NavbarComponent
  imports: [RouterOutlet, NavbarComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {}
```

### Crear el Navbar

```bash
ng g c components/navbar --skip-tests
```

✏️ `navbar.component.ts`:

```typescript
// navbar.component.ts
// Navbar con links de navegación
import { Component, inject } from '@angular/core';
// RouterLink reemplaza href para navegación sin recarga
// RouterLinkActive agrega una clase CSS cuando la ruta coincide
import { RouterLink, RouterLinkActive } from '@angular/router';
import { FavoritesService } from '../../services/favorites.service';

@Component({
  selector: 'app-navbar',
  standalone: true,
  // Importar RouterLink y RouterLinkActive para usarlos en el template
  imports: [RouterLink, RouterLinkActive],
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.scss']
})
export class NavbarComponent {
  // Inyectar el servicio de favoritos para mostrar el contador
  private favoritesService = inject(FavoritesService);

  // Getter que retorna la cantidad de favoritas
  get cantidadFavoritas(): number {
    return this.favoritesService.obtenerCantidad();
  }
}
```

✏️ `navbar.component.html`:

```html
<!-- navbar.component.html -->
<!-- Navbar responsive de Bootstrap -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <!-- navbar-dark: texto blanco -->
  <!-- bg-dark: fondo oscuro -->

  <div class="container">
    <!-- Logo/nombre de la app como link al inicio -->
    <!-- routerLink="/" navega a la ruta raíz sin recargar la página -->
    <a class="navbar-brand" routerLink="/">🎬 CineExplorer</a>

    <!-- Botón hamburguesa para móviles -->
    <button class="navbar-toggler" type="button"
            data-bs-toggle="collapse"
            data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Links de navegación -->
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <!-- ms-auto: empuja los links a la derecha -->

        <li class="nav-item">
          <!-- routerLink: navega a la ruta especificada -->
          <!-- routerLinkActive="active": agrega la clase "active" cuando la ruta coincide -->
          <!-- [routerLinkActiveOptions]="{ exact: true }": solo coincide con la ruta exacta -->
          <a class="nav-link" routerLink="/"
             routerLinkActive="active"
             [routerLinkActiveOptions]="{ exact: true }">
            Inicio
          </a>
        </li>

        <li class="nav-item">
          <a class="nav-link" routerLink="/favorites"
             routerLinkActive="active">
            <!-- Mostrar badge con cantidad de favoritas -->
            Favoritos
            @if (cantidadFavoritas > 0) {
              <span class="badge bg-danger ms-1">{{ cantidadFavoritas }}</span>
            }
          </a>
        </li>
      </ul>
    </div>
  </div>
</nav>
```

---

## 5.4 Crear las páginas (features)

### HomeComponent

```bash
ng g c features/home --skip-tests
```

✏️ `home.component.ts`:

```typescript
// home.component.ts
// Página principal que muestra películas populares
import { Component, inject } from '@angular/core';
import { MovieCardComponent } from '../../components/movie-card/movie-card.component';
import { FavoritesService } from '../../services/favorites.service';
import { Movie } from '../../models/movie';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [MovieCardComponent],
  templateUrl: './home.component.html'
})
export class HomeComponent {
  private favoritesService = inject(FavoritesService);

  // Datos de ejemplo (en el capítulo 6 vendrán de la API)
  peliculas: Movie[] = [
    {
      id: 550, title: 'Fight Club',
      overview: 'Un oficinista insomne y un fabricante de jabón forman un club de pelea clandestino.',
      poster_path: '/pB8BM7pdSp6B6Ih7QI4S2t0POoD.jpg',
      backdrop_path: '/hZkgoQYus5dXo3H8T7Uef6DNknx.jpg',
      vote_average: 8.4, release_date: '1999-10-15', genre_ids: [18, 53]
    },
    {
      id: 680, title: 'Pulp Fiction',
      overview: 'Las vidas de dos sicarios, un boxeador y la esposa de un gángster se entrelazan.',
      poster_path: '/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg',
      backdrop_path: '/suaEOtk1N1sgg2MTM7oZd2cfVp3.jpg',
      vote_average: 8.5, release_date: '1994-09-10', genre_ids: [53, 80]
    },
    {
      id: 13, title: 'Forrest Gump',
      overview: 'La historia de un hombre con un coeficiente intelectual bajo que logra cosas extraordinarias.',
      poster_path: '/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg',
      backdrop_path: '/7c9UVPPiTPltouxRVY6N9uugaVA.jpg',
      vote_average: 8.5, release_date: '1994-06-23', genre_ids: [35, 18, 10749]
    }
  ];

  esFavorita(id: number): boolean {
    return this.favoritesService.esFavorita(id);
  }

  toggleFavorito(movie: Movie): void {
    this.favoritesService.toggle(movie);
  }
}
```

✏️ `home.component.html`:

```html
<!-- home.component.html -->
<!-- Página principal con grid de películas -->
<h2 class="mb-4">🔥 Películas populares</h2>

<div class="row g-4">
  @for (movie of peliculas; track movie.id) {
    <div class="col-sm-6 col-md-4 col-lg-3">
      <app-movie-card
        [movie]="movie"
        [esFavorita]="esFavorita(movie.id)"
        (toggleFavorito)="toggleFavorito($event)" />
    </div>
  } @empty {
    <p class="text-muted">No hay películas para mostrar</p>
  }
</div>
```

### FavoritesComponent

```bash
ng g c features/favorites --skip-tests
```

✏️ `favorites.component.ts`:

```typescript
// favorites.component.ts
// Página que muestra las películas marcadas como favoritas
import { Component, inject } from '@angular/core';
import { MovieCardComponent } from '../../components/movie-card/movie-card.component';
import { FavoritesService } from '../../services/favorites.service';
import { Movie } from '../../models/movie';

@Component({
  selector: 'app-favorites',
  standalone: true,
  imports: [MovieCardComponent],
  templateUrl: './favorites.component.html'
})
export class FavoritesComponent {
  private favoritesService = inject(FavoritesService);

  // Obtener las películas favoritas del servicio
  get favoritas(): Movie[] {
    return this.favoritesService.obtenerTodas();
  }

  // Quitar de favoritos
  toggleFavorito(movie: Movie): void {
    this.favoritesService.toggle(movie);
  }
}
```

✏️ `favorites.component.html`:

```html
<!-- favorites.component.html -->
<h2 class="mb-4">❤️ Mis favoritas</h2>

@if (favoritas.length > 0) {
  <div class="row g-4">
    @for (movie of favoritas; track movie.id) {
      <div class="col-sm-6 col-md-4 col-lg-3">
        <app-movie-card
          [movie]="movie"
          [esFavorita]="true"
          (toggleFavorito)="toggleFavorito($event)" />
      </div>
    }
  </div>
} @else {
  <!-- Estado vacío cuando no hay favoritas -->
  <div class="text-center py-5">
    <p class="display-1">🎬</p>
    <h4 class="text-muted">No tienes películas favoritas</h4>
    <p class="text-muted">Explora películas y marca las que te gusten con ❤️</p>
    <!-- routerLink para navegar al inicio -->
    <a routerLink="/" class="btn btn-primary">Explorar películas</a>
  </div>
}
```

💡 No olviden agregar `RouterLink` a los imports del componente si usan `routerLink` en el template.

---

## 5.5 Rutas con parámetros (:id)

### Navegar a una ruta con parámetro

✏️ Actualizar el botón "Ver detalle" en `movie-card.component.html`:

```html
<!-- Reemplazar el botón de "Ver detalle" -->
<!-- [routerLink] con array: el primer elemento es la ruta, el segundo el parámetro -->
<!-- movie() con paréntesis porque es un signal (input) -->
<a [routerLink]="['/movie', movie().id]"
   class="btn btn-outline-primary flex-grow-1">
  Ver detalle
</a>
```

💡 Agregar `RouterLink` a los imports del `MovieCardComponent`.

### Leer el parámetro en el componente destino

```bash
ng g c features/movie-detail --skip-tests
```

✏️ `movie-detail.component.ts`:

```typescript
// movie-detail.component.ts
// Página de detalle que lee el parámetro :id de la URL
import { Component, OnInit, inject } from '@angular/core';
// ActivatedRoute da acceso a los parámetros de la ruta actual
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-movie-detail',
  standalone: true,
  imports: [],
  templateUrl: './movie-detail.component.html'
})
export class MovieDetailComponent implements OnInit {
  // ActivatedRoute contiene información de la ruta actual
  private route = inject(ActivatedRoute);

  // ID de la película (se lee de la URL)
  movieId: number = 0;

  ngOnInit(): void {
    // snapshot.params contiene los parámetros de la ruta
    // params['id'] corresponde al :id definido en app.routes.ts
    // El "+" convierte el string a número
    this.movieId = +this.route.snapshot.params['id'];
    console.log('ID de la película:', this.movieId);
    // En el capítulo 6 usaremos este ID para llamar a la API
  }
}
```

✏️ `movie-detail.component.html`:

```html
<!-- movie-detail.component.html -->
<!-- Por ahora solo mostramos el ID. En el capítulo 6 cargaremos datos reales -->
<div class="text-center py-5">
  <h2>Detalle de película #{{ movieId }}</h2>
  <p class="text-muted">Los datos reales se cargarán cuando conectemos la API (capítulo 6)</p>
  <a routerLink="/" class="btn btn-outline-primary">← Volver al inicio</a>
</div>
```

---

## 5.6 Query params

Los query params son parámetros opcionales en la URL: `/search?q=batman&page=2`.

```typescript
// Navegar con query params desde código
import { Router } from '@angular/router';

private router = inject(Router);

buscar(termino: string): void {
  // navigate construye la URL: /search?q=batman
  this.router.navigate(['/search'], {
    queryParams: { q: termino }
  });
}
```

```html
<!-- Navegar con query params desde el template -->
<a routerLink="/search" [queryParams]="{ q: termino }">Buscar</a>
```

```typescript
// Leer query params en el componente destino
private route = inject(ActivatedRoute);

ngOnInit(): void {
  // queryParams es un Observable que emite cuando los params cambian
  this.route.queryParams.subscribe(params => {
    const termino = params['q'] || '';
    if (termino) {
      this.buscar(termino);
    }
  });
}
```

---

## 5.7 Guards: proteger rutas

Los guards controlan el acceso a rutas. Ejemplo: redirigir si no hay favoritas.

```typescript
// guards/has-favorites.guard.ts
// Guard funcional (Angular 15+)
import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { FavoritesService } from '../services/favorites.service';

// CanActivateFn es el tipo para guards funcionales
export const hasFavoritesGuard: CanActivateFn = () => {
  const favoritesService = inject(FavoritesService);
  const router = inject(Router);

  // Si hay favoritas, permitir acceso
  if (favoritesService.obtenerCantidad() > 0) {
    return true;
  }

  // Si no hay favoritas, redirigir al inicio
  router.navigate(['/']);
  return false;
};
```

```typescript
// Aplicar el guard a una ruta en app.routes.ts
{ path: 'favorites', component: FavoritesComponent, canActivate: [hasFavoritesGuard] }
```

---

## 5.8 Compilar y probar

▶️ Ejecutar `ng serve`. Deberían poder:
1. Ver el navbar con links a Inicio y Favoritos
2. Navegar entre páginas sin que el navegador recargue
3. Hacer click en "Ver detalle" y ver la página con el ID
4. Marcar favoritas y ver el badge en el navbar
5. Ir a Favoritos y ver las películas marcadas

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| `Routes` | Array que mapea URLs a componentes |
| `RouterOutlet` | Contenedor donde se renderizan las páginas |
| `RouterLink` | Navegación sin recarga (reemplaza `<a href>`) |
| `RouterLinkActive` | Agrega clase CSS cuando la ruta coincide |
| `:id` | Parámetro dinámico en la URL |
| `ActivatedRoute` | Acceder a parámetros de la ruta actual |
| `queryParams` | Parámetros opcionales en la URL (?key=value) |
| `loadComponent` | Lazy loading (carga código solo cuando se visita) |
| Guards | Controlar acceso a rutas |

---

**Anterior:** [← Capítulo 4 — Servicios](04_servicios.md) | **Siguiente:** [Capítulo 6 — HttpClient →](06_httpclient.md)
