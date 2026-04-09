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
class ListaDinamica {

    private int[] datos;

    private int tamaño;

    public ListaDinamica(){

        datos = new int[10];

        tamaño = 0;

    }

    public void agregar(int valor){

        if(tamaño == datos.length){

            redimensionar();

        }

        datos[tamaño++] = valor;

    }

    private void redimensionar(){

        int[] nuevo = new int[datos.length * 2];

        for(int i=0;i<datos.length;i++){

            nuevo[i] = datos[i];

        }

        datos = nuevo;

    }

}
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

# Ejercicios básicos

1 Implementar método eliminar en lista enlazada

2 Implementar búsqueda

3 Implementar inserción en posición específica

---

# 2.3 Enfoque iterativo vs. recursivo en listas enlazadas

Hasta ahora hemos trabajado con listas enlazadas usando **ciclos** (`while`, `for`). Eso se llama enfoque **iterativo**. Pero existe otra forma de resolver los mismos problemas: la **recursividad**.

Antes de ver cómo aplicar recursividad a listas enlazadas, necesitamos entender bien qué es y cómo funciona.

---

## ¿Qué es un algoritmo iterativo?

Un algoritmo **iterativo** resuelve un problema repitiendo un conjunto de instrucciones usando un ciclo.

Características:

- Usa variables que se actualizan en cada paso
- Controla la repetición con condiciones (`while`, `for`)
- Consume memoria constante (no crece con cada paso)

Ejemplo: recorrer una lista enlazada de forma iterativa.

```java
void imprimirIterativo(Nodo cabeza){

    Nodo actual = cabeza;

    while(actual != null){

        System.out.println(actual.valor);

        actual = actual.siguiente;

    }

}
```

Aquí la variable `actual` va avanzando nodo por nodo. El ciclo termina cuando `actual` es `null`.

---

## ¿Qué es la recursividad?

La **recursividad** es una técnica donde una función **se llama a sí misma** para resolver un problema dividiéndolo en subproblemas más pequeños.

Toda función recursiva necesita dos cosas:

1. **Caso base:** la condición que detiene la recursión
2. **Llamada recursiva:** la función se invoca con un problema más pequeño

Si falta el caso base, la función se llama infinitamente y el programa falla con un `StackOverflowError`.

---

## Analogía para entender la recursividad

Imagina que estás en una fila de personas y quieres saber cuántas personas hay detrás de ti.

- Le preguntas a la persona de atrás: "¿cuántas personas hay detrás de ti?"
- Esa persona le pregunta lo mismo a la siguiente
- La última persona dice: "ninguna, soy la última" → **caso base**
- Cada persona suma 1 a la respuesta que recibe y la devuelve hacia adelante

Eso es recursividad: **delegar el problema a alguien más pequeño y combinar la respuesta**.

---

## Ejemplo: recorrer una lista enlazada de forma recursiva

```java
void imprimirRecursivo(Nodo nodo){

    if(nodo == null){       // caso base
        return;
    }

    System.out.println(nodo.valor);   // procesar nodo actual

    imprimirRecursivo(nodo.siguiente); // llamada recursiva
}
```

Comparemos ambos enfoques lado a lado:

| Aspecto | Iterativo | Recursivo |
|---|---|---|
| Usa ciclos | Sí | No |
| Se llama a sí mismo | No | Sí |
| Necesita caso base | No (usa condición del ciclo) | Sí |
| Consumo de memoria | Constante O(1) | Crece con cada llamada O(n) |
| Legibilidad | Más explícito | Más elegante para problemas naturalmente recursivos |

---

# 2.4 El ambiente recursivo (pila de llamadas)

## ¿Qué pasa internamente cuando se ejecuta una función recursiva?

Cada vez que una función se llama a sí misma, Java crea un **marco de ejecución** (stack frame) en la **pila de llamadas** (call stack). Cada marco contiene:

- Los **parámetros** de esa llamada
- Las **variables locales**
- La **dirección de retorno** (a dónde volver cuando termine)

Esto es lo que llamamos un **ambiente recursivo**: el conjunto de marcos apilados que representan cada llamada activa de la función.

---

## Visualización paso a paso

Supongamos esta lista: `10 -> 20 -> 30 -> null`

Llamamos `imprimirRecursivo(nodo10)`

```
Paso 1: imprimirRecursivo(nodo10)
        imprime 10
        llama imprimirRecursivo(nodo20)

    Paso 2: imprimirRecursivo(nodo20)
            imprime 20
            llama imprimirRecursivo(nodo30)

        Paso 3: imprimirRecursivo(nodo30)
                imprime 30
                llama imprimirRecursivo(null)

            Paso 4: imprimirRecursivo(null)
                    caso base → retorna

        retorna al paso 3
    retorna al paso 2
retorna al paso 1
```

