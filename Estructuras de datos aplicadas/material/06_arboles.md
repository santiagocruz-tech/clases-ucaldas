# 6. Árboles

Los árboles son la estructura donde la recursividad se siente **completamente natural**. Un árbol es, por definición, una estructura recursiva: cada nodo es la raíz de un subárbol.

---

## Teoría

Un **árbol** es una estructura jerárquica compuesta por nodos conectados por aristas, donde:

- Hay un nodo especial llamado **raíz**
- Cada nodo puede tener cero o más **hijos**
- Un nodo sin hijos se llama **hoja**
- Cada nodo (excepto la raíz) tiene exactamente un **padre**

Analogía: un árbol genealógico, un sistema de archivos, un organigrama.

```
         10            ← raíz
        /  \
       5    15         ← nodos internos
      / \     \
     3   7    20       ← hojas
```

---

## Terminología

- **Raíz:** nodo superior (10 en el ejemplo)
- **Hoja:** nodo sin hijos (3, 7, 20)
- **Padre:** nodo que tiene hijos (10 es padre de 5 y 15)
- **Hijo:** nodo conectado hacia abajo (5 y 15 son hijos de 10)
- **Profundidad:** distancia desde la raíz (raíz = 0)
- **Altura:** distancia máxima desde un nodo hasta una hoja
- **Subárbol:** cualquier nodo junto con todos sus descendientes

---

## Nodo de árbol binario

Un **árbol binario** es un árbol donde cada nodo tiene como máximo **dos hijos** (izquierdo y derecho).

```java
class NodoArbol {

    int valor;
    NodoArbol izquierdo;
    NodoArbol derecho;

    NodoArbol(int valor){
        this.valor = valor;
    }
}
```

---

## ¿Por qué los árboles son naturalmente recursivos?

Observa la definición: un árbol es un nodo con subárboles. Cada subárbol es también un árbol. Esta definición es recursiva.

```
Árbol = Nodo + Árbol_izquierdo + Árbol_derecho
```

Por eso, casi todas las operaciones sobre árboles se expresan de forma recursiva de manera muy natural.

---

## Árbol binario de búsqueda (BST)

Un **BST** (Binary Search Tree) es un árbol binario donde para cada nodo:

- Todos los valores en el subárbol **izquierdo** son **menores**
- Todos los valores en el subárbol **derecho** son **mayores**

```
         10
        /  \
       5    15
      / \     \
     3   7    20
```

Esto permite buscar en **O(log n)** promedio (similar a búsqueda binaria).

---

## Insertar en BST (recursivo)

```java
NodoArbol insertar(NodoArbol nodo, int valor){

    if(nodo == null){
        return new NodoArbol(valor);     // caso base: crear nodo aquí
    }

    if(valor < nodo.valor){
        nodo.izquierdo = insertar(nodo.izquierdo, valor);
    } else if(valor > nodo.valor){
        nodo.derecho = insertar(nodo.derecho, valor);
    }
    // si es igual, no insertamos (sin duplicados)

    return nodo;
}
```

Traza insertando 7 en el árbol `10 → 5 → 15`:

```
insertar(nodo10, 7)
    7 < 10 → insertar(nodo5, 7)
        7 > 5 → insertar(null, 7)
            caso base → crear NodoArbol(7)
        nodo5.derecho = nodo7
    retorna nodo10
```

---

## Insertar en BST (iterativo)

```java
NodoArbol insertarIterativo(NodoArbol raiz, int valor){

    NodoArbol nuevo = new NodoArbol(valor);

    if(raiz == null) return nuevo;

    NodoArbol actual = raiz;
    NodoArbol padre = null;

    while(actual != null){
        padre = actual;
        if(valor < actual.valor){
            actual = actual.izquierdo;
        } else if(valor > actual.valor){
            actual = actual.derecho;
        } else {
            return raiz;  // duplicado, no insertar
        }
    }

    if(valor < padre.valor){
        padre.izquierdo = nuevo;
    } else {
        padre.derecho = nuevo;
    }

    return raiz;
}
```

Comparación: la versión recursiva es más limpia y natural. La iterativa usa menos memoria (no hay pila de llamadas).

---

## Buscar en BST

**Recursivo:**

```java
boolean buscar(NodoArbol nodo, int objetivo){

    if(nodo == null){
        return false;                    // caso base: no encontrado
    }

    if(nodo.valor == objetivo){
        return true;                     // caso base: encontrado
    }

    if(objetivo < nodo.valor){
        return buscar(nodo.izquierdo, objetivo);
    }

    return buscar(nodo.derecho, objetivo);
}
```

**Iterativo:**

```java
boolean buscarIterativo(NodoArbol raiz, int objetivo){

    NodoArbol actual = raiz;

    while(actual != null){
        if(actual.valor == objetivo) return true;
        if(objetivo < actual.valor){
            actual = actual.izquierdo;
        } else {
            actual = actual.derecho;
        }
    }

    return false;
}
```

Complejidad: **O(log n)** promedio, **O(n)** peor caso (árbol degenerado/lineal).

---

## Recorridos de árboles

Existen tres formas clásicas de recorrer un árbol binario. Todas son naturalmente recursivas.

