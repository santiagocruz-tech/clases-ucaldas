# 4. Servicios e inyección de dependencias

## ¿Qué es un servicio y por qué usarlos?

Un servicio es una clase que contiene lógica reutilizable que no pertenece a un componente específico. Ejemplos:

- Llamadas HTTP a una API.
- Manejo de favoritos en localStorage.
- Lógica de autenticación.
- Preferencias del usuario (tema, idioma).

**Regla de oro:** los componentes muestran datos y manejan interacción del usuario. Los servicios manejan la lógica de negocio y los datos.

---

## Crear servicios con Angular CLI

```bash
ng generate service services/tmdb
ng g s services/tmdb    # Atajo
```

Genera:
```
services/
└── tmdb.service.ts
```

---

## Estructura de un servicio

```typescript
// services/tmdb.service.ts
import { Injectable } from '@angular/core';

@Injectable({
    providedIn: 'root'  // Disponible en toda la aplicación
})
export class TmdbService {

    private apiUrl = 'https://api.themoviedb.org/3';

    obtenerPopulares(): void {
        // Lógica para obtener películas populares
    }
}
```

### ¿Qué es `providedIn: 'root'`?

Le dice a Angular que cree **una sola instancia** del servicio para toda la aplicación (patrón Singleton). Todos los componentes que inyecten este servicio comparten la misma instancia y los mismos datos.

---

## Inyección de dependencias

Para usar un servicio en un componente, se inyecta en el constructor:

```typescript
import { Component, OnInit } from '@angular/core';
import { TmdbService } from '../../services/tmdb.service';

@Component({
    selector: 'app-home',
    standalone: true,
    templateUrl: './home.component.html'
})
export class HomeComponent implements OnInit {

    peliculas: Movie[] = [];

    // Angular crea e inyecta el servicio automáticamente
    constructor(private tmdbService: TmdbService) {}

    ngOnInit(): void {
        // Usar el servicio
        this.tmdbService.obtenerPopulares().subscribe(data => {
            this.peliculas = data.results;
        });
    }
}
```

### Inyección moderna con `inject()`

Angular 14+ permite inyectar sin constructor:

```typescript
import { Component, OnInit, inject } from '@angular/core';
import { TmdbService } from '../../services/tmdb.service';

@Component({ ... })
export class HomeComponent implements OnInit {
    private tmdbService = inject(TmdbService);
    peliculas: Movie[] = [];

    ngOnInit(): void {
        this.tmdbService.obtenerPopulares().subscribe(data => {
            this.peliculas = data.results;
        });
    }
}
```

Ambas formas son válidas. `inject()` es más concisa.

---

## Separar lógica de negocio de los componentes

### ❌ Mal: lógica en el componente

```typescript
export class FavoritesComponent {
    favoritas: Movie[] = [];

    agregar(movie: Movie): void {
        if (!this.favoritas.find(m => m.id === movie.id)) {
            this.favoritas.push(movie);
            localStorage.setItem('favoritas', JSON.stringify(this.favoritas));
        }
    }

    eliminar(id: number): void {
        this.favoritas = this.favoritas.filter(m => m.id !== id);
        localStorage.setItem('favoritas', JSON.stringify(this.favoritas));
    }

    cargar(): void {
        try {
            const data = localStorage.getItem('favoritas');
            this.favoritas = data ? JSON.parse(data) : [];
        } catch {
            this.favoritas = [];
        }
    }
}
```

### ✅ Bien: lógica en un servicio

```typescript
// services/favorites.service.ts
@Injectable({ providedIn: 'root' })
export class FavoritesService {
    private readonly STORAGE_KEY = 'favoritas';

    obtenerTodas(): Movie[] {
        try {
            const data = localStorage.getItem(this.STORAGE_KEY);
            return data ? JSON.parse(data) : [];
        } catch {
            return [];
        }
    }

    agregar(movie: Movie): void {
        const favoritas = this.obtenerTodas();
        if (!favoritas.find(m => m.id === movie.id)) {
            favoritas.push(movie);
            this.guardar(favoritas);
        }
    }

    eliminar(id: number): void {
        const favoritas = this.obtenerTodas().filter(m => m.id !== id);
        this.guardar(favoritas);
    }

    esFavorita(id: number): boolean {
        return this.obtenerTodas().some(m => m.id === id);
    }

    private guardar(favoritas: Movie[]): void {
        localStorage.setItem(this.STORAGE_KEY, JSON.stringify(favoritas));
    }
}
```

```typescript
// Componente limpio
export class FavoritesComponent implements OnInit {
    favoritas: Movie[] = [];

    constructor(private favoritesService: FavoritesService) {}

    ngOnInit(): void {
        this.favoritas = this.favoritesService.obtenerTodas();
    }

    eliminar(id: number): void {
        this.favoritesService.eliminar(id);
        this.favoritas = this.favoritesService.obtenerTodas();
    }
}
```

---

## Ejemplo práctico: servicio de carrito de compras

```typescript
// services/cart.service.ts
import { Injectable } from '@angular/core';

interface CartItem {
    id: number;
    nombre: string;
    precio: number;
    cantidad: number;
}

@Injectable({ providedIn: 'root' })
export class CartService {
    private items: CartItem[] = [];

    obtenerItems(): CartItem[] {
        return [...this.items]; // Retorna copia para evitar mutación externa
    }

    agregar(producto: { id: number; nombre: string; precio: number }): void {
        const existente = this.items.find(item => item.id === producto.id);
        if (existente) {
            existente.cantidad++;
        } else {
            this.items.push({ ...producto, cantidad: 1 });
        }
    }

    eliminar(id: number): void {
        this.items = this.items.filter(item => item.id !== id);
    }

    actualizarCantidad(id: number, cantidad: number): void {
        const item = this.items.find(i => i.id === id);
        if (item && cantidad > 0) {
            item.cantidad = cantidad;
        }
    }

    obtenerTotal(): number {
        return this.items.reduce((sum, item) => sum + item.precio * item.cantidad, 0);
    }

    obtenerCantidadTotal(): number {
        return this.items.reduce((sum, item) => sum + item.cantidad, 0);
    }

    vaciar(): void {
        this.items = [];
    }
}
```

Como el servicio es singleton (`providedIn: 'root'`), el navbar puede mostrar la cantidad de items y la página del carrito puede mostrar el detalle, ambos usando la misma instancia del servicio.

---

## Ejercicios

### Ejercicio 1: ThemeService
Crear un servicio `ThemeService` con métodos para:
- `obtenerTema(): string` — retorna 'light' o 'dark' desde localStorage.
- `cambiarTema(tema: string): void` — guarda en localStorage y aplica al DOM.
- `toggle(): void` — alterna entre light y dark.

### Ejercicio 2: Servicio de notas
Crear un `NotesService` que maneje un CRUD de notas en localStorage. Inyectarlo en un componente que muestre la lista y permita agregar/eliminar.

### Ejercicio 3: Refactorizar
Tomar el ejercicio de la lista de tareas del tema anterior y mover toda la lógica de datos a un `TodoService`. El componente solo debe llamar métodos del servicio.
