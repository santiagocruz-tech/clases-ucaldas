# 9. Resumen general y mapa conceptual

## Mapa de estructuras, enfoques y complejidades

```
┌──────────────────────────────────────────────────────────────────────┐
│                    ESTRUCTURAS DE DATOS                              │
├──────────────┬───────────────┬──────────────┬───────────────────────┤
│   Lineales   │  Jerárquicas  │    Redes     │   Clave-Valor        │
├──────────────┼───────────────┼──────────────┼───────────────────────┤
│ Arreglos     │ Árboles       │ Grafos       │ Tablas Hash          │
│ Listas enlaz.│ BST           │ Dirigidos    │ HashMap              │
│ Pilas        │ AVL (*)       │ No dirigidos │ HashSet              │
│ Colas        │ Heaps (*)     │ Ponderados   │                      │
└──────────────┴───────────────┴──────────────┴───────────────────────┘
                                                    (*) temas avanzados
```

---

## Cuándo usar cada enfoque

```
┌─────────────────────────────────────────────────────────────────┐
│                    ¿Qué enfoque usar?                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ¿La estructura es lineal?                                      │
│      SÍ → ITERATIVO (listas, arreglos, pilas, colas)           │
│                                                                 │
│  ¿La estructura es jerárquica?                                  │
│      SÍ → RECURSIVO (árboles, subárboles)                      │
│                                                                 │
│  ¿Necesitas explorar múltiples opciones?                        │
│      SÍ → BACKTRACKING (combinaciones, puzzles, caminos)       │
│                                                                 │
│  ¿Necesitas el camino más corto?                                │
│      SÍ → BFS con cola                                         │
│                                                                 │
│  ¿Necesitas explorar en profundidad?                            │
│      SÍ → DFS con recursión o pila                             │
│                                                                 │
│  ¿Los datos pueden ser muy grandes (>10,000)?                   │
│      SÍ → Prefiere ITERATIVO para evitar StackOverflow         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Tabla resumen de complejidades

| Estructura | Insertar | Buscar | Eliminar | Acceso por índice |
|---|---|---|---|---|
| Arreglo dinámico | O(1) amortizado | O(n) | O(n) | O(1) |
| Lista enlazada | O(1) al inicio | O(n) | O(n) | O(n) |
| Pila | O(1) push | O(n) | O(1) pop | No aplica |
| Cola | O(1) enqueue | O(n) | O(1) dequeue | No aplica |
| BST (balanceado) | O(log n) | O(log n) | O(log n) | No aplica |
| Tabla Hash | O(1) promedio | O(1) promedio | O(1) promedio | No aplica |

---

## Conexiones entre conceptos

- **Recursividad** usa internamente una **pila** (call stack)
- **DFS** puede implementarse con **recursividad** o con **pila explícita**
- **BFS** usa una **cola**
- **Backtracking** es **recursividad** + **deshacer decisiones**
- **Árboles** son **grafos** acíclicos conexos
- **Tablas hash** usan **listas enlazadas** para manejar colisiones
- **Merge Sort** usa **recursividad** (divide y vencerás)
- **Quick Sort** usa **recursividad** + **particionamiento**

---

## Uso de la biblioteca estándar de Java

Después de comprender las implementaciones internas, se pueden usar las versiones optimizadas:

| Nuestra implementación | Equivalente en Java |
|---|---|
| ListaDinamica | `ArrayList<E>` |
| ListaEnlazada | `LinkedList<E>` |
| Pila | `Stack<E>` o `Deque<E>` |
| Cola | `Queue<E>` / `LinkedList<E>` |
| TablaHash | `HashMap<K,V>` |
| Conjunto | `HashSet<E>` |
| Cola de prioridad | `PriorityQueue<E>` |
| Árbol (BST) | `TreeMap<K,V>` / `TreeSet<E>` |

---

# 10. Proyectos finales

1. **Simulador de banco (colas + prioridad):** clientes llegan aleatoriamente, hay ventanillas normales y preferenciales. Simular tiempos de espera y atención.

2. **Editor de texto con undo/redo (pilas):** cada acción se apila. Ctrl+Z desapila de la pila de acciones y apila en la pila de redo.

3. **Sistema de rutas entre ciudades (grafos + BFS/DFS):** modelar ciudades como nodos, carreteras como aristas ponderadas. Encontrar la ruta más corta entre dos ciudades.

4. **Motor de búsqueda de palabras (tablas hash + árboles):** indexar un conjunto de documentos y permitir búsquedas por palabra con ranking de relevancia.

5. **Solucionador de Sudoku (backtracking):** resolver un Sudoku 9×9 usando backtracking puro. Mostrar el proceso paso a paso.

6. **Juego de inventario con lista enlazada (ya implementado en el proyecto del curso):** expandirlo con búsqueda recursiva, ordenamiento y persistencia.

---

# Evaluación

3 Parciales 60%

Talleres 15%

Proyecto final 25%

---

**Fin del documento**
