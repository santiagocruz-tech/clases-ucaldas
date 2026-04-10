# 2. Componentes

## ¿Qué es un componente en Angular?

Un componente es una pieza reutilizable de la interfaz. Cada componente controla una parte de la pantalla: un navbar, una tarjeta, un formulario, una página completa.

Una aplicación Angular es un árbol de componentes:

```
AppComponent
├── NavbarComponent
├── HomeComponent
│   ├── HeroComponent
│   ├── MovieCardComponent
│   └── MovieCardComponent
└── FooterComponent
```

---

## Anatomía de un componente

Un componente tiene 4 partes:

```typescript
// movie-card.component.ts
import { Component } from '@angular/core';

@Component({
    selector: 'app-movie-card',          // Nombre de la etiqueta HTML
    templateUrl: './movie-card.component.html',  // Template
    styleUrls: ['./movie-card.component.scss'],  // Estilos
    standalone: true                      // Componente independiente
})
export class MovieCardComponent {
    // Lógica del componente (propiedades y métodos)
    titulo: string = 'Película de ejemplo';
    puntuacion: number = 8.5;
}
```

### Componente inline (template y estilos en el mismo archivo)

```typescript
@Component({
    selector: 'app-saludo',
    standalone: true,
    template: `<h2>Hola, {{ nombre }}</h2>`,
    styles: [`h2 { color: blue; }`]
})
export class SaludoComponent {
    nombre: string = 'Mundo';
}
```

---

## Crear componentes con Angular CLI

```bash
# Crear componente (genera 4 archivos: .ts, .html, .scss, .spec.ts)
ng generate component components/movie-card
ng g c components/movie-card    # Atajo

# Crear sin archivo de test
ng g c components/movie-card --skip-tests

# Crear con template inline
ng g c components/saludo --inline-template
```

Archivos generados:
```
components/movie-card/
├── movie-card.component.ts
├── movie-card.component.html
├── movie-card.component.scss
└── movie-card.component.spec.ts
```

---

## Data Binding

El data binding conecta los datos de la clase con el template HTML.

### 1. Interpolación `{{ }}`

Muestra valores de la clase en el HTML.

```typescript
// componente
export class PerfilComponent {
    nombre: string = 'Ana García';
    edad: number = 28;
    activo: boolean = true;
}
```

```html
<!-- template -->
<h1>{{ nombre }}</h1>
<p>Edad: {{ edad }}</p>
<p>Estado: {{ activo ? 'Activo' : 'Inactivo' }}</p>
<p>Nombre en mayúsculas: {{ nombre.toUpperCase() }}</p>
```

### 2. Property Binding `[propiedad]`

Vincula una propiedad del DOM a un valor de la clase.

```typescript
export class ImagenComponent {
    urlImagen: string = 'https://ejemplo.com/foto.jpg';
    altTexto: string = 'Foto de perfil';
    deshabilitado: boolean = true;
}
```

```html
<img [src]="urlImagen" [alt]="altTexto">
<button [disabled]="deshabilitado">Enviar</button>
<div [class.activo]="deshabilitado">Contenido</div>
<div [style.color]="deshabilitado ? 'gray' : 'black'">Texto</div>
```

### 3. Event Binding `(evento)`

Escucha eventos del DOM y ejecuta métodos de la clase.

```typescript
export class ContadorComponent {
    contador: number = 0;

    incrementar(): void {
        this.contador++;
    }

    decrementar(): void {
        this.contador--;
    }

    manejarInput(evento: Event): void {
        const input = evento.target as HTMLInputElement;
        console.log(input.value);
    }
}
```

```html
<p>Contador: {{ contador }}</p>
<button (click)="incrementar()">+</button>
<button (click)="decrementar()">-</button>
<input (input)="manejarInput($event)" placeholder="Escribe algo">
```

### 4. Two-Way Binding `[(ngModel)]`

Vinculación bidireccional: el dato se actualiza en ambas direcciones.

```typescript
import { FormsModule } from '@angular/forms';

@Component({
    // ...
    imports: [FormsModule]  // Necesario para ngModel
})
export class BuscadorComponent {
    termino: string = '';
}
```

```html
<input [(ngModel)]="termino" placeholder="Buscar...">
<p>Buscando: {{ termino }}</p>
```

---

## Directivas estructurales (sintaxis moderna)

Angular 17+ introdujo una nueva sintaxis de control de flujo en los templates.

### @if — Condicional

```html
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
<div class="row">
    @for (pelicula of peliculas; track pelicula.id) {
        <div class="col-md-4">
            <app-movie-card [pelicula]="pelicula" />
        </div>
    } @empty {
        <p>No se encontraron películas</p>
    }
</div>
```

`track` es obligatorio. Le dice a Angular cómo identificar cada elemento para optimizar el renderizado. Usar siempre un ID único.

### @switch — Selección múltiple

```html
@switch (estado) {
    @case ('cargando') {
        <div class="spinner"></div>
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

## Directivas de atributo

### ngClass

```html
<!-- Con objeto -->
<div [ngClass]="{ 'activo': esActivo, 'destacado': esDestacado }">
    Contenido
</div>

<!-- Con expresión -->
<div [ngClass]="esActivo ? 'clase-activa' : 'clase-inactiva'">
    Contenido
</div>
```

### ngStyle

```html
<div [ngStyle]="{
    'background-color': color,
    'font-size': tamano + 'px',
    'font-weight': negrita ? 'bold' : 'normal'
}">
    Texto con estilos dinámicos
</div>
```

---

## Ciclo de vida de un componente

Angular ejecuta métodos en momentos específicos de la vida de un componente.

```typescript
import { Component, OnInit, OnDestroy } from '@angular/core';

@Component({ ... })
export class MiComponente implements OnInit, OnDestroy {

    // Se ejecuta UNA VEZ después de crear el componente
    // Ideal para: cargar datos, inicializar valores
    ngOnInit(): void {
        console.log('Componente inicializado');
        // Aquí se hacen las llamadas HTTP
    }

    // Se ejecuta cuando el componente se destruye
    // Ideal para: limpiar suscripciones, timers
    ngOnDestroy(): void {
        console.log('Componente destruido');
    }
}
```

### Hooks más usados

| Hook | Cuándo se ejecuta | Uso típico |
|---|---|---|
| `ngOnInit` | Después de crear el componente | Cargar datos, inicializar |
| `ngOnDestroy` | Antes de destruir el componente | Limpiar suscripciones |
| `ngOnChanges` | Cuando cambia un @Input() | Reaccionar a cambios de datos |

---

## Ejercicios

### Ejercicio 1: Componente de perfil
Crear un componente `PerfilComponent` que muestre nombre, email y avatar. Usar interpolación y property binding.

### Ejercicio 2: Contador interactivo
Crear un componente con un contador que se pueda incrementar, decrementar y resetear usando event binding.

### Ejercicio 3: Lista de tareas simple
Crear un componente que tenga un array de tareas. Usar `@for` para mostrarlas y `@if` para mostrar un mensaje cuando la lista esté vacía. Agregar un input con two-way binding para agregar nuevas tareas.

### Ejercicio 4: Tarjeta de producto
Crear un componente `ProductCardComponent` que muestre la información de un producto con estilos dinámicos usando ngClass (por ejemplo, clase "agotado" si stock es 0).
