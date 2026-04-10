# 4. Pseudocódigo

## ¿Qué es el pseudocódigo?

El **pseudocódigo** es una forma de escribir algoritmos usando un lenguaje
intermedio entre el español y un lenguaje de programación. No es código que se
pueda ejecutar directamente en una computadora, pero describe con precisión los
pasos de un algoritmo.

Es la herramienta principal para **pensar antes de programar**.

---

## ¿Por qué usar pseudocódigo?

| Ventaja | Explicación |
|---------|------------|
| Independiente del lenguaje | No importa si después programas en Python, Java o C |
| Fácil de leer | Cualquier persona con lógica básica lo entiende |
| Enfoca en la lógica | No te distraes con sintaxis, punto y coma, llaves, etc. |
| Fácil de modificar | Cambiar un algoritmo en pseudocódigo es más rápido que en código |
| Documenta el proceso | Sirve como documentación del diseño del programa |

### Pseudocódigo vs. Diagramas de flujo

| Aspecto | Pseudocódigo | Diagrama de flujo |
|---------|-------------|-------------------|
| Formato | Texto | Gráfico (cajas y flechas) |
| Velocidad de escritura | Rápido | Lento (dibujar) |
| Algoritmos complejos | Se maneja bien | Se vuelve confuso |
| Modificación | Fácil | Hay que redibujar |
| Cercanía al código | Alta | Baja |

Para este curso, preferimos el pseudocódigo porque es más práctico y se traduce
directamente a cualquier lenguaje de programación.

---

## Convenciones y palabras reservadas

En este curso usamos las siguientes convenciones:

### Estructura general

```
Algoritmo NombreDelAlgoritmo
  // declaraciones y instrucciones
FinAlgoritmo
```

### Palabras reservadas

| Palabra | Uso |
|---------|-----|
| Algoritmo / FinAlgoritmo | Inicio y fin del programa |
| Leer | Entrada de datos |
| Escribir | Salida de datos |
| ← | Asignación (variable recibe un valor) |
| Si / SinoSi / Sino / FinSi | Condicionales |
| Según / FinSegún | Estructura selectiva |
| Mientras / FinMientras | Ciclo mientras |
| Hacer / Mientras | Ciclo hacer-mientras |
| Para / FinPara | Ciclo para |
| Funcion / FinFuncion | Definir una función |
| Retornar | Devolver un valor desde una función |
| Dimension | Declarar un arreglo |

### Reglas de escritura

1. **Indentación:** usar sangría para mostrar bloques de código (lo que está dentro de un Si, un Para, etc.)
2. **Nombres descriptivos:** usar nombres que expliquen qué almacena la variable (`sumaTotal` en vez de `x`)
3. **Comentarios:** usar `//` para explicar partes del algoritmo
4. **Una instrucción por línea**
5. **Mayúscula inicial** en palabras reservadas (Si, Para, Mientras)

---

## Estructura general de un programa en pseudocódigo

```
Algoritmo NombreDescriptivo
  // Declaración de variables (opcional, pero recomendado)
  // Variables: nombre (cadena), edad (entero), promedio (real)

  // Entrada de datos
  Escribir "Mensaje para el usuario"
  Leer variable

  // Procesamiento
  variable ← expresión

  // Salida de resultados
  Escribir "Resultado: ", variable
FinAlgoritmo
```

### Ejemplo completo: calcular el IMC (Índice de Masa Corporal)

```
Algoritmo CalcularIMC
  // Entrada
  Escribir "Ingrese su peso en kg:"
  Leer peso
  Escribir "Ingrese su estatura en metros:"
  Leer estatura

  // Procesamiento
  imc ← peso / (estatura ^ 2)

  // Salida con clasificación
  Escribir "Su IMC es: ", imc

  Si (imc < 18.5) Entonces
    Escribir "Clasificación: Bajo peso"
  SinoSi (imc < 25) Entonces
    Escribir "Clasificación: Peso normal"
  SinoSi (imc < 30) Entonces
    Escribir "Clasificación: Sobrepeso"
  Sino
    Escribir "Clasificación: Obesidad"
  FinSi
FinAlgoritmo
```

Prueba de escritorio con peso=70, estatura=1.75:

| Variable | Valor |
|----------|-------|
| peso | 70 |
| estatura | 1.75 |
| imc | 70 / (1.75²) = 70 / 3.0625 = 22.86 |
| Clasificación | 22.86 < 25 → "Peso normal" |

---

