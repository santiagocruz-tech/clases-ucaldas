# 3. Plantillas para la resolución de problemas — Estructuras de control

## ¿Qué es un algoritmo?

Un **algoritmo** es una secuencia finita de pasos ordenados y precisos que
resuelven un problema o realizan una tarea.

Analogía: una receta de cocina es un algoritmo. Tiene ingredientes (datos de
entrada), pasos ordenados (instrucciones) y un resultado (el plato terminado).

### Características de un buen algoritmo

1. **Preciso:** cada paso está claramente definido, sin ambigüedad
2. **Finito:** termina después de un número determinado de pasos
3. **Definido:** si se ejecuta dos veces con los mismos datos, produce el mismo resultado
4. **Tiene entrada:** recibe datos para trabajar (puede ser cero o más)
5. **Tiene salida:** produce al menos un resultado

### Ejemplo cotidiano: preparar café

```
Inicio
  1. Llenar la cafetera con agua
  2. Agregar café molido al filtro
  3. Encender la cafetera
  4. Esperar hasta que el café esté listo
  5. Servir en una taza
  6. Si desea azúcar, agregar azúcar
  7. Revolver
Fin
```

---

## Variables, constantes y tipos de datos

### Variables

Una **variable** es un espacio en memoria que almacena un valor que puede cambiar
durante la ejecución del programa.

```
edad ← 20          // la variable "edad" almacena el valor 20
nombre ← "Ana"     // la variable "nombre" almacena el texto "Ana"
edad ← 21          // ahora "edad" vale 21 (cambió)
```

### Constantes

Una **constante** es un valor que NO cambia durante la ejecución.

```
PI ← 3.14159
GRAVEDAD ← 9.8
```

### Tipos de datos

| Tipo | Descripción | Ejemplos |
|------|------------|----------|
| Entero | Números sin decimales | 5, -3, 0, 1000 |
| Real | Números con decimales | 3.14, -0.5, 100.0 |
| Carácter | Un solo símbolo | 'A', '7', '#' |
| Cadena | Texto (secuencia de caracteres) | "Hola", "Universidad" |
| Lógico | Verdadero o falso | verdadero, falso |

---

## Operadores

### Operadores aritméticos

| Operador | Operación | Ejemplo | Resultado |
|----------|-----------|---------|-----------|
| + | Suma | 5 + 3 | 8 |
| - | Resta | 10 - 4 | 6 |
| * | Multiplicación | 6 * 7 | 42 |
| / | División | 15 / 4 | 3.75 |
| MOD | Módulo (residuo) | 15 MOD 4 | 3 |
| ^ | Potencia | 2 ^ 3 | 8 |

### Operadores relacionales (de comparación)

Siempre devuelven un valor lógico: verdadero o falso.

| Operador | Significado | Ejemplo | Resultado |
|----------|------------|---------|-----------|
| = | Igual a | 5 = 5 | verdadero |
| ≠ o <> | Diferente de | 5 <> 3 | verdadero |
| > | Mayor que | 7 > 3 | verdadero |
| < | Menor que | 2 < 1 | falso |
| >= | Mayor o igual | 5 >= 5 | verdadero |
| <= | Menor o igual | 3 <= 2 | falso |

### Operadores lógicos

Combinan condiciones.

| Operador | Significado | Ejemplo | Resultado |
|----------|------------|---------|-----------|
| Y (AND) | Ambas deben ser verdaderas | (5>3) Y (2<4) | verdadero |
| O (OR) | Al menos una debe ser verdadera | (5>3) O (2>4) | verdadero |
| NO (NOT) | Invierte el valor | NO(5>3) | falso |

Tabla de verdad:

| A | B | A Y B | A O B | NO A |
|---|---|-------|-------|------|
| V | V | V | V | F |
| V | F | F | V | F |
| F | V | F | V | V |
| F | F | F | F | V |

---

## Entrada y salida de datos

Para que un algoritmo interactúe con el usuario necesitamos:

- **Leer:** obtener datos del usuario (entrada)
- **Escribir:** mostrar resultados al usuario (salida)

