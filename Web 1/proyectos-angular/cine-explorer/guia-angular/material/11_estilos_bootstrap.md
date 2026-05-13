# Capítulo 11: Estilos, temas y Bootstrap en Angular

## Objetivo

Dar a CineExplorer un diseño profesional con Bootstrap, variables CSS, tema claro/oscuro con transiciones suaves y animaciones. Al final de este capítulo la app tendrá un look completo y responsive.

---

## 11.1 Estilos globales vs. estilos por componente

### Estilos globales (`styles.scss`)

Afectan a toda la aplicación. Ideal para: variables CSS, reset, temas, fuentes.

### Estilos por componente (encapsulación)

Cada componente tiene sus propios estilos que NO afectan a otros componentes. Angular logra esto con View Encapsulation: agrega un atributo único a cada componente y sus estilos.

```scss
// movie-card.component.scss
// Estos estilos SOLO afectan a este componente
.card {
  transition: transform 0.2s;
  &:hover {
    transform: translateY(-4px);
  }
}
```

---

## 11.2 Variables CSS y sistema de temas

✏️ Configurar `src/styles.scss`:

```scss
// styles.scss
// Estilos globales de CineExplorer

// ===== VARIABLES CSS (TEMA CLARO) =====
// :root aplica las variables a toda la página
:root {
  // Colores principales
  --color-primario: #0d6efd;       // azul Bootstrap
  --color-secundario: #6c757d;     // gris

  // Fondos
  --bg-primary: #ffffff;           // fondo principal
  --bg-secondary: #f8f9fa;         // fondo secundario (secciones)
  --bg-card: #ffffff;              // fondo de tarjetas
  --bg-navbar: #212529;            // fondo del navbar

  // Texto
  --text-primary: #212529;         // texto principal (casi negro)
  --text-secondary: #6c757d;       // texto secundario (gris)

  // Sombras
  --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.12);
  --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
  --shadow-lg: 0 10px 25px rgba(0, 0, 0, 0.15);

  // Bordes
  --radius-sm: 0.25rem;
  --radius-md: 0.5rem;
  --radius-lg: 1rem;
}

// ===== TEMA OSCURO =====
// Se activa cuando el <html> tiene data-theme="dark"
// (lo controla ThemeService del capítulo 10)
[data-theme="dark"] {
  --bg-primary: #121212;           // fondo oscuro
  --bg-secondary: #1e1e1e;        // fondo secundario oscuro
  --bg-card: #2d2d2d;             // tarjetas oscuras
  --bg-navbar: #0d0d0d;           // navbar más oscuro
  --text-primary: #e0e0e0;        // texto claro
  --text-secondary: #aaaaaa;      // texto secundario claro
  --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.3);
  --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.3);
  --shadow-lg: 0 10px 25px rgba(0, 0, 0, 0.4);
}

// ===== ESTILOS BASE =====
body {
  // Usar las variables CSS en lugar de colores hardcodeados
  background-color: var(--bg-primary);
  color: var(--text-primary);
  // Transición suave al cambiar de tema
  transition: background-color 0.3s ease, color 0.3s ease;
}

// Sobreescribir estilos de Bootstrap para que usen nuestras variables
.card {
  background-color: var(--bg-card);
  box-shadow: var(--shadow-md);
  border: none;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}

.text-muted {
  color: var(--text-secondary) !important;
}

// ===== ACCESIBILIDAD =====
// Desactivar animaciones para usuarios que lo prefieran
// (personas con epilepsia, vértigo, etc.)
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

---

## 11.3 Animaciones en componentes

✏️ Agregar animación de entrada en `movie-card.component.scss`:

```scss
// movie-card.component.scss
// Animación de entrada: las tarjetas aparecen desde abajo con fade
@keyframes fadeInUp {
  from {
    opacity: 0;                    // invisible
    transform: translateY(20px);   // 20px abajo de su posición final
  }
  to {
    opacity: 1;                    // visible
    transform: translateY(0);      // posición final
  }
}

// :host es el elemento raíz del componente (el <app-movie-card> en el DOM)
:host {
  // Aplicar la animación al aparecer
  animation: fadeInUp 0.4s ease-out;
}

.card {
  cursor: pointer;
  // Transición suave para hover
  transition: transform 0.2s ease, box-shadow 0.2s ease;

  &:hover {
    transform: translateY(-4px);
    box-shadow: var(--shadow-lg);
  }
}

.card-img-top {
  height: 400px;
  object-fit: cover;  // recorta sin deformar
}
```

### Spinner de carga animado

📁 Crear `src/app/components/spinner/spinner.component.ts`:

```typescript
// spinner.component.ts
// Componente reutilizable de spinner de carga
import { Component } from '@angular/core';

@Component({
  selector: 'app-spinner',
  standalone: true,
  template: `
    <!-- Contenedor centrado -->
    <div class="text-center py-5">
      <!-- Spinner de Bootstrap -->
      <div class="spinner-border text-primary" role="status">
        <!-- visually-hidden: oculto visualmente pero accesible para lectores de pantalla -->
        <span class="visually-hidden">Cargando...</span>
      </div>
      <p class="text-muted mt-2">Cargando...</p>
    </div>
  `
})
export class SpinnerComponent {}
```

---

## 11.4 Responsive design

Bootstrap ya es responsive por defecto con su sistema de grid. Verificar que CineExplorer se ve bien en todos los tamaños:

```html
<!-- Grid responsive: diferentes columnas según el tamaño de pantalla -->
<div class="row g-4">
  @for (movie of peliculas; track movie.id) {
    <!-- col-12: 1 columna en móvil (pantalla completa) -->
    <!-- col-sm-6: 2 columnas en pantallas pequeñas (≥576px) -->
    <!-- col-md-4: 3 columnas en pantallas medianas (≥768px) -->
    <!-- col-lg-3: 4 columnas en pantallas grandes (≥992px) -->
    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
      <app-movie-card [movie]="movie" />
    </div>
  }
</div>
```

---

## 11.5 Compilar y probar

▶️ Verificar que:
1. El tema oscuro funciona y la transición es suave
2. Las tarjetas tienen animación de entrada (fadeInUp)
3. El hover en las tarjetas las eleva con sombra
4. La app se ve bien en móvil, tablet y desktop
5. Si desactivan animaciones en el SO, las animaciones se desactivan en la app

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| Variables CSS (`:root`) | Colores, sombras, espaciado centralizados |
| `[data-theme="dark"]` | Tema oscuro con sobreescritura de variables |
| View Encapsulation | Estilos por componente que no afectan a otros |
| `:host` | Estilar el elemento raíz del componente |
| `@keyframes` | Definir animaciones CSS |
| `transition` | Transiciones suaves entre estados |
| `prefers-reduced-motion` | Accesibilidad: respetar preferencia de animaciones |
| Grid de Bootstrap | Layout responsive con `col-sm-6 col-md-4 col-lg-3` |

---

**Anterior:** [← Capítulo 10 — localStorage](10_localstorage.md) | **Siguiente:** [Capítulo 12 — Arquitectura →](12_arquitectura.md)
