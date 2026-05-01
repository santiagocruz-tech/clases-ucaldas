# Capítulo 8: Formularios

## Objetivo

Aprender Reactive Forms en Angular. Al final de este capítulo, CineExplorer tendrá un formulario para escribir reseñas de películas con validación.

---

## 8.1 Template-driven vs. Reactive Forms

| Característica | Template-driven | Reactive |
|---|---|---|
| Lógica | En el template (HTML) | En la clase (TypeScript) |
| Binding | `ngModel` | `FormControl`, `FormGroup` |
| Validación | Directivas HTML | Funciones en la clase |
| Testing | Más difícil | Más fácil |
| Complejidad | Formularios simples | Formularios complejos |

**Recomendación:** usar Reactive Forms para todo excepto formularios muy simples.

---

## 8.2 FormControl — Un solo campo

```typescript
// Un FormControl representa un solo campo del formulario
import { FormControl, ReactiveFormsModule } from '@angular/forms';

@Component({
  // ...
  // ReactiveFormsModule es necesario para usar [formControl]
  imports: [ReactiveFormsModule]
})
export class Buscador {
  // FormControl con valor inicial vacío
  searchControl = new FormControl('');

  buscar(): void {
    // .value obtiene el valor actual del control
    console.log(this.searchControl.value);
  }
}
```

```html
<!-- [formControl] vincula el input al FormControl -->
<input [formControl]="searchControl" placeholder="Buscar...">
<button (click)="buscar()">Buscar</button>
<!-- Mostrar el valor en tiempo real -->
<p>Valor actual: {{ searchControl.value }}</p>
```

---

## 8.3 FormGroup — Múltiples campos

```typescript
// FormGroup agrupa varios FormControl en un formulario
import { FormGroup, FormControl, Validators, ReactiveFormsModule } from '@angular/forms';

@Component({
  imports: [ReactiveFormsModule]
})
export class ReviewForm {
  // FormGroup con varios campos, cada uno con sus validaciones
  formulario = new FormGroup({
    // Validators.required: campo obligatorio
    // Validators.minLength(n): mínimo n caracteres
    titulo: new FormControl('', [
      Validators.required,
      Validators.minLength(3)
    ]),
    contenido: new FormControl('', [
      Validators.required,
      Validators.minLength(20)
    ]),
    puntuacion: new FormControl(5, [
      Validators.required,
      Validators.min(1),    // valor mínimo
      Validators.max(10)    // valor máximo
    ]),
    recomendada: new FormControl(true)
  });

  // Se ejecuta al enviar el formulario
  onSubmit(): void {
    // .valid retorna true si todos los campos pasan la validación
    if (this.formulario.valid) {
      console.log('Datos del formulario:', this.formulario.value);
      // { titulo: '...', contenido: '...', puntuacion: 5, recomendada: true }
    }
  }
}
```

```html
<!-- [formGroup] vincula el formulario al FormGroup -->
<!-- (ngSubmit) se ejecuta al enviar el formulario -->
<form [formGroup]="formulario" (ngSubmit)="onSubmit()">

  <!-- Campo: Título -->
  <div class="mb-3">
    <label for="titulo" class="form-label">Título de la reseña</label>
    <!-- formControlName vincula este input al FormControl "titulo" -->
    <input id="titulo" formControlName="titulo" class="form-control"
           [class.is-invalid]="formulario.get('titulo')?.invalid
                               && formulario.get('titulo')?.touched">
    <!-- is-invalid: clase de Bootstrap que pone el borde rojo -->
    <!-- .invalid: true si no pasa la validación -->
    <!-- .touched: true si el usuario ya interactuó con el campo -->

    <!-- Mensajes de error -->
    @if (formulario.get('titulo')?.hasError('required')
         && formulario.get('titulo')?.touched) {
      <div class="invalid-feedback">El título es requerido</div>
    }
    @if (formulario.get('titulo')?.hasError('minlength')
         && formulario.get('titulo')?.touched) {
      <div class="invalid-feedback">Mínimo 3 caracteres</div>
    }
  </div>

  <!-- Campo: Contenido -->
  <div class="mb-3">
    <label for="contenido" class="form-label">Tu reseña</label>
    <textarea id="contenido" formControlName="contenido"
              class="form-control" rows="4"
              [class.is-invalid]="formulario.get('contenido')?.invalid
                                  && formulario.get('contenido')?.touched">
    </textarea>
    @if (formulario.get('contenido')?.hasError('required')
         && formulario.get('contenido')?.touched) {
      <div class="invalid-feedback">La reseña es requerida</div>
    }
    @if (formulario.get('contenido')?.hasError('minlength')
         && formulario.get('contenido')?.touched) {
      <div class="invalid-feedback">Mínimo 20 caracteres</div>
    }
  </div>

  <!-- Campo: Puntuación -->
  <div class="mb-3">
    <label for="puntuacion" class="form-label">
      Puntuación: {{ formulario.get('puntuacion')?.value }} / 10
    </label>
    <input id="puntuacion" formControlName="puntuacion"
           type="range" class="form-range" min="1" max="10">
  </div>

  <!-- Campo: Recomendada -->
  <div class="form-check mb-3">
    <input id="recomendada" formControlName="recomendada"
           type="checkbox" class="form-check-input">
    <label for="recomendada" class="form-check-label">
      La recomiendo
    </label>
  </div>

  <!-- Botón de enviar -->
  <!-- [disabled] deshabilita el botón si el formulario es inválido -->
  <button type="submit" class="btn btn-primary"
          [disabled]="formulario.invalid">
    Publicar reseña
  </button>
</form>
```

