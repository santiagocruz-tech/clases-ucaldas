# 0. Prerequisitos y presaberes

Antes de iniciar el curso de Estructuras de Datos, necesitas dominar ciertos conceptos fundamentales de programación en Java. Esta sección sirve como diagnóstico y repaso.

Si alguno de estos temas te resulta difícil, dedica tiempo a reforzarlo antes de avanzar. Las estructuras de datos se construyen sobre estos cimientos.

---

## ¿Qué necesitas saber antes de empezar?

| Tema | ¿Lo dominas? |
|---|---|
| Variables y tipos de datos (int, double, String, boolean) | ☐ |
| Operadores aritméticos, lógicos y de comparación | ☐ |
| Condicionales (if, else, switch) | ☐ |
| Ciclos (for, while, do-while) | ☐ |
| Arreglos unidimensionales y bidimensionales | ☐ |
| Métodos (funciones): definir, llamar, retornar valores | ☐ |
| Clases y objetos básicos | ☐ |
| Entrada y salida (Scanner, System.out.println) | ☐ |

Si marcaste menos de 6, te recomendamos repasar antes de continuar.

---

# 0.1 Repaso rápido de Java

## Variables y tipos

```java
int edad = 20;
double promedio = 4.5;
String nombre = "Ana";
boolean aprobado = true;
char letra = 'A';
```

## Operadores

```java
// Aritméticos
int suma = 5 + 3;        // 8
int residuo = 10 % 3;    // 1

// Comparación (retornan boolean)
boolean mayor = 5 > 3;   // true
boolean igual = 5 == 5;  // true
boolean diff = 5 != 3;   // true

// Lógicos
boolean ambos = true && false;   // false (AND)
boolean alguno = true || false;  // true (OR)
boolean negado = !true;          // false (NOT)
```

## Condicionales

```java
int nota = 35;

if(nota >= 30){
    System.out.println("Aprobado");
} else {
    System.out.println("Reprobado");
}
```

## Ciclos

```java
// for: cuando sabes cuántas veces repetir
for(int i = 0; i < 5; i++){
    System.out.println("Iteración " + i);
}

// while: cuando no sabes cuántas veces
int contador = 10;
while(contador > 0){
    System.out.println(contador);
    contador--;
}
```

## Arreglos

```java
int[] numeros = {10, 20, 30, 40, 50};

// acceder por índice
System.out.println(numeros[0]);  // 10
System.out.println(numeros[4]);  // 50

// recorrer
for(int i = 0; i < numeros.length; i++){
    System.out.println(numeros[i]);
}
```

## Métodos

```java
static int sumar(int a, int b){
    return a + b;
}

static void saludar(String nombre){
    System.out.println("Hola " + nombre);
}

// Uso:
int resultado = sumar(3, 4);  // 7
saludar("Carlos");             // Hola Carlos
```

## Clases y objetos

```java
class Estudiante {

    String nombre;
    int edad;

    Estudiante(String nombre, int edad){
        this.nombre = nombre;
        this.edad = edad;
    }

    void presentarse(){
        System.out.println("Soy " + nombre + ", tengo " + edad + " años");
    }
}

// Uso:
Estudiante e = new Estudiante("Ana", 20);
e.presentarse();  // Soy Ana, tengo 20 años
```

---

# 0.2 Pruebas de escritorio

## ¿Qué es una prueba de escritorio?

Una **prueba de escritorio** es una técnica para ejecutar un programa **a mano, en papel**, paso a paso, registrando el valor de cada variable en cada momento. Es la herramienta más importante para entender qué hace un código y para encontrar errores.

En este curso la usaremos constantemente para entender cómo funcionan las estructuras de datos internamente.

---

## ¿Cómo se hace?

1. Escribir el código en papel (o tenerlo a la vista)
2. Crear una **tabla** con una columna por cada variable
3. Agregar una columna para la **salida** (lo que imprime)
4. Ejecutar línea por línea, actualizando los valores en la tabla
5. Cuando hay un condicional, evaluar la condición y seguir la rama correcta
6. Cuando hay un ciclo, repetir las filas hasta que la condición sea falsa

---

## Ejemplo 1: prueba de escritorio de un ciclo simple

Código:

```java
int suma = 0;

for(int i = 1; i <= 4; i++){
    suma = suma + i;
}

System.out.println(suma);
```

Tabla de prueba de escritorio:

| Paso | i | i <= 4 | suma | Salida |
|------|---|--------|------|--------|
| 1 | 1 | true | 1 | |
| 2 | 2 | true | 3 | |
| 3 | 3 | true | 6 | |
| 4 | 4 | true | 10 | |
| 5 | 5 | false | 10 | 10 |

Explicación paso a paso:

- Paso 1: i=1, 1<=4 es true, suma = 0+1 = 1
- Paso 2: i=2, 2<=4 es true, suma = 1+2 = 3
- Paso 3: i=3, 3<=4 es true, suma = 3+3 = 6
- Paso 4: i=4, 4<=4 es true, suma = 6+4 = 10
- Paso 5: i=5, 5<=4 es false, sale del ciclo, imprime 10

---

## Ejemplo 2: prueba de escritorio con condicional

Código:

```java
int[] datos = {5, 12, 3, 8, 1};
int mayor = datos[0];

for(int i = 1; i < datos.length; i++){
    if(datos[i] > mayor){
        mayor = datos[i];
    }
}

System.out.println("Mayor: " + mayor);
```

Tabla:

| Paso | i | datos[i] | datos[i] > mayor | mayor | Salida |
|------|---|----------|------------------|-------|--------|
| init | | | | 5 | |
| 1 | 1 | 12 | 12 > 5 = true | 12 | |
| 2 | 2 | 3 | 3 > 12 = false | 12 | |
| 3 | 3 | 8 | 8 > 12 = false | 12 | |
| 4 | 4 | 1 | 1 > 12 = false | 12 | |
| fin | | | | 12 | Mayor: 12 |

---

## Ejemplo 3: prueba de escritorio con while y múltiples variables

Código:

```java
int a = 20;
int b = 8;

while(b != 0){
    int temp = b;
    b = a % b;
    a = temp;
}

System.out.println("MCD: " + a);
```

Este es el algoritmo de Euclides para el Máximo Común Divisor.

Tabla:

| Paso | a | b | b != 0 | temp | a % b | Salida |
|------|---|---|--------|------|-------|--------|
| init | 20 | 8 | | | | |
| 1 | 8 | 4 | true | 8 | 20%8=4 | |
| 2 | 4 | 0 | true | 4 | 8%4=0 | |
| 3 | 4 | 0 | false | | | MCD: 4 |

Paso a paso:

- Inicio: a=20, b=8
- Paso 1: b≠0 true. temp=8, b=20%8=4, a=8
- Paso 2: b≠0 true. temp=4, b=8%4=0, a=4
- Paso 3: b≠0 false. Sale del ciclo. Imprime MCD: 4

---

## Ejemplo 4: prueba de escritorio con arreglo bidimensional

Código:

```java
int[][] matriz = {
    {1, 2, 3},
    {4, 5, 6}
};

int suma = 0;

for(int fila = 0; fila < 2; fila++){
    for(int col = 0; col < 3; col++){
        suma += matriz[fila][col];
    }
}

System.out.println("Suma: " + suma);
```

Tabla:

| Paso | fila | col | matriz[fila][col] | suma | Salida |
|------|------|-----|-------------------|------|--------|
| init | | | | 0 | |
| 1 | 0 | 0 | 1 | 1 | |
| 2 | 0 | 1 | 2 | 3 | |
| 3 | 0 | 2 | 3 | 6 | |
| 4 | 1 | 0 | 4 | 10 | |
| 5 | 1 | 1 | 5 | 15 | |
| 6 | 1 | 2 | 6 | 21 | |
| fin | | | | 21 | Suma: 21 |

---

## Ejemplo 5: prueba de escritorio con métodos

Código:

```java
static int factorial(int n){
    int resultado = 1;
    for(int i = 1; i <= n; i++){
        resultado = resultado * i;
    }
    return resultado;
}

// Llamada:
int x = factorial(5);
System.out.println(x);
```

Tabla (dentro de la llamada `factorial(5)`):

| Paso | i | i <= 5 | resultado | Salida |
|------|---|--------|-----------|--------|
| init | | | 1 | |
| 1 | 1 | true | 1 | |
| 2 | 2 | true | 2 | |
| 3 | 3 | true | 6 | |
| 4 | 4 | true | 24 | |
| 5 | 5 | true | 120 | |
| 6 | 6 | false | 120 | |
| fin | | | retorna 120 | 120 |

