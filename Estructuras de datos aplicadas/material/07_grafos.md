# 7. Grafos

## Teoría

Un **grafo** es un conjunto de **nodos** (vértices) conectados por **aristas** (edges). A diferencia de los árboles, los grafos pueden tener ciclos, múltiples caminos entre nodos, y no tienen una raíz definida.

Analogía: una red de ciudades conectadas por carreteras. Cada ciudad es un nodo, cada carretera es una arista.

```
    A --- B
    |   / |
    |  /  |
    C --- D
```

---

## Tipos de grafos

- **Dirigido:** las aristas tienen dirección (A → B no implica B → A)
- **No dirigido:** las aristas van en ambas direcciones
- **Ponderado:** las aristas tienen un peso/costo (distancia, tiempo, etc.)
- **No ponderado:** todas las aristas tienen el mismo "costo"
- **Conexo:** existe un camino entre cualquier par de nodos
- **Cíclico:** contiene al menos un ciclo
- **Acíclico:** no contiene ciclos (un árbol es un grafo acíclico conexo)

---

## Representaciones

### Lista de adyacencia

Cada nodo almacena una lista de sus vecinos. Es la representación más común y eficiente para grafos dispersos.

```java
import java.util.*;

class Grafo {

    private Map<Integer, List<Integer>> adyacencia;

    public Grafo(){
        adyacencia = new HashMap<>();
    }

    public void agregarNodo(int nodo){
        adyacencia.putIfAbsent(nodo, new ArrayList<>());
    }

    public void agregarArista(int origen, int destino){
        agregarNodo(origen);
        agregarNodo(destino);
        adyacencia.get(origen).add(destino);
        adyacencia.get(destino).add(origen);  // quitar para grafo dirigido
    }

    public List<Integer> vecinos(int nodo){
        return adyacencia.getOrDefault(nodo, new ArrayList<>());
    }
}
```

### Matriz de adyacencia

Una matriz donde `matriz[i][j] = 1` si hay arista entre i y j.

```java
class GrafoMatriz {

    private int[][] matriz;
    private int numNodos;

    public GrafoMatriz(int numNodos){
        this.numNodos = numNodos;
        matriz = new int[numNodos][numNodos];
    }

    public void agregarArista(int origen, int destino){
        matriz[origen][destino] = 1;
        matriz[destino][origen] = 1;  // quitar para dirigido
    }

    public boolean hayArista(int origen, int destino){
        return matriz[origen][destino] == 1;
    }
}
```

| Representación | Espacio | Verificar arista | Listar vecinos |
|---|---|---|---|
| Lista de adyacencia | O(V + E) | O(grado) | O(grado) |
| Matriz de adyacencia | O(V²) | O(1) | O(V) |

Donde V = vértices, E = aristas.

---

## DFS: Búsqueda en profundidad

**DFS** (Depth-First Search) explora tan profundo como sea posible antes de retroceder. Es naturalmente recursivo y usa backtracking implícito.

### DFS recursivo

```java
void dfs(Grafo grafo, int nodo, Set<Integer> visitados){

    if(visitados.contains(nodo)){
        return;                          // ya visitado (evitar ciclos)
    }

    visitados.add(nodo);
    System.out.print(nodo + " ");

    for(int vecino : grafo.vecinos(nodo)){
        dfs(grafo, vecino, visitados);   // explorar vecinos recursivamente
    }
}

// Uso:
// Set<Integer> visitados = new HashSet<>();
// dfs(grafo, nodoInicial, visitados);
```

### DFS iterativo (con pila)

```java
void dfsIterativo(Grafo grafo, int inicio){

    Set<Integer> visitados = new HashSet<>();
    Stack<Integer> pila = new Stack<>();

    pila.push(inicio);

    while(!pila.isEmpty()){

        int nodo = pila.pop();

        if(visitados.contains(nodo)) continue;

        visitados.add(nodo);
        System.out.print(nodo + " ");

        for(int vecino : grafo.vecinos(nodo)){
            if(!visitados.contains(vecino)){
                pila.push(vecino);
            }
        }
    }
}
```

### Ambiente recursivo del DFS

Con el grafo:

```
    0 --- 1
    |     |
    2 --- 3
```

DFS desde 0:

