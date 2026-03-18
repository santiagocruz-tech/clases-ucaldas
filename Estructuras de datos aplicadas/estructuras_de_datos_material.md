# Estructuras de Datos (Java) — Universidad de Caldas (Ingeniería)

**Enfoque:** comprender primero **cómo funcionan internamente** las estructuras de datos y luego aprender a usar las implementaciones de Java.

Este documento está diseñado para que los estudiantes:

1. Comprendan **la lógica interna de las estructuras de datos**.
2. Aprendan a **implementarlas desde cero**.
3. Analicen **complejidad algorítmica**.
4. Finalmente utilicen **las implementaciones de la biblioteca estándar de Java**.

El curso mantiene un equilibrio aproximado de **50% teoría y 50% práctica**.

---

# Contenido del curso

1. Fundamentos de estructuras de datos
2. Implementación de listas desde cero
3. Pilas y colas
4. Tablas hash y conjuntos
5. Pensamiento recursivo
6. Árboles
7. Grafos
8. Proyectos finales

---

# 1. Fundamentos de estructuras de datos

## ¿Qué es una estructura de datos?

Una **estructura de datos** es una forma organizada de almacenar información para que pueda ser utilizada de manera eficiente.

Las estructuras de datos permiten realizar operaciones como:

- insertar datos
- eliminar datos
- buscar datos
- ordenar datos

La eficiencia de estas operaciones depende de **cómo estén organizados los datos internamente**.

---

## Complejidad algorítmica

Para analizar la eficiencia utilizamos **notación Big-O**.

Ejemplos:

| Complejidad | Significado |
|---|---|
| O(1) | tiempo constante |
| O(log n) | crecimiento logarítmico |
| O(n) | crecimiento lineal |
| O(n log n) | típico de algoritmos de ordenamiento eficientes |
| O(n²) | crecimiento cuadrático |

---

# 2. Implementación de listas desde cero

## Teoría

Una **lista** es una colección ordenada de elementos.

Existen dos implementaciones fundamentales:

1. **Arreglos dinámicos**
2. **Listas enlazadas**

Primero implementaremos una lista usando **arreglos** para entender cómo funcionan estructuras como `ArrayList`.

---

# 2.1 Arreglos

Un **arreglo** es una estructura que almacena elementos en posiciones contiguas de memoria.

Ejemplo conceptual:

```
indice:   0   1   2   3
valor:   10  20  30  40
```

Ventaja:

acceso rápido por índice

Complejidad:

acceso -> O(1)

---

# Implementar lista dinámica desde cero

Primero implementaremos una lista simple usando un arreglo.

```java
class ListaDinamica {

    private int[] datos;

    private int tamaño;

    public ListaDinamica(int capacidad){

        datos = new int[capacidad];

        tamaño = 0;

    }

    public void agregar(int valor){

        datos[tamaño] = valor;

        tamaño++;

    }

    public int obtener(int indice){

        return datos[indice];

    }

}
```

---

## Problema de capacidad

¿Qué pasa si el arreglo se llena?

Debemos **crear un arreglo más grande y copiar los elementos**.

Este es el principio detrás de `ArrayList`.

---

# Lista dinámica con redimensionamiento

```java

```

---

# 2.2 Listas enlazadas

En una **lista enlazada** cada elemento apunta al siguiente.

Representación conceptual

```
[10 | * ] -> [20 | * ] -> [30 | * ]
```

Cada nodo contiene

- dato
- referencia al siguiente nodo

---

# Implementación de nodo

```java
class Nodo{

    int valor;

    Nodo siguiente;

    Nodo(int valor){

        this.valor = valor;

    }

}
```

---

# Implementación de lista enlazada

```java
class ListaEnlazada{

    Nodo cabeza;

    public void agregar(int valor){

        Nodo nuevo = new Nodo(valor);

        if(cabeza == null){

            cabeza = nuevo;

            return;

        }

        Nodo actual = cabeza;

        while(actual.siguiente != null){

            actual = actual.siguiente;

        }

        actual.siguiente = nuevo;

    }

}
```

---

# Ejercicios

1 Implementar método eliminar en lista enlazada

2 Implementar búsqueda

3 Implementar inserción en posición específica

---

# 3. Pilas

## Teoría

Una **pila** funciona con el principio

LIFO

Last In First Out

Ejemplo

platos apilados

---

## Implementación desde cero

```java
class Pila{

    int[] datos = new int[100];

    int tope = -1;

    void push(int valor){

        datos[++tope] = valor;

    }

    int pop(){

        return datos[tope--];

    }

}
```

---

# 4. Colas

## Teoría

FIFO

First In First Out

Ejemplo

fila en banco

---

## Implementación

```java
class Cola{

    int[] datos = new int[100];

    int frente = 0;

    int fin = -1;

    void enqueue(int valor){

        datos[++fin] = valor;

    }

    int dequeue(){

        return datos[frente++];

    }

}
```

---

# 5. Ordenamientos

Antes de continuar con estructuras más complejas es importante entender **algoritmos de ordenamiento**.

## Bubble Sort

```java
public static void bubbleSort(int[] arr){

    for(int i=0;i<arr.length;i++){

        for(int j=0;j<arr.length-1;j++){

            if(arr[j] > arr[j+1]){

                int temp = arr[j];

                arr[j] = arr[j+1];

                arr[j+1] = temp;

            }

        }

    }

}
```

Complejidad

O(n²)

---

# 6. Recursión

Una función recursiva se llama a sí misma.

Debe tener

- caso base
- llamada recursiva

---

# Factorial

```java
static int factorial(int n){

    if(n<=1)
        return 1;

    return n * factorial(n-1);

}
```

---

# 7. Árboles

Un árbol es una estructura jerárquica.

Componentes

- raíz
- nodos
- hojas

---

## Nodo de árbol

```java
class NodoArbol{

    int valor;

    NodoArbol izquierdo;

    NodoArbol derecho;

}
```

---

# 8. Grafos

Un grafo es un conjunto de nodos conectados por aristas.

---

# Representación con lista de adyacencia

```java
Map<Integer,List<Integer>> grafo = new HashMap<>();
```

---

# Finalmente: uso de estructuras de Java

Después de comprender las implementaciones internas, se pueden usar estructuras de la biblioteca estándar:

- ArrayList
- LinkedList
- Stack
- Queue
- HashMap
- HashSet

Estas implementaciones están optimizadas y probadas.

---

# Proyectos finales

1 Simulador de banco (colas)

2 Editor con undo redo (pilas)

3 Sistema de rutas (grafos)

4 Motor de búsqueda de palabras (hashmaps)

---

# Evaluación

3 Parciales 60%

Talleres 15%

Proyecto final 25%

---

**Fin del documento**