---

## Ejemplo 6: prueba de escritorio con objetos

Código:

```java
class Contador {
    int valor;

    Contador(){ valor = 0; }

    void incrementar(){ valor++; }
    void decrementar(){ valor--; }
}

Contador c = new Contador();
c.incrementar();
c.incrementar();
c.incrementar();
c.decrementar();
System.out.println(c.valor);
```

Tabla:

| Paso | Operación | c.valor | Salida |
|------|-----------|---------|--------|
| init | new Contador() | 0 | |
| 1 | incrementar() | 1 | |
| 2 | incrementar() | 2 | |
| 3 | incrementar() | 3 | |
| 4 | decrementar() | 2 | |
| 5 | println | 2 | 2 |

---

## Consejos para hacer buenas pruebas de escritorio

1. **No te saltes pasos.** Ejecuta cada línea, incluso si crees saber el resultado.
2. **Escribe la tabla en papel.** No la hagas mentalmente. El papel te obliga a ser preciso.
3. **Incluye la condición de los ciclos.** Escribe si es true o false en cada iteración.
4. **Marca cuándo se sale del ciclo.** Es un error común olvidar la última evaluación de la condición.
5. **Para métodos, haz una tabla separada** por cada llamada.
6. **Para objetos, registra el estado** de cada atributo después de cada operación.

---

# 0.3 Ejercicios de lógica en Java

Estos ejercicios refuerzan el pensamiento lógico necesario para estructuras de datos. Para cada uno, **primero haz la prueba de escritorio en papel** y luego verifica ejecutando el código.

---

## Ejercicio 1: Intercambiar dos variables sin variable temporal

```java
int a = 5;
int b = 3;

a = a + b;   // a = ?
b = a - b;   // b = ?
a = a - b;   // a = ?

System.out.println("a=" + a + " b=" + b);
```

Haz la prueba de escritorio. ¿Cuál es la salida?

<details>
<summary>Solución</summary>

| Paso | a | b | Nota |
|------|---|---|------|
| init | 5 | 3 | |
| 1 | 8 | 3 | a = 5+3 |
| 2 | 8 | 5 | b = 8-3 |
| 3 | 3 | 5 | a = 8-5 |

Salida: a=3 b=5 (se intercambiaron)

</details>

---

## Ejercicio 2: ¿Qué imprime este código?

```java
int x = 10;

for(int i = 0; i < 3; i++){
    for(int j = 0; j < 2; j++){
        x = x - 1;
    }
}

System.out.println(x);
```

Haz la prueba de escritorio con la tabla completa.

<details>
<summary>Solución</summary>

| Paso | i | j | x |
|------|---|---|---|
| init | | | 10 |
| 1 | 0 | 0 | 9 |
| 2 | 0 | 1 | 8 |
| 3 | 1 | 0 | 7 |
| 4 | 1 | 1 | 6 |
| 5 | 2 | 0 | 5 |
| 6 | 2 | 1 | 4 |

Salida: 4
El ciclo externo se ejecuta 3 veces, el interno 2 → total 6 restas.

</details>

---

## Ejercicio 3: Invertir un arreglo

```java
int[] arr = {1, 2, 3, 4, 5};

int izq = 0;
int der = arr.length - 1;

while(izq < der){
    int temp = arr[izq];
    arr[izq] = arr[der];
    arr[der] = temp;
    izq++;
    der--;
}

// ¿Cómo queda arr?
```

<details>
<summary>Solución</summary>

| Paso | izq | der | izq < der | arr |
|------|-----|-----|-----------|-----|
| init | 0 | 4 | | [1, 2, 3, 4, 5] |
| 1 | 1 | 3 | true | [5, 2, 3, 4, 1] |
| 2 | 2 | 2 | true | [5, 4, 3, 2, 1] |
| 3 | 3 | 1 | false | [5, 4, 3, 2, 1] |

Resultado: [5, 4, 3, 2, 1]

</details>

---

## Ejercicio 4: Contar vocales

Implementar y hacer prueba de escritorio:

```java
static int contarVocales(String texto){

    int contador = 0;
    String vocales = "aeiouAEIOU";

    for(int i = 0; i < texto.length(); i++){
        char c = texto.charAt(i);
        if(vocales.indexOf(c) != -1){
            contador++;
        }
    }

    return contador;
}

// contarVocales("Hola Mundo") → ?
```

<details>
<summary>Solución</summary>

| Paso | i | c | ¿Es vocal? | contador |
|------|---|---|------------|----------|
| init | | | | 0 |
| 1 | 0 | 'H' | No | 0 |
| 2 | 1 | 'o' | Sí | 1 |
| 3 | 2 | 'l' | No | 1 |
| 4 | 3 | 'a' | Sí | 2 |
| 5 | 4 | ' ' | No | 2 |
| 6 | 5 | 'M' | No | 2 |
| 7 | 6 | 'u' | Sí | 3 |
| 8 | 7 | 'n' | No | 3 |
| 9 | 8 | 'd' | No | 3 |
| 10 | 9 | 'o' | Sí | 4 |

Retorna: 4

</details>

---

## Ejercicio 5: Búsqueda lineal

```java
static int buscar(int[] arr, int objetivo){

    for(int i = 0; i < arr.length; i++){
        if(arr[i] == objetivo){
            return i;
        }
    }

    return -1;
}

// buscar({10, 25, 3, 47, 8}, 47) → ?
// buscar({10, 25, 3, 47, 8}, 99) → ?
```

<details>
<summary>Solución</summary>

Llamada 1: `buscar({10, 25, 3, 47, 8}, 47)`

| Paso | i | arr[i] | arr[i]==47 |
|------|---|--------|------------|
| 1 | 0 | 10 | false |
| 2 | 1 | 25 | false |
| 3 | 2 | 3 | false |
| 4 | 3 | 47 | true → retorna 3 |

Llamada 2: `buscar({10, 25, 3, 47, 8}, 99)`

| Paso | i | arr[i] | arr[i]==99 |
|------|---|--------|------------|
| 1 | 0 | 10 | false |
| 2 | 1 | 25 | false |
| 3 | 2 | 3 | false |
| 4 | 3 | 47 | false |
| 5 | 4 | 8 | false |

Sale del ciclo → retorna -1

</details>

---

## Ejercicio 6: Números primos

```java
static boolean esPrimo(int n){

    if(n <= 1) return false;

    for(int i = 2; i * i <= n; i++){
        if(n % i == 0){
            return false;
        }
    }

    return true;
}

// esPrimo(7) → ?
// esPrimo(12) → ?
```

<details>
<summary>Solución</summary>

Llamada 1: `esPrimo(7)`

| Paso | i | i*i | i*i<=7 | 7%i==0 |
|------|---|-----|--------|--------|
| 1 | 2 | 4 | true | 7%2=1 → false |
| 2 | 3 | 9 | false | |

Sale del ciclo → retorna true (7 es primo)

Llamada 2: `esPrimo(12)`

| Paso | i | i*i | i*i<=12 | 12%i==0 |
|------|---|-----|---------|---------|
| 1 | 2 | 4 | true | 12%2=0 → true → retorna false |

12 no es primo (divisible por 2).

</details>

---

## Ejercicio 7: Fibonacci iterativo

```java
static void fibonacci(int n){

    int a = 0;
    int b = 1;

    for(int i = 0; i < n; i++){
        System.out.print(a + " ");
        int temp = a + b;
        a = b;
        b = temp;
    }
}

// fibonacci(8) → ?
```

<details>
<summary>Solución</summary>

| Paso | i | a | b | temp | Salida |
|------|---|---|---|------|--------|
| init | | 0 | 1 | | |
| 1 | 0 | 1 | 1 | 1 | 0 |
| 2 | 1 | 1 | 2 | 2 | 1 |
| 3 | 2 | 2 | 3 | 3 | 1 |
| 4 | 3 | 3 | 5 | 5 | 2 |
| 5 | 4 | 5 | 8 | 8 | 3 |
| 6 | 5 | 8 | 13 | 13 | 5 |
| 7 | 6 | 13 | 21 | 21 | 8 |
| 8 | 7 | 21 | 34 | 34 | 13 |

Salida: 0 1 1 2 3 5 8 13

