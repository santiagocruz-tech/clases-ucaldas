package juego;

/**
 * ============================================================
 *  TAREA DEL ESTUDIANTE: Lista Dinámica (basada en arreglos)
 * ============================================================
 *
 * Debes implementar TODOS los métodos de la interfaz IListaDinamica.
 *
 * Reglas:
 * - Usa un arreglo interno de String[] para almacenar los datos.
 * - Cuando el arreglo se llene, debes redimensionarlo (crear uno del doble de tamaño y copiar).
 * - NO puedes usar ArrayList, LinkedList ni ninguna clase de java.util.
 *
 * Pistas:
 * - Necesitas un campo "tamaño" para saber cuántos elementos hay realmente.
 * - Al eliminar, debes desplazar los elementos para no dejar huecos.
 */
public class ListaDinamica implements IListaDinamica {

    private String[] datos;
    private int cantidad;

    public ListaDinamica() {
        datos = new String[4]; // capacidad inicial pequeña para forzar redimensionamiento
        cantidad = 0;
    }

    // =============================================
    //  IMPLEMENTA TODOS LOS MÉTODOS A CONTINUACIÓN
    // =============================================

    @Override
    public void agregar(String valor) {
        // TODO: Si el arreglo está lleno, redimensionar.
        //       Luego agregar el valor en la posición 'cantidad' e incrementar.
        throw new UnsupportedOperationException("Implementa el método agregar()");
    }

    @Override
    public String obtener(int indice) {
        // TODO: Validar que el índice esté en rango [0, cantidad).
        //       Retornar el elemento en esa posición.
        throw new UnsupportedOperationException("Implementa el método obtener()");
    }

    @Override
    public String eliminar(int indice) {
        // TODO: Validar índice. Guardar el valor a eliminar.
        //       Desplazar elementos hacia la izquierda para llenar el hueco.
        //       Decrementar cantidad. Retornar el valor eliminado.
        throw new UnsupportedOperationException("Implementa el método eliminar()");
    }

    @Override
    public int tamaño() {
        // TODO: Retornar la cantidad de elementos almacenados.
        throw new UnsupportedOperationException("Implementa el método tamaño()");
    }

    @Override
    public boolean contiene(String valor) {
        // TODO: Recorrer el arreglo y comparar con .equals()
        //       Retornar true si lo encuentra, false si no.
        throw new UnsupportedOperationException("Implementa el método contiene()");
    }

    @Override
    public int indexOf(String valor) {
        // TODO: Recorrer el arreglo. Si encuentra el valor, retornar el índice.
        //       Si no lo encuentra, retornar -1.
        throw new UnsupportedOperationException("Implementa el método indexOf()");
    }

    // Puedes agregar métodos privados auxiliares como redimensionar()
}