### Inorden (izquierda → raíz → derecha)

En un BST, produce los valores **ordenados**.

```java
void inorden(NodoArbol nodo){

    if(nodo == null) return;

    inorden(nodo.izquierdo);
    System.out.print(nodo.valor + " ");
    inorden(nodo.derecho);
}
```

Con el árbol `10(5(3,7), 15(,20))`:

```
Salida: 3 5 7 10 15 20
```

### Preorden (raíz → izquierda → derecha)

Útil para copiar/serializar un árbol.

```java
void preorden(NodoArbol nodo){

    if(nodo == null) return;

    System.out.print(nodo.valor + " ");
    preorden(nodo.izquierdo);
    preorden(nodo.derecho);
}
```

Salida: `10 5 3 7 15 20`

### Postorden (izquierda → derecha → raíz)

Útil para eliminar un árbol (se eliminan hijos antes que el padre).

```java
void postorden(NodoArbol nodo){

    if(nodo == null) return;

    postorden(nodo.izquierdo);
    postorden(nodo.derecho);
    System.out.print(nodo.valor + " ");
}
```

Salida: `3 7 5 20 15 10`

---

## Ambiente recursivo en recorrido inorden

Con el árbol:

```
     10
    /  \
   5    15
```

```
inorden(10)
    inorden(5)
        inorden(null) → retorna
        imprime 5
        inorden(null) → retorna
    imprime 10
    inorden(15)
        inorden(null) → retorna
        imprime 15
        inorden(null) → retorna
```

Pila de llamadas en el momento más profundo (cuando se procesa el nodo 5):

```
| inorden(null)  |  ← tope
| inorden(5)     |
| inorden(10)    |  ← fondo
```

La profundidad máxima de la pila es la **altura del árbol**.

---

## Recorrido por niveles (BFS — iterativo con cola)

Este recorrido NO es recursivo naturalmente. Usa una **cola**.

```java
void recorridoPorNiveles(NodoArbol raiz){

    if(raiz == null) return;

    Cola cola = new Cola(100);  // o usar java.util.LinkedList
    cola.enqueue(raiz);

    while(!cola.isEmpty()){

        NodoArbol actual = cola.dequeue();
        System.out.print(actual.valor + " ");

        if(actual.izquierdo != null){
            cola.enqueue(actual.izquierdo);
        }
        if(actual.derecho != null){
            cola.enqueue(actual.derecho);
        }
    }
}
```

Salida: `10 5 15 3 7 20` (nivel por nivel)

Aquí vemos la diferencia:

- **DFS** (inorden, preorden, postorden) → usa **pila** (recursión o pila explícita)
- **BFS** (por niveles) → usa **cola**

---

## Recorrido inorden iterativo (con pila explícita)

```java
void inordenIterativo(NodoArbol raiz){

    java.util.Stack<NodoArbol> pila = new java.util.Stack<>();
    NodoArbol actual = raiz;

    while(actual != null || !pila.isEmpty()){

        // ir lo más a la izquierda posible
        while(actual != null){
            pila.push(actual);
            actual = actual.izquierdo;
        }

        actual = pila.pop();
        System.out.print(actual.valor + " ");

        actual = actual.derecho;
    }
}
```

Este es el equivalente iterativo del recorrido inorden recursivo. Más complejo de entender, pero no tiene riesgo de `StackOverflowError`.

---

## Calcular altura del árbol

**Recursivo:**

```java
int altura(NodoArbol nodo){

    if(nodo == null){
        return -1;                       // árbol vacío tiene altura -1
    }

    int alturaIzq = altura(nodo.izquierdo);
    int alturaDer = altura(nodo.derecho);

    return 1 + Math.max(alturaIzq, alturaDer);
}
```

**Iterativo (BFS):**

```java
int alturaIterativa(NodoArbol raiz){

    if(raiz == null) return -1;

    java.util.LinkedList<NodoArbol> cola = new java.util.LinkedList<>();
    cola.add(raiz);
    int altura = -1;

    while(!cola.isEmpty()){

        int tamaño = cola.size();
        altura++;

        for(int i = 0; i < tamaño; i++){
            NodoArbol actual = cola.poll();
            if(actual.izquierdo != null) cola.add(actual.izquierdo);
            if(actual.derecho != null) cola.add(actual.derecho);
        }
    }

    return altura;
}
```

---

## Contar nodos

```java
int contarNodos(NodoArbol nodo){

    if(nodo == null) return 0;

    return 1 + contarNodos(nodo.izquierdo) + contarNodos(nodo.derecho);
}
```

---

## Verificar si un árbol es BST válido

```java
boolean esBST(NodoArbol nodo, int min, int max){

    if(nodo == null) return true;

    if(nodo.valor <= min || nodo.valor >= max){
        return false;
    }

    return esBST(nodo.izquierdo, min, nodo.valor) &&
           esBST(nodo.derecho, nodo.valor, max);
}

// Uso: esBST(raiz, Integer.MIN_VALUE, Integer.MAX_VALUE)
```

---

## Eliminar un nodo en BST (recursivo)

