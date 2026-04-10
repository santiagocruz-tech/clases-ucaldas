# 8. Formularios

## Template-driven forms vs. Reactive forms

Angular ofrece dos enfoques para formularios:

| Característica | Template-driven | Reactive |
|---|---|---|
| Lógica | En el template (HTML) | En la clase (TypeScript) |
| Binding | `ngModel` | `FormControl`, `FormGroup` |
| Validación | Directivas HTML | Funciones en la clase |
| Testing | Más difícil | Más fácil |
| Complejidad | Formularios simples | Formularios complejos |

**Recomendación:** usar Reactive Forms para todo excepto formularios muy simples.

---

## Reactive Forms

### Configuración

```typescript
import { ReactiveFormsModule, FormControl, FormGroup, Validators } from '@angular/forms';

@Component({
    selector: 'app-registro',
    standalone: true,
    imports: [ReactiveFormsModule],
    templateUrl: './registro.component.html'
})
export class RegistroComponent {}
```

### FormControl — Un solo campo

```typescript
export class BuscadorComponent {
    searchControl = new FormControl('');  // Valor inicial vacío

    buscar(): void {
        console.log(this.searchControl.value);
    }
}
```

```html
<input [formControl]="searchControl" placeholder="Buscar...">
<button (click)="buscar()">Buscar</button>
<p>Valor actual: {{ searchControl.value }}</p>
```

### FormGroup — Múltiples campos

```typescript
export class RegistroComponent {
    formulario = new FormGroup({
        nombre: new FormControl('', [Validators.required, Validators.minLength(2)]),
        email: new FormControl('', [Validators.required, Validators.email]),
        password: new FormControl('', [Validators.required, Validators.minLength(6)]),
        confirmarPassword: new FormControl('', [Validators.required])
    });

    onSubmit(): void {
        if (this.formulario.valid) {
            console.log(this.formulario.value);
            // { nombre: '...', email: '...', password: '...', confirmarPassword: '...' }
        }
    }
}
```

```html
<form [formGroup]="formulario" (ngSubmit)="onSubmit()">
    <div class="mb-3">
        <label for="nombre" class="form-label">Nombre</label>
        <input id="nombre" formControlName="nombre" class="form-control"
               [class.is-invalid]="formulario.get('nombre')?.invalid && formulario.get('nombre')?.touched">
        @if (formulario.get('nombre')?.hasError('required') && formulario.get('nombre')?.touched) {
            <div class="invalid-feedback">El nombre es requerido</div>
        }
        @if (formulario.get('nombre')?.hasError('minlength') && formulario.get('nombre')?.touched) {
            <div class="invalid-feedback">Mínimo 2 caracteres</div>
        }
    </div>

    <div class="mb-3">
        <label for="email" class="form-label">Email</label>
        <input id="email" formControlName="email" type="email" class="form-control"
               [class.is-invalid]="formulario.get('email')?.invalid && formulario.get('email')?.touched">
        @if (formulario.get('email')?.hasError('required') && formulario.get('email')?.touched) {
            <div class="invalid-feedback">El email es requerido</div>
        }
        @if (formulario.get('email')?.hasError('email') && formulario.get('email')?.touched) {
            <div class="invalid-feedback">Email inválido</div>
        }
    </div>

    <button type="submit" class="btn btn-primary" [disabled]="formulario.invalid">
        Registrarse
    </button>
</form>
```

### FormBuilder — Atajo para crear formularios

```typescript
import { FormBuilder, Validators } from '@angular/forms';

export class RegistroComponent {
    private fb = inject(FormBuilder);

    formulario = this.fb.group({
        nombre: ['', [Validators.required, Validators.minLength(2)]],
        email: ['', [Validators.required, Validators.email]],
        password: ['', [Validators.required, Validators.minLength(6)]],
        confirmarPassword: ['', [Validators.required]]
    });
}
```

`FormBuilder` es más conciso que crear `FormGroup` y `FormControl` manualmente.

---

## Validaciones built-in

```typescript
import { Validators } from '@angular/forms';

formulario = this.fb.group({
    nombre: ['', [
        Validators.required,           // Campo obligatorio
        Validators.minLength(2),        // Mínimo 2 caracteres
        Validators.maxLength(50)        // Máximo 50 caracteres
    ]],
    email: ['', [
        Validators.required,
        Validators.email                // Formato de email válido
    ]],
    edad: [null, [
        Validators.required,
        Validators.min(18),             // Valor mínimo
        Validators.max(120)             // Valor máximo
    ]],
    telefono: ['', [
        Validators.pattern(/^[0-9]{10}$/)  // Patrón regex
    ]]
});
```

