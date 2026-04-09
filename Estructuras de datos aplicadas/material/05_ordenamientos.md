# 5. Algoritmos de ordenamiento

Antes de avanzar a estructuras más complejas, es fundamental entender cómo se ordenan datos. Los algoritmos de ordenamiento son un campo donde la diferencia entre enfoque iterativo, recursivo y backtracking se hace muy evidente.

---

## ¿Por qué importa ordenar?

- Buscar en datos ordenados es mucho más rápido (búsqueda binaria: O(log n) vs. O(n))
- Muchos algoritmos requieren datos ordenados como precondición
- Es uno de los problemas más estudiados en ciencias de la computación

---

## 5.1 Bubble Sort (iterativo)

El algoritmo más simple. Compara pares adyacentes y los intercambia si están desordenados. Repite hasta que no haya intercambios.

```java
void bubbleSort(int[] arr){

    int n = arr.length;

    for(int i = 0; i < n - 1; i++){

        boolean huboIntercambio = false;

        for(int j = 0; j < n - 1 - i; j++){

            if(arr[j] > arr[j + 1]){
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
                huboIntercambio = true;
            }
        }

        // optimización: si no hubo intercambios, ya está ordenado
        if(!huboIntercambio) break;
    }
}
```

Complejidad: **O(n²)** en el peor caso, **O(n)** en el mejor caso (ya ordenado, con la optimización).

Traza con `[5, 3, 8, 1]`:

```
Pasada 1: [3, 5, 1, 8]  (3 intercambios)
Pasada 2: [3, 1, 5, 8]  (1 intercambio)
Pasada 3: [1, 3, 5, 8]  (1 intercambio)
Pasada 4: sin intercambios → terminó
```

---

## 5.2 Selection Sort (iterativo)

Encuentra el mínimo del arreglo y lo coloca en la primera posición. Luego encuentra el mínimo del resto y lo coloca en la segunda posición. Y así sucesivamente.

```java
void selectionSort(int[] arr){

    int n = arr.length;

    for(int i = 0; i < n - 1; i++){

        int indiceMin = i;

        for(int j = i + 1; j < n; j++){
            if(arr[j] < arr[indiceMin]){
                indiceMin = j;
            }
        }

        // intercambiar
        int temp = arr[i];
        arr[i] = arr[indiceMin];
        arr[indiceMin] = temp;
    }
}
```

Complejidad: **O(n²)** siempre (no tiene mejor caso).

---

## 5.3 Insertion Sort (iterativo)

Toma cada elemento y lo inserta en la posición correcta dentro de la parte ya ordenada del arreglo. Como ordenar cartas en la mano.

```java
void insertionSort(int[] arr){

    for(int i = 1; i < arr.length; i++){

        int clave = arr[i];
        int j = i - 1;

        while(j >= 0 && arr[j] > clave){
            arr[j + 1] = arr[j];
            j--;
        }

        arr[j + 1] = clave;
    }
}
```

Complejidad: **O(n²)** peor caso, **O(n)** mejor caso (ya ordenado).

---

## 5.4 Merge Sort (recursivo — divide y vencerás)

Aquí es donde la recursividad brilla en ordenamiento. **Merge Sort** divide el arreglo a la mitad, ordena cada mitad recursivamente, y luego las combina (merge).

```
Arreglo original: [38, 27, 43, 3, 9, 82, 10]

Dividir:
[38, 27, 43, 3]          [9, 82, 10]
[38, 27]  [43, 3]        [9, 82]  [10]
[38] [27] [43] [3]       [9] [82] [10]

Combinar (merge):
[27, 38] [3, 43]         [9, 82] [10]
[3, 27, 38, 43]          [9, 10, 82]
[3, 9, 10, 27, 38, 43, 82]
```

```java
void mergeSort(int[] arr, int inicio, int fin){

    if(inicio >= fin){
        return;                          // caso base: 0 o 1 elemento
    }

    int medio = (inicio + fin) / 2;

    mergeSort(arr, inicio, medio);       // ordenar mitad izquierda
    mergeSort(arr, medio + 1, fin);      // ordenar mitad derecha

    merge(arr, inicio, medio, fin);      // combinar
}

void merge(int[] arr, int inicio, int medio, int fin){

    int[] temp = new int[fin - inicio + 1];
    int i = inicio;
    int j = medio + 1;
    int k = 0;

    while(i <= medio && j <= fin){
        if(arr[i] <= arr[j]){
            temp[k++] = arr[i++];
        } else {
            temp[k++] = arr[j++];
        }
    }

    while(i <= medio){
        temp[k++] = arr[i++];
    }

    while(j <= fin){
        temp[k++] = arr[j++];
    }

    for(int m = 0; m < temp.length; m++){
        arr[inicio + m] = temp[m];
    }
}
```

Complejidad: **O(n log n)** siempre. Usa **O(n)** de espacio extra.

### Ambiente recursivo de Merge Sort

Con `[38, 27, 43, 3]`:

```
mergeSort([38,27,43,3], 0, 3)
    mergeSort([38,27,43,3], 0, 1)        ← mitad izquierda
        mergeSort([38,27,43,3], 0, 0)    ← caso base [38]
        mergeSort([38,27,43,3], 1, 1)    ← caso base [27]
        merge → [27, 38]
    mergeSort([38,27,43,3], 2, 3)        ← mitad derecha
        mergeSort([38,27,43,3], 2, 2)    ← caso base [43]
        mergeSort([38,27,43,3], 3, 3)    ← caso base [3]
        merge → [3, 43]
    merge → [3, 27, 38, 43]
```

La profundidad de la pila de llamadas es **O(log n)** porque el arreglo se divide a la mitad en cada nivel.

---

## 5.5 Quick Sort (recursivo — divide y vencerás)

Elige un **pivote**, coloca todos los menores a la izquierda y los mayores a la derecha, y luego ordena cada lado recursivamente.

```java
void quickSort(int[] arr, int inicio, int fin){

    if(inicio >= fin){
        return;                          // caso base
    }

    int indicePivote = particionar(arr, inicio, fin);

    quickSort(arr, inicio, indicePivote - 1);   // ordenar izquierda
    quickSort(arr, indicePivote + 1, fin);       // ordenar derecha
}

int particionar(int[] arr, int inicio, int fin){

    int pivote = arr[fin];               // elegimos el último como pivote
    int i = inicio - 1;

    for(int j = inicio; j < fin; j++){
        if(arr[j] <= pivote){
            i++;
            int temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }
    }

    // colocar pivote en su posición final
    int temp = arr[i + 1];
    arr[i + 1] = arr[fin];
    arr[fin] = temp;

    return i + 1;
}
```

Complejidad: **O(n log n)** promedio, **O(n²)** peor caso (arreglo ya ordenado con pivote malo).

Ventaja sobre Merge Sort: ordena **in-place** (no necesita arreglo auxiliar).

---

## 5.6 Comparación de algoritmos de ordenamiento

| Algoritmo | Complejidad (peor) | Complejidad (mejor) | Espacio extra | Estable | Enfoque |
|---|---|---|---|---|---|
| Bubble Sort | O(n²) | O(n) | O(1) | Sí | Iterativo |
| Selection Sort | O(n²) | O(n²) | O(1) | No | Iterativo |
| Insertion Sort | O(n²) | O(n) | O(1) | Sí | Iterativo |
| Merge Sort | O(n log n) | O(n log n) | O(n) | Sí | Recursivo |
| Quick Sort | O(n²) | O(n log n) | O(log n) | No | Recursivo |

**Estable** significa que elementos iguales mantienen su orden relativo original.

---

## 5.7 Búsqueda binaria (recursiva e iterativa)

Ahora que sabemos ordenar, podemos buscar eficientemente en datos ordenados.

**Iterativa:**

```java
int busquedaBinaria(int[] arr, int objetivo){

    int inicio = 0;
    int fin = arr.length - 1;

    while(inicio <= fin){

        int medio = (inicio + fin) / 2;

        if(arr[medio] == objetivo){
            return medio;
        }

        if(arr[medio] < objetivo){
            inicio = medio + 1;
        } else {
            fin = medio - 1;
        }
    }

    return -1;  // no encontrado
}
```

**Recursiva:**

```java
int busquedaBinariaRecursiva(int[] arr, int objetivo, int inicio, int fin){

    if(inicio > fin){
        return -1;                       // caso base: no encontrado
    }

    int medio = (inicio + fin) / 2;

    if(arr[medio] == objetivo){
        return medio;                    // caso base: encontrado
    }

    if(arr[medio] < objetivo){
        return busquedaBinariaRecursiva(arr, objetivo, medio + 1, fin);
    }

    return busquedaBinariaRecursiva(arr, objetivo, inicio, medio - 1);
}
```

Complejidad: **O(log n)** en ambos casos. La versión recursiva usa O(log n) de espacio en la pila.

Traza buscando 27 en `[3, 9, 10, 27, 38, 43, 82]`:

```
busqueda(arr, 27, 0, 6)
    medio = 3, arr[3] = 27 → ¡encontrado! retorna 3
```

Buscando 10:

```
busqueda(arr, 10, 0, 6)
    medio = 3, arr[3] = 27 > 10 → buscar izquierda
    busqueda(arr, 10, 0, 2)
        medio = 1, arr[1] = 9 < 10 → buscar derecha
        busqueda(arr, 10, 2, 2)
            medio = 2, arr[2] = 10 → ¡encontrado! retorna 2
```

---

## Ejercicios de ordenamiento

1. Implementar Bubble Sort de forma recursiva (sin ciclos). Pista: cada llamada recursiva realiza una "pasada".

2. Implementar Merge Sort para una lista enlazada (no un arreglo). Pista: usar la técnica de dos punteros (lento/rápido) para encontrar el medio.

3. Implementar Quick Sort eligiendo el pivote como la mediana de tres elementos (inicio, medio, fin).

4. Contar el número de inversiones en un arreglo usando Merge Sort modificado. Una inversión es un par (i, j) donde i < j pero arr[i] > arr[j].

5. (Backtracking) Dado un arreglo desordenado, generar todas las permutaciones posibles y verificar cuál está ordenada. ¿Por qué este enfoque es terrible? Analizar la complejidad.

---
