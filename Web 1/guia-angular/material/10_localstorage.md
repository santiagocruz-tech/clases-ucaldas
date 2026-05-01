# Capítulo 10: Persistencia con localStorage

## Objetivo

Persistir datos en el navegador para que sobrevivan al cerrar la pestaña. Al final de este capítulo, los favoritos y la preferencia de tema de CineExplorer se guardarán en localStorage.

---

## 10.1 ¿Cuándo usar localStorage?

| ✅ Usar para | ❌ No usar para |
|---|---|
| Favoritos del usuario | Datos sensibles (contraseñas, tokens) |
| Preferencia de tema (claro/oscuro) | Grandes cantidades de datos (límite ~5MB) |
| Historial de búsqueda | Datos que necesitan sincronización entre dispositivos |
| Cache de datos simples | Datos críticos (pueden borrarse) |

---

## 10.2 StorageService: wrapper para localStorage

Nunca usar `localStorage` directamente en los componentes. Crear un servicio que lo encapsule.

📁 Crear `src/app/services/storage.service.ts`:

```typescript
// storage.service.ts
// Servicio wrapper para localStorage con manejo de errores y tipado genérico
import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class StorageService {

  // Obtener un valor de localStorage con tipado genérico
  // T es el tipo esperado del dato (Movie[], string, boolean, etc.)
  // key: clave con la que se guardó el dato
  // defaultValue: valor por defecto si no existe o hay error
  get<T>(key: string, defaultValue: T): T {
    try {
      // localStorage.getItem retorna string o null
      const data = localStorage.getItem(key);
      // Si existe, parsear el JSON. Si no, retornar el valor por defecto
      // JSON.parse puede fallar si el dato está corrupto
      return data ? JSON.parse(data) : defaultValue;
    } catch {
      // Si JSON.parse falla, retornar el valor por defecto
      return defaultValue;
    }
  }

  // Guardar un valor en localStorage
  // JSON.stringify convierte cualquier objeto a string
  set<T>(key: string, value: T): void {
    try {
      localStorage.setItem(key, JSON.stringify(value));
    } catch (error) {
      // Puede fallar si localStorage está lleno (~5MB)
      console.error('Error al guardar en localStorage:', error);
    }
  }

  // Eliminar un valor
  remove(key: string): void {
    localStorage.removeItem(key);
  }

  // Limpiar todo localStorage
  clear(): void {
    localStorage.clear();
  }
}
```

💡 **¿Por qué un wrapper?**
1. `JSON.parse` puede fallar si el dato está corrupto → el `try/catch` lo maneja
2. Centraliza la lógica → si mañana cambian a sessionStorage, solo cambian un archivo
3. Tipado genérico → `get<Movie[]>('favoritas', [])` retorna `Movie[]`

---

## 10.3 Persistir favoritos

Vamos a actualizar el `FavoritesService` que refactorizamos en el capítulo 07 (con BehaviorSubject) para que ahora también guarde los datos en localStorage. La API pública del servicio no cambia, solo se agrega persistencia interna.

✏️ Modificar `favorites.service.ts` para usar StorageService:

```typescript
// favorites.service.ts
// Servicio de favoritos con persistencia en localStorage
import { Injectable, inject } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { map } from 'rxjs';
import { Movie } from '../models/movie';
// Importar el servicio de storage
import { StorageService } from './storage.service';

@Injectable({ providedIn: 'root' })
export class FavoritesService {
  private storage = inject(StorageService);
  // Clave para guardar en localStorage
  private readonly KEY = 'cine-explorer-favoritas';

  // Inicializar el BehaviorSubject con los datos guardados en localStorage
  // Si no hay datos guardados, usa un array vacío
  private favoritasSubject = new BehaviorSubject<Movie[]>(
    this.storage.get<Movie[]>(this.KEY, [])
  );

  // Observable público para que los componentes se suscriban
  favoritas$: Observable<Movie[]> = this.favoritasSubject.asObservable();

  // Observable derivado: cantidad de favoritas
  cantidad$: Observable<number> = this.favoritas$.pipe(
    map(favs => favs.length)
  );

  agregar(movie: Movie): void {
    const actuales = this.favoritasSubject.value;
    if (!actuales.find(m => m.id === movie.id)) {
      const nuevas = [...actuales, movie];
      // Emitir el nuevo valor a todos los suscriptores
      this.favoritasSubject.next(nuevas);
      // Persistir en localStorage
      this.storage.set(this.KEY, nuevas);
    }
  }

  eliminar(id: number): void {
    const nuevas = this.favoritasSubject.value.filter(m => m.id !== id);
    this.favoritasSubject.next(nuevas);
    // Actualizar localStorage
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

  obtenerCantidad(): number {
    return this.favoritasSubject.value.length;
  }
}
```