```
Escribir "¿Cuál es tu edad?"
Leer edad
Escribir "Tienes ", edad, " años"
```

---

## 3.1 Estructura secuencial

Es la más simple. Las instrucciones se ejecutan una tras otra, en orden, de
arriba hacia abajo.

### Ejemplo: calcular el área de un rectángulo

```
Inicio
  Escribir "Ingrese la base:"
  Leer base
  Escribir "Ingrese la altura:"
  Leer altura
  area ← base * altura
  Escribir "El área es: ", area
Fin
```

Prueba de escritorio con base=5, altura=3:

| Paso | base | altura | area | Salida |
|------|------|--------|------|--------|
| 1 | 5 | | | "Ingrese la base:" |
| 2 | 5 | 3 | | "Ingrese la altura:" |
| 3 | 5 | 3 | 15 | |
| 4 | 5 | 3 | 15 | "El área es: 15" |

### Ejemplo: convertir temperatura de Celsius a Fahrenheit

Fórmula: F = C × 9/5 + 32

```
Inicio
  Escribir "Ingrese temperatura en Celsius:"
  Leer celsius
  fahrenheit ← celsius * 9 / 5 + 32
  Escribir celsius, "°C = ", fahrenheit, "°F"
Fin
```

Prueba de escritorio con celsius=25:

| Paso | celsius | fahrenheit | Salida |
|------|---------|-----------|--------|
| 1 | 25 | | "Ingrese temperatura en Celsius:" |
| 2 | 25 | 77 | |
| 3 | 25 | 77 | "25°C = 77°F" |

---

## 3.2 Condicionales

Permiten tomar decisiones. El programa elige un camino u otro según una condición.

### Si simple (if)

```
Si (condición) Entonces
  instrucciones
FinSi
```

Ejemplo: verificar si un número es positivo

```
Inicio
  Escribir "Ingrese un número:"
  Leer num
  Si (num > 0) Entonces
    Escribir "El número es positivo"
  FinSi
Fin
```

### Si-Sino (if-else)

```
Si (condición) Entonces
  instrucciones si verdadero
Sino
  instrucciones si falso
FinSi
```

Ejemplo: determinar si aprobó o reprobó

```
Inicio
  Escribir "Ingrese su nota (0-50):"
  Leer nota
  Si (nota >= 30) Entonces
    Escribir "Aprobado"
  Sino
    Escribir "Reprobado"
  FinSi
Fin
```

Prueba de escritorio con nota=35:

| Paso | nota | nota >= 30 | Salida |
|------|------|-----------|--------|
| 1 | 35 | | "Ingrese su nota:" |
| 2 | 35 | verdadero | |
| 3 | 35 | | "Aprobado" |

Prueba de escritorio con nota=22:

| Paso | nota | nota >= 30 | Salida |
|------|------|-----------|--------|
| 1 | 22 | | "Ingrese su nota:" |
| 2 | 22 | falso | |
| 3 | 22 | | "Reprobado" |

### Si anidado (if-else if-else)

Cuando hay más de dos opciones:

```
Si (condición1) Entonces
  instrucciones
SinoSi (condición2) Entonces
  instrucciones
SinoSi (condición3) Entonces
  instrucciones
Sino
  instrucciones por defecto
FinSi
```

Ejemplo: clasificar una nota

```
Inicio
  Escribir "Ingrese su nota (0-50):"
  Leer nota

  Si (nota >= 45) Entonces
    Escribir "Excelente"
  SinoSi (nota >= 38) Entonces
    Escribir "Bueno"
  SinoSi (nota >= 30) Entonces
    Escribir "Aceptable"
  Sino
    Escribir "Reprobado"
  FinSi
Fin
```

Prueba de escritorio con nota=40:

| Paso | nota | nota>=45 | nota>=38 | Salida |
|------|------|---------|---------|--------|
| 1 | 40 | falso | verdadero | "Bueno" |

### Ejemplo: determinar el mayor de tres números

```
Inicio
  Escribir "Ingrese tres números:"
  Leer a, b, c

  Si (a >= b) Y (a >= c) Entonces
    Escribir "El mayor es: ", a
  SinoSi (b >= a) Y (b >= c) Entonces
    Escribir "El mayor es: ", b
  Sino
    Escribir "El mayor es: ", c
  FinSi
Fin
```

