# 3. Pilas (Stacks)

## Teoría

Una **pila** es una estructura de datos que funciona con el principio **LIFO** (Last In, First Out): el último elemento que entra es el primero que sale.

Analogía: imagina una pila de platos. Solo puedes poner o quitar platos por arriba. No puedes sacar el plato del fondo sin quitar todos los de encima.

Operaciones fundamentales:

- **push(valor):** agregar un elemento al tope
- **pop():** quitar y retornar el elemento del tope
- **peek():** ver el elemento del tope sin quitarlo
- **isEmpty():** verificar si la pila está vacía

---

## Implementación con arreglo (iterativa)

```java
class Pila {

    private int[] datos;
    private int tope;

    public Pila(int capacidad){
        datos = new int[capacidad];
        tope = -1;
    }

    public void push(int valor){
        if(tope == datos.length - 1){
            throw new RuntimeException("Pila llena");
        }
        datos[++tope] = valor;
    }

    public int pop(){
        if(tope == -1){
            throw new RuntimeException("Pila vacía");
        }
        return datos[tope--];
    }

    public int peek(){
        if(tope == -1){
            throw new RuntimeException("Pila vacía");
        }
        return datos[tope];
    }

    public boolean isEmpty(){
        return tope == -1;
    }
}
```

---

## Implementación con lista enlazada

Usar una lista enlazada permite una pila sin límite fijo de capacidad. El tope de la pila es la cabeza de la lista.

```java
class PilaEnlazada {

    private Nodo tope;

    public void push(int valor){
        Nodo nuevo = new Nodo(valor);
        nuevo.siguiente = tope;
        tope = nuevo;
    }

    public int pop(){
        if(tope == null){
            throw new RuntimeException("Pila vacía");
        }
        int valor = tope.valor;
        tope = tope.siguiente;
        return valor;
    }

    public int peek(){
        if(tope == null){
            throw new RuntimeException("Pila vacía");
        }
        return tope.valor;
    }

    public boolean isEmpty(){
        return tope == null;
    }
}
```

---

## Visualización de operaciones

Veamos cómo se ve la pila internamente paso a paso:

```
Operación          Estado de la pila (tope arriba)
─────────          ──────────────────────────────
push(10)           | 10 |

push(20)           | 20 |
                   | 10 |

push(30)           | 30 |  ← tope
                   | 20 |
                   | 10 |

pop() → 30         | 20 |  ← tope
                   | 10 |

peek() → 20        | 20 |  ← tope (no se quita)
                   | 10 |

pop() → 20         | 10 |  ← tope

pop() → 10         (vacía)

pop() → ERROR      RuntimeException: Pila vacía
```

---

## Implementación con genéricos

Las implementaciones anteriores solo almacenan `int`. En la práctica, queremos pilas que almacenen cualquier tipo de dato:

```java
class PilaGenerica<T> {

    private Object[] datos;
    private int tope;

    public PilaGenerica(int capacidad){
        datos = new Object[capacidad];
        tope = -1;
    }

    public void push(T valor){
        if(tope == datos.length - 1){
            throw new RuntimeException("Pila llena");
        }
        datos[++tope] = valor;
    }

    @SuppressWarnings("unchecked")
    public T pop(){
        if(tope == -1){
            throw new RuntimeException("Pila vacía");
        }
        return (T) datos[tope--];
    }

    @SuppressWarnings("unchecked")
    public T peek(){
        if(tope == -1){
            throw new RuntimeException("Pila vacía");
        }
        return (T) datos[tope];
    }

    public boolean isEmpty(){
        return tope == -1;
    }

    public int tamaño(){
        return tope + 1;
    }
}
```

Uso:

```java
PilaGenerica<String> pilaTexto = new PilaGenerica<>(10);
pilaTexto.push("hola");
pilaTexto.push("mundo");
System.out.println(pilaTexto.pop());  // "mundo"

PilaGenerica<Double> pilaDecimal = new PilaGenerica<>(10);
pilaDecimal.push(3.14);
pilaDecimal.push(2.71);
```