---

## 10.4 Persistir tema claro/oscuro

📁 Crear `src/app/services/theme.service.ts`:

```typescript
// theme.service.ts
// Servicio que maneja el tema visual (claro/oscuro) con persistencia
import { Injectable, inject } from '@angular/core';
import { StorageService } from './storage.service';

@Injectable({ providedIn: 'root' })
export class ThemeService {
  private storage = inject(StorageService);
  private readonly KEY = 'cine-explorer-tema';

  // Tema actual (se inicializa en el constructor)
  private temaActual: string;

  constructor() {
    // Obtener el tema inicial (guardado o preferencia del sistema)
    this.temaActual = this.obtenerTemaInicial();
    // Aplicar el tema al DOM
    this.aplicarTema(this.temaActual);
  }

  // Retorna el tema actual
  obtenerTema(): string {
    return this.temaActual;
  }

  // Cambia el tema y lo persiste
  cambiarTema(tema: string): void {
    this.temaActual = tema;
    this.aplicarTema(tema);
    // Guardar en localStorage para que persista al recargar
    this.storage.set(this.KEY, tema);
  }

  // Alterna entre light y dark
  toggle(): void {
    const nuevoTema = this.temaActual === 'light' ? 'dark' : 'light';
    this.cambiarTema(nuevoTema);
  }

  // Determina el tema inicial
  private obtenerTemaInicial(): string {
    // 1. Verificar si hay tema guardado en localStorage
    const guardado = this.storage.get<string | null>(this.KEY, null);
    if (guardado) return guardado;

    // 2. Si no hay guardado, respetar la preferencia del sistema operativo
    // window.matchMedia detecta si el usuario tiene tema oscuro en su SO
    if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
      return 'dark';
    }

    // 3. Por defecto: tema claro
    return 'light';
  }

  // Aplica el tema al elemento <html> del DOM
  private aplicarTema(tema: string): void {
    // setAttribute agrega data-theme="dark" o data-theme="light" al <html>
    // Los estilos CSS usan este atributo para cambiar colores
    document.documentElement.setAttribute('data-theme', tema);
  }
}
```

✏️ Agregar el toggle de tema en el navbar:

```html
<!-- Agregar en navbar.html, dentro del navbar -->
<button (click)="toggleTema()" class="btn btn-outline-light btn-sm ms-2">
  <!-- Mostrar emoji según el tema actual -->
  {{ temaActual === 'light' ? '🌙' : '☀️' }}
</button>
```

```typescript
// Agregar en navbar.ts
private themeService = inject(ThemeService);

get temaActual(): string {
  return this.themeService.obtenerTema();
}

toggleTema(): void {
  this.themeService.toggle();
}
```

---

## 10.5 Compilar y probar

▶️ Verificar que:
1. Marcar películas como favoritas y recargar la página → siguen marcadas
2. Cambiar el tema a oscuro y recargar → sigue en oscuro
3. Abrir DevTools → Application → Local Storage → ver los datos guardados

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| `localStorage` | Guardar datos en el navegador (persisten al cerrar) |
| `StorageService` | Wrapper con manejo de errores y tipado |
| `JSON.parse/stringify` | Convertir objetos a/desde string |
| `BehaviorSubject` + localStorage | Estado reactivo que persiste |
| `ThemeService` | Manejar tema claro/oscuro con persistencia |
| `prefers-color-scheme` | Detectar preferencia de tema del SO |
| `data-theme` attribute | Aplicar tema con CSS |

---

**Anterior:** [← Capítulo 9 — Pipes](09_pipes.md) | **Siguiente:** [Capítulo 11 — Estilos y Bootstrap →](11_estilos_bootstrap.md)
