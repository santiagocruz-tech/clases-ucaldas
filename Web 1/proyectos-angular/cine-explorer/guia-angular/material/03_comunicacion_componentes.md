# Capítulo 3: Comunicación entre componentes

## Objetivo

Aprender a pasar datos entre componentes padre e hijo. Al final de este capítulo, el `MovieCardComponent` recibirá datos del padre con `@Input()` y emitirá eventos de favorito con `@Output()`.

---

## 3.1 @Input(): pasar datos de padre a hijo

`@Input()` permite que un componente padre envíe datos a un componente hijo. Es como pasar parámetros a una función.

### Componente hijo (recibe datos)

✏️ Modificar `movie-card.component.ts`:

```typescript
// movie-card.component.ts
// Componente de tarjeta que RECIBE una película del padre
import { Component, Input } from '@angular/core';
// Input se importa del core de Angular
import { Movie } from '../../models/movie';

@Component({
  selector: 'app-movie-card',
  standalone: true,
  imports: [],
  templateUrl: './movie-card.component.html',
  styleUrls: ['./movie-card.component.scss']
})
export class MovieCardComponent {
  // @Input() marca esta propiedad como "entrada" de datos
  // El padre puede pasar un valor con [movie]="valor"
  // { required: true } hace que sea obligatorio pasarlo
  // El "!" indica que se inicializará desde fuera (no aquí)
  @Input({ required: true }) movie!: Movie;

  // @Input() para saber si esta película es favorita
  // Tiene valor por defecto false (no es obligatorio pasarlo)
  @Input() esFavorita: boolean = false;
}
```

El template `movie-card.component.html` ahora usa `movie` en lugar de `pelicula`:

```html
<!-- movie-card.component.html -->
<!-- Tarjeta que muestra los datos recibidos por @Input -->
<div class="card shadow-sm h-100">
  <img
    [src]="'https://image.tmdb.org/t/p/w500' + movie.poster_path"
    [alt]="movie.title"
    class="card-img-top">

  <div class="card-body d-flex flex-column">
    <h5 class="card-title">{{ movie.title }}</h5>

    <p class="text-muted mb-2">⭐ {{ movie.vote_average }} / 10</p>

    <p class="card-text flex-grow-1">
      {{ movie.overview.length > 120
        ? movie.overview.slice(0, 120) + '...'
        : movie.overview }}
    </p>

    <!-- Botón de favorito: cambia según el estado -->
    <div class="d-flex gap-2 mt-auto">
      <!-- gap-2: espacio entre botones -->
      <button class="btn btn-outline-primary flex-grow-1">
        Ver detalle
      </button>
      <button
        class="btn"
        [ngClass]="esFavorita ? 'btn-danger' : 'btn-outline-danger'">
        <!-- ngClass cambia la clase según la condición -->
        <!-- btn-danger: rojo sólido (es favorita) -->
        <!-- btn-outline-danger: rojo solo borde (no es favorita) -->
        {{ esFavorita ? '❤️' : '🤍' }}
      </button>
    </div>
  </div>
</div>
```

💡 Agregar `CommonModule` o `NgClass` a los imports del componente si `ngClass` no funciona:

```typescript
import { NgClass } from '@angular/common';

@Component({
  // ...
  imports: [NgClass],
})
```

### Componente padre (envía datos)

✏️ Modificar `app.component.ts`:

