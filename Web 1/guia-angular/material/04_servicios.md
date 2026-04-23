# Capítulo 4: Servicios e inyección de dependencias

## Objetivo

Aprender a crear servicios para separar la lógica de negocio de los componentes. Al final de este capítulo, CineExplorer tendrá un `TmdbService` y un `FavoritesService`.

---

## 4.1 ¿Qué es un servicio y por qué usarlos?

Un servicio es una clase que contiene lógica reutilizable que no pertenece a un componente específico:

- Llamadas HTTP a una API
- Manejo de favoritos
- Preferencias del usuario (tema, idioma)
- Lógica de autenticación

**Regla de oro:** los componentes muestran datos y manejan interacción del usuario. Los servicios manejan la lógica de negocio y los datos.

---

## 4.2 Crear servicios con Angular CLI

```bash
# Crear un servicio en la carpeta services/
ng generate service services/tmdb
ng g s services/tmdb    # Atajo
```

---

## 4.3 Estructura de un servicio

```typescript
// services/tmdb.service.ts
// Importar Injectable del core de Angular
import { Injectable } from '@angular/core';

// @Injectable marca esta clase como un servicio que puede ser inyectado
@Injectable({
  // providedIn: 'root' = disponible en toda la aplicación
  // Angular crea UNA SOLA instancia (patrón Singleton)
  // Todos los componentes que lo inyecten comparten la misma instancia
  providedIn: 'root'
})
export class TmdbService {
  // URL base de la API de TMDB
  private apiUrl = 'https://api.themoviedb.org/3';
  // API key (después la moveremos a environment.ts)
  private apiKey = 'TU_API_KEY_AQUI';
}
```

---

## 4.4 Inyección de dependencias

Para usar un servicio en un componente, se **inyecta**. Angular lo crea y lo pasa automáticamente.

### Forma clásica: en el constructor

```typescript
import { Component, OnInit } from '@angular/core';
// Importar el servicio
import { TmdbService } from '../../services/tmdb.service';

@Component({ /* ... */ })
export class HomeComponent implements OnInit {
  // Angular inyecta el servicio automáticamente en el constructor
  // "private" crea la propiedad this.tmdbService
  constructor(private tmdbService: TmdbService) {}

  ngOnInit(): void {
    // Usar el servicio
    // this.tmdbService.obtenerPopulares()...
  }
}
```

### Forma moderna: con inject()

```typescript
import { Component, OnInit, inject } from '@angular/core';
import { TmdbService } from '../../services/tmdb.service';

@Component({ /* ... */ })
export class HomeComponent implements OnInit {
  // inject() inyecta el servicio sin necesidad de constructor
  // Es más conciso y funciona igual
  private tmdbService = inject(TmdbService);

  ngOnInit(): void {
    // Usar el servicio igual que antes
  }
}
```

💡 Ambas formas son válidas. `inject()` es más concisa y es la tendencia moderna.

---

## 4.5 Aplicar al proyecto: FavoritesService

Vamos a mover la lógica de favoritos del `AppComponent` a un servicio dedicado.

📁 Crear el servicio:

```bash
ng g s services/favorites --skip-tests
```

✏️ `src/app/services/favorites.service.ts`:

```typescript
// favorites.service.ts
// Servicio que maneja las películas favoritas del usuario
// Al ser singleton, todos los componentes comparten los mismos favoritos
import { Injectable } from '@angular/core';
import { Movie } from '../models/movie';

@Injectable({ providedIn: 'root' })
export class FavoritesService {
  // Array privado de películas favoritas
  // "private" impide que los componentes modifiquen el array directamente
  private favoritas: Movie[] = [];

  // Retorna una copia del array (para evitar mutación externa)
  // El spread operator [...] crea un nuevo array con los mismos elementos
  obtenerTodas(): Movie[] {
    return [...this.favoritas];
  }

  // Agrega una película a favoritos si no está ya
  agregar(movie: Movie): void {
    // .find() busca un elemento que cumpla la condición
    // Si no lo encuentra, retorna undefined
    if (!this.favoritas.find(m => m.id === movie.id)) {
      this.favoritas.push(movie);
    }
  }

  // Elimina una película de favoritos por su ID
  eliminar(id: number): void {
    // .filter() crea un nuevo array sin el elemento eliminado
    this.favoritas = this.favoritas.filter(m => m.id !== id);
  }

  // Verifica si una película es favorita
  esFavorita(id: number): boolean {
    // .some() retorna true si al menos un elemento cumple la condición
    return this.favoritas.some(m => m.id === id);
  }

  // Alterna el estado de favorito (agrega si no está, quita si está)
  toggle(movie: Movie): void {
    if (this.esFavorita(movie.id)) {
      this.eliminar(movie.id);
    } else {
      this.agregar(movie);
    }
  }

  // Retorna la cantidad de favoritas
  obtenerCantidad(): number {
    return this.favoritas.length;
  }
}
```

