// app.ts
// Componente padre que pasa datos a los hijos MovieCard
import { Component } from '@angular/core';
import { MovieCard } from './components/movie-card/movie-card';
import { Movie } from './models/movie';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [MovieCard],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  titulo: string = 'CineExplorer';

  // Array de películas de ejemplo (después vendrán de la API)
  peliculas: Movie[] = [
    {
      id: 550,
      title: 'Fight Club',
      overview: 'Un oficinista insomne y un fabricante de jabón forman un club de pelea clandestino.',
      poster_path: '/jSziioSwPVrOy9Yow3XhWIBDjq1.jpg',
      backdrop_path: '/hZkgoQYus5dXo3H8T7Uef6DNknx.jpg',
      vote_average: 8.4,
      release_date: '1999-10-15',
      genre_ids: [18, 53]
    },
    {
      id: 680,
      title: 'Pulp Fiction',
      overview: 'Las vidas de dos sicarios, un boxeador y la esposa de un gángster se entrelazan.',
      poster_path: '/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg',
      backdrop_path: '/suaEOtk1N1sgg2MTM7oZd2cfVp3.jpg',
      vote_average: 8.5,
      release_date: '1994-09-10',
      genre_ids: [53, 80]
    },
    {
      id: 13,
      title: 'Forrest Gump',
      overview: 'La historia de un hombre con un coeficiente intelectual bajo que logra cosas extraordinarias.',
      poster_path: '/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg',
      backdrop_path: '/7c9UVPPiTPltouxRVY6N9uugaVA.jpg',
      vote_average: 8.5,
      release_date: '1994-06-23',
      genre_ids: [35, 18, 10749]
    }
  ];

  // Set de IDs de películas favoritas
  favoritasIds: Set<number> = new Set();

  // Verifica si una película es favorita
  esFavorita(id: number): boolean {
    return this.favoritasIds.has(id);
  }

  // Alterna el estado de favorito de una película
  toggleFavorito(movie: Movie): void {
    if (this.favoritasIds.has(movie.id)) {
      this.favoritasIds.delete(movie.id);
    } else {
      this.favoritasIds.add(movie.id);
    }
  }
}
