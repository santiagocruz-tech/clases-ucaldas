# 3. Comunicación entre componentes

## @Input(): pasar datos de padre a hijo

`@Input()` permite que un componente padre envíe datos a un componente hijo.

### Componente hijo (recibe datos)

```typescript
// movie-card.component.ts
import { Component, Input } from '@angular/core';

interface Movie {
    id: number;
    title: string;
    poster_path: string;
    vote_average: number;
}

@Component({
    selector: 'app-movie-card',
    standalone: true,
    templateUrl: './movie-card.component.html',
    styleUrls: ['./movie-card.component.scss']
})
export class MovieCardComponent {
    @Input({ required: true }) movie!: Movie;
}
```

```html
<!-- movie-card.component.html -->
<div class="card">
    <img [src]="'https://image.tmdb.org/t/p/w500' + movie.poster_path"
         [alt]="movie.title">
    <div class="card-body">
        <h5>{{ movie.title }}</h5>
        <p>⭐ {{ movie.vote_average }}</p>
    </div>
</div>
```

### Componente padre (envía datos)

```typescript
// home.component.ts
import { MovieCardComponent } from '../movie-card/movie-card.component';

@Component({
    selector: 'app-home',
    standalone: true,
    imports: [MovieCardComponent],
    templateUrl: './home.component.html'
})
export class HomeComponent {
    peliculas: Movie[] = [
        { id: 1, title: 'Inception', poster_path: '/path.jpg', vote_average: 8.8 },
        { id: 2, title: 'Interstellar', poster_path: '/path2.jpg', vote_average: 8.6 }
    ];
}
```

```html
<!-- home.component.html -->
<div class="row">
    @for (pelicula of peliculas; track pelicula.id) {
        <div class="col-md-4">
            <app-movie-card [movie]="pelicula" />
        </div>
    }
</div>
```

---

## @Output() y EventEmitter: emitir eventos de hijo a padre

`@Output()` permite que un componente hijo notifique al padre cuando algo pasa.

### Componente hijo (emite evento)

```typescript
// movie-card.component.ts
import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
    selector: 'app-movie-card',
    standalone: true,
    templateUrl: './movie-card.component.html'
})
export class MovieCardComponent {
    @Input({ required: true }) movie!: Movie;
    @Input() esFavorita: boolean = false;

    @Output() toggleFavorito = new EventEmitter<Movie>();

    onToggleFavorito(): void {
        this.toggleFavorito.emit(this.movie);
    }
}
```

```html
<!-- movie-card.component.html -->
<div class="card">
    <img [src]="'https://image.tmdb.org/t/p/w500' + movie.poster_path"
         [alt]="movie.title">
    <div class="card-body">
        <h5>{{ movie.title }}</h5>
        <button (click)="onToggleFavorito()"
                [class.btn-danger]="esFavorita"
                [class.btn-outline-danger]="!esFavorita"
                class="btn btn-sm">
            {{ esFavorita ? '❤️ Favorita' : '🤍 Agregar' }}
        </button>
    </div>
</div>
```

### Componente padre (escucha evento)

```typescript
// home.component.ts
export class HomeComponent {
    peliculas: Movie[] = [];
    favoritas: number[] = []; // IDs de películas favoritas

    manejarFavorito(movie: Movie): void {
        const index = this.favoritas.indexOf(movie.id);
        if (index === -1) {
            this.favoritas.push(movie.id);
        } else {
            this.favoritas.splice(index, 1);
        }
    }

    esFavorita(id: number): boolean {
        return this.favoritas.includes(id);
    }
}
```

```html
<!-- home.component.html -->
@for (pelicula of peliculas; track pelicula.id) {
    <app-movie-card
        [movie]="pelicula"
        [esFavorita]="esFavorita(pelicula.id)"
        (toggleFavorito)="manejarFavorito($event)" />
}
```

---

## Componentes inteligentes vs. componentes de presentación

Este patrón es clave para escribir código mantenible.

### Componente de presentación (dumb component)
- Solo muestra datos que recibe por `@Input()`.
- Emite eventos con `@Output()` cuando el usuario interactúa.
- No conoce servicios ni lógica de negocio.
- Ejemplo: `MovieCardComponent`, `ButtonComponent`, `SpinnerComponent`.

### Componente inteligente (smart component)
- Inyecta servicios y obtiene datos.
- Maneja la lógica de negocio.
- Pasa datos a los componentes de presentación.
- Ejemplo: `HomeComponent`, `SearchResultsComponent`, `FavoritesComponent`.

```
HomeComponent (inteligente)
├── Inyecta TmdbService
├── Llama a la API
├── Maneja favoritos
└── Pasa datos a:
    ├── MovieCardComponent (presentación)
    ├── MovieCardComponent (presentación)
    └── MovieCardComponent (presentación)
```

---

## Proyección de contenido con ng-content

`ng-content` permite que un componente padre inserte HTML dentro de un componente hijo.

### Componente contenedor

```typescript
// card.component.ts
@Component({
    selector: 'app-card',
    standalone: true,
    template: `
        <div class="card shadow-sm">
            <div class="card-header">
                <ng-content select="[card-header]"></ng-content>
            </div>
            <div class="card-body">
                <ng-content></ng-content>
            </div>
            <div class="card-footer">
                <ng-content select="[card-footer]"></ng-content>
            </div>
        </div>
    `
})
export class CardComponent {}
```

### Uso desde el padre

```html
<app-card>
    <h5 card-header>Título de la tarjeta</h5>

    <p>Este contenido va en el body</p>
    <p>Puede ser cualquier HTML</p>

    <button card-footer class="btn btn-primary">Acción</button>
</app-card>
```

---

## ViewChild

`@ViewChild` permite acceder a un componente hijo o elemento del DOM desde la clase del padre.

```typescript
import { Component, ViewChild, AfterViewInit } from '@angular/core';
import { BuscadorComponent } from './buscador/buscador.component';

@Component({
    selector: 'app-navbar',
    standalone: true,
    imports: [BuscadorComponent],
    template: `
        <nav>
            <app-buscador />
            <button (click)="limpiarBusqueda()">Limpiar</button>
        </nav>
    `
})
export class NavbarComponent implements AfterViewInit {
    @ViewChild(BuscadorComponent) buscador!: BuscadorComponent;

    ngAfterViewInit(): void {
        // El ViewChild está disponible después de AfterViewInit
        console.log(this.buscador);
    }

    limpiarBusqueda(): void {
        this.buscador.termino = '';
    }
}
```

Usar `@ViewChild` con moderación. Si te encontrás usándolo mucho, probablemente la comunicación debería ser con `@Input`/`@Output` o un servicio compartido.

---

## Ejercicios

### Ejercicio 1: Tarjeta reutilizable
Crear un `ProductCardComponent` que reciba un producto por `@Input()` y emita un evento `agregarAlCarrito` con `@Output()`. Usarlo desde un componente padre que muestre una lista de productos.

### Ejercicio 2: Componente de rating
Crear un `RatingComponent` que reciba `puntuacion: number` por Input y muestre estrellas (★ y ☆). Al hacer click en una estrella, emitir la nueva puntuación con Output.

### Ejercicio 3: Layout con ng-content
Crear un `PageLayoutComponent` con slots para header, contenido principal y sidebar usando `ng-content` con selectores.

### Ejercicio 4: Smart vs. Dumb
Refactorizar una lista de contactos: crear un `ContactListComponent` (inteligente, tiene los datos) y un `ContactItemComponent` (presentación, solo muestra y emite eventos de editar/eliminar).