## Traducción de problemas cotidianos a pseudocódigo

La clave para resolver problemas es seguir estos pasos:

1. **Entender el problema:** ¿qué me piden? ¿qué datos tengo?
2. **Identificar entrada, proceso y salida**
3. **Escribir el algoritmo paso a paso**
4. **Verificar con prueba de escritorio**

### Problema 1: Calcular el cambio en una tienda

"Un cliente compra un producto. El cajero necesita calcular cuánto cambio debe devolver."

Análisis:
- Entrada: precio del producto, dinero que paga el cliente
- Proceso: cambio = dinero - precio
- Salida: el cambio, o un mensaje si el dinero no alcanza

```
Algoritmo CalcularCambio
  Escribir "Precio del producto:"
  Leer precio
  Escribir "Dinero del cliente:"
  Leer dinero

  Si (dinero >= precio) Entonces
    cambio ← dinero - precio
    Escribir "Cambio a devolver: $", cambio
  Sino
    faltante ← precio - dinero
    Escribir "Dinero insuficiente. Faltan: $", faltante
  FinSi
FinAlgoritmo
```

### Problema 2: Promedio de notas con aprobación

"Calcular el promedio de 3 notas de un estudiante y determinar si aprobó (promedio >= 30)."

```
Algoritmo PromedioNotas
  Escribir "Ingrese las tres notas:"
  Leer nota1, nota2, nota3

  promedio ← (nota1 + nota2 + nota3) / 3

  Escribir "Promedio: ", promedio

  Si (promedio >= 30) Entonces
    Escribir "Estado: APROBADO"
  Sino
    Escribir "Estado: REPROBADO"
  FinSi
FinAlgoritmo
```

### Problema 3: Cajero automático

"Simular un cajero que entrega billetes. Dado un monto, determinar cuántos billetes de 50000, 20000, 10000, 5000, 2000 y 1000 se necesitan."

```
Algoritmo CajeroAutomatico
  Escribir "Ingrese el monto a retirar:"
  Leer monto

  billetes50 ← monto / 50000
  monto ← monto MOD 50000

  billetes20 ← monto / 20000
  monto ← monto MOD 20000

  billetes10 ← monto / 10000
  monto ← monto MOD 10000

  billetes5 ← monto / 5000
  monto ← monto MOD 5000

  billetes2 ← monto / 2000
  monto ← monto MOD 2000

  billetes1 ← monto / 1000
  monto ← monto MOD 1000

  Escribir "Billetes de $50,000: ", billetes50
  Escribir "Billetes de $20,000: ", billetes20
  Escribir "Billetes de $10,000: ", billetes10
  Escribir "Billetes de $5,000: ", billetes5
  Escribir "Billetes de $2,000: ", billetes2
  Escribir "Billetes de $1,000: ", billetes1

  Si (monto > 0) Entonces
    Escribir "Sobrante sin entregar: $", monto
  FinSi
FinAlgoritmo
```

Prueba de escritorio con monto=87000:

| Paso | monto | billetes | Cálculo |
|------|-------|----------|---------|
| init | 87000 | | |
| 50000 | 37000 | billetes50 = 1 | 87000/50000=1, 87000 MOD 50000=37000 |
| 20000 | 17000 | billetes20 = 1 | 37000/20000=1, 37000 MOD 20000=17000 |
| 10000 | 7000 | billetes10 = 1 | 17000/10000=1, 17000 MOD 10000=7000 |
| 5000 | 2000 | billetes5 = 1 | 7000/5000=1, 7000 MOD 5000=2000 |
| 2000 | 0 | billetes2 = 1 | 2000/2000=1, 2000 MOD 2000=0 |
| 1000 | 0 | billetes1 = 0 | 0/1000=0 |

Salida: 1 de $50,000 + 1 de $20,000 + 1 de $10,000 + 1 de $5,000 + 1 de $2,000 = $87,000 ✓

---

## Subprocesos y funciones en pseudocódigo

Cuando un algoritmo se vuelve largo, conviene dividirlo en partes más pequeñas
llamadas **funciones** o **subprocesos**.

### ¿Por qué usar funciones?

1. **Reutilización:** escribir el código una vez y usarlo muchas veces
2. **Organización:** dividir un problema grande en problemas pequeños
3. **Legibilidad:** el algoritmo principal queda más limpio

### Sintaxis de una función

```
Funcion resultado ← NombreFuncion(parámetro1, parámetro2)
  // instrucciones
  resultado ← valor
FinFuncion
```