---

## 8.4 FormBuilder — Atajo para crear formularios

```typescript
// FormBuilder es una forma más concisa de crear FormGroup
import { inject } from '@angular/core';
import { FormBuilder, Validators, ReactiveFormsModule } from '@angular/forms';

@Component({
  imports: [ReactiveFormsModule]
})
export class ReviewForm {
  // Inyectar FormBuilder
  private fb = inject(FormBuilder);

  // fb.group() crea un FormGroup de forma más concisa
  // Cada campo es un array: [valorInicial, [validadores]]
  formulario = this.fb.group({
    titulo: ['', [Validators.required, Validators.minLength(3)]],
    contenido: ['', [Validators.required, Validators.minLength(20)]],
    puntuacion: [5, [Validators.required, Validators.min(1), Validators.max(10)]],
    recomendada: [true]
  });

  // Helper para verificar errores de forma más limpia
  tieneError(campo: string, error: string): boolean {
    const control = this.formulario.get(campo);
    // !! convierte a boolean
    return !!control?.hasError(error) && !!control?.touched;
  }
}
```

Con el helper, el template queda más limpio:

```html
@if (tieneError('titulo', 'required')) {
  <div class="invalid-feedback">El título es requerido</div>
}
```

---

## 8.5 Validaciones personalizadas

```typescript
// Validador personalizado: no permite solo espacios en blanco
import { AbstractControl, ValidationErrors, ValidatorFn } from '@angular/forms';

export function noSoloEspacios(): ValidatorFn {
  // Retorna una función que recibe el control y retorna errores o null
  return (control: AbstractControl): ValidationErrors | null => {
    // Si el valor existe y solo tiene espacios
    if (control.value && control.value.trim().length === 0) {
      // Retornar un objeto con el error (la clave es el nombre del error)
      return { noSoloEspacios: true };
    }
    // null = sin errores (válido)
    return null;
  };
}

// Uso:
titulo: ['', [Validators.required, noSoloEspacios()]]
```

---

## 8.6 Aplicar al proyecto: Formulario de reseña

📁 Crear el componente:

```bash
ng g c features/movie-detail/review-form --skip-tests
```

Este formulario se mostrará dentro de la página de detalle de película para que los usuarios puedan escribir reseñas.

---

## 8.7 Compilar y probar

▶️ Verificar que:
1. Los campos muestran errores al tocar y dejar vacío
2. El botón se deshabilita si el formulario es inválido
3. Al enviar, los datos se muestran en consola

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| `FormControl` | Un solo campo del formulario |
| `FormGroup` | Agrupar varios campos |
| `FormBuilder` | Crear formularios de forma concisa |
| `Validators` | Validaciones built-in (required, minLength, etc.) |
| `ValidatorFn` | Crear validaciones personalizadas |
| `formControlName` | Vincular input a un FormControl |
| `[formGroup]` | Vincular form a un FormGroup |
| `.invalid` / `.touched` | Estado del campo para mostrar errores |
| `[disabled]` | Deshabilitar botón si formulario inválido |

---

**Anterior:** [← Capítulo 7 — RxJS](07_rxjs.md) | **Siguiente:** [Capítulo 9 — Pipes →](09_pipes.md)
