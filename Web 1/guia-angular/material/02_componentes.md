# Capítulo 2: Componentes

## Objetivo

Entender qué es un componente en Angular, cómo funciona el data binding y las directivas. Al final de este capítulo, CineExplorer tendrá un componente `MovieCardComponent` y una página Home que muestra películas con datos de ejemplo.

---

## 2.1 ¿Qué es un componente?

Un componente es una pieza reutilizable de la interfaz. Cada componente controla una parte de la pantalla: un navbar, una tarjeta, un formulario, una página completa.

Una aplicación Angular es un árbol de componentes:

```
AppComponent
├── NavbarComponent
├── HomeComponent
│   ├── MovieCardComponent
│   ├── MovieCardComponent
│   └── MovieCardComponent
└── FooterComponent
```

---

## 2.2 Anatomía de un componente

Un componente tiene 4 partes:

```typescript
// movie-card.component.ts
// Importar Component del core de Angular
import { Component } from '@angular/core';

// @Component es un decorador que configura el componente
@Component({
  // selector: nombre de la etiqueta HTML para usar este componente
  // Se usa como <app-movie-card></app-movie-card> en otros templates
  selector: 'app-movie-card',
  // standalone: true = componente independiente (no necesita módulo)
  // Es la forma moderna de Angular 17+
  standalone: true,
  // imports: otros componentes/módulos que este componente necesita
  imports: [],
  // templateUrl: ruta al archivo HTML del componente
  templateUrl: './movie-card.component.html',
  // styleUrls: ruta al archivo de estilos (solo afecta a este componente)
  styleUrls: ['./movie-card.component.scss']
})
// La clase contiene la lógica: propiedades y métodos
export class MovieCardComponent {
  // Propiedades que se pueden usar en el template
  titulo: string = 'Película de ejemplo';
  puntuacion: number = 8.5;
}
```

---

## 2.3 Crear componentes con Angular CLI

```bash
# Crear componente (genera 4 archivos: .ts, .html, .scss, .spec.ts)
ng generate component components/movie-card
ng g c components/movie-card    # Atajo

# Crear sin archivo de test
ng g c components/movie-card --skip-tests

# Crear con template inline (todo en un solo archivo)
ng g c components/saludo --inline-template --inline-style
```

Archivos generados:
```
components/movie-card/
├── movie-card.component.ts       ← Lógica del componente
├── movie-card.component.html     ← Template HTML
├── movie-card.component.scss     ← Estilos (solo afectan a este componente)
└── movie-card.component.spec.ts  ← Tests (opcional)
```

---

## 2.4 Data Binding

El data binding conecta los datos de la clase TypeScript con el template HTML.

### Interpolación `{{ }}`

Muestra valores de la clase en el HTML:

```typescript
// perfil.component.ts
export class PerfilComponent {
  nombre: string = 'Ana García';   // propiedad de la clase
  edad: number = 28;
  activo: boolean = true;
}
```

```html
<!-- perfil.component.html -->
<!-- {{ }} inserta el valor de la propiedad en el HTML -->
<h1>{{ nombre }}</h1>
<p>Edad: {{ edad }}</p>
<!-- Se pueden usar expresiones dentro de {{ }} -->
<p>Estado: {{ activo ? 'Activo' : 'Inactivo' }}</p>
<p>Nombre en mayúsculas: {{ nombre.toUpperCase() }}</p>
```

### Property Binding `[propiedad]`

Vincula una propiedad del DOM a un valor de la clase:

```typescript
// imagen.component.ts
export class ImagenComponent {
  urlImagen: string = 'https://image.tmdb.org/t/p/w500/poster.jpg';
  altTexto: string = 'Póster de película';
  deshabilitado: boolean = true;
}
```

```html
<!-- [propiedad]="valor" vincula una propiedad del DOM -->
<!-- Es diferente a interpolación: [src] acepta cualquier tipo, {{ }} solo strings -->
<img [src]="urlImagen" [alt]="altTexto">
<button [disabled]="deshabilitado">Enviar</button>
<!-- [class.nombre] agrega/quita una clase CSS según la condición -->
<div [class.activo]="deshabilitado">Contenido</div>
<!-- [style.propiedad] establece un estilo inline -->
<div [style.color]="deshabilitado ? 'gray' : 'black'">Texto</div>
```