### Ejemplo: función para calcular el factorial

```
Funcion fact ← Factorial(n)
  fact ← 1
  Para i ← 1 Hasta n Con paso 1 Hacer
    fact ← fact * i
  FinPara
FinFuncion

// Uso:
Algoritmo UsarFactorial
  Escribir "Ingrese un número:"
  Leer num
  resultado ← Factorial(num)
  Escribir num, "! = ", resultado
FinAlgoritmo
```

### Ejemplo: función para verificar si es primo

```
Funcion resultado ← EsPrimo(n)
  resultado ← verdadero
  Si (n <= 1) Entonces
    resultado ← falso
  Sino
    Para i ← 2 Hasta n - 1 Con paso 1 Hacer
      Si (n MOD i = 0) Entonces
        resultado ← falso
      FinSi
    FinPara
  FinSi
FinFuncion
```

### Ejemplo: programa con múltiples funciones

```
Funcion resultado ← Mayor(a, b)
  Si (a >= b) Entonces
    resultado ← a
  Sino
    resultado ← b
  FinSi
FinFuncion

Funcion resultado ← MayorDeTres(a, b, c)
  resultado ← Mayor(Mayor(a, b), c)
FinFuncion

Algoritmo EncontrarMayor
  Escribir "Ingrese tres números:"
  Leer x, y, z
  m ← MayorDeTres(x, y, z)
  Escribir "El mayor es: ", m
FinAlgoritmo
```

Prueba con x=8, y=15, z=3:
- Mayor(8, 15) → 15
- Mayor(15, 3) → 15
- Salida: "El mayor es: 15"

---

## Arreglos en pseudocódigo

Un **arreglo** es una variable que almacena múltiples valores del mismo tipo,
accesibles por un índice (posición).

### Declaración

```
Dimension numeros[5]    // arreglo de 5 posiciones (índices 1 a 5)
```

### Visualización

```
Índice:    1     2     3     4     5
Valor:   [ 10 ][ 25 ][ 3  ][ 47 ][ 8  ]
```

### Operaciones básicas con arreglos

```
// Llenar un arreglo
Dimension notas[5]
Para i ← 1 Hasta 5 Con paso 1 Hacer
  Escribir "Ingrese nota ", i, ":"
  Leer notas[i]
FinPara

// Mostrar un arreglo
Para i ← 1 Hasta 5 Con paso 1 Hacer
  Escribir "notas[", i, "] = ", notas[i]
FinPara

// Buscar el mayor
mayor ← notas[1]
Para i ← 2 Hasta 5 Con paso 1 Hacer
  Si (notas[i] > mayor) Entonces
    mayor ← notas[i]
  FinSi
FinPara
Escribir "La nota más alta es: ", mayor
```

### Ejemplo completo: estadísticas de un grupo

```
Algoritmo EstadisticasGrupo
  Escribir "¿Cuántos estudiantes?"
  Leer n
  Dimension notas[n]

  // Leer notas
  Para i ← 1 Hasta n Con paso 1 Hacer
    Escribir "Nota del estudiante ", i, ":"
    Leer notas[i]
  FinPara

  // Calcular suma y encontrar mayor y menor
  suma ← notas[1]
  mayor ← notas[1]
  menor ← notas[1]

  Para i ← 2 Hasta n Con paso 1 Hacer
    suma ← suma + notas[i]
    Si (notas[i] > mayor) Entonces
      mayor ← notas[i]
    FinSi
    Si (notas[i] < menor) Entonces
      menor ← notas[i]
    FinSi
  FinPara

  promedio ← suma / n

  Escribir "Promedio: ", promedio
  Escribir "Nota más alta: ", mayor
  Escribir "Nota más baja: ", menor
FinAlgoritmo
```

Prueba con n=4, notas: 35, 42, 28, 40:

| i | notas[i] | suma | mayor | menor |
|---|----------|------|-------|-------|
| 1 | 35 | 35 | 35 | 35 |
| 2 | 42 | 77 | 42 | 35 |
| 3 | 28 | 105 | 42 | 28 |
| 4 | 40 | 145 | 42 | 28 |

promedio = 145/4 = 36.25
Salida: Promedio: 36.25, Mayor: 42, Menor: 28

### Ejemplo: ordenar un arreglo (Burbuja)

El ordenamiento burbuja compara pares de elementos adyacentes y los intercambia
si están en el orden incorrecto. Se repite hasta que no haya más intercambios.

