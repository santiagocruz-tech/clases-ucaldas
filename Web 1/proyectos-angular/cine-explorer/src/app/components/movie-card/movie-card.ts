// movie-card.ts
// Componente con input() (recibe datos) y output() (emite eventos)
import { Component, input, output } from '@angular/core';
// input y output se importan del core de Angular (funciones, no decoradores)
import { Movie } from '../../models/movie';

@Component({
  selector: 'app-movie-card',
  standalone: true,
  imports: [],
  templateUrl: './movie-card.html',
  styleUrls: ['./movie-card.scss']
})
export class MovieCard {
  // Entrada: datos que recibe del padre (signals)
  movie = input.required<Movie>();
  esFavorita = input<boolean>(false);

  // Salida: evento que emite hacia el padre
  // output<Movie>() crea un OutputEmitterRef que emite objetos Movie
  toggleFavorito = output<Movie>();

  // Método que se ejecuta al hacer click en el botón de favorito
  onToggleFavorito(): void {
    // .emit() envía el evento al padre con la película como dato
    // this.movie() con paréntesis porque es un signal
    this.toggleFavorito.emit(this.movie());
  }
}
