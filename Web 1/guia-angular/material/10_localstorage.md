# 10. Persistencia con localStorage

## localStorage en Angular: cuándo y cómo usarlo

localStorage permite guardar datos en el navegador que persisten después de cerrar la pestaña o el navegador.

### Cuándo usarlo
- Favoritos del usuario.
- Preferencia de tema (claro/oscuro).
- Datos de sesión simples.
- Cache de datos que no cambian frecuentemente.

### Cuándo NO usarlo
- Datos sensibles (contraseñas, tokens de larga duración).
- Grandes cantidades de datos (límite ~5MB).
- Datos que necesitan sincronización entre dispositivos.

---

## Servicio wrapper para localStorage

Nunca usar `localStorage` directamente en los componentes. Crear un servicio que lo encapsule.

```typescript
// services/storage.service.ts
import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class StorageService {

    get<T>(key: string, defaultValue: T): T {
        try {
            const data = localStorage.getItem(key);
            return data ? JSON.parse(data) : defaultValue;
        } catch {
            return defaultValue;
        }
    }

    set<T>(key: string, value: T): void {
        try {
            localStorage.setItem(key, JSON.stringify(value));
        } catch (error) {
            console.error('Error al guardar en localStorage:', error);
        }
    }

    remove(key: string): void {
        localStorage.removeItem(key);
    }

    clear(): void {
        localStorage.clear();
    }
}
```

### ¿Por qué un wrapper?

1. `JSON.parse` puede fallar si el dato está corrupto → el `try/catch` lo maneja.
2. Centraliza la lógica → si mañana cambiás a sessionStorage o IndexedDB, solo cambiás un archivo.
3. Tipado genérico → `get<Movie[]>('favoritas', [])` retorna `Movie[]`.

---

## Persistir favoritos

```typescript
// services/favorites.service.ts
import { Injectable, inject } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { map } from 'rxjs';
import { StorageService } from './storage.service';
import { Movie } from '../models/movie';

@Injectable({ providedIn: 'root' })
export class FavoritesService {
    private storage = inject(StorageService);
    private readonly KEY = 'favoritas';

    private favoritasSubject = new BehaviorSubject<Movie[]>(
        this.storage.get<Movie[]>(this.KEY, [])
    );

    favoritas$: Observable<Movie[]> = this.favoritasSubject.asObservable();

    cantidad$: Observable<number> = this.favoritas$.pipe(
        map(favs => favs.length)
    );

    agregar(movie: Movie): void {
        const actuales = this.favoritasSubject.value;
        if (!this.esFavorita(movie.id)) {
            const nuevas = [...actuales, movie];
            this.favoritasSubject.next(nuevas);
            this.storage.set(this.KEY, nuevas);
        }
    }

    eliminar(id: number): void {
        const nuevas = this.favoritasSubject.value.filter(m => m.id !== id);
        this.favoritasSubject.next(nuevas);
        this.storage.set(this.KEY, nuevas);
    }

    esFavorita(id: number): boolean {
        return this.favoritasSubject.value.some(m => m.id === id);
    }

    toggle(movie: Movie): void {
        if (this.esFavorita(movie.id)) {
            this.eliminar(movie.id);
        } else {
            this.agregar(movie);
        }
    }

    obtenerTodas(): Movie[] {
        return this.favoritasSubject.value;
    }
}
```

### Uso en componentes

```typescript
// navbar.component.ts — mostrar contador
export class NavbarComponent {
    private favoritesService = inject(FavoritesService);
    cantidad$ = this.favoritesService.cantidad$;
}
```

```html
<!-- navbar.component.html -->
<a routerLink="/favorites" class="nav-link">
    Favoritos
    @if (cantidad$ | async; as cantidad) {
        @if (cantidad > 0) {
            <span class="badge bg-danger">{{ cantidad }}</span>
        }
    }
</a>
```

```typescript
// movie-card.component.ts — toggle favorito
export class MovieCardComponent {
    @Input({ required: true }) movie!: Movie;
    private favoritesService = inject(FavoritesService);

    get esFavorita(): boolean {
        return this.favoritesService.esFavorita(this.movie.id);
    }

    toggleFavorito(): void {
        this.favoritesService.toggle(this.movie);
    }
}
```

---

## Persistir tema claro/oscuro

```typescript
// services/theme.service.ts
import { Injectable, inject } from '@angular/core';
import { StorageService } from './storage.service';

@Injectable({ providedIn: 'root' })
export class ThemeService {
    private storage = inject(StorageService);
    private readonly KEY = 'tema';

    private temaActual: string;

    constructor() {
        this.temaActual = this.obtenerTemaInicial();
        this.aplicarTema(this.temaActual);
    }

    obtenerTema(): string {
        return this.temaActual;
    }

    cambiarTema(tema: string): void {
        this.temaActual = tema;
        this.aplicarTema(tema);
        this.storage.set(this.KEY, tema);
    }

    toggle(): void {
        const nuevoTema = this.temaActual === 'light' ? 'dark' : 'light';
        this.cambiarTema(nuevoTema);
    }

    private obtenerTemaInicial(): string {
        // 1. Verificar si hay tema guardado
        const guardado = this.storage.get<string | null>(this.KEY, null);
        if (guardado) return guardado;

        // 2. Si no hay, respetar preferencia del sistema
        if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
            return 'dark';
        }

        return 'light';
    }

    private aplicarTema(tema: string): void {
        document.documentElement.setAttribute('data-theme', tema);
    }
}
```

### Uso en el navbar

```typescript
export class NavbarComponent {
    private themeService = inject(ThemeService);

    get temaActual(): string {
        return this.themeService.obtenerTema();
    }

    toggleTema(): void {
        this.themeService.toggle();
    }
}
```

```html
<button (click)="toggleTema()" class="btn btn-outline-light btn-sm">
    {{ temaActual === 'light' ? '🌙' : '☀️' }}
</button>
```

### CSS para temas

```css
/* styles.scss (global) */
:root {
    --bg-primary: #ffffff;
    --bg-secondary: #f8f9fa;
    --text-primary: #212529;
    --text-secondary: #6c757d;
    --card-bg: #ffffff;
    --shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

[data-theme="dark"] {
    --bg-primary: #121212;
    --bg-secondary: #1e1e1e;
    --text-primary: #e0e0e0;
    --text-secondary: #aaaaaa;
    --card-bg: #2d2d2d;
    --shadow: 0 2px 8px rgba(0, 0, 0, 0.4);
}

body {
    background-color: var(--bg-primary);
    color: var(--text-primary);
    transition: background-color 0.3s, color 0.3s;
}

.card {
    background-color: var(--card-bg);
    box-shadow: var(--shadow);
    transition: background-color 0.3s;
}
```

---

## Ejercicios

### Ejercicio 1: StorageService genérico
Implementar el `StorageService` y usarlo para guardar/recuperar una lista de notas. Verificar que los datos persisten al recargar la página.

### Ejercicio 2: Favoritos completos
Implementar `FavoritesService` con BehaviorSubject. Crear una vista `/favorites` que muestre las películas favoritas y permita eliminarlas. Mostrar un badge con la cantidad en el navbar.

### Ejercicio 3: Tema persistente
Implementar `ThemeService` con detección de `prefers-color-scheme`. Crear las variables CSS para ambos temas. Agregar un toggle en el navbar.

### Ejercicio 4: Historial de búsqueda
Crear un servicio que guarde las últimas 10 búsquedas del usuario en localStorage. Mostrarlas como sugerencias debajo del buscador.