---

## Validaciones personalizadas

```typescript
import { AbstractControl, ValidationErrors, ValidatorFn } from '@angular/forms';

// Validador personalizado: no permite espacios en blanco
export function sinEspacios(): ValidatorFn {
    return (control: AbstractControl): ValidationErrors | null => {
        if (control.value && control.value.includes(' ')) {
            return { sinEspacios: true };
        }
        return null;  // null = válido
    };
}

// Validador de grupo: confirmar password
export function passwordsIguales(): ValidatorFn {
    return (group: AbstractControl): ValidationErrors | null => {
        const password = group.get('password')?.value;
        const confirmar = group.get('confirmarPassword')?.value;

        if (password !== confirmar) {
            return { passwordsNoCoinciden: true };
        }
        return null;
    };
}
```

### Usar validadores personalizados

```typescript
formulario = this.fb.group({
    username: ['', [Validators.required, sinEspacios()]],
    password: ['', [Validators.required, Validators.minLength(6)]],
    confirmarPassword: ['', [Validators.required]]
}, {
    validators: [passwordsIguales()]  // Validador a nivel de grupo
});
```

```html
@if (formulario.hasError('passwordsNoCoinciden') && formulario.get('confirmarPassword')?.touched) {
    <div class="text-danger">Las contraseñas no coinciden</div>
}
```

---

## Mostrar mensajes de error — Patrón reutilizable

Para no repetir la lógica de errores en cada campo, crear un método helper:

```typescript
export class RegistroComponent {
    formulario = this.fb.group({ ... });

    // Helper para verificar errores
    tieneError(campo: string, error: string): boolean {
        const control = this.formulario.get(campo);
        return !!control?.hasError(error) && !!control?.touched;
    }
}
```

```html
<div class="mb-3">
    <label for="nombre" class="form-label">Nombre</label>
    <input id="nombre" formControlName="nombre" class="form-control"
           [class.is-invalid]="formulario.get('nombre')?.invalid && formulario.get('nombre')?.touched">

    @if (tieneError('nombre', 'required')) {
        <div class="invalid-feedback">El nombre es requerido</div>
    }
    @if (tieneError('nombre', 'minlength')) {
        <div class="invalid-feedback">Mínimo 2 caracteres</div>
    }
</div>
```

---

## Formularios dinámicos con FormArray

FormArray permite agregar o quitar campos dinámicamente.

```typescript
import { FormArray } from '@angular/forms';

export class RecetaComponent {
    formulario = this.fb.group({
        nombre: ['', Validators.required],
        ingredientes: this.fb.array([
            this.fb.control('', Validators.required)
        ])
    });

    get ingredientes(): FormArray {
        return this.formulario.get('ingredientes') as FormArray;
    }

    agregarIngrediente(): void {
        this.ingredientes.push(this.fb.control('', Validators.required));
    }

    eliminarIngrediente(index: number): void {
        this.ingredientes.removeAt(index);
    }
}
```

```html
<form [formGroup]="formulario">
    <div class="mb-3">
        <label class="form-label">Nombre de la receta</label>
        <input formControlName="nombre" class="form-control">
    </div>

    <div formArrayName="ingredientes">
        <label class="form-label">Ingredientes</label>
        @for (ingrediente of ingredientes.controls; track $index) {
            <div class="input-group mb-2">
                <input [formControlName]="$index" class="form-control"
                       placeholder="Ingrediente {{ $index + 1 }}">
                <button type="button" class="btn btn-outline-danger"
                        (click)="eliminarIngrediente($index)">✕</button>
            </div>
        }
    </div>

    <button type="button" class="btn btn-outline-primary" (click)="agregarIngrediente()">
        + Agregar ingrediente
    </button>
</form>
```

---

## Ejercicios

### Ejercicio 1: Formulario de contacto
Crear un formulario reactivo con: nombre (requerido, min 2), email (requerido, formato email), mensaje (requerido, min 10). Mostrar errores de validación con Bootstrap.

### Ejercicio 2: Formulario de registro con validación cruzada
Crear un formulario con password y confirmar password. Usar un validador personalizado a nivel de grupo para verificar que coincidan.

### Ejercicio 3: Formulario dinámico
Crear un formulario para agregar un equipo de trabajo: nombre del equipo + lista dinámica de miembros (nombre y rol). Usar FormArray para agregar/quitar miembros.

### Ejercicio 4: Buscador reactivo
Crear un buscador con FormControl que use `valueChanges` con `debounceTime` y `switchMap` para buscar en una API en tiempo real.