```
Algoritmo OrdenarBurbuja
  Dimension datos[5]
  // Supongamos datos = [40, 10, 30, 20, 50]

  Para i ← 1 Hasta 4 Con paso 1 Hacer
    Para j ← 1 Hasta 5 - i Con paso 1 Hacer
      Si (datos[j] > datos[j + 1]) Entonces
        // Intercambiar
        temp ← datos[j]
        datos[j] ← datos[j + 1]
        datos[j + 1] ← temp
      FinSi
    FinPara
  FinPara
FinAlgoritmo
```

Prueba de escritorio con [40, 10, 30, 20, 50]:

```
Pasada 1 (i=1): compara posiciones 1-2, 2-3, 3-4, 4-5
  [40, 10, 30, 20, 50] → 40>10 intercambiar → [10, 40, 30, 20, 50]
  [10, 40, 30, 20, 50] → 40>30 intercambiar → [10, 30, 40, 20, 50]
  [10, 30, 40, 20, 50] → 40>20 intercambiar → [10, 30, 20, 40, 50]
  [10, 30, 20, 40, 50] → 40<50 no cambia    → [10, 30, 20, 40, 50]

Pasada 2 (i=2): compara posiciones 1-2, 2-3, 3-4
  [10, 30, 20, 40, 50] → 10<30 no cambia    → [10, 30, 20, 40, 50]
  [10, 30, 20, 40, 50] → 30>20 intercambiar → [10, 20, 30, 40, 50]
  [10, 20, 30, 40, 50] → 30<40 no cambia    → [10, 20, 30, 40, 50]

Pasada 3 (i=3): compara posiciones 1-2, 2-3
  [10, 20, 30, 40, 50] → no hay intercambios

Resultado final: [10, 20, 30, 40, 50] ✓
```

---

## Ejercicios integradores

### Ejercicio 1: Tienda de productos

Crear un programa que permita registrar N productos con nombre y precio, y luego
muestre: el producto más caro, el más barato y el precio promedio.

<details>
<summary>Solución</summary>

```
Algoritmo TiendaProductos
  Escribir "¿Cuántos productos?"
  Leer n
  Dimension nombres[n]
  Dimension precios[n]

  // Leer productos
  Para i ← 1 Hasta n Con paso 1 Hacer
    Escribir "Nombre del producto ", i, ":"
    Leer nombres[i]
    Escribir "Precio:"
    Leer precios[i]
  FinPara

  // Encontrar mayor, menor y promedio
  posMayor ← 1
  posMenor ← 1
  suma ← precios[1]

  Para i ← 2 Hasta n Con paso 1 Hacer
    suma ← suma + precios[i]
    Si (precios[i] > precios[posMayor]) Entonces
      posMayor ← i
    FinSi
    Si (precios[i] < precios[posMenor]) Entonces
      posMenor ← i
    FinSi
  FinPara

  promedio ← suma / n

  Escribir "Más caro: ", nombres[posMayor], " ($", precios[posMayor], ")"
  Escribir "Más barato: ", nombres[posMenor], " ($", precios[posMenor], ")"
  Escribir "Precio promedio: $", promedio
FinAlgoritmo
```

</details>

---

### Ejercicio 2: Juego de adivinanza

El programa genera un número secreto (simulado) y el usuario tiene 5 intentos
para adivinarlo. El programa indica si el número es mayor o menor.

<details>
<summary>Solución</summary>

```
Algoritmo JuegoAdivinanza
  secreto ← 42  // en un programa real sería aleatorio
  intentos ← 5
  adivinado ← falso

  Escribir "Adivina el número (1-100). Tienes ", intentos, " intentos."

  Para i ← 1 Hasta intentos Con paso 1 Hacer
    Escribir "Intento ", i, ":"
    Leer respuesta

    Si (respuesta = secreto) Entonces
      Escribir "¡Correcto! Lo adivinaste en ", i, " intentos."
      adivinado ← verdadero
      // Aquí idealmente saldríamos del ciclo
    SinoSi (respuesta < secreto) Entonces
      Escribir "El número es MAYOR"
    Sino
      Escribir "El número es MENOR"
    FinSi
  FinPara

  Si (NO adivinado) Entonces
    Escribir "Se acabaron los intentos. El número era: ", secreto
  FinSi
FinAlgoritmo
```

</details>

---

### Ejercicio 3: Cifrado César

Implementar el cifrado César: desplazar cada letra del alfabeto N posiciones.