```
dfs(0, {})
    visita 0, visitados = {0}
    dfs(1, {0})
        visita 1, visitados = {0,1}
        dfs(0, {0,1}) → ya visitado, retorna
        dfs(3, {0,1})
            visita 3, visitados = {0,1,3}
            dfs(1, {0,1,3}) → ya visitado, retorna
            dfs(2, {0,1,3})
                visita 2, visitados = {0,1,3,2}
                dfs(0, {0,1,3,2}) → ya visitado, retorna
                dfs(3, {0,1,3,2}) → ya visitado, retorna
            retorna
        retorna
    dfs(2, {0,1,3,2}) → ya visitado, retorna
retorna
```

Salida: `0 1 3 2`

Pila de llamadas en el momento más profundo:

```
| dfs(2)  |  ← tope
| dfs(3)  |
| dfs(1)  |
| dfs(0)  |  ← fondo
```

---

## BFS: Búsqueda en anchura

**BFS** (Breadth-First Search) explora todos los vecinos de un nodo antes de pasar al siguiente nivel. Usa una **cola**.

```java
void bfs(Grafo grafo, int inicio){

    Set<Integer> visitados = new HashSet<>();
    Queue<Integer> cola = new LinkedList<>();

    visitados.add(inicio);
    cola.add(inicio);

    while(!cola.isEmpty()){

        int nodo = cola.poll();
        System.out.print(nodo + " ");

        for(int vecino : grafo.vecinos(nodo)){
            if(!visitados.contains(vecino)){
                visitados.add(vecino);
                cola.add(vecino);
            }
        }
    }
}
```

Con el mismo grafo, BFS desde 0: `0 1 2 3` (nivel por nivel).

---

## DFS vs. BFS

| Aspecto | DFS | BFS |
|---|---|---|
| Estructura auxiliar | Pila (o recursión) | Cola |
| Exploración | Profundidad primero | Anchura primero |
| Encuentra camino más corto | No (en grafos no ponderados) | Sí |
| Memoria | O(profundidad máxima) | O(anchura máxima) |
| Detecta ciclos | Sí | Sí |
| Enfoque natural | Recursivo | Iterativo |

---

## Detectar ciclos con DFS

### En grafo no dirigido

```java
boolean tieneCiclo(Grafo grafo){

    Set<Integer> visitados = new HashSet<>();

    for(int nodo : grafo.todosLosNodos()){
        if(!visitados.contains(nodo)){
            if(dfsCiclo(grafo, nodo, -1, visitados)){
                return true;
            }
        }
    }

    return false;
}

boolean dfsCiclo(Grafo grafo, int nodo, int padre, Set<Integer> visitados){

    visitados.add(nodo);

    for(int vecino : grafo.vecinos(nodo)){

        if(!visitados.contains(vecino)){
            if(dfsCiclo(grafo, vecino, nodo, visitados)){
                return true;
            }
        }
        else if(vecino != padre){
            return true;  // encontramos un ciclo
        }
    }

    return false;
}
```

---

## Camino más corto con BFS (grafos no ponderados)

```java
List<Integer> caminoMasCorto(Grafo grafo, int inicio, int destino){

    Map<Integer, Integer> padre = new HashMap<>();
    Set<Integer> visitados = new HashSet<>();
    Queue<Integer> cola = new LinkedList<>();

    visitados.add(inicio);
    cola.add(inicio);
    padre.put(inicio, -1);

    while(!cola.isEmpty()){

        int nodo = cola.poll();

        if(nodo == destino){
            // reconstruir camino
            List<Integer> camino = new ArrayList<>();
            int actual = destino;
            while(actual != -1){
                camino.add(0, actual);
                actual = padre.get(actual);
            }
            return camino;
        }

        for(int vecino : grafo.vecinos(nodo)){
            if(!visitados.contains(vecino)){
                visitados.add(vecino);
                padre.put(vecino, nodo);
                cola.add(vecino);
            }
        }
    }

    return new ArrayList<>();  // no hay camino
}
```

---

## Backtracking en grafos: encontrar TODOS los caminos

A diferencia de BFS (que encuentra el más corto), el backtracking puede encontrar **todos** los caminos posibles entre dos nodos.

