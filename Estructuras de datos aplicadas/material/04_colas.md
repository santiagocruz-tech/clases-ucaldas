# 4. Colas (Queues)

## Teoría

Una **cola** es una estructura de datos que funciona con el principio **FIFO** (First In, First Out): el primer elemento que entra es el primero que sale.

Analogía: una fila en un banco. La primera persona que llega es la primera en ser atendida. No puedes saltarte la fila.

Operaciones fundamentales:

- **enqueue(valor):** agregar un elemento al final de la cola
- **dequeue():** quitar y retornar el elemento del frente
- **peek():** ver el elemento del frente sin quitarlo
- **isEmpty():** verificar si la cola está vacía

---

## Implementación con arreglo circular (iterativa)

Un arreglo simple tiene un problema: al hacer `dequeue`, el espacio al inicio se desperdicia. La solución es un **arreglo circular** donde los índices "dan la vuelta".

```java
class Cola {

    private int[] datos;
    private int frente;
    private int fin;
    private int tamaño;
    private int capacidad;

    public Cola(int capacidad){
        this.capacidad = capacidad;
        datos = new int[capacidad];
        frente = 0;
        fin = -1;
        tamaño = 0;
    }

    public void enqueue(int valor){
        if(tamaño == capacidad){
            throw new RuntimeException("Cola llena");
        }
        fin = (fin + 1) % capacidad;  // avanza circularmente
        datos[fin] = valor;
        tamaño++;
    }

    public int dequeue(){
        if(tamaño == 0){
            throw new RuntimeException("Cola vacía");
        }
        int valor = datos[frente];
        frente = (frente + 1) % capacidad;  // avanza circularmente
        tamaño--;
        return valor;
    }

    public int peek(){
        if(tamaño == 0){
            throw new RuntimeException("Cola vacía");
        }
        return datos[frente];
    }

    public boolean isEmpty(){
        return tamaño == 0;
    }
}
```

Visualización del arreglo circular:

```
Capacidad: 5

Después de enqueue(10), enqueue(20), enqueue(30):

  [10] [20] [30] [  ] [  ]
   ^frente        ^fin

Después de dequeue() → retorna 10:

  [  ] [20] [30] [  ] [  ]
        ^frente   ^fin

Después de enqueue(40), enqueue(50), enqueue(60):

  [60] [20] [30] [40] [50]
   ^fin ^frente
   
El índice "dio la vuelta" gracias al operador %
```

---

## Implementación con lista enlazada

```java
class ColaEnlazada {

    private Nodo frente;
    private Nodo fin;

    public void enqueue(int valor){
        Nodo nuevo = new Nodo(valor);
        if(fin != null){
            fin.siguiente = nuevo;
        }
        fin = nuevo;
        if(frente == null){
            frente = nuevo;
        }
    }

    public int dequeue(){
        if(frente == null){
            throw new RuntimeException("Cola vacía");
        }
        int valor = frente.valor;
        frente = frente.siguiente;
        if(frente == null){
            fin = null;
        }
        return valor;
    }

    public boolean isEmpty(){
        return frente == null;
    }
}
```

---

## Colas y recursividad

Las colas no tienen una relación tan directa con la recursividad como las pilas. Sin embargo, hay un ejercicio clásico que conecta ambos conceptos:

### Invertir una cola usando recursividad

```java
void invertirCola(Cola cola){

    if(cola.isEmpty()){
        return;                    // caso base
    }

    int valor = cola.dequeue();    // sacar el frente

    invertirCola(cola);            // invertir el resto recursivamente

    cola.enqueue(valor);           // poner el valor al final
}
```

Traza con cola `[10, 20, 30]` (10 al frente):

```
invertirCola([10, 20, 30])
    saca 10
    invertirCola([20, 30])
        saca 20
        invertirCola([30])
            saca 30
            invertirCola([])
                caso base → retorna
            enqueue(30) → [30]
        enqueue(20) → [30, 20]
    enqueue(10) → [30, 20, 10]
```

Resultado: la cola quedó invertida.

---

### Ordenar una cola usando recursividad

```java
void ordenarCola(Cola cola){

    if(cola.isEmpty()){
        return;
    }

    int minimo = extraerMinimo(cola);

    ordenarCola(cola);

    cola.enqueue(minimo);  // se inserta al final, pero como ya está ordenado...
    // necesitamos rotar para que quede al frente
}

int extraerMinimo(Cola cola){

    int min = Integer.MAX_VALUE;
    int tamaño = cola.tamaño;

    for(int i = 0; i < tamaño; i++){
        int valor = cola.dequeue();
        if(valor < min){
            min = valor;
        }
        cola.enqueue(valor);
    }

    // remover el mínimo de la cola
    for(int i = 0; i < tamaño; i++){
        int valor = cola.dequeue();
        if(valor != min){
            cola.enqueue(valor);
        }
    }

    return min;
}
```

---

## BFS: Recorrido en anchura (la aplicación estrella de las colas)

El **BFS** (Breadth-First Search) es un algoritmo que recorre estructuras nivel por nivel. Usa una cola internamente. Lo veremos en detalle en la sección de árboles y grafos, pero aquí va una introducción:

```
Imagina un árbol genealógico:
        Abuelo
       /      \
    Padre     Tío
    /   \       \
  Hijo  Hija   Prima

BFS recorre: Abuelo → Padre → Tío → Hijo → Hija → Prima
(nivel por nivel, de izquierda a derecha)
```

La cola garantiza que se procesen los nodos en el orden correcto.

---

## Cola de prioridad (concepto)

En una cola normal, el primero en entrar es el primero en salir. En una **cola de prioridad**, sale primero el elemento con mayor (o menor) prioridad.

Analogía: en urgencias de un hospital, no atienden por orden de llegada sino por gravedad.

```java
// Usando PriorityQueue de Java (min-heap por defecto)
import java.util.PriorityQueue;

PriorityQueue<Integer> colaPrioridad = new PriorityQueue<>();
colaPrioridad.add(30);
colaPrioridad.add(10);
colaPrioridad.add(20);

System.out.println(colaPrioridad.poll());  // 10 (el menor)
System.out.println(colaPrioridad.poll());  // 20
System.out.println(colaPrioridad.poll());  // 30
```

---

## Ejercicios de colas

1. Implementar un sistema de turnos para un banco. Cada cliente tiene un nombre y un tipo (preferencial o normal). Los preferenciales tienen prioridad.

2. Implementar `intercalarColas(Cola a, Cola b)` que combine dos colas alternando elementos: a1, b1, a2, b2, ...

3. Simular el juego de la "papa caliente": n personas en círculo, se cuenta hasta k y esa persona sale. Usar una cola. ¿Quién sobrevive? (Problema de Josefo).

4. Implementar una cola usando dos pilas. Pista: una pila para enqueue, otra para dequeue.

5. (Recursivo) Dado un número entero, generar todos los números binarios del 1 al n usando una cola. Ejemplo: n=5 → "1", "10", "11", "100", "101".

---

## Comparación: Pila vs. Cola

| Aspecto | Pila (LIFO) | Cola (FIFO) |
|---|---|---|
| Orden de salida | Último en entrar | Primero en entrar |
| Analogía | Platos apilados | Fila en banco |
| Uso en recursión | Directamente (call stack) | Indirectamente (BFS) |
| Aplicaciones | Undo/redo, paréntesis, DFS | Turnos, BFS, buffers |
| Complejidad push/enqueue | O(1) | O(1) |
| Complejidad pop/dequeue | O(1) | O(1) |

---