Prueba de escritorio con a=7, b=12, c=5:

| Paso | a | b | c | a>=b Y a>=c | b>=a Y b>=c | Salida |
|------|---|---|---|------------|------------|--------|
| 1 | 7 | 12 | 5 | F Y V = F | V Y V = V | "El mayor es: 12" |

---

## 3.3 Estructuras selectivas: Según (switch/case)

Cuando una variable puede tomar varios valores específicos y queremos ejecutar
algo diferente para cada uno:

```
Según (variable) Hacer
  caso valor1:
    instrucciones
  caso valor2:
    instrucciones
  caso valor3:
    instrucciones
  De otro modo:
    instrucciones por defecto
FinSegún
```

Ejemplo: menú de operaciones

```
Inicio
  Escribir "Seleccione una operación:"
  Escribir "1. Sumar"
  Escribir "2. Restar"
  Escribir "3. Multiplicar"
  Escribir "4. Dividir"
  Leer opcion

  Escribir "Ingrese dos números:"
  Leer a, b

  Según (opcion) Hacer
    caso 1:
      resultado ← a + b
      Escribir "Suma: ", resultado
    caso 2:
      resultado ← a - b
      Escribir "Resta: ", resultado
    caso 3:
      resultado ← a * b
      Escribir "Multiplicación: ", resultado
    caso 4:
      Si (b <> 0) Entonces
        resultado ← a / b
        Escribir "División: ", resultado
      Sino
        Escribir "Error: no se puede dividir por cero"
      FinSi
    De otro modo:
      Escribir "Opción no válida"
  FinSegún
Fin
```

Prueba de escritorio con opcion=3, a=6, b=4:

| Paso | opcion | a | b | resultado | Salida |
|------|--------|---|---|-----------|--------|
| 1 | 3 | | | | "Seleccione una operación:" |
| 2 | 3 | 6 | 4 | | "Ingrese dos números:" |
| 3 | 3 | 6 | 4 | 24 | "Multiplicación: 24" |

### Ejemplo: día de la semana

```
Inicio
  Escribir "Ingrese un número del 1 al 7:"
  Leer dia

  Según (dia) Hacer
    caso 1: Escribir "Lunes"
    caso 2: Escribir "Martes"
    caso 3: Escribir "Miércoles"
    caso 4: Escribir "Jueves"
    caso 5: Escribir "Viernes"
    caso 6: Escribir "Sábado"
    caso 7: Escribir "Domingo"
    De otro modo: Escribir "Número no válido"
  FinSegún
Fin
```

---

## 3.4 Ciclos (bucles)

Los ciclos permiten repetir un bloque de instrucciones múltiples veces.

### Ciclo Mientras (while)

Repite **mientras** la condición sea verdadera. La condición se evalúa **antes**
de cada iteración.

```
Mientras (condición) Hacer
  instrucciones
FinMientras
```

Ejemplo: contar del 1 al 5

```
Inicio
  i ← 1
  Mientras (i <= 5) Hacer
    Escribir i
    i ← i + 1
  FinMientras
Fin
```

Prueba de escritorio:

| Paso | i | i <= 5 | Salida |
|------|---|--------|--------|
| 1 | 1 | verdadero | 1 |
| 2 | 2 | verdadero | 2 |
| 3 | 3 | verdadero | 3 |
| 4 | 4 | verdadero | 4 |
| 5 | 5 | verdadero | 5 |
| 6 | 6 | falso | (sale del ciclo) |

### Ejemplo: sumar números hasta que el usuario ingrese 0

```
Inicio
  suma ← 0
  Escribir "Ingrese números (0 para terminar):"
  Leer num

  Mientras (num <> 0) Hacer
    suma ← suma + num
    Leer num
  FinMientras

  Escribir "La suma es: ", suma
Fin
```

Prueba de escritorio con entradas 5, 3, 8, 0:

