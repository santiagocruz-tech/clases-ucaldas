# 5. Routing y navegación

## Configuración de rutas

Angular usa un sistema de rutas para navegar entre vistas sin recargar la página (Single Page Application).

### Definir rutas en app.routes.ts

```typescript
// app.routes.ts
import { Routes } from '@angular/router';
import { HomeComponent } from './features/home/home.component';

export const routes: Routes = [
    { path: '', component: HomeComponent },
    { path: 'movie/:id', component: MovieDetailComponent },
    { path: 'search', component: SearchResultsComponent },
    { path: 'favorites', component: FavoritesComponent },
    { path: 'genre/:id', component: GenreFilterComponent },
    { path: '**', redirectTo: '' }  // Cualquier ruta no definida → inicio
];
```

### Configurar en app.config.ts

```typescript
// app.config.ts
import { ApplicationConfig } from '@angular/core';
import { provideRouter } from '@angular/router';
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
    providers: [
        provideRouter(routes)
    ]
};
```

---

## RouterLink y RouterOutlet

### RouterOutlet

Es el contenedor donde Angular renderiza el componente de la ruta activa.

```html
<!-- app.component.html -->
<app-navbar />

<main class="container">
    <router-outlet />  <!-- Aquí se muestra el componente de la ruta actual -->
</main>

<app-footer />
```

### RouterLink

Reemplaza los `<a href>` tradicionales. Navega sin recargar la página.

```typescript
// navbar.component.ts
import { RouterLink, RouterLinkActive } from '@angular/router';

@Component({
    selector: 'app-navbar',
    standalone: true,
    imports: [RouterLink, RouterLinkActive],
    templateUrl: './navbar.component.html'
})
export class NavbarComponent {}
```

```html
<!-- navbar.component.html -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" routerLink="/">CineExplorer</a>

        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" routerLink="/"
                   routerLinkActive="active"
                   [routerLinkActiveOptions]="{ exact: true }">
                    Inicio
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" routerLink="/favorites"
                   routerLinkActive="active">
                    Favoritos
                </a>
            </li>
        </ul>
    </div>
</nav>
```

`routerLinkActive="active"` agrega la clase CSS `active` cuando la ruta coincide.

---

## Rutas con parámetros (:id)

### Definir la ruta

```typescript
{ path: 'movie/:id', component: MovieDetailComponent }
```

### Navegar a la ruta

```html
<!-- Desde el template -->
<a [routerLink]="['/movie', pelicula.id]">Ver detalle</a>

<!-- Equivalente -->
<a routerLink="/movie/{{ pelicula.id }}">Ver detalle</a>
```

```typescript
// Desde la clase (navegación programática)
import { Router } from '@angular/router';

export class MovieCardComponent {
    constructor(private router: Router) {}

    verDetalle(id: number): void {
        this.router.navigate(['/movie', id]);
    }
}
```

### Leer el parámetro en el componente destino

```typescript
// movie-detail.component.ts
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { TmdbService } from '../../services/tmdb.service';

@Component({ ... })
export class MovieDetailComponent implements OnInit {
    pelicula: MovieDetail | null = null;
    cargando: boolean = true;

    constructor(
        private route: ActivatedRoute,
        private tmdbService: TmdbService
    ) {}

    ngOnInit(): void {
        // Opción 1: snapshot (valor estático, se lee una vez)
        const id = this.route.snapshot.params['id'];
        this.cargarPelicula(id);

        // Opción 2: observable (reacciona a cambios de parámetro)
        this.route.params.subscribe(params => {
            this.cargarPelicula(params['id']);
        });
    }

    cargarPelicula(id: string): void {
        this.cargando = true;
        this.tmdbService.obtenerDetalle(+id).subscribe({
            next: (data) => {
                this.pelicula = data;
                this.cargando = false;
            },
            error: () => {
                this.cargando = false;
            }
        });
    }
}
```

Usar la opción 2 (observable) cuando el componente puede cambiar de parámetro sin destruirse (por ejemplo, navegar de `/movie/1` a `/movie/2`).

---

## Query params

Los query params son parámetros opcionales en la URL: `/search?q=batman&page=2`.

### Navegar con query params

```html
<!-- Desde template -->
<a routerLink="/search" [queryParams]="{ q: termino }">Buscar</a>
```

```typescript
// Desde la clase
this.router.navigate(['/search'], {
    queryParams: { q: this.termino, page: 1 }
});
```

### Leer query params

```typescript
export class SearchResultsComponent implements OnInit {
    resultados: Movie[] = [];
    termino: string = '';

    constructor(
        private route: ActivatedRoute,
        private tmdbService: TmdbService
    ) {}

    ngOnInit(): void {
        this.route.queryParams.subscribe(params => {
            this.termino = params['q'] || '';
            if (this.termino) {
                this.buscar(this.termino);
            }
        });
    }

    buscar(termino: string): void {
        this.tmdbService.buscarPeliculas(termino).subscribe(data => {
            this.resultados = data.results;
        });
    }
}
```

---

## Lazy loading de rutas

Lazy loading carga el código de una ruta solo cuando el usuario navega a ella. Mejora el tiempo de carga inicial.

```typescript
// app.routes.ts
export const routes: Routes = [
    { path: '', component: HomeComponent },
    {
        path: 'movie/:id',
        loadComponent: () =>
            import('./features/movie-detail/movie-detail.component')
                .then(m => m.MovieDetailComponent)
    },
    {
        path: 'favorites',
        loadComponent: () =>
            import('./features/favorites/favorites.component')
                .then(m => m.FavoritesComponent)
    },
    { path: '**', redirectTo: '' }
];
```

Con `loadComponent`, Angular solo descarga el código del componente cuando el usuario visita esa ruta.

---

## Guards: proteger rutas

Los guards controlan el acceso a rutas. Ejemplo: redirigir si el usuario no está autenticado.

```typescript
// guards/auth.guard.ts
import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

export const authGuard: CanActivateFn = () => {
    const authService = inject(AuthService);
    const router = inject(Router);

    if (authService.estaAutenticado()) {
        return true;
    }

    router.navigate(['/login']);
    return false;
};
```

### Aplicar el guard a una ruta

```typescript
export const routes: Routes = [
    { path: 'favorites', component: FavoritesComponent, canActivate: [authGuard] },
];
```

---

## Ejercicios

### Ejercicio 1: Navegación básica
Crear una app con 3 rutas: Home, About, Contact. Agregar un navbar con RouterLink y RouterLinkActive. Incluir una ruta wildcard que redirija a Home.

### Ejercicio 2: Ruta con parámetro
Crear una lista de productos en Home. Al hacer click en uno, navegar a `/product/:id` y mostrar el detalle leyendo el parámetro con ActivatedRoute.

### Ejercicio 3: Búsqueda con query params
Crear un buscador en el navbar que al presionar Enter navegue a `/search?q=termino`. En SearchResultsComponent, leer el query param y filtrar resultados.

### Ejercicio 4: Lazy loading
Convertir las rutas del ejercicio 1 a lazy loading con `loadComponent`.