Esto es exactamente lo que hace `java.util.Stack<E>` internamente.

---

## La pila y la recursividad: una conexión profunda

Aquí viene algo importante: **la recursividad usa internamente una pila**. Cada llamada recursiva se apila en el call stack de Java. Por eso, **todo lo que se puede hacer con recursividad se puede hacer con una pila explícita**, y viceversa.

Esto significa que si tienes un algoritmo recursivo que causa `StackOverflowError`, puedes convertirlo a iterativo usando tu propia pila.

### Visualización: el call stack ES una pila

Cuando ejecutamos `factorial(4)`:

```
factorial(4)
    factorial(3)
        factorial(2)
            factorial(1)
                retorna 1

Pila de llamadas en ese momento:

| factorial(1) |  ← tope (caso base, retorna 1)
| factorial(2) |  ← espera resultado para hacer 2 * resultado
| factorial(3) |  ← espera resultado para hacer 3 * resultado
| factorial(4) |  ← espera resultado para hacer 4 * resultado
```

Desenrollado:

```
factorial(1) retorna 1
factorial(2) retorna 2 * 1 = 2
factorial(3) retorna 3 * 2 = 6
factorial(4) retorna 4 * 6 = 24
```

### Factorial iterativo con pila explícita

Podemos simular exactamente lo mismo con nuestra propia pila:

```java
int factorialConPila(int n){

    PilaGenerica<Integer> pila = new PilaGenerica<>(n);

    // apilar los valores (simula las llamadas recursivas)
    for(int i = n; i >= 1; i--){
        pila.push(i);
    }

    // desapilar multiplicando (simula el desenrollado)
    int resultado = 1;
    while(!pila.isEmpty()){
        resultado *= pila.pop();
    }

    return resultado;
}
```

---

## Ejemplo: recorrer una lista enlazada en orden inverso

**Versión recursiva** (ya la vimos en listas):

```java
void imprimirInverso(Nodo nodo){
    if(nodo == null) return;
    imprimirInverso(nodo.siguiente);
    System.out.println(nodo.valor);
}
```

**Versión iterativa con pila explícita:**

```java
void imprimirInversoConPila(Nodo cabeza){

    PilaGenerica<Integer> pila = new PilaGenerica<>(1000);
    Nodo actual = cabeza;

    // apilar todos los valores
    while(actual != null){
        pila.push(actual.valor);
        actual = actual.siguiente;
    }

    // desapilar e imprimir
    while(!pila.isEmpty()){
        System.out.println(pila.pop());
    }
}
```

Traza con lista `10 -> 20 -> 30`:

```
Fase 1 — Apilar:
  push(10) → | 10 |
  push(20) → | 20 |
             | 10 |
  push(30) → | 30 |
             | 20 |
             | 10 |

Fase 2 — Desapilar e imprimir:
  pop() → imprime 30
  pop() → imprime 20
  pop() → imprime 10
```

Ambos producen el mismo resultado. La versión con pila explícita evita el riesgo de `StackOverflowError`.

---

## DFS con pila explícita (puente hacia grafos)

El recorrido en profundidad (DFS) que veremos en grafos y árboles se puede implementar con recursividad O con una pila. Aquí un adelanto usando una estructura simple:

```java
// Recorrer un arreglo de arreglos (como un grafo simple) usando DFS con pila
void dfsConPila(int[][] adyacencia, int inicio){

    boolean[] visitados = new boolean[adyacencia.length];
    PilaGenerica<Integer> pila = new PilaGenerica<>(adyacencia.length);

    pila.push(inicio);

    while(!pila.isEmpty()){

        int nodo = pila.pop();

        if(visitados[nodo]) continue;

        visitados[nodo] = true;
        System.out.print(nodo + " ");

        // apilar vecinos (en orden inverso para mantener el orden natural)
        for(int i = adyacencia[nodo].length - 1; i >= 0; i--){
            int vecino = adyacencia[nodo][i];
            if(!visitados[vecino]){
                pila.push(vecino);
            }
        }
    }
}
```

