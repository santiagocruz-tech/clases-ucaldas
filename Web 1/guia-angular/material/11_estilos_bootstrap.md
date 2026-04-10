# 11. Estilos, temas y Bootstrap en Angular

## Estilos globales vs. estilos por componente

### Estilos globales (styles.scss)

Afectan a toda la aplicación. Ideal para:
- Variables CSS.
- Reset/normalize.
- Estilos de Bootstrap personalizados.
- Temas (claro/oscuro).

```scss
/* src/styles.scss */
:root {
    --color-primario: #007bff;
    --color-fondo: #ffffff;
    --color-texto: #212529;
}

body {
    font-family: 'Inter', sans-serif;
    background-color: var(--color-fondo);
    color: var(--color-texto);
}
```

### Estilos por componente (encapsulación)

Cada componente tiene sus propios estilos que NO afectan a otros componentes. Angular logra esto con View Encapsulation.

```typescript
@Component({
    selector: 'app-movie-card',
    styleUrls: ['./movie-card.component.scss']
})
```

```scss
/* movie-card.component.scss */
/* Estos estilos SOLO afectan a este componente */
.card {
    transition: transform 0.2s;

    &:hover {
        transform: translateY(-4px);
    }
}

h5 {
    /* Solo afecta a los h5 dentro de este componente */
    text-transform: capitalize;
}
```

### ¿Cómo funciona la encapsulación?

Angular agrega un atributo único a cada componente:

```html
<!-- Angular genera esto internamente -->
<div _ngcontent-abc123 class="card">
    <h5 _ngcontent-abc123>Título</h5>
</div>
```

```css
/* Angular transforma los estilos a: */
.card[_ngcontent-abc123] { ... }
h5[_ngcontent-abc123] { ... }
```

### Acceder a estilos del host o hijos

```scss
/* Estilos del elemento host (el selector del componente) */
:host {
    display: block;
    margin-bottom: 1rem;
}

/* Penetrar la encapsulación (usar con precaución) */
:host ::ng-deep .clase-interna {
    color: red;
}
```

---

## Instalar y configurar Bootstrap en Angular

### Paso 1: Instalar

```bash
npm install bootstrap
```

### Paso 2: Configurar en angular.json

```json
{
    "architect": {
        "build": {
            "options": {
                "styles": [
                    "node_modules/bootstrap/dist/css/bootstrap.min.css",
                    "src/styles.scss"
                ],
                "scripts": [
                    "node_modules/bootstrap/dist/js/bootstrap.bundle.min.js"
                ]
            }
        }
    }
}
```

El orden importa: Bootstrap primero, estilos personalizados después (para poder sobreescribir).

### Paso 3: Usar en templates

```html
<!-- Ahora podés usar clases de Bootstrap en cualquier componente -->
<div class="container">
    <div class="row g-3">
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">Título</h5>
                </div>
            </div>
        </div>
    </div>
</div>
```

---

## Variables CSS y sistema de temas

### Definir variables globales

```scss
/* src/styles.scss */
:root {
    /* Colores */
    --color-primario: #007bff;
    --color-secundario: #6c757d;
    --color-exito: #28a745;
    --color-peligro: #dc3545;

    /* Fondos */
    --bg-primary: #ffffff;
    --bg-secondary: #f8f9fa;
    --bg-card: #ffffff;

    /* Texto */
    --text-primary: #212529;
    --text-secondary: #6c757d;

    /* Sombras */
    --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.12);
    --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
    --shadow-lg: 0 10px 25px rgba(0, 0, 0, 0.15);

    /* Bordes */
    --radius-sm: 0.25rem;
    --radius-md: 0.5rem;
    --radius-lg: 1rem;

    /* Espaciado */
    --spacing-xs: 0.25rem;
    --spacing-sm: 0.5rem;
    --spacing-md: 1rem;
    --spacing-lg: 1.5rem;
    --spacing-xl: 3rem;

    /* Tipografía */
    --font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
}

/* Tema oscuro */
[data-theme="dark"] {
    --bg-primary: #121212;
    --bg-secondary: #1e1e1e;
    --bg-card: #2d2d2d;
    --text-primary: #e0e0e0;
    --text-secondary: #aaaaaa;
    --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.3);
    --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.3);
    --shadow-lg: 0 10px 25px rgba(0, 0, 0, 0.4);
}
```

### Usar variables en componentes

```scss
/* movie-card.component.scss */
.card {
    background-color: var(--bg-card);
    box-shadow: var(--shadow-md);
    border-radius: var(--radius-md);
    transition: transform 0.2s, box-shadow 0.2s, background-color 0.3s;

    &:hover {
        transform: translateY(-4px);
        box-shadow: var(--shadow-lg);
    }
}

.card-title {
    color: var(--text-primary);
    font-family: var(--font-family);
}

.card-text {
    color: var(--text-secondary);
}
```

---

## Animaciones y transiciones CSS en componentes

### Transición de tema suave

```scss
/* styles.scss */
body {
    background-color: var(--bg-primary);
    color: var(--text-primary);
    transition: background-color 0.3s ease, color 0.3s ease;
}

.card, .navbar, .btn {
    transition: background-color 0.3s ease, color 0.3s ease, box-shadow 0.3s ease;
}
```

### Animación de entrada para tarjetas

```scss
/* movie-card.component.scss */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

:host {
    animation: fadeInUp 0.4s ease-out;
}
```

### Spinner de carga animado

```scss
/* spinner.component.scss */
.spinner {
    width: 40px;
    height: 40px;
    border: 4px solid var(--bg-secondary);
    border-top-color: var(--color-primario);
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}
```

---

## Accesibilidad: prefers-reduced-motion

Algunos usuarios tienen configurado en su sistema que prefieren menos animaciones (por ejemplo, personas con epilepsia o vértigo).

```scss
/* styles.scss — SIEMPRE incluir esto */
@media (prefers-reduced-motion: reduce) {
    *,
    *::before,
    *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
        scroll-behavior: auto !important;
    }
}
```

Esto desactiva todas las animaciones para usuarios que lo necesitan.

---

## Ejercicios

### Ejercicio 1: Configurar Bootstrap
Instalar Bootstrap en un proyecto Angular. Crear un navbar responsive y un grid de tarjetas usando clases de Bootstrap.

### Ejercicio 2: Sistema de variables
Definir un sistema completo de variables CSS en `:root`. Crear un tema oscuro con `[data-theme="dark"]`. Verificar que todos los componentes usen variables en vez de colores hardcodeados.

### Ejercicio 3: Animaciones
Agregar animación `fadeInUp` a las tarjetas de películas. Agregar transición de hover con escala y sombra. Crear un spinner de carga animado. Incluir `prefers-reduced-motion`.

### Ejercicio 4: Tema completo
Integrar `ThemeService` (del tema 10) con las variables CSS. El toggle en el navbar debe cambiar el tema con transición suave. Verificar que persiste al recargar.