</details>

---

## Ejercicio 8: Ordenar tres números sin arreglo

```java
static void ordenarTres(int a, int b, int c){

    if(a > b){ int t = a; a = b; b = t; }
    if(b > c){ int t = b; b = c; c = t; }
    if(a > b){ int t = a; a = b; b = t; }

    System.out.println(a + " " + b + " " + c);
}

// ordenarTres(30, 10, 20) → ?
```

<details>
<summary>Solución</summary>

| Paso | a | b | c | Condición |
|------|---|---|---|-----------|
| init | 30 | 10 | 20 | |
| 1 | 10 | 30 | 20 | 30>10 true → intercambiar a,b |
| 2 | 10 | 20 | 30 | 30>20 true → intercambiar b,c |
| 3 | 10 | 20 | 30 | 10>20 false → no cambia |

Salida: 10 20 30

Este es un mini Bubble Sort para 3 elementos.

</details>

---

## Ejercicio 9: Matriz identidad

```java
static void identidad(int n){

    for(int i = 0; i < n; i++){
        for(int j = 0; j < n; j++){
            if(i == j){
                System.out.print("1 ");
            } else {
                System.out.print("0 ");
            }
        }
        System.out.println();
    }
}

// identidad(3) → ?
```

<details>
<summary>Solución</summary>

```
i=0: j=0 (i==j → 1)  j=1 (0)  j=2 (0)  → "1 0 0"
i=1: j=0 (0)  j=1 (i==j → 1)  j=2 (0)  → "0 1 0"
i=2: j=0 (0)  j=1 (0)  j=2 (i==j → 1)  → "0 0 1"

Salida:
1 0 0
0 1 0
0 0 1
```

</details>

---

## Ejercicio 10: Palíndromo

```java
static boolean esPalindromo(String texto){

    int izq = 0;
    int der = texto.length() - 1;

    while(izq < der){
        if(texto.charAt(izq) != texto.charAt(der)){
            return false;
        }
        izq++;
        der--;
    }

    return true;
}

// esPalindromo("anilina") → ?
// esPalindromo("hola") → ?
```

<details>
<summary>Solución</summary>

Llamada 1: `esPalindromo("anilina")`

| Paso | izq | der | charAt(izq) | charAt(der) | iguales |
|------|-----|-----|-------------|-------------|---------|
| 1 | 0 | 6 | 'a' | 'a' | sí |
| 2 | 1 | 5 | 'n' | 'n' | sí |
| 3 | 2 | 4 | 'i' | 'i' | sí |
| 4 | 3 | 3 | izq < der = false → sale del ciclo | | |

Retorna: true (es palíndromo)

Llamada 2: `esPalindromo("hola")`

| Paso | izq | der | charAt(izq) | charAt(der) | iguales |
|------|-----|-----|-------------|-------------|---------|
| 1 | 0 | 3 | 'h' | 'a' | no → retorna false |

</details>

---

# 0.4 Ejercicios para practicar por tu cuenta

Implementa cada uno y haz la prueba de escritorio en papel antes de ejecutar:

1. Dado un arreglo de enteros, encontrar el segundo mayor valor.
2. Dado un número entero, determinar si es un número perfecto (la suma de sus divisores propios es igual al número. Ejemplo: 6 = 1+2+3).
3. Dado un arreglo, rotar todos los elementos una posición a la derecha. El último pasa al inicio. Ejemplo: `[1,2,3,4,5]` → `[5,1,2,3,4]`.
4. Dado un String, contar cuántas veces aparece cada carácter. Usar un arreglo de 256 posiciones (una por cada carácter ASCII).
5. Implementar la multiplicación de dos matrices 2×2.
6. Dado un arreglo ordenado, eliminar los duplicados in-place (sin crear otro arreglo). Retornar el nuevo tamaño.
7. Implementar el cifrado César: desplazar cada letra del alfabeto n posiciones. Ejemplo con n=3: "HOLA" → "KROD".
8. Dado un número entero positivo, imprimir su representación en binario usando divisiones sucesivas por 2.

Para cada ejercicio, entrega:

- El código en Java
- La prueba de escritorio en papel con al menos un ejemplo
- La complejidad del algoritmo (¿cuántas operaciones hace en función del tamaño de la entrada?)

---