Esto demuestra que la pila es la estructura fundamental detrás de la recursividad y el DFS.

---

## Verificar paréntesis balanceados (aplicación clásica)

Este es uno de los problemas más clásicos que se resuelven con pilas. La idea: cada símbolo de apertura se apila, y cada símbolo de cierre debe coincidir con el tope.

**Iterativo con pila:**

```java
boolean parentesisBalanceados(String expresion){

    PilaGenerica<Character> pila = new PilaGenerica<>(expresion.length());

    for(int i = 0; i < expresion.length(); i++){

        char c = expresion.charAt(i);

        if(c == '(' || c == '[' || c == '{'){
            pila.push(c);
        }
        else if(c == ')' || c == ']' || c == '}'){

            if(pila.isEmpty()) return false;

            char abierto = pila.pop();

            if(c == ')' && abierto != '(') return false;
            if(c == ']' && abierto != '[') return false;
            if(c == '}' && abierto != '{') return false;
        }
    }

    return pila.isEmpty();
}
```

Traza con `"{[()]}"`

```
Carácter    Acción          Estado de la pila
────────    ──────          ─────────────────
{           push('{')       | { |
[           push('[')       | [ |
                            | { |
(           push('(')       | ( |
                            | [ |
                            | { |
)           pop() → '('    | [ |
            ')' coincide    | { |
]           pop() → '['    | { |
            ']' coincide
}           pop() → '{'    (vacía)
            '}' coincide

Pila vacía al final → BALANCEADO ✓
```

Traza con `"([)]"`:

```
Carácter    Acción          Estado de la pila
────────    ──────          ─────────────────
(           push('(')       | ( |
[           push('[')       | [ |
                            | ( |
)           pop() → '['    
            ')' NO coincide con '[' → NO BALANCEADO ✗
```

**Recursivo:**

```java
boolean verificarRecursivo(String expr, int indice, PilaGenerica<Character> pila){

    // caso base: recorrimos toda la expresión
    if(indice == expr.length()){
        return pila.isEmpty();
    }

    char c = expr.charAt(indice);

    if(c == '(' || c == '[' || c == '{'){
        pila.push(c);
        return verificarRecursivo(expr, indice + 1, pila);
    }

    if(c == ')' || c == ']' || c == '}'){
        if(pila.isEmpty()) return false;
        char abierto = pila.pop();
        if(c == ')' && abierto != '(') return false;
        if(c == ']' && abierto != '[') return false;
        if(c == '}' && abierto != '{') return false;
        return verificarRecursivo(expr, indice + 1, pila);
    }

    // carácter que no es paréntesis, ignorar
    return verificarRecursivo(expr, indice + 1, pila);
}

// Uso: verificarRecursivo("{[()]}", 0, new PilaGenerica<>(100))
```

Ambiente recursivo con `"([])"`:

```
verificarRecursivo("([])", 0, {})
    push('('), pila = {(}
    verificarRecursivo("([])", 1, {(})
        push('['), pila = {(, [}
        verificarRecursivo("([])", 2, {(, [})
            pop() → '[', coincide con ']', pila = {(}
            verificarRecursivo("([])", 3, {(})
                pop() → '(', coincide con ')', pila = {}
                verificarRecursivo("([])", 4, {})
                    indice == length, pila vacía → true
```

---

## Evaluar expresión postfija con pila

Una expresión postfija (notación polaca inversa) como `3 4 + 2 *` equivale a `(3 + 4) * 2 = 14`.

La ventaja de la notación postfija es que **no necesita paréntesis** y se evalúa de izquierda a derecha con una pila.

