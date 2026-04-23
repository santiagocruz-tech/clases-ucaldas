# Capítulo 1: TypeScript para Angular

## Objetivo

Aprender la sintaxis de TypeScript que necesitamos para Angular. Al final de este capítulo, habremos creado las interfaces que representan los datos de la API de TMDB para CineExplorer.

---

## 1.1 ¿Por qué TypeScript?

Angular está escrito en TypeScript y obliga a usarlo. TypeScript es JavaScript con tipos. Las ventajas:

- El editor detecta errores **antes** de ejecutar el código
- Autocompletado inteligente (saben qué propiedades tiene un objeto)
- Código más legible y mantenible en equipos
- Refactorización segura

TypeScript compila a JavaScript. El navegador nunca ejecuta TypeScript directamente.

---

## 1.2 Tipos básicos

```typescript
// Tipos primitivos — se declaran con : después del nombre
let nombre: string = "CineExplorer";  // texto
let anio: number = 2024;              // número (entero o decimal)
let activo: boolean = true;           // verdadero o falso

// Arrays — se declaran con tipo[]
let generos: string[] = ["Acción", "Comedia", "Drama"];  // array de strings
let puntuaciones: number[] = [8.5, 7.2, 9.1];           // array de números

// any — evitar siempre que sea posible
// Desactiva el tipado, perdemos las ventajas de TypeScript
let cualquierCosa: any = "hola";
cualquierCosa = 42;  // no da error, pero es peligroso

// unknown — más seguro que any
// Obliga a verificar el tipo antes de usarlo
let dato: unknown = "hola";
// dato.toUpperCase();  // ERROR: hay que verificar el tipo primero
if (typeof dato === "string") {
  dato.toUpperCase();  // OK, TypeScript sabe que es string
}

// void — funciones que no retornan nada
function saludar(): void {
  console.log("Hola");
  // No tiene return
}
```

---

## 1.3 Interfaces

Las interfaces definen la forma de un objeto. Son fundamentales en Angular para tipar datos de APIs.

```typescript
// Definir una interfaz con la palabra clave "interface"
// Cada propiedad tiene un nombre y un tipo
interface Pelicula {
  id: number;            // identificador único
  title: string;         // título de la película
  overview: string;      // sinopsis
  poster_path: string;   // ruta de la imagen del póster
  vote_average: number;  // puntuación promedio (0-10)
  release_date: string;  // fecha de estreno como texto
  genre_ids: number[];   // array de IDs de géneros
}

// Propiedad opcional: se agrega "?" después del nombre
// No es obligatorio incluirla al crear el objeto
interface PeliculaDetalle extends Pelicula {
  // "extends" hereda todas las propiedades de Pelicula
  runtime: number;          // duración en minutos
  genres: Genero[];         // array de objetos Genero
  budget: number;           // presupuesto
  revenue: number;          // recaudación
  tagline?: string;         // frase promocional (opcional)
}

// Interfaz para la respuesta paginada de la API
interface PeliculaResponse {
  page: number;              // página actual
  results: Pelicula[];       // array de películas
  total_pages: number;       // total de páginas disponibles
  total_results: number;     // total de resultados
}

// Interfaz para géneros
interface Genero {
  id: number;      // ID del género
  name: string;    // nombre del género ("Acción", "Comedia", etc.)
}

// Usar la interfaz para tipar una variable
const miPelicula: Pelicula = {
  id: 550,
  title: "Fight Club",
  overview: "Un oficinista insomne...",
  poster_path: "/pB8BM7pdSp6B6Ih7QI4S2t0POoD.jpg",
  vote_average: 8.4,
  release_date: "1999-10-15",
  genre_ids: [18, 53]
};

// Tipar parámetros y retorno de funciones
function obtenerTitulo(pelicula: Pelicula): string {
  return pelicula.title;
}
```

---

## 1.4 Types