### Event Binding `(evento)`

Escucha eventos del DOM y ejecuta métodos de la clase:

```typescript
// contador.component.ts
export class ContadorComponent {
  contador: number = 0;

  // Método que se ejecuta al hacer click
  incrementar(): void {
    this.contador++;
  }

  decrementar(): void {
    this.contador--;
  }

  // $event contiene información del evento del DOM
  manejarInput(evento: Event): void {
    // Castear el target a HTMLInputElement para acceder a .value
    const input = evento.target as HTMLInputElement;
    console.log(input.value);
  }
}
```

```html
<!-- (evento)="metodo()" ejecuta el método cuando ocurre el evento -->
<p>Contador: {{ contador }}</p>
<button (click)="incrementar()">+</button>
<button (click)="decrementar()">-</button>
<!-- $event pasa el objeto del evento al método -->
<input (input)="manejarInput($event)" placeholder="Escribe algo">
```

### Two-Way Binding `[(ngModel)]`

Vinculación bidireccional: el dato se actualiza en ambas direcciones (clase ↔ template):

```typescript
// buscador.component.ts
// FormsModule es necesario para usar ngModel
import { FormsModule } from '@angular/forms';

@Component({
  // ...
  // Importar FormsModule para habilitar ngModel
  imports: [FormsModule]
})
export class BuscadorComponent {
  termino: string = '';  // se sincroniza con el input
}
```

```html
<!-- [(ngModel)] sincroniza el valor del input con la propiedad -->
<!-- Si el usuario escribe, termino se actualiza -->
<!-- Si termino cambia desde código, el input se actualiza -->
<input [(ngModel)]="termino" placeholder="Buscar películas...">
<p>Buscando: {{ termino }}</p>
```

---

## 2.5 Directivas estructurales (sintaxis moderna Angular 17+)

### @if — Condicional

```html
<!-- @if muestra u oculta contenido según una condición -->
@if (usuario) {
  <p>Bienvenido, {{ usuario.nombre }}</p>
} @else if (cargando) {
  <p>Cargando...</p>
} @else {
  <p>No has iniciado sesión</p>
}
```

### @for — Iteración

```html
<!-- @for recorre un array y renderiza contenido por cada elemento -->
<!-- track es OBLIGATORIO: le dice a Angular cómo identificar cada elemento -->
<!-- Usar siempre un ID único para optimizar el renderizado -->
<div class="row">
  @for (pelicula of peliculas; track pelicula.id) {
    <div class="col-md-4">
      <app-movie-card [pelicula]="pelicula" />
    </div>
  } @empty {
    <!-- @empty se muestra cuando el array está vacío -->
    <p>No se encontraron películas</p>
  }
</div>
```

### @switch — Selección múltiple

```html
<!-- @switch evalúa una expresión y muestra el caso que coincida -->
@switch (estado) {
  @case ('cargando') {
    <div class="spinner-border"></div>
  }
  @case ('error') {
    <div class="alert alert-danger">Ocurrió un error</div>
  }
  @case ('exito') {
    <div class="alert alert-success">Datos cargados</div>
  }
  @default {
    <p>Estado desconocido</p>
  }
}
```

---

## 2.6 Directivas de atributo

### ngClass — Clases CSS dinámicas

```html
<!-- [ngClass] con objeto: agrega la clase si la condición es true -->
<div [ngClass]="{ 'activo': esActivo, 'destacado': esDestacado }">
  Contenido
</div>

<!-- [ngClass] con expresión ternaria -->
<div [ngClass]="esActivo ? 'clase-activa' : 'clase-inactiva'">
  Contenido
</div>
```

### ngStyle — Estilos inline dinámicos

```html
<!-- [ngStyle] establece estilos CSS dinámicamente -->
<div [ngStyle]="{
  'background-color': color,
  'font-size': tamano + 'px',
  'font-weight': negrita ? 'bold' : 'normal'
}">
  Texto con estilos dinámicos
</div>
```

---

## 2.7 Ciclo de vida de un componente

Angular ejecuta métodos específicos en momentos clave de la vida de un componente:

```typescript
// Importar las interfaces del ciclo de vida
import { Component, OnInit, OnDestroy } from '@angular/core';

@Component({ /* ... */ })
// "implements OnInit, OnDestroy" obliga a implementar los métodos
export class MiComponente implements OnInit, OnDestroy {

  // ngOnInit: se ejecuta UNA VEZ después de crear el componente
  // Ideal para: cargar datos de una API, inicializar valores
  // Es el equivalente a "componentDidMount" en React
  ngOnInit(): void {
    console.log('Componente inicializado');
    // Aquí se hacen las llamadas HTTP
  }

  // ngOnDestroy: se ejecuta cuando el componente se destruye
  // Ideal para: limpiar suscripciones, cancelar timers
  ngOnDestroy(): void {
    console.log('Componente destruido');
  }
}
```

| Hook | Cuándo se ejecuta | Uso típico |
|---|---|---|
| `ngOnInit` | Después de crear el componente | Cargar datos, inicializar |
| `ngOnDestroy` | Antes de destruir el componente | Limpiar suscripciones |
| `ngOnChanges` | Cuando cambia un input() | Reaccionar a cambios de datos del padre |

💡 **Con signals**, muchos usos de `ngOnChanges` se reemplazan por `effect()` o `computed()`, que reaccionan automáticamente cuando un signal cambia. Lo veremos en el próximo capítulo.

---

## 2.8 Aplicar al proyecto: MovieCard y página Home

Vamos a crear el componente de tarjeta de película y la página principal de CineExplorer.

📁 Crear el componente MovieCard:

```bash
ng g c components/movie-card --skip-tests
```

✏️ `src/app/components/movie-card/movie-card.component.ts`:

```typescript
// movie-card.component.ts
// Componente que muestra una tarjeta con la información de una película
import { Component } from '@angular/core';
// Importar la interfaz Movie que creamos en el capítulo 1
import { Movie } from '../../models/movie';

@Component({
  selector: 'app-movie-card',
  standalone: true,
  imports: [],
  templateUrl: './movie-card.component.html',
  styleUrls: ['./movie-card.component.scss']
})
export class MovieCardComponent {
  // Por ahora usamos datos de ejemplo hardcodeados
  // En el próximo capítulo recibiremos los datos del componente padre con @Input
  pelicula: Movie = {
    id: 550,
    title: 'Fight Club',
    overview: 'Un oficinista insomne y un fabricante de jabón forman un club de pelea clandestino que evoluciona hacia algo mucho más peligroso.',
    poster_path: '/jSziioSwPVrOy9Yow3XhWIBDjq1.jpg',
    backdrop_path: '/hZkgoQYus5dXo3H8T7Uef6DNknx.jpg',
    vote_average: 8.4,
    release_date: '1999-10-15',
    genre_ids: [18, 53]
  };
}
```

✏️ `src/app/components/movie-card/movie-card.component.html`:

```html
<!-- movie-card.component.html -->
<!-- Tarjeta de película usando clases de Bootstrap -->
<div class="card shadow-sm h-100">
  <!-- shadow-sm: sombra suave -->
  <!-- h-100: altura 100% (para que todas las tarjetas tengan la misma altura) -->

  <!-- Imagen del póster -->
  <!-- Concatenamos la URL base de TMDB con el poster_path -->
  <img
    [src]="'https://image.tmdb.org/t/p/w500' + pelicula.poster_path"
    [alt]="pelicula.title"
    class="card-img-top">
  <!-- card-img-top: imagen en la parte superior de la tarjeta -->

  <!-- Cuerpo de la tarjeta -->
  <div class="card-body d-flex flex-column">
    <!-- d-flex flex-column: layout flexible vertical -->

    <!-- Título de la película -->
    <h5 class="card-title">{{ pelicula.title }}</h5>

    <!-- Puntuación con estrella -->
    <p class="text-muted mb-2">
      <!-- text-muted: color gris -->
      <!-- mb-2: margin-bottom pequeño -->
      ⭐ {{ pelicula.vote_average }} / 10
    </p>

    <!-- Sinopsis truncada -->
    <!-- Usamos slice para mostrar solo los primeros 120 caracteres -->
    <p class="card-text flex-grow-1">
      <!-- flex-grow-1: ocupa el espacio disponible (empuja el botón abajo) -->
      {{ pelicula.overview.length > 120
        ? pelicula.overview.slice(0, 120) + '...'
        : pelicula.overview }}
    </p>

    <!-- Botón de ver detalle -->
    <button class="btn btn-outline-primary mt-auto">
      <!-- mt-auto: margin-top automático (se pega al fondo) -->
      Ver detalle
    </button>
  </div>
</div>
```