```java
int evaluarPostfija(String expresion){

    PilaGenerica<Integer> pila = new PilaGenerica<>(100);
    String[] tokens = expresion.split(" ");

    for(String token : tokens){

        if(token.matches("\\d+")){
            pila.push(Integer.parseInt(token));
        } else {
            int b = pila.pop();  // segundo operando (sale primero)
            int a = pila.pop();  // primer operando

            switch(token){
                case "+": pila.push(a + b); break;
                case "-": pila.push(a - b); break;
                case "*": pila.push(a * b); break;
                case "/": pila.push(a / b); break;
            }
        }
    }

    return pila.pop();
}
```

Traza con `"3 4 + 2 *"`:

```
Token    Acción              Estado de la pila
─────    ──────              ─────────────────
3        push(3)             | 3 |
4        push(4)             | 4 |
                             | 3 |
+        pop 4, pop 3        
         push(3+4=7)         | 7 |
2        push(2)             | 2 |
                             | 7 |
*        pop 2, pop 7
         push(7*2=14)        | 14 |

Resultado: 14
```

Traza con `"5 1 2 + 4 * + 3 -"` que equivale a `5 + (1 + 2) * 4 - 3 = 14`:

```
Token    Pila después
─────    ────────────
5        | 5 |
1        | 1 | 5 |
2        | 2 | 1 | 5 |
+        | 3 | 5 |          (1+2=3)
4        | 4 | 3 | 5 |
*        | 12 | 5 |         (3*4=12)
+        | 17 |             (5+12=17)
3        | 3 | 17 |
-        | 14 |             (17-3=14)

Resultado: 14
```

---

## Invertir una pila usando recursividad (ejercicio resuelto)

Este es un ejercicio clásico que demuestra el poder de la recursividad con pilas. La restricción: solo puedes usar operaciones `push`, `pop`, `isEmpty`.

La idea requiere dos funciones recursivas:

1. `invertir`: saca todos los elementos recursivamente
2. `insertarAlFondo`: inserta un elemento en el fondo de la pila

```java
void insertarAlFondo(PilaGenerica<Integer> pila, int valor){

    if(pila.isEmpty()){
        pila.push(valor);    // caso base: pila vacía, insertar aquí
        return;
    }

    int temp = pila.pop();               // sacar el tope
    insertarAlFondo(pila, valor);        // insertar al fondo recursivamente
    pila.push(temp);                     // restaurar el tope
}

void invertirPila(PilaGenerica<Integer> pila){

    if(pila.isEmpty()){
        return;                          // caso base
    }

    int temp = pila.pop();              // sacar el tope
    invertirPila(pila);                 // invertir el resto
    insertarAlFondo(pila, temp);        // insertar al fondo
}
```

Traza con pila `| 3 | 2 | 1 |` (3 en el tope):

```
invertirPila(| 3 | 2 | 1 |)
    pop 3, invertirPila(| 2 | 1 |)
        pop 2, invertirPila(| 1 |)
            pop 1, invertirPila(vacía)
                caso base → retorna
            insertarAlFondo(vacía, 1) → | 1 |
        insertarAlFondo(| 1 |, 2) → | 1 | 2 |
    insertarAlFondo(| 1 | 2 |, 3) → | 1 | 2 | 3 |

Resultado: | 1 | 2 | 3 |  (1 en el tope, invertida)
```

Complejidad: O(n²) — cada inserción al fondo recorre toda la pila.

---

## Historial de navegación con dos pilas (ejercicio resuelto)

Los botones "atrás" y "adelante" del navegador se implementan con dos pilas:

```java
class Navegador {

    private PilaGenerica<String> atras;
    private PilaGenerica<String> adelante;
    private String paginaActual;

    public Navegador(){
        atras = new PilaGenerica<>(100);
        adelante = new PilaGenerica<>(100);
        paginaActual = null;
    }

    public void visitar(String url){
        if(paginaActual != null){
            atras.push(paginaActual);
        }
        paginaActual = url;
        adelante = new PilaGenerica<>(100);  // limpiar historial adelante
        System.out.println("Visitando: " + url);
    }

    public void irAtras(){
        if(atras.isEmpty()){
            System.out.println("No hay páginas atrás");
            return;
        }
        adelante.push(paginaActual);
        paginaActual = atras.pop();
        System.out.println("Atrás → " + paginaActual);
    }

    public void irAdelante(){
        if(adelante.isEmpty()){
            System.out.println("No hay páginas adelante");
            return;
        }
        atras.push(paginaActual);
        paginaActual = adelante.pop();
        System.out.println("Adelante → " + paginaActual);
    }
}
```