```typescript
// app.component.ts
// Componente padre que pasa datos a los hijos MovieCard
import { Component } from '@angular/core';
import { MovieCardComponent } from './components/movie-card/movie-card.component';
// Importar la interfaz Movie para tipar el array
import { Movie } from './models/movie';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [MovieCardComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  titulo: string = 'CineExplorer';

  // Array de películas de ejemplo (después vendrán de la API)
  peliculas: Movie[] = [
    {
      id: 550,
      title: 'Fight Club',
      overview: 'Un oficinista insomne y un fabricante de jabón forman un club de pelea clandestino.',
      poster_path: '/jSziioSwPVrOy9Yow3XhWIBDjq1.jpg',
      backdrop_path: '/hZkgoQYus5dXo3H8T7Uef6DNknx.jpg',
      vote_average: 8.4,
      release_date: '1999-10-15',
      genre_ids: [18, 53]
    },
    {
      id: 680,
      title: 'Pulp Fiction',
      overview: 'Las vidas de dos sicarios, un boxeador y la esposa de un gángster se entrelazan.',
      poster_path: '/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg',
      backdrop_path: '/suaEOtk1N1sgg2MTM7oZd2cfVp3.jpg',
      vote_average: 8.5,
      release_date: '1994-09-10',
      genre_ids: [53, 80]
    },
    {
      id: 13,
      title: 'Forrest Gump',
      overview: 'La historia de un hombre con un coeficiente intelectual bajo que logra cosas extraordinarias.',
      poster_path: '/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg',
      backdrop_path: '/7c9UVPPiTPltouxRVY6N9uugaVA.jpg',
      vote_average: 8.5,
      release_date: '1994-06-23',
      genre_ids: [35, 18, 10749]
    }
  ];

  // Set de IDs de películas favoritas
  favoritasIds: Set<number> = new Set();

  // Verifica si una película es favorita
  esFavorita(id: number): boolean {
    return this.favoritasIds.has(id);
  }

  // Alterna el estado de favorito de una película
  toggleFavorito(movie: Movie): void {
    if (this.favoritasIds.has(movie.id)) {
      // Si ya es favorita, quitarla
      this.favoritasIds.delete(movie.id);
    } else {
      // Si no es favorita, agregarla
      this.favoritasIds.add(movie.id);
    }
  }
}
```

✏️ Modificar `app.component.html`:

```html
<!-- app.component.html -->
<!-- Página principal que pasa datos a cada MovieCard -->
<div class="container py-4">
  <h1 class="display-5 mb-1">🎬 {{ titulo }}</h1>
  <p class="lead text-muted mb-4">Explora las mejores películas del mundo</p>

  <!-- @for recorre el array de películas -->
  <!-- track movie.id: Angular usa el ID para optimizar el renderizado -->
  <div class="row g-4">
    @for (movie of peliculas; track movie.id) {
      <div class="col-sm-6 col-md-4">
        <!-- [movie]="movie" pasa la película al hijo (property binding a @Input) -->
        <!-- [esFavorita] pasa si esta película está en favoritos -->
        <!-- (toggleFavorito) escucha el evento emitido por el hijo -->
        <app-movie-card
          [movie]="movie"
          [esFavorita]="esFavorita(movie.id)"
          (toggleFavorito)="toggleFavorito($event)" />
      </div>
    } @empty {
      <p class="text-muted">No hay películas para mostrar</p>
    }
  </div>
</div>
```

---

## 3.2 @Output() y EventEmitter: emitir eventos de hijo a padre

`@Output()` permite que un componente hijo notifique al padre cuando algo pasa (como hacer click en favorito).

✏️ Modificar `movie-card.component.ts` para agregar el Output:

```typescript
// movie-card.component.ts
// Componente con @Input (recibe datos) y @Output (emite eventos)
import { Component, Input, Output, EventEmitter } from '@angular/core';
// EventEmitter es la clase que permite emitir eventos personalizados
import { NgClass } from '@angular/common';
import { Movie } from '../../models/movie';

@Component({
  selector: 'app-movie-card',
  standalone: true,
  imports: [NgClass],
  templateUrl: './movie-card.component.html',
  styleUrls: ['./movie-card.component.scss']
})
export class MovieCardComponent {
  // Entrada: datos que recibe del padre
  @Input({ required: true }) movie!: Movie;
  @Input() esFavorita: boolean = false;

  // Salida: evento que emite hacia el padre
  // EventEmitter<Movie> indica que el evento envía un objeto Movie
  @Output() toggleFavorito = new EventEmitter<Movie>();

  // Método que se ejecuta al hacer click en el botón de favorito
  onToggleFavorito(): void {
    // emit() envía el evento al padre con la película como dato
    this.toggleFavorito.emit(this.movie);
  }
}
```

