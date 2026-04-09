package juego;

/**
 * Interfaz para una lista dinámica basada en arreglos.
 * Los estudiantes deben implementar TODOS estos métodos en ListaDinamica.java
 */
public interface IListaDinamica {

    /** Agrega un elemento al final de la lista */
    void agregar(String valor);

    /** Obtiene el elemento en la posición indicada */
    String obtener(int indice);

    /** Elimina el elemento en la posición indicada y lo retorna */
    String eliminar(int indice);

    /** Retorna la cantidad de elementos en la lista */
    int tamaño();

    /** Retorna true si la lista contiene el valor */
    boolean contiene(String valor);

    /** Retorna el índice del valor, o -1 si no existe */
    int indexOf(String valor);
}