---

## 4.6 Usar el servicio en los componentes

✏️ Modificar `app.component.ts` para usar el servicio en lugar de manejar favoritos directamente:

```typescript
// app.component.ts
// Componente padre que usa FavoritesService para manejar favoritos
import { Component, inject } from '@angular/core';
import { MovieCardComponent } from './components/movie-card/movie-card.component';
import { Movie } from './models/movie';
// Importar el servicio
import { FavoritesService } from './services/favorites.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [MovieCardComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  titulo: string = 'CineExplorer';

  // Inyectar el servicio de favoritos
  private favoritesService = inject(FavoritesService);

  // Datos de ejemplo (después vendrán de TmdbService + HttpClient)
  peliculas: Movie[] = [
    {
      id: 550, title: 'Fight Club',
      overview: 'Un oficinista insomne y un fabricante de jabón forman un club de pelea clandestino.',
      poster_path: '/pB8BM7pdSp6B6Ih7QI4S2t0POoD.jpg',
      backdrop_path: '/hZkgoQYus5dXo3H8T7Uef6DNknx.jpg',
      vote_average: 8.4, release_date: '1999-10-15', genre_ids: [18, 53]
    },
    {
      id: 680, title: 'Pulp Fiction',
      overview: 'Las vidas de dos sicarios, un boxeador y la esposa de un gángster se entrelazan.',
      poster_path: '/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg',
      backdrop_path: '/suaEOtk1N1sgg2MTM7oZd2cfVp3.jpg',
      vote_average: 8.5, release_date: '1994-09-10', genre_ids: [53, 80]
    },
    {
      id: 13, title: 'Forrest Gump',
      overview: 'La historia de un hombre con un coeficiente intelectual bajo que logra cosas extraordinarias.',
      poster_path: '/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg',
      backdrop_path: '/7c9UVPPiTPltouxRVY6N9uugaVA.jpg',
      vote_average: 8.5, release_date: '1994-06-23', genre_ids: [35, 18, 10749]
    }
  ];

  // Ahora delega al servicio en lugar de manejar un Set local
  esFavorita(id: number): boolean {
    return this.favoritesService.esFavorita(id);
  }

  toggleFavorito(movie: Movie): void {
    this.favoritesService.toggle(movie);
  }
}
```

---

## 4.7 Separar lógica: ❌ mal vs. ✅ bien

```typescript
// ❌ MAL: lógica de negocio en el componente
export class FavoritesComponent {
  favoritas: Movie[] = [];

  agregar(movie: Movie): void {
    if (!this.favoritas.find(m => m.id === movie.id)) {
      this.favoritas.push(movie);
      localStorage.setItem('favoritas', JSON.stringify(this.favoritas));
    }
  }
}

// ✅ BIEN: lógica en un servicio, componente delgado
export class FavoritesComponent {
  // El componente solo llama métodos del servicio
  private favoritesService = inject(FavoritesService);
  favoritas = this.favoritesService.obtenerTodas();

  eliminar(id: number): void {
    this.favoritesService.eliminar(id);
    this.favoritas = this.favoritesService.obtenerTodas();
  }
}
```

---

## 4.8 Compilar y probar

▶️ La app debería funcionar exactamente igual que antes. La diferencia es interna: la lógica de favoritos ahora está en un servicio reutilizable. Cualquier componente futuro (navbar, página de favoritos) podrá usar el mismo servicio.

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| `@Injectable` | Marcar una clase como servicio inyectable |
| `providedIn: 'root'` | Singleton disponible en toda la app |
| `inject()` | Inyectar un servicio en un componente |
| Constructor injection | Forma clásica de inyectar servicios |
| Singleton | Una sola instancia compartida por todos los componentes |
| Separación de responsabilidades | Componentes = UI, Servicios = lógica |

---

**Anterior:** [← Capítulo 3 — Comunicación entre componentes](03_comunicacion_componentes.md) | **Siguiente:** [Capítulo 5 — Routing y navegación →](05_routing.md)
