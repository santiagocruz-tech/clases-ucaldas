# Estructuras de Datos (Java) — Universidad de Caldas (Ingeniería)

**Enfoque:** comprender primero **cómo funcionan internamente** las estructuras de datos y luego aprender a usar las implementaciones de Java.

Este documento está diseñado para que los estudiantes:

1. Comprendan **la lógica interna de las estructuras de datos**.
2. Aprendan a **implementarlas desde cero**.
3. Analicen **complejidad algorítmica**.
4. Finalmente utilicen **las implementaciones de la biblioteca estándar de Java**.

El curso mantiene un equilibrio aproximado de **50% teoría y 50% práctica**.

Cada sección incluye enfoques **iterativos**, **recursivos** y de **backtracking**, con explicaciones de ambientes recursivos, ventajas/desventajas de cada enfoque, y ejercicios progresivos.

---

# Contenido del curso

## 1. Fundamentos de estructuras de datos

> 📄 [material/01_fundamentos.md](material/01_fundamentos.md)

- ¿Qué es una estructura de datos?
- Complejidad algorítmica y notación Big-O

---

## 2. Implementación de listas desde cero

> 📄 [material/02_listas.md](material/02_listas.md)

- 2.1 Arreglos dinámicos (implementación desde cero, redimensionamiento)
- 2.2 Listas enlazadas (nodo, implementación, ejercicios básicos)
- 2.3 Enfoque iterativo vs. recursivo en listas enlazadas
- 2.4 El ambiente recursivo (pila de llamadas, visualización paso a paso)
- 2.5 Operaciones recursivas sobre listas enlazadas (contar, buscar, sumar, imprimir inverso, agregar, eliminar)
- 2.6 Ventajas y desventajas: iterativo vs. recursivo (tabla comparativa)
- 2.7 Introducción al Backtracking (concepto, estructura general, ejemplos con listas)
- 2.8 Ejercicios integradores (invertir lista, palíndromo, subconjuntos, laberinto)
- 2.9 Resumen conceptual (diagrama de enfoques)

---

## 3. Pilas (Stacks)

> 📄 [material/03_pilas.md](material/03_pilas.md)

- Implementación con arreglo y con lista enlazada
- Conexión entre pilas y recursividad
- Conversión de recursivo a iterativo con pila explícita
- Verificar paréntesis balanceados (iterativo y recursivo)
- Evaluar expresiones postfijas
- Ejercicios

---

## 4. Colas (Queues)

> 📄 [material/04_colas.md](material/04_colas.md)

- Implementación con arreglo circular (visualización)
- Implementación con lista enlazada
- Invertir y ordenar colas con recursividad
- BFS como aplicación estrella de las colas
- Cola de prioridad
- Comparación Pila vs. Cola
- Ejercicios

---

## 5. Algoritmos de ordenamiento

> 📄 [material/05_ordenamientos.md](material/05_ordenamientos.md)

- Bubble Sort, Selection Sort, Insertion Sort (iterativos)
- Merge Sort y Quick Sort (recursivos — divide y vencerás)
- Ambiente recursivo de Merge Sort paso a paso
- Búsqueda binaria (iterativa y recursiva con trazas)
- Tabla comparativa de todos los algoritmos
- Ejercicios (incluye backtracking en ordenamiento)

---

## 6. Árboles

> 📄 [material/06_arboles.md](material/06_arboles.md)

- Teoría y terminología
- Árbol binario de búsqueda (BST): insertar, buscar, eliminar (recursivo e iterativo)
- Recorridos: inorden, preorden, postorden (recursivos) y por niveles (BFS con cola)
- Recorrido inorden iterativo con pila explícita
- Ambiente recursivo en recorridos (visualización)
- Backtracking: caminos con suma dada, generar todos los BST posibles
- Ventajas y desventajas iterativo vs. recursivo en árboles
- Ejercicios

---

## 7. Grafos

> 📄 [material/07_grafos.md](material/07_grafos.md)

- Tipos de grafos y representaciones (lista y matriz de adyacencia)
- DFS recursivo e iterativo con pila (ambiente recursivo paso a paso)
- BFS iterativo con cola
- Detectar ciclos con DFS
- Camino más corto con BFS
- Backtracking: encontrar todos los caminos, problema del caballo de ajedrez
- Ordenamiento topológico
- Comparación DFS vs. BFS
- Ejercicios

---

## 8. Tablas Hash y Conjuntos

> 📄 [material/08_tablas_hash.md](material/08_tablas_hash.md)

- Función hash y colisiones
- Implementación desde cero con encadenamiento (listas enlazadas)
- Conjuntos (Sets)
- Uso de HashMap y HashSet de Java
- Aplicaciones: frecuencia de palabras, detectar duplicados
- Ejercicios

---

## 9. Resumen general, proyectos finales y evaluación

> 📄 [material/09_resumen_final.md](material/09_resumen_final.md)

- Mapa conceptual de todas las estructuras
- Guía de cuándo usar cada enfoque (iterativo, recursivo, backtracking)
- Tabla resumen de complejidades
- Conexiones entre conceptos
- Equivalencias con la biblioteca estándar de Java
- Proyectos finales
- Evaluación
