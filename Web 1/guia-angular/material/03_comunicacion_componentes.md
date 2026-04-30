# Capítulo 3: Comunicación entre componentes

## Objetivo

Aprender a pasar datos entre componentes padre e hijo. Al final de este capítulo, el `MovieCardComponent` recibirá datos del padre con `input()` y emitirá eventos de favorito con `output()`.

---

## 3.1 Signals: el modelo reactivo moderno de Angular

Antes de ver `input()` y `output()`, necesitamos entender **signals**. Un signal es un contenedor de valor que notifica a Angular cuando cambia, para que actualice solo lo necesario en la pantalla.

```typescript
import { signal, computed, effect } from '@angular/core';

// signal() crea un valor reactivo
// Angular detecta automáticamente cuándo cambia y actualiza el template
const contador = signal(0);

// Leer el valor: se llama como función
console.log(contador());  // 0

// Escribir un nuevo valor: .set()
contador.set(5);

// Actualizar basándose en el valor anterior: .update()
contador.update(valor => valor + 1);  // 6

// computed() crea un valor derivado que se recalcula automáticamente
// cuando sus dependencias (otros signals) cambian
const doble = computed(() => contador() * 2);
console.log(doble());  // 12

// effect() ejecuta código cada vez que un signal cambia
// Útil para logging, guardar en localStorage, etc.
effect(() => {
  console.log('El contador cambió a:', contador());
});
```

💡 **¿Por qué signals?** Antes Angular usaba Zone.js para detectar cambios en toda la app. Con signals, Angular sabe exactamente qué cambió y actualiza solo eso. Es más eficiente y predecible.

---

## 3.2 input(): pasar datos de padre a hijo

`input()` es una función que define una entrada de datos en un componente hijo. Reemplaza al decorador `@Input()` con una API basada en signals.

### Componente hijo (recibe datos)

✏️ Modificar `movie-card.component.ts`:

```typescript
// movie-card.component.ts
// Componente de tarjeta que RECIBE una película del padre
import { Component, input } from '@angular/core';
// input se importa del core de Angular (función, no decorador)
import { Movie } from '../../models/movie';

@Component({
  selector: 'app-movie-card',
  standalone: true,
  imports: [],
  templateUrl: './movie-card.component.html',
  styleUrls: ['./movie-card.component.scss']
})
export class MovieCardComponent {
  // input.required<Movie>() define una entrada obligatoria de tipo Movie
  // El padre DEBE pasar un valor con [movie]="valor"
  // Es un signal: en el template se lee como movie() (con paréntesis)
  movie = input.required<Movie>();

  // input<boolean>() con valor por defecto false (no es obligatorio pasarlo)
  esFavorita = input<boolean>(false);
}
```

El template `movie-card.component.html` ahora usa `movie()` con paréntesis (porque es un signal):

```html
<!-- movie-card.component.html -->
<!-- Tarjeta que muestra los datos recibidos por input() -->
<!-- IMPORTANTE: los inputs se leen con () porque son signals -->
<div class="card shadow-sm h-100">
  <img
    [src]="'https://image.tmdb.org/t/p/w500' + movie().poster_path"
    [alt]="movie().title"
    class="card-img-top">

  <div class="card-body d-flex flex-column">
    <h5 class="card-title">{{ movie().title }}</h5>

    <p class="text-muted mb-2">⭐ {{ movie().vote_average }} / 10</p>

    <p class="card-text flex-grow-1">
      {{ movie().overview.length > 120
        ? movie().overview.slice(0, 120) + '...'
        : movie().overview }}
    </p>

    <!-- Botón de favorito: cambia según el estado -->
    <div class="d-flex gap-2 mt-auto">
      <button class="btn btn-outline-primary flex-grow-1">
        Ver detalle
      </button>
      <button
        class="btn"
        [class.btn-danger]="esFavorita()"
        [class.btn-outline-danger]="!esFavorita()">
        <!-- esFavorita() se lee con paréntesis porque es un signal -->
        {{ esFavorita() ? '❤️' : '🤍' }}
      </button>
    </div>
  </div>
</div>
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
      poster_path: '/pB8BM7pdSp6B6Ih7QI4S2t0POoD.jpg',
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
      this.favoritasIds.delete(movie.id);
    } else {
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
        <!-- [movie]="movie" pasa la película al hijo (property binding a input()) -->
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

💡 **Desde el padre, la sintaxis `[movie]="valor"` es idéntica** tanto con `input()` como con el antiguo `@Input()`. El cambio está en cómo el hijo define y lee la propiedad.

---

## 3.3 output(): emitir eventos de hijo a padre

`output()` permite que un componente hijo notifique al padre cuando algo pasa (como hacer click en favorito). Reemplaza a `@Output()` + `EventEmitter`.

✏️ Modificar `movie-card.component.ts` para agregar el output:

```typescript
// movie-card.component.ts
// Componente con input() (recibe datos) y output() (emite eventos)
import { Component, input, output } from '@angular/core';
// output se importa del core de Angular (función, no decorador)
import { Movie } from '../../models/movie';

