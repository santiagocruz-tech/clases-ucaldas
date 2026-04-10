# 1. Conceptos básicos de computación

## ¿Qué es una computadora?

Una **computadora** es una máquina electrónica capaz de recibir datos, procesarlos
siguiendo instrucciones y producir resultados. Es una herramienta que amplifica
nuestra capacidad de resolver problemas.

Toda computadora sigue un ciclo fundamental:

```
Entrada → Procesamiento → Salida
```

- **Entrada:** datos que el usuario proporciona (teclado, ratón, micrófono, escáner)
- **Procesamiento:** la CPU ejecuta operaciones sobre esos datos
- **Salida:** resultados que la computadora devuelve (pantalla, impresora, parlantes)

---

## Hardware y software

| Concepto | Definición | Ejemplos |
|----------|-----------|----------|
| Hardware | Componentes físicos, lo que puedes tocar | Teclado, monitor, disco duro, CPU |
| Software | Programas e instrucciones, lo que no puedes tocar | Windows, Word, Chrome, un videojuego |

Sin hardware, el software no tiene dónde ejecutarse.
Sin software, el hardware no sabe qué hacer.

---

## Componentes principales de una computadora

### CPU (Unidad Central de Procesamiento)

Es el "cerebro" de la computadora. Ejecuta las instrucciones de los programas.

Tiene dos partes principales:

- **ALU (Unidad Aritmético-Lógica):** realiza operaciones matemáticas y comparaciones
- **UC (Unidad de Control):** coordina y dirige todas las operaciones

La velocidad de la CPU se mide en **GHz** (gigahercios). Un procesador de 3.5 GHz
puede ejecutar 3,500 millones de ciclos por segundo.

### Memoria

| Tipo | Características | Velocidad | Persistencia |
|------|----------------|-----------|-------------|
| RAM | Memoria de trabajo, temporal | Muy rápida | Se borra al apagar |
| ROM | Memoria de solo lectura | Rápida | Permanente |
| Caché | Memoria ultrarrápida dentro de la CPU | La más rápida | Temporal |
| Disco duro/SSD | Almacenamiento masivo | Más lenta | Permanente |

### Dispositivos de entrada y salida

**Entrada:**
- Teclado
- Ratón
- Micrófono
- Escáner
- Cámara web

**Salida:**
- Monitor
- Impresora
- Parlantes

**Entrada/Salida:**
- Pantalla táctil
- Memoria USB (lee y escribe datos)

---

## Sistemas de numeración

Los humanos usamos el sistema **decimal** (base 10) porque tenemos 10 dedos.
Las computadoras usan el sistema **binario** (base 2) porque trabajan con dos
estados: encendido (1) y apagado (0).

### Sistema decimal (base 10)

Dígitos: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

Cada posición tiene un valor que es una potencia de 10:

```
Número: 3 5 7
        ↓ ↓ ↓
        3×10² + 5×10¹ + 7×10⁰
        3×100 + 5×10  + 7×1
        300   + 50    + 7
        = 357
```

### Sistema binario (base 2)

Dígitos: 0, 1

Cada posición tiene un valor que es una potencia de 2:

```
Número binario: 1 0 1 1
                ↓ ↓ ↓ ↓
                1×2³ + 0×2² + 1×2¹ + 1×2⁰
                1×8  + 0×4  + 1×2  + 1×1
                8    + 0    + 2    + 1
                = 11 (en decimal)
```

### Sistema octal (base 8)

Dígitos: 0, 1, 2, 3, 4, 5, 6, 7

```
Número octal: 1 5 3
              ↓ ↓ ↓
              1×8² + 5×8¹ + 3×8⁰
              1×64 + 5×8  + 3×1
              64   + 40   + 3
              = 107 (en decimal)
```

### Sistema hexadecimal (base 16)

Dígitos: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A(10), B(11), C(12), D(13), E(14), F(15)

```
Número hexadecimal: 2 A F
                    ↓ ↓ ↓
                    2×16² + A×16¹ + F×16⁰
                    2×256 + 10×16 + 15×1
                    512   + 160   + 15
                    = 687 (en decimal)
```

---

## Conversiones entre sistemas

### Decimal a binario (divisiones sucesivas por 2)

Convertir 25 a binario:

```
25 ÷ 2 = 12  residuo 1  ↑
12 ÷ 2 = 6   residuo 0  ↑
 6 ÷ 2 = 3   residuo 0  ↑
 3 ÷ 2 = 1   residuo 1  ↑
 1 ÷ 2 = 0   residuo 1  ↑

Lectura de abajo hacia arriba: 11001
```

