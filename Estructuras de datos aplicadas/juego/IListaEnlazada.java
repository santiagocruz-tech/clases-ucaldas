package juego;

/**
 * Interfaz para una lista enlazada.
 * Los estudiantes deben implementar TODOS estos métodos en ListaEnlazada.java
 */
public interface IListaEnlazada {

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

    /** Inserta un elemento en una posición específica */
    void insertar(int indice, String valor);
}