✏️ `src/app/components/movie-card/movie-card.component.scss`:

```scss
// movie-card.component.scss
// Estilos que SOLO afectan a este componente (encapsulación de Angular)

// Efecto hover en la tarjeta
.card {
  // Transición suave al hacer hover
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  // cursor pointer para indicar que es clickeable
  cursor: pointer;

  &:hover {
    // Elevar la tarjeta ligeramente al pasar el mouse
    transform: translateY(-4px);
    // Sombra más pronunciada
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15) !important;
  }
}

// Limitar la altura de la imagen para consistencia
.card-img-top {
  height: 400px;
  // object-fit: cover recorta la imagen para llenar el espacio sin deformarla
  object-fit: cover;
}
```

Ahora creamos la página Home que muestra varias tarjetas:

✏️ Modificar `src/app/app.component.html`:

```html
<!-- app.component.html -->
<!-- Página principal de CineExplorer con tarjetas de ejemplo -->
<div class="container py-4">
  <!-- container: centra el contenido con márgenes -->
  <!-- py-4: padding vertical -->

  <!-- Encabezado -->
  <h1 class="display-5 mb-1">🎬 CineExplorer</h1>
  <p class="lead text-muted mb-4">Explora las mejores películas del mundo</p>

  <!-- Grid de tarjetas -->
  <!-- row: fila de Bootstrap -->
  <!-- g-4: gap (espacio) de 4 entre columnas -->
  <div class="row g-4">
    <!-- col-md-4: 3 columnas en pantallas medianas y grandes -->
    <!-- col-sm-6: 2 columnas en pantallas pequeñas -->
    <div class="col-sm-6 col-md-4">
      <app-movie-card />
    </div>
    <div class="col-sm-6 col-md-4">
      <app-movie-card />
    </div>
    <div class="col-sm-6 col-md-4">
      <app-movie-card />
    </div>
  </div>
</div>
```

✏️ Modificar `src/app/app.component.ts` para importar MovieCardComponent:

```typescript
// app.component.ts
import { Component } from '@angular/core';
// Importar el componente de tarjeta para poder usarlo en el template
import { MovieCardComponent } from './components/movie-card/movie-card.component';

@Component({
  selector: 'app-root',
  standalone: true,
  // Agregar MovieCardComponent a imports para que esté disponible en el template
  imports: [MovieCardComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  titulo: string = 'CineExplorer';
}
```

---

## 2.9 Compilar y probar

▶️ Ejecutar `ng serve` y abrir `http://localhost:4200`. Deberían ver:
- El título "CineExplorer" con subtítulo
- Tres tarjetas de película idénticas (Fight Club) con póster, título, puntuación y sinopsis
- Efecto hover al pasar el mouse sobre las tarjetas

💡 Las tres tarjetas muestran la misma película porque los datos están hardcodeados. En el próximo capítulo aprenderemos a pasar datos diferentes a cada tarjeta con `input()` (signals).

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| Componente | Pieza reutilizable de UI (template + lógica + estilos) |
| `@Component` | Decorador que configura un componente |
| `standalone: true` | Componente independiente (sin módulo) |
| Interpolación `{{ }}` | Mostrar valores en el HTML |
| Property binding `[prop]` | Vincular propiedades del DOM |
| Event binding `(event)` | Escuchar eventos del DOM |
| Two-way binding `[(ngModel)]` | Sincronización bidireccional |
| `@if` / `@for` / `@switch` | Control de flujo en templates |
| `ngClass` / `ngStyle` | Clases y estilos dinámicos |
| `ngOnInit` / `ngOnDestroy` | Hooks del ciclo de vida |

---

**Anterior:** [← Capítulo 1 — TypeScript](01_typescript.md) | **Siguiente:** [Capítulo 3 — Comunicación entre componentes →](03_comunicacion_componentes.md)