Verificación: 1×16 + 1×8 + 0×4 + 0×2 + 1×1 = 16+8+1 = 25 ✓

### Decimal a octal (divisiones sucesivas por 8)

Convertir 156 a octal:

```
156 ÷ 8 = 19  residuo 4  ↑
 19 ÷ 8 = 2   residuo 3  ↑
  2 ÷ 8 = 0   residuo 2  ↑

Lectura de abajo hacia arriba: 234
```

Verificación: 2×64 + 3×8 + 4×1 = 128+24+4 = 156 ✓

### Decimal a hexadecimal (divisiones sucesivas por 16)

Convertir 450 a hexadecimal:

```
450 ÷ 16 = 28  residuo 2   ↑
 28 ÷ 16 = 1   residuo 12 (C)  ↑
  1 ÷ 16 = 0   residuo 1   ↑

Lectura de abajo hacia arriba: 1C2
```

Verificación: 1×256 + 12×16 + 2×1 = 256+192+2 = 450 ✓

### Binario a decimal

```
10110 en binario:
1×2⁴ + 0×2³ + 1×2² + 1×2¹ + 0×2⁰
16   + 0    + 4    + 2    + 0
= 22
```

### Binario a octal (agrupar de 3 en 3 desde la derecha)

```
Binario:  1 0 1 1 0 1 1 0
Agrupar:  10  110  110
Rellenar: 010 110  110
            2   6    6

Resultado: 266 en octal
```

### Binario a hexadecimal (agrupar de 4 en 4 desde la derecha)

```
Binario:  1 0 1 1 0 1 1 0
Agrupar:  1011  0110
            B     6

Resultado: B6 en hexadecimal
```

---

## Unidades de medida de información

La unidad mínima de información es el **bit** (binary digit): un 0 o un 1.

| Unidad | Equivalencia | Ejemplo de uso |
|--------|-------------|----------------|
| 1 bit | 0 o 1 | Un interruptor encendido/apagado |
| 1 byte | 8 bits | Un carácter (letra 'A') |
| 1 KB (kilobyte) | 1,024 bytes | Un documento de texto corto |
| 1 MB (megabyte) | 1,024 KB | Una foto de buena calidad |
| 1 GB (gigabyte) | 1,024 MB | Una película en calidad estándar |
| 1 TB (terabyte) | 1,024 GB | Un disco duro grande |

Nota: en informática se usa base 2, por eso 1 KB = 1,024 bytes (2¹⁰) y no 1,000.

---

## Tipos de software

### Software de sistema

Es el que permite que la computadora funcione. El más importante es el **sistema operativo**.

Ejemplos: Windows, Linux, macOS, Android, iOS

Funciones del sistema operativo:
- Administrar el hardware
- Gestionar archivos y carpetas
- Permitir ejecutar programas
- Gestionar la memoria

### Software de aplicación

Programas que el usuario utiliza para realizar tareas específicas.

Ejemplos: Word, Excel, Chrome, Photoshop, Spotify

### Software de desarrollo (utilidades)

Herramientas para crear otros programas.

Ejemplos: Visual Studio Code, Eclipse, compiladores, intérpretes

---

## Historia breve de la computación

| Época | Hito | Importancia |
|-------|------|-------------|
| ~3000 a.C. | Ábaco | Primer instrumento de cálculo |
| 1642 | Pascalina (Blaise Pascal) | Primera calculadora mecánica |
| 1837 | Máquina analítica (Charles Babbage) | Concepto de computadora programable |
| 1843 | Ada Lovelace | Primera programadora de la historia |
| 1936 | Máquina de Turing (Alan Turing) | Fundamentos teóricos de la computación |
| 1946 | ENIAC | Primera computadora electrónica de propósito general |
| 1971 | Intel 4004 | Primer microprocesador comercial |
| 1976 | Apple I | Inicio de la computación personal |
| 1981 | IBM PC | Estándar de computadora personal |
| 1991 | World Wide Web | Internet accesible para todos |
| 2007 | iPhone | Revolución de la computación móvil |

---

## Ejercicios

### Ejercicio 1: Identificar componentes

Clasifica cada elemento como Hardware o Software:

a) Teclado  
b) Windows 11  
c) Disco duro SSD  
d) Google Chrome  
e) Memoria RAM de 16 GB  
f) Microsoft Excel  