La pila de llamadas en el momento más profundo se ve así:

```
| imprimirRecursivo(null)  |  ← tope (caso base)
| imprimirRecursivo(nodo30)|
| imprimirRecursivo(nodo20)|
| imprimirRecursivo(nodo10)|  ← fondo
```

Cuando el caso base se alcanza, las llamadas se **desenrollan** en orden inverso.

---

## ¿Por qué importa entender el ambiente recursivo?

1. **Memoria:** cada llamada consume espacio en la pila. Una lista de 10,000 nodos genera 10,000 marcos → posible `StackOverflowError`
2. **Depuración:** entender la pila de llamadas ayuda a rastrear errores
3. **Diseño:** saber cuándo la recursión es apropiada y cuándo no

---

## Regla práctica

- Si la profundidad de recursión puede ser **muy grande** (miles o millones), prefiere el enfoque **iterativo**
- Si el problema tiene una **estructura naturalmente recursiva** (árboles, subdivisiones), la recursión es más clara

---

# 2.5 Operaciones recursivas sobre listas enlazadas

Ahora apliquemos recursividad a operaciones concretas sobre listas enlazadas.

---

## Contar nodos (recursivo)

```java
int contarNodos(Nodo nodo){

    if(nodo == null){
        return 0;                        // caso base
    }

    return 1 + contarNodos(nodo.siguiente); // 1 por este nodo + los que siguen
}
```

Traza con lista `10 -> 20 -> 30 -> null`:

```
contarNodos(10) = 1 + contarNodos(20)
                = 1 + (1 + contarNodos(30))
                = 1 + (1 + (1 + contarNodos(null)))
                = 1 + (1 + (1 + 0))
                = 3
```

---

## Buscar un valor (recursivo)

```java
boolean buscar(Nodo nodo, int objetivo){

    if(nodo == null){
        return false;                          // no encontrado
    }

    if(nodo.valor == objetivo){
        return true;                           // encontrado
    }

    return buscar(nodo.siguiente, objetivo);   // seguir buscando
}
```

---

## Comparación: buscar iterativo vs. recursivo

Iterativo:

```java
boolean buscarIterativo(Nodo cabeza, int objetivo){

    Nodo actual = cabeza;

    while(actual != null){

        if(actual.valor == objetivo){
            return true;
        }

        actual = actual.siguiente;
    }

    return false;
}
```

Ambos tienen complejidad **O(n)** en tiempo, pero el recursivo usa **O(n)** en espacio adicional (por la pila de llamadas) mientras el iterativo usa **O(1)**.

---

## Sumar todos los valores (recursivo)

```java
int sumar(Nodo nodo){

    if(nodo == null){
        return 0;
    }

    return nodo.valor + sumar(nodo.siguiente);
}
```

---

## Imprimir en orden inverso (recursivo)

Este es un caso donde la recursividad brilla. Imprimir una lista enlazada al revés de forma iterativa requiere una pila auxiliar o invertir la lista. Con recursividad es natural:

```java
void imprimirInverso(Nodo nodo){

    if(nodo == null){
        return;
    }

    imprimirInverso(nodo.siguiente);  // primero llegar al final

    System.out.println(nodo.valor);   // imprimir al regresar
}
```

El truco está en que la impresión ocurre **después** de la llamada recursiva, es decir, durante el **desenrollado** de la pila.

Con lista `10 -> 20 -> 30`:

```
imprimirInverso(10)
    imprimirInverso(20)
        imprimirInverso(30)
            imprimirInverso(null) → retorna
        imprime 30
    imprime 20
imprime 10
```

Salida: `30, 20, 10`

---

## Agregar al final (recursivo)

```java
Nodo agregarAlFinal(Nodo nodo, int valor){

    if(nodo == null){
        return new Nodo(valor);              // caso base: crear el nuevo nodo aquí
    }

    nodo.siguiente = agregarAlFinal(nodo.siguiente, valor);

    return nodo;
}
```

Uso:

```java
cabeza = agregarAlFinal(cabeza, 40);
```

Este patrón de **retornar el nodo** es muy común en recursividad sobre listas y árboles. Permite reconstruir la estructura mientras se regresa.

---

## Eliminar un nodo por valor (recursivo)

