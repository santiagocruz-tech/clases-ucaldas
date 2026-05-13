# Capítulo 9: Pipes

## Objetivo

Aprender a usar y crear pipes para transformar datos en los templates. Al final de este capítulo, CineExplorer tendrá pipes personalizados para truncar texto, construir URLs de imágenes y mostrar estrellas.

---

## 9.1 ¿Qué son los Pipes?

Los pipes transforman datos en el template sin modificar el dato original. Se aplican con el operador `|`.

```html
<!-- Sin pipe: muestra la fecha cruda -->
<p>{{ fecha }}</p>
<!-- Resultado: 2024-03-15T10:30:00.000Z -->

<!-- Con pipe: formatea la fecha -->
<p>{{ fecha | date:'longDate' }}</p>
<!-- Resultado: 15 de marzo de 2024 -->
```

---

## 9.2 Pipes built-in

### date — Formatear fechas

```html
<p>{{ fecha | date }}</p>                    <!-- Mar 15, 2024 -->
<p>{{ fecha | date:'short' }}</p>            <!-- 3/15/24, 10:30 AM -->
<p>{{ fecha | date:'longDate' }}</p>         <!-- March 15, 2024 -->
<p>{{ fecha | date:'dd/MM/yyyy' }}</p>       <!-- 15/03/2024 -->
```

### currency — Formatear moneda

```html
<p>{{ precio | currency }}</p>               <!-- $1,500.00 -->
<p>{{ precio | currency:'EUR' }}</p>         <!-- €1,500.00 -->
<p>{{ precio | currency:'COP':'symbol':'1.0-0' }}</p>  <!-- $1,500 -->
```

### uppercase / lowercase / titlecase

```html
<p>{{ nombre | uppercase }}</p>     <!-- ANA GARCÍA -->
<p>{{ nombre | lowercase }}</p>     <!-- ana garcía -->
<p>{{ nombre | titlecase }}</p>     <!-- Ana García -->
```

### json — Debug de objetos

```html
<!-- Muy útil para depurar: muestra el objeto completo formateado -->
<pre>{{ pelicula | json }}</pre>
```

### async — Suscripción automática a Observables

```html
<!-- async pipe se suscribe al Observable y muestra el valor -->
<!-- Se desuscribe automáticamente cuando el componente se destruye -->
@if (peliculas$ | async; as peliculas) {
  @for (pelicula of peliculas; track pelicula.id) {
    <app-movie-card [movie]="pelicula" />
  }
} @else {
  <div class="spinner-border"></div>
}
```

### Encadenar pipes

```html
<!-- Los pipes se pueden encadenar: el resultado de uno es la entrada del siguiente -->
<p>{{ nombre | lowercase | titlecase }}</p>
<p>{{ fecha | date:'longDate' | uppercase }}</p>
```

---

## 9.3 Crear pipes personalizados

```bash
# Generar un pipe con Angular CLI
ng generate pipe pipes/truncate
ng g p pipes/truncate    # Atajo
```

### TruncatePipe — Truncar texto largo

📁 Crear `src/app/pipes/truncate.pipe.ts`:

```typescript
// truncate.pipe.ts
// Pipe que trunca texto largo y agrega "..." al final
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  // name: nombre que se usa en el template con |
  name: 'truncate',
  // standalone: true para poder importarlo directamente
  standalone: true
})
// PipeTransform obliga a implementar el método transform()
export class TruncatePipe implements PipeTransform {
  // transform recibe el valor original y parámetros opcionales
  // value: el texto a truncar
  // limit: máximo de caracteres (por defecto 100)
  // trail: texto que se agrega al final (por defecto "...")
  transform(value: string, limit: number = 100, trail: string = '...'): string {
    // Si no hay valor, retornar vacío
    if (!value) return '';
    // Si el texto es más corto que el límite, retornarlo completo
    if (value.length <= limit) return value;
    // Cortar el texto y agregar el trail
    return value.substring(0, limit).trim() + trail;
  }
}
```

### TmdbImagePipe — Construir URLs de imágenes TMDB

📁 Crear `src/app/pipes/tmdb-image.pipe.ts`:

```typescript
// tmdb-image.pipe.ts
// Pipe que construye la URL completa de una imagen de TMDB
// TMDB devuelve rutas relativas como "/jSziioSwPVrOy9Yow3XhWIBDjq1.jpg"
// Este pipe las convierte en URLs completas
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'tmdbImage',
  standalone: true
})
export class TmdbImagePipe implements PipeTransform {
  // URL base de las imágenes de TMDB
  private baseUrl = 'https://image.tmdb.org/t/p/';

  // path: ruta relativa de la imagen (puede ser null si no hay imagen)
  // size: tamaño de la imagen (w200, w300, w500, original)
  transform(path: string | null, size: string = 'w500'): string {
    // Si no hay path, retornar imagen por defecto
    if (!path) {
      return 'assets/no-image.png';
    }
    // Concatenar base URL + tamaño + path
    return `${this.baseUrl}${size}${path}`;
  }
}
```

### StarsPipe — Convertir puntuación a estrellas