| Paso | num | num <> 0 | suma | Salida |
|------|-----|---------|------|--------|
| init | | | 0 | "Ingrese números:" |
| 1 | 5 | verdadero | 5 | |
| 2 | 3 | verdadero | 8 | |
| 3 | 8 | verdadero | 16 | |
| 4 | 0 | falso | 16 | "La suma es: 16" |

### Ciclo Hacer-Mientras (do-while)

Similar al Mientras, pero la condición se evalúa **después** de cada iteración.
Esto garantiza que el bloque se ejecuta **al menos una vez**.

```
Hacer
  instrucciones
Mientras (condición)
```

Ejemplo: pedir una nota válida (entre 0 y 50)

```
Inicio
  Hacer
    Escribir "Ingrese una nota (0-50):"
    Leer nota
  Mientras (nota < 0) O (nota > 50)

  Escribir "Nota válida: ", nota
Fin
```

Si el usuario ingresa 60, luego -5, luego 35:

| Paso | nota | nota<0 O nota>50 | Salida |
|------|------|-----------------|--------|
| 1 | 60 | F O V = verdadero | "Ingrese una nota:" |
| 2 | -5 | V O F = verdadero | "Ingrese una nota:" |
| 3 | 35 | F O F = falso | "Nota válida: 35" |

### Ciclo Para (for)

Se usa cuando se conoce de antemano cuántas veces se va a repetir.

```
Para variable ← inicio Hasta fin Con paso Hacer
  instrucciones
FinPara
```

Ejemplo: tabla de multiplicar del 7

```
Inicio
  Escribir "Tabla del 7:"
  Para i ← 1 Hasta 10 Con paso 1 Hacer
    resultado ← 7 * i
    Escribir "7 × ", i, " = ", resultado
  FinPara
Fin
```

Prueba de escritorio:

| i | resultado | Salida |
|---|-----------|--------|
| 1 | 7 | 7 × 1 = 7 |
| 2 | 14 | 7 × 2 = 14 |
| 3 | 21 | 7 × 3 = 21 |
| 4 | 28 | 7 × 4 = 28 |
| 5 | 35 | 7 × 5 = 35 |
| 6 | 42 | 7 × 6 = 42 |
| 7 | 49 | 7 × 7 = 49 |
| 8 | 56 | 7 × 8 = 56 |
| 9 | 63 | 7 × 9 = 63 |
| 10 | 70 | 7 × 10 = 70 |

### Ejemplo: sumar los números pares del 2 al 20

```
Inicio
  suma ← 0
  Para i ← 2 Hasta 20 Con paso 2 Hacer
    suma ← suma + i
  FinPara
  Escribir "La suma de pares es: ", suma
Fin
```

Prueba de escritorio:

| i | suma |
|---|------|
| 2 | 2 |
| 4 | 6 |
| 6 | 12 |
| 8 | 20 |
| 10 | 30 |
| 12 | 42 |
| 14 | 56 |
| 16 | 72 |
| 18 | 90 |
| 20 | 110 |

Salida: "La suma de pares es: 110"

---

## 3.5 Ciclos anidados

Un ciclo dentro de otro. El ciclo interno se ejecuta completamente por cada
iteración del ciclo externo.

### Ejemplo: tabla de multiplicar del 1 al 5

```
Inicio
  Para i ← 1 Hasta 5 Con paso 1 Hacer
    Escribir "--- Tabla del ", i, " ---"
    Para j ← 1 Hasta 10 Con paso 1 Hacer
      Escribir i, " × ", j, " = ", i * j
    FinPara
  FinPara
Fin
```

¿Cuántas líneas imprime? El ciclo externo se ejecuta 5 veces. Por cada una, el
interno se ejecuta 10 veces. Total: 5 × 10 = 50 multiplicaciones + 5 títulos = 55 líneas.

### Ejemplo: dibujar un rectángulo de asteriscos

```
Inicio
  Escribir "Ingrese filas:"
  Leer filas
  Escribir "Ingrese columnas:"
  Leer columnas

  Para i ← 1 Hasta filas Con paso 1 Hacer
    linea ← ""
    Para j ← 1 Hasta columnas Con paso 1 Hacer
      linea ← linea + "* "
    FinPara
    Escribir linea
  FinPara
Fin
```

