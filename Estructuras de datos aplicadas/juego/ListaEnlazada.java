package juego;

/**
 * ============================================================
 *  TAREA DEL ESTUDIANTE: Lista Enlazada
 * ============================================================
 *
 * Debes implementar TODOS los métodos de la interfaz IListaEnlazada.
 *
 * Reglas:
 * - Usa nodos (clase Nodo) enlazados entre sí.
 * - Mantén una referencia a la "cabeza" de la lista.
 * - NO puedes usar ArrayList, LinkedList ni ninguna clase de java.util.
 *
 * Pistas:
 * - Para agregar al final, recorre hasta el último nodo.
 * - Para eliminar, necesitas el nodo anterior al que vas a eliminar.
 * - Mantén un contador de tamaño para no tener que recorrer cada vez.
 */
public class ListaEnlazada implements IListaEnlazada {

    private Nodo cabeza;
    private int cantidad;

    public ListaEnlazada() {
        cabeza = null;
        cantidad = 0;
    }

    // =============================================
    //  IMPLEMENTA TODOS LOS MÉTODOS A CONTINUACIÓN
    // =============================================

    @Override
    public void agregar(String valor) {
        // TODO: Crear un nuevo Nodo. Si la lista está vacía, será la cabeza.
        //       Si no, recorrer hasta el final y enlazar el nuevo nodo.
        //       Incrementar cantidad.
        throw new UnsupportedOperationException("Implementa el método agregar()");
    }

    @Override
    public String obtener(int indice) {
        // TODO: Validar índice [0, cantidad). Recorrer la lista hasta
        //       llegar al nodo en la posición indicada. Retornar su valor.
        throw new UnsupportedOperationException("Implementa el método obtener()");
    }

    @Override
    public String eliminar(int indice) {
        // TODO: Validar índice. Si es 0, eliminar la cabeza.
        //       Si no, recorrer hasta el nodo anterior y "saltar" el nodo a eliminar.
        //       Decrementar cantidad. Retornar el valor eliminado.
        throw new UnsupportedOperationException("Implementa el método eliminar()");
    }

    @Override
    public int tamaño() {
        // TODO: Retornar la cantidad de elementos.
        throw new UnsupportedOperationException("Implementa el método tamaño()");
    }

    @Override
    public boolean contiene(String valor) {
        // TODO: Recorrer nodo por nodo comparando con .equals()
        //       Retornar true si lo encuentra, false si no.
        throw new UnsupportedOperationException("Implementa el método contiene()");
    }

    @Override
    public void insertar(int indice, String valor) {
        // TODO: Validar índice [0, cantidad]. Si es 0, insertar como nueva cabeza.
        //       Si no, recorrer hasta el nodo anterior a la posición e insertar ahí.
        //       Incrementar cantidad.
        throw new UnsupportedOperationException("Implementa el método insertar()");
    }
}