📁 Crear `src/app/pipes/stars.pipe.ts`:

```typescript
// stars.pipe.ts
// Pipe que convierte una puntuación numérica (0-10) en estrellas visuales
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'stars',
  standalone: true
})
export class StarsPipe implements PipeTransform {
  // value: puntuación de 0 a 10
  // maxStars: cantidad máxima de estrellas (por defecto 5)
  transform(value: number, maxStars: number = 5): string {
    // Convertir escala 0-10 a escala 0-maxStars
    // Math.round redondea al entero más cercano
    const filledStars = Math.round((value / 10) * maxStars);
    // Crear string de estrellas llenas + estrellas vacías
    const filled = '★'.repeat(filledStars);
    const empty = '☆'.repeat(maxStars - filledStars);
    return filled + empty;
  }
}
```

---

## 9.4 Usar pipes en MovieCardComponent

Vamos a refactorizar el template de `MovieCardComponent` para usar los pipes que acabamos de crear. Esto reemplaza la concatenación manual de URLs y el truncado con `.slice()` que teníamos antes.

✏️ Modificar `movie-card.component.ts` para importar los pipes:

```typescript
// movie-card.component.ts
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { RouterLink } from '@angular/router';
import { NgClass } from '@angular/common';
import { Movie } from '../../models/movie';
// Importar los pipes personalizados
import { TruncatePipe } from '../../pipes/truncate.pipe';
import { TmdbImagePipe } from '../../pipes/tmdb-image.pipe';
import { StarsPipe } from '../../pipes/stars.pipe';

@Component({
  selector: 'app-movie-card',
  standalone: true,
  // Agregar los pipes a imports para usarlos en el template
  imports: [RouterLink, NgClass, TruncatePipe, TmdbImagePipe, StarsPipe],
  templateUrl: './movie-card.component.html',
  styleUrls: ['./movie-card.component.scss']
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

✏️ Modificar `movie-card.component.html` para usar los pipes:

```html
<!-- movie-card.component.html -->
<!-- Tarjeta usando pipes personalizados -->
<div class="card shadow-sm h-100">
  <!-- tmdbImage pipe construye la URL completa de la imagen -->
  <!-- En lugar de concatenar manualmente, usamos el pipe -->
  <img [src]="movie.poster_path | tmdbImage:'w500'"
       [alt]="movie.title"
       class="card-img-top">

  <div class="card-body d-flex flex-column">
    <h5 class="card-title">{{ movie.title }}</h5>

    <!-- stars pipe convierte 8.4 → "★★★★☆" -->
    <p class="mb-1">{{ movie.vote_average | stars }}</p>
    <small class="text-muted mb-2">{{ movie.vote_average }} / 10</small>

    <!-- truncate pipe corta el texto a 120 caracteres -->
    <!-- Más limpio que hacer el slice en el template -->
    <p class="card-text flex-grow-1">
      {{ movie.overview | truncate:120 }}
    </p>

    <div class="d-flex gap-2 mt-auto">
      <a [routerLink]="['/movie', movie.id]"
         class="btn btn-outline-primary flex-grow-1">
        Ver detalle
      </a>
      <button class="btn"
              [ngClass]="esFavorita ? 'btn-danger' : 'btn-outline-danger'"
              (click)="onToggleFavorito()">
        {{ esFavorita ? '❤️' : '🤍' }}
      </button>
    </div>
  </div>
</div>
```

---

## 9.5 Pipes puros vs. impuros

| Tipo | Cuándo se re-ejecuta | Rendimiento |
|------|---------------------|-------------|
| Puro (default) | Solo cuando cambia la referencia del valor | Eficiente |
| Impuro | En cada ciclo de detección de cambios | Costoso |

```typescript
// Pipe puro (por defecto): pure: true
@Pipe({ name: 'miPipe', standalone: true, pure: true })

// Pipe impuro: pure: false (usar con precaución)
@Pipe({ name: 'miPipe', standalone: true, pure: false })
```

💡 **Regla:** usar pipes puros siempre. Si necesitan un pipe impuro, probablemente hay una mejor solución.

---

## 9.6 Compilar y probar

▶️ Verificar que:
1. Las imágenes se cargan correctamente (pipe tmdbImage)
2. Las sinopsis se truncan a 120 caracteres (pipe truncate)
3. Las puntuaciones se muestran como estrellas (pipe stars)

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| Pipe `\|` | Transformar datos en el template |
| `date`, `currency`, `uppercase` | Pipes built-in de Angular |
| `async` | Suscripción automática a Observables |
| `@Pipe` | Decorador para crear pipes personalizados |
| `PipeTransform` | Interface que obliga a implementar `transform()` |
| Pipes puros | Se ejecutan solo cuando cambia la referencia (eficientes) |
| `TruncatePipe` | Truncar texto largo |
| `TmdbImagePipe` | Construir URLs de imágenes TMDB |
| `StarsPipe` | Convertir puntuación a estrellas visuales |

---

**Anterior:** [← Capítulo 8 — Formularios](08_formularios.md) | **Siguiente:** [Capítulo 10 — localStorage →](10_localstorage.md)