Similar a interfaces pero con sintaxis diferente. Útiles para uniones y alias.

```typescript
// Type alias: un nombre corto para un tipo
type ID = number | string;  // puede ser número o string

// Unión de tipos literales: solo acepta estos valores exactos
type Tema = "light" | "dark";
// let temaActual: Tema = "blue";  // ERROR: "blue" no es válido

// Type para objetos (similar a interface)
type Coordenada = {
  x: number;
  y: number;
};
```

💡 **¿Interface o Type?** Usar `interface` para modelos de datos (películas, géneros, respuestas de API). Usar `type` para uniones y alias. En Angular, la convención es interfaces para modelos.

---

## 1.5 Clases con tipado

```typescript
// Clase con propiedades tipadas
class Persona {
  // Propiedades con tipo y visibilidad
  nombre: string;          // pública por defecto
  private email: string;   // solo accesible dentro de la clase

  // Constructor: se ejecuta al crear una instancia con "new"
  constructor(nombre: string, email: string) {
    this.nombre = nombre;
    this.email = email;
  }

  // Método con tipo de retorno
  saludar(): string {
    return `Hola, soy ${this.nombre}`;
  }
}

// Atajo del constructor (muy usado en Angular para inyección de dependencias)
// "public" y "private" en los parámetros crean las propiedades automáticamente
class Estudiante {
  constructor(
    public nombre: string,    // crea this.nombre automáticamente
    public edad: number,      // crea this.edad automáticamente
    private carrera: string   // crea this.carrera (privada) automáticamente
  ) {}
  // No necesitamos asignar this.nombre = nombre, TypeScript lo hace solo
}

const est = new Estudiante("Carlos", 20, "Ingeniería");
console.log(est.nombre);  // "Carlos"
// console.log(est.carrera);  // ERROR: carrera es private
```

---

## 1.6 Enums

```typescript
// Enum: conjunto fijo de valores con nombre
// Útil para categorías, estados, roles
enum Categoria {
  Accion = "ACTION",
  Comedia = "COMEDY",
  Drama = "DRAMA",
  Terror = "HORROR",
  SciFi = "SCI_FI"
}

// Uso
let generoFavorito: Categoria = Categoria.Accion;

// En condicionales
if (generoFavorito === Categoria.Accion) {
  console.log("Te gustan las películas de acción");
}
```

---

## 1.7 Generics

Los generics permiten crear funciones y clases que trabajan con cualquier tipo.

```typescript
// Función genérica: <T> es un tipo que se define al llamar la función
// Permite reutilizar la misma función con diferentes tipos
function primero<T>(array: T[]): T | undefined {
  return array[0];
}

// TypeScript infiere el tipo automáticamente
const primerNumero = primero([1, 2, 3]);        // tipo: number
const primerTexto = primero(["a", "b", "c"]);   // tipo: string

// Interface genérica (muy común para respuestas de API)
// T es un placeholder que se reemplaza al usar la interfaz
interface RespuestaApi<T> {
  data: T;          // los datos pueden ser de cualquier tipo
  status: number;   // código HTTP
  mensaje: string;  // mensaje descriptivo
}

// Uso: especificar qué tipo es T
const respuesta: RespuestaApi<Pelicula[]> = {
  data: [miPelicula],
  status: 200,
  mensaje: "OK"
};
```

---

## 1.8 Módulos (import/export)

```typescript
// archivo: models/movie.ts
// "export" hace que la interfaz esté disponible para otros archivos
export interface Movie {
  id: number;
  title: string;
  overview: string;
}

// archivo: services/tmdb.service.ts
// "import" trae la interfaz desde otro archivo
// La ruta es relativa al archivo actual
import { Movie } from '../models/movie';

export function obtenerTitulo(movie: Movie): string {
  return movie.title;
}
```

---

## 1.9 Decoradores

Los decoradores son funciones especiales que modifican clases o propiedades. Angular los usa en todo.