```java
void todosLosCaminos(Grafo grafo, int actual, int destino,
                     Set<Integer> visitados, List<Integer> camino){

    visitados.add(actual);
    camino.add(actual);

    if(actual == destino){
        System.out.println("Camino: " + camino);
    } else {
        for(int vecino : grafo.vecinos(actual)){
            if(!visitados.contains(vecino)){
                todosLosCaminos(grafo, vecino, destino, visitados, camino);
            }
        }
    }

    // BACKTRACK: desmarcar para explorar otros caminos
    camino.remove(camino.size() - 1);
    visitados.remove(actual);
}
```

Uso:

```java
todosLosCaminos(grafo, 0, 3, new HashSet<>(), new ArrayList<>());
```

Con el grafo `0-1, 0-2, 1-3, 2-3`:

```
Camino: [0, 1, 3]
Camino: [0, 2, 3]
```

El backtrack (`visitados.remove(actual)`) es crucial. Sin él, solo encontraríamos un camino porque los nodos quedarían marcados como visitados permanentemente.

---

## Backtracking: el problema del caballo de ajedrez

Encontrar un recorrido del caballo que visite todas las casillas de un tablero n×n exactamente una vez.

```java
boolean caballoRecorrido(int[][] tablero, int fila, int col,
                         int movimiento, int n){

    tablero[fila][col] = movimiento;

    if(movimiento == n * n){
        return true;  // visitó todas las casillas
    }

    // 8 movimientos posibles del caballo
    int[] df = {-2, -2, -1, -1, 1, 1, 2, 2};
    int[] dc = {-1, 1, -2, 2, -2, 2, -1, 1};

    for(int i = 0; i < 8; i++){

        int nf = fila + df[i];
        int nc = col + dc[i];

        if(nf >= 0 && nf < n && nc >= 0 && nc < n && tablero[nf][nc] == 0){
            if(caballoRecorrido(tablero, nf, nc, movimiento + 1, n)){
                return true;
            }
        }
    }

    // BACKTRACK
    tablero[fila][col] = 0;
    return false;
}

// Uso:
// int[][] tablero = new int[5][5];
// caballoRecorrido(tablero, 0, 0, 1, 5);
```

---

## Ordenamiento topológico (DFS en grafos dirigidos acíclicos)

Útil para determinar el orden de ejecución de tareas con dependencias.

```java
void ordenTopologico(Grafo grafo){

    Set<Integer> visitados = new HashSet<>();
    Stack<Integer> resultado = new Stack<>();

    for(int nodo : grafo.todosLosNodos()){
        if(!visitados.contains(nodo)){
            dfsTopologico(grafo, nodo, visitados, resultado);
        }
    }

    // imprimir en orden inverso
    while(!resultado.isEmpty()){
        System.out.print(resultado.pop() + " ");
    }
}

void dfsTopologico(Grafo grafo, int nodo, Set<Integer> visitados,
                   Stack<Integer> resultado){

    visitados.add(nodo);

    for(int vecino : grafo.vecinos(nodo)){
        if(!visitados.contains(vecino)){
            dfsTopologico(grafo, vecino, visitados, resultado);
        }
    }

    resultado.push(nodo);  // apilar DESPUÉS de procesar todos los vecinos
}
```

---

## Resumen: recursividad, iterativo y backtracking en grafos

| Algoritmo | Enfoque | Estructura auxiliar | Uso |
|---|---|---|---|
| DFS | Recursivo o iterativo con pila | Pila / call stack | Exploración profunda, ciclos, topológico |
| BFS | Iterativo con cola | Cola | Camino más corto, niveles |
| Todos los caminos | Backtracking | Set de visitados (con undo) | Exploración exhaustiva |
| Caballo de ajedrez | Backtracking | Tablero (con undo) | Problemas combinatorios |

---

## Ejercicios de grafos

1. Implementar DFS y BFS para un grafo representado con matriz de adyacencia.

2. Determinar si un grafo no dirigido es conexo (todos los nodos son alcanzables desde cualquier otro).

3. Contar el número de componentes conexos en un grafo. Pista: ejecutar DFS desde cada nodo no visitado.

4. Determinar si un grafo es bipartito (se puede colorear con 2 colores sin que dos vecinos tengan el mismo color). Usar BFS.

5. (Backtracking) Resolver un Sudoku 4×4 modelándolo como un problema de grafos con restricciones.

6. Implementar el algoritmo de Dijkstra para encontrar el camino más corto en un grafo ponderado.

7. Dado un laberinto representado como grafo, encontrar el camino más corto (BFS) y todos los caminos posibles (backtracking).

---