Con filas=3, columnas=4:

```
* * * *
* * * *
* * * *
```

---

## 3.6 Contadores y acumuladores

### Contador

Variable que se incrementa en una cantidad fija (generalmente 1) cada vez que
ocurre un evento.

```
contador ← 0
// cada vez que ocurre el evento:
contador ← contador + 1
```

### Acumulador

Variable que acumula valores que pueden ser diferentes en cada iteración.

```
suma ← 0
// cada vez que hay un nuevo valor:
suma ← suma + valor
```

### Ejemplo: contar aprobados y calcular promedio

```
Inicio
  totalEstudiantes ← 5
  aprobados ← 0
  sumaNotas ← 0

  Para i ← 1 Hasta totalEstudiantes Con paso 1 Hacer
    Escribir "Ingrese nota del estudiante ", i, ":"
    Leer nota
    sumaNotas ← sumaNotas + nota      // acumulador
    Si (nota >= 30) Entonces
      aprobados ← aprobados + 1        // contador
    FinSi
  FinPara

  promedio ← sumaNotas / totalEstudiantes
  Escribir "Aprobados: ", aprobados
  Escribir "Promedio del grupo: ", promedio
Fin
```

Prueba de escritorio con notas 40, 25, 35, 18, 42:

| i | nota | sumaNotas | nota>=30 | aprobados |
|---|------|-----------|---------|-----------|
| 1 | 40 | 40 | V | 1 |
| 2 | 25 | 65 | F | 1 |
| 3 | 35 | 100 | V | 2 |
| 4 | 18 | 118 | F | 2 |
| 5 | 42 | 160 | V | 3 |

promedio = 160 / 5 = 32
Salida: "Aprobados: 3" y "Promedio del grupo: 32"

---

## Ejercicios con soluciones

### Ejercicio 1: Par o impar

Escribir un algoritmo que lea un número y determine si es par o impar.

<details>
<summary>Solución</summary>

```
Inicio
  Escribir "Ingrese un número:"
  Leer num

  Si (num MOD 2 = 0) Entonces
    Escribir num, " es par"
  Sino
    Escribir num, " es impar"
  FinSi
Fin
```

Prueba con num=7: 7 MOD 2 = 1, 1 ≠ 0 → "7 es impar"
Prueba con num=12: 12 MOD 2 = 0 → "12 es par"

</details>

---

### Ejercicio 2: Calculadora con menú

Crear una calculadora que muestre un menú, realice la operación y pregunte si
desea continuar.

<details>
<summary>Solución</summary>

```
Inicio
  Hacer
    Escribir "=== CALCULADORA ==="
    Escribir "1. Sumar"
    Escribir "2. Restar"
    Escribir "3. Multiplicar"
    Escribir "4. Dividir"
    Escribir "5. Salir"
    Leer opcion

    Si (opcion <> 5) Entonces
      Escribir "Ingrese primer número:"
      Leer a
      Escribir "Ingrese segundo número:"
      Leer b

      Según (opcion) Hacer
        caso 1: Escribir "Resultado: ", a + b
        caso 2: Escribir "Resultado: ", a - b
        caso 3: Escribir "Resultado: ", a * b
        caso 4:
          Si (b <> 0) Entonces
            Escribir "Resultado: ", a / b
          Sino
            Escribir "Error: división por cero"
          FinSi
        De otro modo:
          Escribir "Opción no válida"
      FinSegún
    FinSi
  Mientras (opcion <> 5)

  Escribir "Hasta luego"
Fin
```

</details>

---

### Ejercicio 3: Factorial

Calcular el factorial de un número. Recuerda: 5! = 5 × 4 × 3 × 2 × 1 = 120

<details>
<summary>Solución</summary>

```
Inicio
  Escribir "Ingrese un número:"
  Leer n
  factorial ← 1

  Para i ← 1 Hasta n Con paso 1 Hacer
    factorial ← factorial * i
  FinPara

  Escribir n, "! = ", factorial
Fin
```

Prueba de escritorio con n=5:

| i | factorial |
|---|-----------|
| 1 | 1 |
| 2 | 2 |
| 3 | 6 |
| 4 | 24 |
| 5 | 120 |

