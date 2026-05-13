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