```java
Nodo eliminar(Nodo nodo, int objetivo){

    if(nodo == null){
        return null;                         // no se encontró
    }

    if(nodo.valor == objetivo){
        return nodo.siguiente;               // saltar este nodo
    }

    nodo.siguiente = eliminar(nodo.siguiente, objetivo);

    return nodo;
}
```

Uso:

```java
cabeza = eliminar(cabeza, 20);
```

---

# 2.6 Ventajas y desventajas: iterativo vs. recursivo

| Criterio | Iterativo | Recursivo |
|---|---|---|
| Memoria | O(1) extra | O(n) por la pila de llamadas |
| Velocidad | Generalmente más rápido (sin overhead de llamadas) | Ligeramente más lento por el manejo de marcos |
| Legibilidad | Más claro para secuencias lineales | Más claro para estructuras jerárquicas |
| Riesgo de StackOverflow | No | Sí, con datos grandes |
| Facilidad de depuración | Más fácil (se puede inspeccionar variables en el ciclo) | Más difícil (hay que rastrear la pila) |
| Elegancia | Menos elegante para problemas recursivos | Muy elegante para árboles, grafos, subdivisiones |
| Transformación | Todo recursivo se puede convertir a iterativo | No todo iterativo se expresa naturalmente como recursivo |

---

## ¿Cuándo usar cada uno?

**Usa iterativo cuando:**

- La estructura es lineal (listas, arreglos)
- Los datos pueden ser muy grandes
- La eficiencia de memoria es crítica

**Usa recursivo cuando:**

- La estructura es jerárquica (árboles, grafos)
- El problema se divide naturalmente en subproblemas
- La claridad del código es más importante que la eficiencia

---

# 2.7 Introducción al Backtracking

## ¿Qué es backtracking?

**Backtracking** (retroceso) es una técnica algorítmica que construye soluciones paso a paso y **retrocede** cuando detecta que el camino actual no lleva a una solución válida.

Es como explorar un laberinto:

- Avanzas por un camino
- Si llegas a un callejón sin salida, **retrocedes** al último punto donde tenías opciones
- Pruebas otro camino
- Repites hasta encontrar la salida o agotar todas las opciones

Backtracking es una forma especializada de recursividad donde se **exploran múltiples opciones** y se **deshacen decisiones** que no funcionan.

---

## Estructura general del backtracking

```
funcion resolver(estado):

    si estado es solución:
        registrar solución
        retornar

    para cada opción posible desde estado:
        aplicar opción
        resolver(nuevo estado)
        deshacer opción          ← aquí está el "backtrack"
```

Los tres elementos clave son:

1. **Elegir:** tomar una decisión
2. **Explorar:** avanzar recursivamente con esa decisión
3. **Deshacer:** si no funcionó, revertir la decisión y probar otra

---

## Ejemplo: encontrar un camino en una lista de decisiones

Supongamos que tenemos una lista enlazada donde cada nodo tiene un valor y queremos encontrar si existe un camino (secuencia de nodos) cuya suma sea exactamente un valor objetivo.

```java
boolean encontrarSuma(Nodo nodo, int objetivo, int sumaActual){

    // caso base: recorrimos toda la lista
    if(nodo == null){
        return sumaActual == objetivo;
    }

    // opción 1: incluir este nodo en la suma
    if(encontrarSuma(nodo.siguiente, objetivo, sumaActual + nodo.valor)){
        return true;
    }

    // opción 2: NO incluir este nodo (backtrack implícito)
    if(encontrarSuma(nodo.siguiente, objetivo, sumaActual)){
        return true;
    }

    return false;
}
```

Uso:

```java
boolean existe = encontrarSuma(cabeza, 50, 0);
```

Aquí el backtracking ocurre cuando la primera opción (incluir el nodo) no lleva a la solución, y se prueba la segunda opción (excluirlo). La suma se "deshace" automáticamente porque cada llamada recursiva tiene su propia copia de `sumaActual`.

---

## Ejemplo clásico: generar todas las subsecuencias de una lista

```java
void subsecuencias(Nodo nodo, String actual){

    if(nodo == null){
        System.out.println(actual);   // imprimir la subsecuencia generada
        return;
    }

    // incluir el nodo actual
    subsecuencias(nodo.siguiente, actual + nodo.valor + " ");

    // no incluir el nodo actual (backtrack)
    subsecuencias(nodo.siguiente, actual);
}
```

Con lista `1 -> 2 -> 3`, genera:

```
1 2 3
1 2
1 3
1
2 3
2
3
(vacío)
```

Esto produce **2^n** combinaciones, donde n es el número de nodos. La complejidad es **O(2^n)**.

---

## Backtracking vs. recursividad simple