Salida: "5! = 120"

</details>

---

### Ejercicio 4: Números primos

Determinar si un número es primo.

<details>
<summary>Solución</summary>

```
Inicio
  Escribir "Ingrese un número:"
  Leer n
  esPrimo ← verdadero

  Si (n <= 1) Entonces
    esPrimo ← falso
  Sino
    Para i ← 2 Hasta n - 1 Con paso 1 Hacer
      Si (n MOD i = 0) Entonces
        esPrimo ← falso
      FinSi
    FinPara
  FinSi

  Si (esPrimo) Entonces
    Escribir n, " es primo"
  Sino
    Escribir n, " no es primo"
  FinSi
Fin
```

Prueba con n=7:

| i | n MOD i | n MOD i = 0 | esPrimo |
|---|---------|------------|---------|
| 2 | 1 | falso | verdadero |
| 3 | 1 | falso | verdadero |
| 4 | 3 | falso | verdadero |
| 5 | 2 | falso | verdadero |
| 6 | 1 | falso | verdadero |

Salida: "7 es primo"

Prueba con n=12:

| i | n MOD i | n MOD i = 0 | esPrimo |
|---|---------|------------|---------|
| 2 | 0 | verdadero | falso |

Salida: "12 no es primo" (se detecta en la primera iteración)

</details>

---

### Ejercicio 5: Serie Fibonacci

Imprimir los primeros N términos de la serie Fibonacci: 0, 1, 1, 2, 3, 5, 8, 13...

<details>
<summary>Solución</summary>

```
Inicio
  Escribir "¿Cuántos términos?"
  Leer n

  a ← 0
  b ← 1

  Para i ← 1 Hasta n Con paso 1 Hacer
    Escribir a
    temp ← a + b
    a ← b
    b ← temp
  FinPara
Fin
```

Prueba con n=8:

| i | a | b | temp | Salida |
|---|---|---|------|--------|
| 1 | 0 | 1 | 1 | 0 |
| 2 | 1 | 1 | 2 | 1 |
| 3 | 1 | 2 | 3 | 1 |
| 4 | 2 | 3 | 5 | 2 |
| 5 | 3 | 5 | 8 | 3 |
| 6 | 5 | 8 | 13 | 5 |
| 7 | 8 | 13 | 21 | 8 |
| 8 | 13 | 21 | 34 | 13 |

Salida: 0 1 1 2 3 5 8 13

</details>

---

### Ejercicio 6: Triángulo de asteriscos

Dibujar un triángulo de N filas:

```
*
* *
* * *
* * * *
* * * * *
```

<details>
<summary>Solución</summary>

```
Inicio
  Escribir "Ingrese el número de filas:"
  Leer n

  Para i ← 1 Hasta n Con paso 1 Hacer
    linea ← ""
    Para j ← 1 Hasta i Con paso 1 Hacer
      linea ← linea + "* "
    FinPara
    Escribir linea
  FinPara
Fin
```

Prueba con n=4:

| i | j recorre | Salida |
|---|-----------|--------|
| 1 | 1 | "* " |
| 2 | 1, 2 | "* * " |
| 3 | 1, 2, 3 | "* * * " |
| 4 | 1, 2, 3, 4 | "* * * * " |

</details>

---

### Ejercicios para practicar por tu cuenta

1. Leer tres números y mostrarlos ordenados de menor a mayor.
2. Calcular el promedio de N números ingresados por el usuario (N lo decide el usuario).
3. Determinar si un año es bisiesto. (Divisible por 4, excepto los divisibles por 100, excepto los divisibles por 400).
4. Imprimir todos los números primos entre 1 y 100.
5. Leer un número y mostrar la suma de sus dígitos. Ejemplo: 1234 → 1+2+3+4 = 10.
6. Crear un programa que convierta un número decimal a binario usando divisiones sucesivas.
7. Dibujar un triángulo invertido de asteriscos.
8. Simular el juego de adivinar un número: el programa "piensa" un número y el usuario intenta adivinarlo. El programa dice "mayor" o "menor" hasta que acierte.