```typescript
// En Angular, los decoradores más comunes son:
@Component({...})    // Marca una clase como componente de UI
@Injectable({...})   // Marca una clase como servicio inyectable
@Input()             // Marca una propiedad como entrada de datos (padre → hijo)
@Output()            // Marca una propiedad como salida de eventos (hijo → padre)
@Pipe({...})         // Marca una clase como pipe (transformador de datos)

// No necesitan crear decoradores propios
// Solo entender que son "etiquetas" que le dicen a Angular
// qué rol tiene cada clase o propiedad
```

---

## 1.10 Aplicar al proyecto: Interfaces de CineExplorer

Vamos a crear las interfaces que usaremos en toda la app para tipar los datos de la API de TMDB.

📁 Crear la carpeta `src/app/models/` y dentro el archivo `movie.ts`:

```typescript
// src/app/models/movie.ts
// Interfaces que representan los datos de la API de TMDB
// Estas interfaces se usan en toda la app para tipar respuestas HTTP

// Película básica (lo que devuelve la lista de populares, búsqueda, etc.)
export interface Movie {
  id: number;               // ID único de la película en TMDB
  title: string;            // título de la película
  overview: string;         // sinopsis / descripción
  poster_path: string;      // ruta relativa del póster (se concatena con base URL)
  backdrop_path: string;    // ruta relativa de la imagen de fondo
  vote_average: number;     // puntuación promedio (0 a 10)
  release_date: string;     // fecha de estreno en formato "YYYY-MM-DD"
  genre_ids: number[];      // array de IDs de géneros
}

// Respuesta paginada de la API (GET /movie/popular, GET /search/movie, etc.)
export interface MovieResponse {
  page: number;             // número de página actual
  results: Movie[];         // array de películas de esta página
  total_pages: number;      // total de páginas disponibles
  total_results: number;    // total de resultados encontrados
}

// Detalle completo de una película (GET /movie/{id})
export interface MovieDetail extends Movie {
  runtime: number;          // duración en minutos
  genres: Genre[];          // array de objetos género (no solo IDs)
  budget: number;           // presupuesto en USD
  revenue: number;          // recaudación en USD
  tagline: string;          // frase promocional
  original_language: string; // idioma original
}

// Género de película
export interface Genre {
  id: number;       // ID del género
  name: string;     // nombre del género ("Action", "Comedy", etc.)
}

// Créditos de una película (GET /movie/{id}/credits)
export interface Credits {
  cast: CastMember[];   // actores
  crew: CrewMember[];   // equipo técnico (director, etc.)
}

// Miembro del reparto (actor)
export interface CastMember {
  id: number;                  // ID del actor
  name: string;                // nombre real
  character: string;           // personaje que interpreta
  profile_path: string | null; // foto del actor (puede ser null)
}

// Miembro del equipo técnico
export interface CrewMember {
  id: number;       // ID
  name: string;     // nombre
  job: string;      // rol ("Director", "Producer", etc.)
}
```

---

## Resumen de conceptos

| Concepto | Para qué | Ejemplo |
|----------|----------|---------|
| Tipos básicos | Tipar variables | `let nombre: string = "Ana"` |
| Interfaces | Definir forma de objetos | `interface Movie { id: number; ... }` |
| Types | Uniones y alias | `type Tema = "light" \| "dark"` |
| Clases | Agrupar datos y lógica | `class Persona { ... }` |
| Enums | Conjunto fijo de valores | `enum Rol { Admin, User }` |
| Generics | Funciones/clases reutilizables | `function primero<T>(arr: T[]): T` |
| import/export | Compartir código entre archivos | `export interface Movie { ... }` |
| Decoradores | Configurar clases para Angular | `@Component({...})` |

---

**Anterior:** [← Capítulo 0 — Prerequisitos](00_prerequisitos.md) | **Siguiente:** [Capítulo 2 — Componentes →](02_componentes.md)