Este es el algoritmo más complejo sobre BST. Hay tres casos:

1. **Nodo hoja:** simplemente eliminarlo
2. **Nodo con un hijo:** reemplazarlo por su hijo
3. **Nodo con dos hijos:** reemplazarlo por su sucesor inorden (el menor del subárbol derecho)

```java
NodoArbol eliminar(NodoArbol nodo, int objetivo){

    if(nodo == null) return null;

    if(objetivo < nodo.valor){
        nodo.izquierdo = eliminar(nodo.izquierdo, objetivo);
    }
    else if(objetivo > nodo.valor){
        nodo.derecho = eliminar(nodo.derecho, objetivo);
    }
    else {
        // encontramos el nodo a eliminar

        // caso 1: hoja o un solo hijo
        if(nodo.izquierdo == null) return nodo.derecho;
        if(nodo.derecho == null) return nodo.izquierdo;

        // caso 2: dos hijos → buscar sucesor inorden
        NodoArbol sucesor = encontrarMinimo(nodo.derecho);
        nodo.valor = sucesor.valor;
        nodo.derecho = eliminar(nodo.derecho, sucesor.valor);
    }

    return nodo;
}

NodoArbol encontrarMinimo(NodoArbol nodo){

    while(nodo.izquierdo != null){
        nodo = nodo.izquierdo;
    }
    return nodo;
}
```

---

## Backtracking en árboles: encontrar todos los caminos con una suma dada

Dado un árbol binario y un valor objetivo, encontrar **todos los caminos** desde la raíz hasta una hoja cuya suma sea igual al objetivo.

```java
void caminosConSuma(NodoArbol nodo, int objetivo, int sumaActual, String camino){

    if(nodo == null) return;

    sumaActual += nodo.valor;
    camino += nodo.valor + " → ";

    // si es hoja y la suma coincide
    if(nodo.izquierdo == null && nodo.derecho == null){
        if(sumaActual == objetivo){
            System.out.println("Camino encontrado: " + camino);
        }
        return;  // backtrack implícito (sumaActual y camino son locales)
    }

    // explorar ambos subárboles
    caminosConSuma(nodo.izquierdo, objetivo, sumaActual, camino);
    caminosConSuma(nodo.derecho, objetivo, sumaActual, camino);
}
```

Con el árbol:

```
         10
        /  \
       5    15
      / \     \
     3   7    20
```

`caminosConSuma(raiz, 18, 0, "")` → encuentra: `10 → 5 → 3` (suma = 18? No, 18≠18... veamos: 10+5+3=18 ✓)

Salida: `Camino encontrado: 10 → 5 → 3 →`

---

## Backtracking: generar todos los BST posibles con n nodos

Dado un número n, generar todos los árboles binarios de búsqueda estructuralmente diferentes que contienen valores de 1 a n.

```java
java.util.List<NodoArbol> generarBSTs(int inicio, int fin){

    java.util.List<NodoArbol> arboles = new java.util.ArrayList<>();

    if(inicio > fin){
        arboles.add(null);
        return arboles;
    }

    for(int i = inicio; i <= fin; i++){

        // i es la raíz
        java.util.List<NodoArbol> izquierdos = generarBSTs(inicio, i - 1);
        java.util.List<NodoArbol> derechos = generarBSTs(i + 1, fin);

        // combinar todas las posibilidades
        for(NodoArbol izq : izquierdos){
            for(NodoArbol der : derechos){
                NodoArbol raiz = new NodoArbol(i);
                raiz.izquierdo = izq;
                raiz.derecho = der;
                arboles.add(raiz);
            }
        }
    }

    return arboles;
}

// Uso: List<NodoArbol> todos = generarBSTs(1, 3);
// Con n=3, genera 5 árboles diferentes (números de Catalan)
```

---

## Ventajas y desventajas: iterativo vs. recursivo en árboles

| Operación | Recursivo | Iterativo |
|---|---|---|
| Recorridos DFS | Natural y limpio | Requiere pila explícita, más complejo |
| Recorrido BFS | No natural | Natural con cola |
| Insertar/buscar | Elegante | Más eficiente en memoria |
| Eliminar | Mucho más claro | Muy complejo |
| Riesgo StackOverflow | Sí (árboles muy profundos) | No |

**Recomendación:** para árboles, la recursividad es casi siempre la mejor opción. Los árboles balanceados tienen altura O(log n), así que la pila de llamadas rara vez es un problema.

---

## Ejercicios de árboles

1. Implementar una función que determine si dos árboles son idénticos (misma estructura y valores). Hacerlo recursivo e iterativo.

2. Encontrar el ancestro común más bajo (LCA) de dos nodos en un BST.

3. Convertir un arreglo ordenado en un BST balanceado. Pista: el elemento del medio es la raíz.

4. Imprimir el árbol por niveles, pero en zigzag (nivel 0 izq→der, nivel 1 der→izq, etc.). Usar dos pilas.

5. (Backtracking) Dado un árbol binario, encontrar el camino más largo entre dos nodos cualesquiera (diámetro del árbol).

6. Serializar un árbol a String y deserializarlo de vuelta a árbol. Usar preorden con marcadores para nulos.

---