<details>
<summary>Solución</summary>

a) Hardware  
b) Software (sistema operativo)  
c) Hardware  
d) Software (aplicación)  
e) Hardware  
f) Software (aplicación)  

</details>

---

### Ejercicio 2: Convertir decimal a binario

Convierte los siguientes números a binario:

a) 13  
b) 42  
c) 100  

<details>
<summary>Solución</summary>

a) 13 en binario:
```
13 ÷ 2 = 6  residuo 1
 6 ÷ 2 = 3  residuo 0
 3 ÷ 2 = 1  residuo 1
 1 ÷ 2 = 0  residuo 1
Resultado: 1101
```
Verificación: 8+4+0+1 = 13 ✓

b) 42 en binario:
```
42 ÷ 2 = 21  residuo 0
21 ÷ 2 = 10  residuo 1
10 ÷ 2 = 5   residuo 0
 5 ÷ 2 = 2   residuo 1
 2 ÷ 2 = 1   residuo 0
 1 ÷ 2 = 0   residuo 1
Resultado: 101010
```
Verificación: 32+0+8+0+2+0 = 42 ✓

c) 100 en binario:
```
100 ÷ 2 = 50  residuo 0
 50 ÷ 2 = 25  residuo 0
 25 ÷ 2 = 12  residuo 1
 12 ÷ 2 = 6   residuo 0
  6 ÷ 2 = 3   residuo 0
  3 ÷ 2 = 1   residuo 1
  1 ÷ 2 = 0   residuo 1
Resultado: 1100100
```
Verificación: 64+32+0+0+4+0+0 = 100 ✓

</details>

---

### Ejercicio 3: Convertir binario a decimal

Convierte a decimal:

a) 1010  
b) 11100  
c) 10000001  

<details>
<summary>Solución</summary>

a) 1010 = 1×8 + 0×4 + 1×2 + 0×1 = 10

b) 11100 = 1×16 + 1×8 + 1×4 + 0×2 + 0×1 = 28

c) 10000001 = 1×128 + 0+0+0+0+0+0 + 1×1 = 129

</details>

---

### Ejercicio 4: Conversiones mixtas

a) Convierte 255 a binario, octal y hexadecimal  
b) Convierte el binario 11011011 a decimal, octal y hexadecimal  
c) Convierte el hexadecimal FF a decimal y binario  

<details>
<summary>Solución</summary>

a) 255:
- Binario: 11111111 (255 = 128+64+32+16+8+4+2+1)
- Octal: 377 (255÷8=31 r7, 31÷8=3 r7, 3÷8=0 r3)
- Hexadecimal: FF (255÷16=15 rF, 15÷16=0 rF)

b) 11011011:
- Decimal: 128+64+0+16+8+0+2+1 = 219
- Octal: agrupar de 3: 011 011 011 → 333
- Hexadecimal: agrupar de 4: 1101 1011 → DB

c) FF:
- Decimal: 15×16 + 15×1 = 240+15 = 255
- Binario: F=1111, F=1111 → 11111111

</details>

---

### Ejercicio 5: Unidades de medida

a) ¿Cuántos bits hay en 3 bytes?  
b) ¿Cuántos bytes hay en 2 KB?  
c) Si una foto pesa 3.5 MB, ¿cuántas fotos caben en una USB de 4 GB?  
d) Si un disco duro tiene 500 GB, ¿cuántos TB son?  

<details>
<summary>Solución</summary>

a) 3 bytes × 8 bits = 24 bits

b) 2 KB × 1,024 = 2,048 bytes

c) 4 GB = 4 × 1,024 MB = 4,096 MB. 4,096 ÷ 3.5 ≈ 1,170 fotos

d) 500 GB ÷ 1,024 ≈ 0.488 TB

</details>

---

### Ejercicios para practicar por tu cuenta

1. Convierte los números del 0 al 15 a binario. Memoriza esta tabla, te será muy útil.
2. Convierte 1000 a binario, octal y hexadecimal.
3. ¿Cuántos bytes se necesitan para representar tu nombre completo? (cada carácter = 1 byte)
4. Investiga: ¿cuál es la diferencia entre un disco duro HDD y un SSD?
5. Investiga: ¿qué es la memoria caché y por qué es más rápida que la RAM?
6. Si un video pesa 700 MB y tu conexión descarga a 10 MB/s, ¿cuánto tarda la descarga?