<details>
<summary>Solución</summary>

```
Algoritmo CifradoCesar
  Escribir "Ingrese el texto (solo mayúsculas):"
  Leer texto
  Escribir "Ingrese el desplazamiento:"
  Leer desplazamiento

  abecedario ← "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  resultado ← ""

  Para i ← 1 Hasta Longitud(texto) Con paso 1 Hacer
    letra ← Subcadena(texto, i, i)

    // Buscar posición de la letra en el abecedario
    posicion ← 0
    Para j ← 1 Hasta 26 Con paso 1 Hacer
      Si (Subcadena(abecedario, j, j) = letra) Entonces
        posicion ← j
      FinSi
    FinPara

    Si (posicion > 0) Entonces
      // Calcular nueva posición con desplazamiento circular
      nuevaPos ← ((posicion - 1 + desplazamiento) MOD 26) + 1
      resultado ← resultado + Subcadena(abecedario, nuevaPos, nuevaPos)
    Sino
      resultado ← resultado + letra  // no es letra, dejar igual
    FinSi
  FinPara

  Escribir "Texto cifrado: ", resultado
FinAlgoritmo
```

Prueba con texto="HOLA", desplazamiento=3:

| i | letra | posición | nuevaPos | resultado |
|---|-------|----------|----------|-----------|
| 1 | H | 8 | (7+3) MOD 26 + 1 = 11 | "K" |
| 2 | O | 15 | (14+3) MOD 26 + 1 = 18 | "KR" |
| 3 | L | 12 | (11+3) MOD 26 + 1 = 15 | "KRO" |
| 4 | A | 1 | (0+3) MOD 26 + 1 = 4 | "KROD" |

Salida: "Texto cifrado: KROD"

</details>

---

## Proyecto final: problemas completos en pseudocódigo

### Proyecto 1: Sistema de notas

Crear un sistema que:
1. Lea las notas de N estudiantes (3 notas por estudiante)
2. Calcule el promedio de cada estudiante
3. Determine si aprobó o reprobó
4. Al final muestre: cuántos aprobaron, cuántos reprobaron, el promedio general

<details>
<summary>Solución</summary>

```
Algoritmo SistemaNotas
  Escribir "¿Cuántos estudiantes?"
  Leer n

  aprobados ← 0
  reprobados ← 0
  sumaGeneral ← 0

  Para i ← 1 Hasta n Con paso 1 Hacer
    Escribir "=== Estudiante ", i, " ==="
    Escribir "Nota 1:"
    Leer n1
    Escribir "Nota 2:"
    Leer n2
    Escribir "Nota 3:"
    Leer n3

    promedio ← (n1 + n2 + n3) / 3
    sumaGeneral ← sumaGeneral + promedio

    Escribir "Promedio: ", promedio

    Si (promedio >= 30) Entonces
      Escribir "Estado: APROBADO"
      aprobados ← aprobados + 1
    Sino
      Escribir "Estado: REPROBADO"
      reprobados ← reprobados + 1
    FinSi
  FinPara

  promedioGeneral ← sumaGeneral / n

  Escribir ""
  Escribir "=== RESUMEN ==="
  Escribir "Total estudiantes: ", n
  Escribir "Aprobados: ", aprobados
  Escribir "Reprobados: ", reprobados
  Escribir "Promedio general: ", promedioGeneral
FinAlgoritmo
```

</details>

---

### Proyecto 2: Gestión de inventario

Crear un programa con menú que permita:
1. Agregar un producto (nombre y cantidad)
2. Buscar un producto por nombre
3. Mostrar todos los productos
4. Salir

<details>
<summary>Solución</summary>