Traza:

```
visitar("google.com")     → actual: google.com
visitar("youtube.com")    → actual: youtube.com,    atrás: [google.com]
visitar("github.com")     → actual: github.com,     atrás: [youtube.com, google.com]
irAtras()                 → actual: youtube.com,     atrás: [google.com],     adelante: [github.com]
irAtras()                 → actual: google.com,      atrás: [],               adelante: [youtube.com, github.com]
irAdelante()              → actual: youtube.com,     atrás: [google.com],     adelante: [github.com]
visitar("reddit.com")     → actual: reddit.com,      atrás: [youtube.com, google.com], adelante: [] (limpiado)
```

---

## Temperaturas: días de espera (ejercicio resuelto)

Dado un arreglo de temperaturas diarias, para cada día encontrar cuántos días hay que esperar para una temperatura más alta.

Ejemplo: `[73, 74, 75, 71, 69, 72, 76, 73]` → `[1, 1, 4, 2, 1, 1, 0, 0]`

```java
int[] diasDeEspera(int[] temperaturas){

    int n = temperaturas.length;
    int[] resultado = new int[n];
    PilaGenerica<Integer> pila = new PilaGenerica<>(n);  // almacena índices

    for(int i = 0; i < n; i++){

        // mientras la temperatura actual sea mayor que la del tope
        while(!pila.isEmpty() && temperaturas[i] > temperaturas[pila.peek()]){
            int indice = pila.pop();
            resultado[indice] = i - indice;
        }

        pila.push(i);
    }

    // los que quedan en la pila no tienen día más cálido → ya son 0
    return resultado;
}
```

Traza:

```
i=0  temp=73  pila vacía → push(0)                    pila: [0]
i=1  temp=74  74>73 → pop(0), resultado[0]=1-0=1      pila: []
              push(1)                                   pila: [1]
i=2  temp=75  75>74 → pop(1), resultado[1]=2-1=1      pila: []
              push(2)                                   pila: [2]
i=3  temp=71  71<75 → push(3)                          pila: [2,3]
i=4  temp=69  69<71 → push(4)                          pila: [2,3,4]
i=5  temp=72  72>69 → pop(4), resultado[4]=5-4=1      
              72>71 → pop(3), resultado[3]=5-3=2       pila: [2]
              72<75 → push(5)                           pila: [2,5]
i=6  temp=76  76>72 → pop(5), resultado[5]=6-5=1
              76>75 → pop(2), resultado[2]=6-2=4       pila: []
              push(6)                                   pila: [6]
i=7  temp=73  73<76 → push(7)                          pila: [6,7]

Resultado: [1, 1, 4, 2, 1, 1, 0, 0] ✓
```

Complejidad: O(n) — cada elemento se apila y desapila como máximo una vez.

---

## Backtracking con pilas: generar todas las secuencias válidas de paréntesis

Dado un número n, generar todas las combinaciones de n pares de paréntesis bien formados.

```java
void generarParentesis(int n, int abiertos, int cerrados,
                       String actual, PilaGenerica<String> resultados){

    // caso base: usamos todos los paréntesis
    if(actual.length() == 2 * n){
        resultados.push(actual);
        System.out.println(actual);
        return;
    }

    // opción 1: agregar '(' si aún quedan
    if(abiertos < n){
        generarParentesis(n, abiertos + 1, cerrados, actual + "(", resultados);
    }

    // opción 2: agregar ')' si hay '(' sin cerrar (backtrack implícito)
    if(cerrados < abiertos){
        generarParentesis(n, abiertos, cerrados + 1, actual + ")", resultados);
    }
}

// Uso: generarParentesis(3, 0, 0, "", new PilaGenerica<>(100));
```