| Aspecto | Recursividad simple | Backtracking |
|---|---|---|
| Caminos explorados | Uno solo | Múltiples |
| Decisiones | Secuenciales | Con opciones que se prueban y deshacen |
| Complejidad típica | O(n) | O(2^n) o más |
| Uso típico | Recorrer, buscar, contar | Encontrar combinaciones, resolver puzzles |

---

# 2.8 Ejercicios integradores

Estos ejercicios están diseñados para practicar los tres enfoques: iterativo, recursivo y backtracking sobre listas enlazadas.

---

## Ejercicio 1: Invertir una lista enlazada

Implementar de las dos formas.

**a) Iterativo:**

```java
Nodo invertirIterativo(Nodo cabeza){

    Nodo anterior = null;
    Nodo actual = cabeza;

    while(actual != null){

        Nodo siguiente = actual.siguiente;  // guardar referencia
        actual.siguiente = anterior;        // invertir enlace
        anterior = actual;                  // avanzar anterior
        actual = siguiente;                 // avanzar actual
    }

    return anterior;  // nueva cabeza
}
```

**b) Recursivo:**

```java
Nodo invertirRecursivo(Nodo nodo){

    if(nodo == null || nodo.siguiente == null){
        return nodo;                        // caso base
    }

    Nodo nuevaCabeza = invertirRecursivo(nodo.siguiente);

    nodo.siguiente.siguiente = nodo;        // invertir enlace
    nodo.siguiente = null;                  // evitar ciclo

    return nuevaCabeza;
}
```

**Reflexión:** ¿Cuál es más fácil de entender? ¿Cuál usa menos memoria? Discutir en clase.

---

## Ejercicio 2: Obtener el n-ésimo nodo desde el final

**Iterativo (dos punteros):**

```java
int desdeElFinal(Nodo cabeza, int n){

    Nodo adelantado = cabeza;
    Nodo actual = cabeza;

    // adelantar el primer puntero n posiciones
    for(int i = 0; i < n; i++){
        adelantado = adelantado.siguiente;
    }

    // avanzar ambos hasta que el adelantado llegue al final
    while(adelantado != null){
        adelantado = adelantado.siguiente;
        actual = actual.siguiente;
    }

    return actual.valor;
}
```

**Recursivo (con contador al regresar):**

```java
int[] desdeElFinalRecursivo(Nodo nodo, int n){

    if(nodo == null){
        return new int[]{0, -1};  // {contador, resultado}
    }

    int[] resultado = desdeElFinalRecursivo(nodo.siguiente, n);

    resultado[0]++;  // incrementar contador al regresar

    if(resultado[0] == n){
        resultado[1] = nodo.valor;
    }

    return resultado;
}
```

---

## Ejercicio 3: Verificar si una lista es palíndromo

Una lista es palíndromo si se lee igual de izquierda a derecha que de derecha a izquierda.

Lista: `1 -> 2 -> 3 -> 2 -> 1` → **sí es palíndromo**

Pista: usar recursividad para comparar el primer nodo con el último, el segundo con el penúltimo, etc.

```java
Nodo frente;  // variable de instancia

boolean esPalindromo(Nodo nodo){

    if(nodo == null){
        return true;
    }

    boolean resultado = esPalindromo(nodo.siguiente);

    if(!resultado){
        return false;
    }

    boolean coincide = (frente.valor == nodo.valor);

    frente = frente.siguiente;

    return coincide;
}

// Uso:
// frente = cabeza;
// boolean resultado = esPalindromo(cabeza);
```

---

## Ejercicio 4: Encontrar todos los subconjuntos que suman un valor (backtracking)

Dada una lista enlazada de enteros positivos, encontrar **todos** los subconjuntos de nodos cuya suma sea exactamente `objetivo`.

```java
void encontrarSubconjuntos(Nodo nodo, int objetivo, int sumaActual, String camino){

    if(sumaActual == objetivo){
        System.out.println("Encontrado: " + camino);
        // no retornamos, puede haber más soluciones
    }

    if(nodo == null || sumaActual > objetivo){
        return;
    }

    // incluir este nodo
    encontrarSubconjuntos(
        nodo.siguiente,
        objetivo,
        sumaActual + nodo.valor,
        camino + nodo.valor + " "
    );

    // no incluir este nodo (backtrack)
    encontrarSubconjuntos(
        nodo.siguiente,
        objetivo,
        sumaActual,
        camino
    );
}
```

Uso:

```java
// Lista: 3 -> 7 -> 1 -> 8 -> 4
// encontrarSubconjuntos(cabeza, 11, 0, "");
// Salida posible:
// Encontrado: 3 8
// Encontrado: 3 4
// ... etc
```

