# 9. Pipes

## ¿Qué son los Pipes?

Los pipes transforman datos en el template sin modificar el dato original. Se aplican con el operador `|`.

```html
<!-- Sin pipe -->
<p>{{ fecha }}</p>
<!-- Muestra: 2024-03-15T10:30:00.000Z -->

<!-- Con pipe -->
<p>{{ fecha | date:'longDate' }}</p>
<!-- Muestra: 15 de marzo de 2024 -->
```

---

## Pipes built-in

### date — Formatear fechas

```html
<p>{{ fecha | date }}</p>                    <!-- Mar 15, 2024 -->
<p>{{ fecha | date:'short' }}</p>            <!-- 3/15/24, 10:30 AM -->
<p>{{ fecha | date:'longDate' }}</p>         <!-- March 15, 2024 -->
<p>{{ fecha | date:'dd/MM/yyyy' }}</p>       <!-- 15/03/2024 -->
<p>{{ fecha | date:'EEEE, d MMMM y' }}</p>  <!-- Friday, 15 March 2024 -->
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
<!-- Muy útil para depurar -->
<pre>{{ pelicula | json }}</pre>
```

### async — Suscripción automática a Observables

```typescript
export class HomeComponent {
    peliculas$ = this.tmdbService.obtenerPopulares().pipe(
        map(response => response.results)
    );
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

El `async` pipe:
- Se suscribe automáticamente al Observable.
- Se desuscribe cuando el componente se destruye.
- Actualiza la vista cuando llegan nuevos datos.

### Encadenar pipes

```html
<p>{{ nombre | lowercase | titlecase }}</p>
<p>{{ fecha | date:'longDate' | uppercase }}</p>
```

---

## Crear pipes personalizados

```bash
ng generate pipe pipes/truncate
ng g p pipes/truncate
```

### Pipe para truncar texto

```typescript
// pipes/truncate.pipe.ts
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
    name: 'truncate',
    standalone: true
})
export class TruncatePipe implements PipeTransform {
    transform(value: string, limit: number = 100, trail: string = '...'): string {
        if (!value) return '';
        if (value.length <= limit) return value;
        return value.substring(0, limit).trim() + trail;
    }
}
```

```html
<!-- Uso -->
<p>{{ pelicula.overview | truncate:150 }}</p>
<p>{{ pelicula.overview | truncate:80:'…' }}</p>
```

### Pipe para URL de imágenes TMDB

```typescript
// pipes/tmdb-image.pipe.ts
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
    name: 'tmdbImage',
    standalone: true
})
export class TmdbImagePipe implements PipeTransform {
    private baseUrl = 'https://image.tmdb.org/t/p/';

    transform(path: string | null, size: string = 'w500'): string {
        if (!path) {
            return 'assets/no-image.png';  // Imagen por defecto
        }
        return `${this.baseUrl}${size}${path}`;
    }
}
```

```html
<!-- Uso -->
<img [src]="pelicula.poster_path | tmdbImage" [alt]="pelicula.title">
<img [src]="pelicula.poster_path | tmdbImage:'w300'" [alt]="pelicula.title">
<img [src]="pelicula.backdrop_path | tmdbImage:'original'" [alt]="pelicula.title">
```

### Pipe para tiempo relativo

```typescript
// pipes/time-ago.pipe.ts
@Pipe({
    name: 'timeAgo',
    standalone: true
})
export class TimeAgoPipe implements PipeTransform {
    transform(value: string): string {
        if (!value) return '';

        const fecha = new Date(value);
        const ahora = new Date();
        const diferencia = ahora.getTime() - fecha.getTime();

        const minutos = Math.floor(diferencia / 60000);
        const horas = Math.floor(diferencia / 3600000);
        const dias = Math.floor(diferencia / 86400000);

        if (minutos < 1) return 'Hace un momento';
        if (minutos < 60) return `Hace ${minutos} minutos`;
        if (horas < 24) return `Hace ${horas} horas`;
        if (dias < 30) return `Hace ${dias} días`;

        return fecha.toLocaleDateString('es-ES');
    }
}
```

---

## Pipes puros vs. impuros

### Pipe puro (por defecto)

Angular solo re-ejecuta el pipe cuando cambia la referencia del valor de entrada. Es más eficiente.

```typescript
@Pipe({ name: 'miPipe', standalone: true, pure: true })  // pure: true es el default
```

### Pipe impuro

Se re-ejecuta en cada ciclo de detección de cambios. Usar con precaución.

```typescript
@Pipe({ name: 'miPipe', standalone: true, pure: false })
```

**Regla:** usar pipes puros siempre. Si necesitás un pipe impuro, probablemente hay una mejor solución.

---

## Usar pipes en componentes

Para usar un pipe personalizado, importarlo en el componente:

```typescript
@Component({
    selector: 'app-movie-card',
    standalone: true,
    imports: [TruncatePipe, TmdbImagePipe],
    templateUrl: './movie-card.component.html'
})
export class MovieCardComponent {
    @Input({ required: true }) movie!: Movie;
}
```

```html
<div class="card">
    <img [src]="movie.poster_path | tmdbImage:'w300'" [alt]="movie.title">
    <div class="card-body">
        <h5>{{ movie.title }}</h5>
        <p>{{ movie.overview | truncate:120 }}</p>
    </div>
</div>
```

---

## Ejercicios

### Ejercicio 1: Pipe de estrellas
Crear un pipe `stars` que reciba un número (ej: 7.5) y retorne estrellas: "★★★★☆" (sobre 5, redondeando).

### Ejercicio 2: Pipe de filtro
Crear un pipe `filterBy` que filtre un array de objetos por una propiedad. Uso: `peliculas | filterBy:'genre':'Action'`.

### Ejercicio 3: Pipe de moneda local
Crear un pipe `localCurrency` que formatee números como moneda local (ej: 1500000 → "$1.500.000 COP").

### Ejercicio 4: Aplicar pipes al proyecto
Usar `TruncatePipe` y `TmdbImagePipe` en el componente de tarjeta de película. Usar `async` pipe para mostrar datos de un Observable sin `subscribe()`.