Salida para n=3:

```
((()))
(()())
(())()
()(())
()()()
```

Este es un problema de backtracking porque en cada paso decidimos si poner `(` o `)`, y las restricciones (no más de n abiertos, no cerrar sin abrir) podan el árbol de decisiones.

---

## Ventajas y desventajas: Pila con arreglo vs. Pila con lista enlazada

| Criterio | Arreglo | Lista enlazada |
|---|---|---|
| Capacidad | Fija (o con redimensionamiento) | Ilimitada (hasta memoria disponible) |
| Memoria | Puede desperdiciar espacio si no se llena | Usa exactamente lo necesario + overhead por nodos |
| Velocidad | Ligeramente más rápida (acceso directo) | Ligeramente más lenta (indirección por punteros) |
| Implementación | Más simple | Requiere clase Nodo |
| Cache-friendly | Sí (datos contiguos en memoria) | No (nodos dispersos en memoria) |

---

## Ejercicios de pilas

### Ejercicios básicos

1. Implementar el método `tamaño()` y `imprimir()` en la clase Pila con arreglo.

2. Implementar una pila con redimensionamiento automático (cuando se llena, duplicar la capacidad).

3. Implementar el método `minimo()` que retorne el valor mínimo de la pila en O(1). Pista: usar una segunda pila auxiliar que almacene los mínimos.

### Ejercicios de aplicación

4. Convertir una expresión infija `(3 + 4) * 2` a postfija `3 4 + 2 *` usando una pila (algoritmo Shunting Yard). Investigar las reglas de precedencia de operadores.

5. Implementar una calculadora que evalúe expresiones como `"3 + 4 * 2"` respetando precedencia. Pista: convertir a postfija y luego evaluar.

6. Dado un String con etiquetas HTML como `"<div><p></p></div>"`, verificar que estén correctamente anidadas usando una pila.

### Ejercicios recursivos

7. Implementar `ordenarPila(Pila pila)` que ordene una pila de menor (fondo) a mayor (tope) usando solo recursividad y operaciones de pila. Pista: similar a invertir, pero insertando en la posición correcta.

8. Implementar la función de Fibonacci usando una pila explícita en lugar de recursividad. Comparar con la versión recursiva.

### Ejercicios de backtracking

9. Dado un arreglo de enteros y un valor objetivo, usar una pila para almacenar las decisiones del backtracking y encontrar todos los subconjuntos que sumen el objetivo. Imprimir el contenido de la pila cada vez que se encuentre una solución.

10. (Desafío) Implementar un solucionador de expresiones matemáticas con paréntesis usando backtracking: dado un resultado objetivo y un conjunto de números, encontrar cómo combinarlos con +, -, *, / para obtener el resultado.

---

## Complejidad de operaciones en pilas

| Operación | Arreglo | Lista enlazada |
|---|---|---|
| push | O(1) amortizado | O(1) |
| pop | O(1) | O(1) |
| peek | O(1) | O(1) |
| buscar un elemento | O(n) | O(n) |
| tamaño | O(1) | O(1) si se mantiene contador |

---

## Conexión con la biblioteca estándar de Java

Después de entender la implementación interna, puedes usar:

```java
import java.util.Stack;

Stack<Integer> pila = new Stack<>();
pila.push(10);
pila.push(20);
System.out.println(pila.pop());    // 20
System.out.println(pila.peek());   // 10
System.out.println(pila.isEmpty()); // false
```

O mejor aún, usar `Deque` (recomendado por Java desde Java 6):

```java
import java.util.ArrayDeque;
import java.util.Deque;

Deque<Integer> pila = new ArrayDeque<>();
pila.push(10);
pila.push(20);
System.out.println(pila.pop());    // 20
```

`ArrayDeque` es más rápida que `Stack` porque `Stack` hereda de `Vector` (sincronizado, más lento).

---