@Component({
  selector: 'app-movie-card',
  standalone: true,
  imports: [],
  templateUrl: './movie-card.component.html',
  styleUrls: ['./movie-card.component.scss']
})
export class MovieCardComponent {
  // Entrada: datos que recibe del padre (signals)
  movie = input.required<Movie>();
  esFavorita = input<boolean>(false);

  // Salida: evento que emite hacia el padre
  // output<Movie>() crea un OutputEmitterRef que emite objetos Movie
  // Reemplaza a @Output() toggleFavorito = new EventEmitter<Movie>()
  toggleFavorito = output<Movie>();

  // Método que se ejecuta al hacer click en el botón de favorito
  onToggleFavorito(): void {
    // .emit() envía el evento al padre con la película como dato
    this.toggleFavorito.emit(this.movie());
    // Notar: this.movie() con paréntesis porque es un signal
  }
}
```

✏️ Actualizar el botón de favorito en `movie-card.component.html`:

```html
<!-- Reemplazar el botón de favorito por este -->
<button
  class="btn"
  [class.btn-danger]="esFavorita()"
  [class.btn-outline-danger]="!esFavorita()"
  (click)="onToggleFavorito()">
  <!-- (click) llama al método que emite el evento -->
  {{ esFavorita() ? '❤️' : '🤍' }}
</button>
```

---

## 3.4 Comparación: API antigua vs. moderna

| Concepto | Antes (decoradores) | Ahora (signals) |
|----------|---------------------|------------------|
| Entrada obligatoria | `@Input({ required: true }) movie!: Movie;` | `movie = input.required<Movie>();` |
| Entrada con default | `@Input() esFavorita: boolean = false;` | `esFavorita = input<boolean>(false);` |
| Salida de evento | `@Output() toggle = new EventEmitter<Movie>();` | `toggle = output<Movie>();` |
| Leer en template | `{{ movie.title }}` | `{{ movie().title }}` |
| Leer en clase | `this.movie` | `this.movie()` |
| Emitir evento | `this.toggle.emit(valor)` | `this.toggle.emit(valor)` |

💡 **¿Por qué cambiar?** La API de signals es más concisa, tiene mejor inferencia de tipos, y se integra con el sistema de reactividad de Angular (signals, computed, effect). Angular recomienda usar `input()` y `output()` en proyectos nuevos.

---

## 3.5 Componentes inteligentes vs. componentes de presentación

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

💡 **Regla:** los componentes de presentación no conocen servicios ni lógica de negocio. Solo reciben datos por `input()` y emiten eventos por `output()`.

---

## 3.6 Proyección de contenido con ng-content

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

## 3.7 Compilar y probar

▶️ Ejecutar `ng serve`. Deberían ver:
- Tres tarjetas con películas diferentes (Fight Club, Pulp Fiction, Forrest Gump)
- Al hacer click en 🤍, cambia a ❤️ (y viceversa)
- Cada tarjeta es independiente: marcar una como favorita no afecta a las otras

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| `signal()` | Crear un valor reactivo que notifica cambios |
| `computed()` | Valor derivado que se recalcula automáticamente |
| `input()` | Recibir datos del componente padre (signal) |
| `input.required()` | Entrada obligatoria del padre |
| `output()` | Emitir eventos hacia el componente padre |
| `[propiedad]="valor"` | Pasar datos al hijo (property binding) |
| `(evento)="metodo($event)"` | Escuchar eventos del hijo |
| Smart vs. Dumb components | Separar lógica de presentación |
| `ng-content` | Insertar HTML del padre dentro del hijo |

---

**Anterior:** [← Capítulo 2 — Componentes](02_componentes.md) | **Siguiente:** [Capítulo 4 — Servicios →](04_servicios.md)