```
Algoritmo GestionInventario
  Dimension nombres[100]
  Dimension cantidades[100]
  totalProductos ← 0

  Hacer
    Escribir ""
    Escribir "=== INVENTARIO ==="
    Escribir "1. Agregar producto"
    Escribir "2. Buscar producto"
    Escribir "3. Mostrar todos"
    Escribir "4. Salir"
    Leer opcion

    Según (opcion) Hacer
      caso 1:
        totalProductos ← totalProductos + 1
        Escribir "Nombre del producto:"
        Leer nombres[totalProductos]
        Escribir "Cantidad:"
        Leer cantidades[totalProductos]
        Escribir "Producto agregado."

      caso 2:
        Escribir "Nombre a buscar:"
        Leer buscar
        encontrado ← falso
        Para i ← 1 Hasta totalProductos Con paso 1 Hacer
          Si (nombres[i] = buscar) Entonces
            Escribir "Encontrado: ", nombres[i], " - Cantidad: ", cantidades[i]
            encontrado ← verdadero
          FinSi
        FinPara
        Si (NO encontrado) Entonces
          Escribir "Producto no encontrado."
        FinSi

      caso 3:
        Si (totalProductos = 0) Entonces
          Escribir "No hay productos registrados."
        Sino
          Escribir "--- Lista de productos ---"
          Para i ← 1 Hasta totalProductos Con paso 1 Hacer
            Escribir i, ". ", nombres[i], " (", cantidades[i], " unidades)"
          FinPara
        FinSi

      caso 4:
        Escribir "Hasta luego."

      De otro modo:
        Escribir "Opción no válida."
    FinSegún
  Mientras (opcion <> 4)
FinAlgoritmo
```

</details>

---

### Proyecto 3: Análisis de texto

Crear un programa que reciba un texto y muestre:
- Cantidad de caracteres
- Cantidad de palabras (contar espacios + 1)
- Cantidad de vocales
- Cantidad de consonantes

<details>
<summary>Solución</summary>

```
Algoritmo AnalisisTexto
  Escribir "Ingrese un texto:"
  Leer texto

  totalCaracteres ← Longitud(texto)
  palabras ← 1
  vocales ← 0
  consonantes ← 0
  letrasVocales ← "aeiouAEIOU"
  letrasConsonantes ← "bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ"

  Para i ← 1 Hasta totalCaracteres Con paso 1 Hacer
    caracter ← Subcadena(texto, i, i)

    // Contar palabras
    Si (caracter = " ") Entonces
      palabras ← palabras + 1
    FinSi

    // Contar vocales
    esVocal ← falso
    Para j ← 1 Hasta Longitud(letrasVocales) Con paso 1 Hacer
      Si (caracter = Subcadena(letrasVocales, j, j)) Entonces
        esVocal ← verdadero
      FinSi
    FinPara

    Si (esVocal) Entonces
      vocales ← vocales + 1
    Sino
      // Verificar si es consonante
      esConsonante ← falso
      Para j ← 1 Hasta Longitud(letrasConsonantes) Con paso 1 Hacer
        Si (caracter = Subcadena(letrasConsonantes, j, j)) Entonces
          esConsonante ← verdadero
        FinSi
      FinPara
      Si (esConsonante) Entonces
        consonantes ← consonantes + 1
      FinSi
    FinSi
  FinPara

  Escribir "Caracteres: ", totalCaracteres
  Escribir "Palabras: ", palabras
  Escribir "Vocales: ", vocales
  Escribir "Consonantes: ", consonantes
FinAlgoritmo
```

Prueba con texto = "Hola Mundo":

| i | caracter | palabras | vocales | consonantes |
|---|----------|----------|---------|-------------|
| 1 | H | 1 | 0 | 1 |
| 2 | o | 1 | 1 | 1 |
| 3 | l | 1 | 1 | 2 |
| 4 | a | 1 | 2 | 2 |
| 5 | (espacio) | 2 | 2 | 2 |
| 6 | M | 2 | 2 | 3 |
| 7 | u | 2 | 3 | 3 |
| 8 | n | 2 | 3 | 4 |
| 9 | d | 2 | 3 | 5 |
| 10 | o | 2 | 4 | 5 |

Salida: Caracteres: 10, Palabras: 2, Vocales: 4, Consonantes: 5

</details>

---

## Ejercicios finales para practicar

1. Crear un programa que lea N números y los muestre en orden inverso (usando un arreglo).
2. Implementar una función que reciba un arreglo y retorne la suma de todos sus elementos.
3. Crear un programa que genere la tabla de multiplicar de cualquier número, usando una función.
4. Implementar un programa que determine si una palabra es palíndromo.
5. Crear un sistema de votación: registrar votos para 3 candidatos y mostrar el ganador.
6. Implementar un programa que convierta un número decimal a cualquier base (2, 8, 16) usando una función.
7. Crear un programa que simule una lista de tareas: agregar, marcar como completada, mostrar pendientes.
8. Implementar el juego del ahorcado: el programa tiene una palabra secreta y el usuario adivina letra por letra.

Para cada ejercicio, entrega:
- El pseudocódigo completo
- Una prueba de escritorio con al menos un ejemplo
- Una breve explicación de la lógica utilizada