✏️ Actualizar el botón de favorito en `movie-card.component.html`:

```html
<!-- Reemplazar el botón de favorito por este -->
<button
  class="btn"
  [ngClass]="esFavorita ? 'btn-danger' : 'btn-outline-danger'"
  (click)="onToggleFavorito()">
  <!-- (click) llama al método que emite el evento -->
  {{ esFavorita ? '❤️' : '🤍' }}
</button>
```

---

## 3.3 Componentes inteligentes vs. componentes de presentación

Este patrón es clave para código mantenible:

| Tipo | Responsabilidad | Ejemplo |
|------|----------------|---------|
| **Inteligente** (smart) | Obtiene datos, maneja lógica | `HomeComponent`, `SearchComponent` |
| **Presentación** (dumb) | Solo muestra datos, emite eventos | `MovieCardComponent`, `SpinnerComponent` |

```
HomeComponent (inteligente)
├── Inyecta TmdbService
├── Llama a la API
├── Maneja favoritos
└── Pasa datos a:
    ├── MovieCardComponent (presentación) ← solo muestra y emite
    ├── MovieCardComponent (presentación)
    └── MovieCardComponent (presentación)
```

💡 **Regla:** los componentes de presentación no conocen servicios ni lógica de negocio. Solo reciben datos por `@Input()` y emiten eventos por `@Output()`.

---

## 3.4 Proyección de contenido con ng-content

`ng-content` permite que un componente padre inserte HTML dentro de un componente hijo. Es como los "slots" de Vue o los "children" de React.

```typescript
// card-layout.component.ts
// Componente contenedor reutilizable con slots para contenido
@Component({
  selector: 'app-card-layout',
  standalone: true,
  template: `
    <!-- ng-content con select filtra qué contenido va en cada slot -->
    <div class="card shadow-sm">
      <div class="card-header bg-primary text-white">
        <!-- Solo el contenido con atributo "card-header" va aquí -->
        <ng-content select="[card-header]"></ng-content>
      </div>
      <div class="card-body">
        <!-- El contenido sin selector va aquí (slot por defecto) -->
        <ng-content></ng-content>
      </div>
      <div class="card-footer">
        <!-- Solo el contenido con atributo "card-footer" va aquí -->
        <ng-content select="[card-footer]"></ng-content>
      </div>
    </div>
  `
})
export class CardLayoutComponent {}
```

```html
<!-- Uso desde el padre: el contenido se distribuye en los slots -->
<app-card-layout>
  <h5 card-header>Título de la tarjeta</h5>

  <p>Este contenido va en el body (slot por defecto)</p>
  <p>Puede ser cualquier HTML</p>

  <button card-footer class="btn btn-primary">Acción</button>
</app-card-layout>
```

---

## 3.5 Compilar y probar

▶️ Ejecutar `ng serve`. Deberían ver:
- Tres tarjetas con películas diferentes (Fight Club, Pulp Fiction, Forrest Gump)
- Al hacer click en 🤍, cambia a ❤️ (y viceversa)
- Cada tarjeta es independiente: marcar una como favorita no afecta a las otras

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| `@Input()` | Recibir datos del componente padre |
| `@Output()` + `EventEmitter` | Emitir eventos hacia el componente padre |
| `[propiedad]="valor"` | Pasar datos al hijo (property binding) |
| `(evento)="metodo($event)"` | Escuchar eventos del hijo |
| Smart vs. Dumb components | Separar lógica de presentación |
| `ng-content` | Insertar HTML del padre dentro del hijo |

---

**Anterior:** [← Capítulo 2 — Componentes](02_componentes.md) | **Siguiente:** [Capítulo 4 — Servicios →](04_servicios.md)