---

## Ejercicio 5: Eliminar nodos duplicados

**a) Iterativo:**

```java
void eliminarDuplicadosIterativo(Nodo cabeza){

    Nodo actual = cabeza;

    while(actual != null){

        Nodo comparador = actual;

        while(comparador.siguiente != null){

            if(comparador.siguiente.valor == actual.valor){
                comparador.siguiente = comparador.siguiente.siguiente;
            } else {
                comparador = comparador.siguiente;
            }
        }

        actual = actual.siguiente;
    }
}
```

**b) Recursivo:**

```java
Nodo eliminarDuplicadosRecursivo(Nodo nodo){

    if(nodo == null || nodo.siguiente == null){
        return nodo;
    }

    nodo.siguiente = eliminarDuplicadosRecursivo(nodo.siguiente);

    // eliminar nodo actual si su valor aparece en el resto
    if(contiene(nodo.siguiente, nodo.valor)){
        return nodo.siguiente;
    }

    return nodo;
}

boolean contiene(Nodo nodo, int valor){

    if(nodo == null) return false;

    if(nodo.valor == valor) return true;

    return contiene(nodo.siguiente, valor);
}
```

---

## Ejercicio 6 (desafío): El problema del laberinto con lista de movimientos

Representar un laberinto como una cuadrícula y usar una lista enlazada para almacenar la secuencia de movimientos. Usar backtracking para encontrar un camino desde la entrada hasta la salida.

```java
class Movimiento {
    int fila;
    int columna;
    Movimiento siguiente;

    Movimiento(int fila, int columna){
        this.fila = fila;
        this.columna = columna;
    }
}

boolean resolverLaberinto(int[][] laberinto, int fila, int col,
                          int filaFin, int colFin, Movimiento camino){

    // fuera de límites o pared
    if(fila < 0 || fila >= laberinto.length ||
       col < 0 || col >= laberinto[0].length ||
       laberinto[fila][col] == 1){
        return false;
    }

    // ya visitado
    if(laberinto[fila][col] == 2){
        return false;
    }

    // registrar movimiento en la lista enlazada
    Movimiento paso = new Movimiento(fila, col);
    paso.siguiente = camino;
    camino = paso;

    // llegamos al destino
    if(fila == filaFin && col == colFin){
        imprimirCamino(camino);
        return true;
    }

    // marcar como visitado
    laberinto[fila][col] = 2;

    // intentar las 4 direcciones (backtracking)
    if(resolverLaberinto(laberinto, fila+1, col, filaFin, colFin, camino)) return true;
    if(resolverLaberinto(laberinto, fila-1, col, filaFin, colFin, camino)) return true;
    if(resolverLaberinto(laberinto, fila, col+1, filaFin, colFin, camino)) return true;
    if(resolverLaberinto(laberinto, fila, col-1, filaFin, colFin, camino)) return true;

    // backtrack: desmarcar
    laberinto[fila][col] = 0;

    return false;
}

void imprimirCamino(Movimiento camino){

    if(camino == null) return;

    imprimirCamino(camino.siguiente);

    System.out.println("(" + camino.fila + ", " + camino.columna + ")");
}
```

---

# 2.9 Resumen conceptual

```
                    ┌─────────────────────────┐
                    │   Problema a resolver    │
                    └────────┬────────────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
        ┌──────────┐  ┌──────────┐  ┌──────────────┐
        │Iterativo │  │Recursivo │  │Backtracking  │
        │          │  │          │  │              │
        │ ciclos   │  │ se llama │  │ recursivo +  │
        │ while/for│  │ a sí     │  │ deshacer     │
        │          │  │ mismo    │  │ decisiones   │
        └──────────┘  └──────────┘  └──────────────┘
              │              │              │
              ▼              ▼              ▼
         O(1) espacio   O(n) espacio   O(2^n) tiempo
         lineal         jerárquico     combinatorio
```

**Conceptos clave para recordar:**

- **Iterativo:** usa ciclos, memoria constante, ideal para recorridos lineales
- **Recursivo:** se llama a sí mismo, necesita caso base, cada llamada crea un marco en la pila
- **Ambiente recursivo:** el conjunto de marcos de ejecución apilados durante la recursión
- **Backtracking:** recursividad con exploración de múltiples caminos y retroceso
- **Pila de llamadas:** estructura interna de Java que almacena los marcos de cada llamada recursiva
- **StackOverflowError:** ocurre cuando la pila de llamadas se llena (recursión muy profunda o sin caso base)

---
