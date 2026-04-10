# 2. Medios de almacenamiento, información y ofimática

## Tipos de memoria

### Memoria RAM (Random Access Memory)

Es la memoria de **trabajo** de la computadora. Almacena temporalmente los datos
y programas que se están usando en el momento.

Características:
- **Volátil:** se borra al apagar la computadora
- **Rápida:** mucho más rápida que el disco duro
- **Limitada:** típicamente 4 GB, 8 GB, 16 GB o 32 GB

Analogía: la RAM es como tu escritorio de trabajo. Mientras más grande sea, más
documentos puedes tener abiertos al mismo tiempo.

### Memoria ROM (Read Only Memory)

Memoria de **solo lectura**. Contiene instrucciones permanentes que la computadora
necesita para arrancar.

Características:
- **No volátil:** no se borra al apagar
- **No modificable** (en su forma básica)
- Contiene el **BIOS/UEFI**: el programa que inicia la computadora

### Memoria caché

Memoria ultrarrápida ubicada **dentro de la CPU**. Almacena copias de los datos
más usados para que el procesador no tenga que ir a buscarlos a la RAM.

Niveles:
- **L1:** la más rápida y pequeña (32-64 KB por núcleo)
- **L2:** intermedia (256 KB - 1 MB por núcleo)
- **L3:** más grande y compartida entre núcleos (4-32 MB)

---

## Jerarquía de memoria

La memoria se organiza en una pirámide donde a mayor velocidad, menor capacidad
y mayor costo:

```
        ┌─────────┐
        │ Registros│  ← Más rápida, más cara, menor capacidad
        │  (CPU)   │
        ├──────────┤
        │  Caché   │
        │ L1/L2/L3 │
        ├──────────┤
        │   RAM    │
        ├──────────┤
        │ SSD/HDD  │
        ├──────────┤
        │  Nube /  │  ← Más lenta, más barata, mayor capacidad
        │ Externos │
        └──────────┘
```

---

## Medios de almacenamiento

### Disco duro (HDD - Hard Disk Drive)

- Almacenamiento **magnético** con discos giratorios
- Capacidad: 500 GB a 20 TB
- Velocidad: 80-160 MB/s
- Ventaja: económico para grandes cantidades de datos
- Desventaja: más lento, sensible a golpes

### Unidad de estado sólido (SSD - Solid State Drive)

- Almacenamiento en **chips de memoria flash** (sin partes móviles)
- Capacidad: 128 GB a 8 TB
- Velocidad: 500-7,000 MB/s
- Ventaja: mucho más rápido, resistente a golpes, silencioso
- Desventaja: más costoso por GB

### Comparación HDD vs SSD

| Característica | HDD | SSD |
|---------------|-----|-----|
| Velocidad de lectura | ~120 MB/s | ~550 MB/s (SATA) / ~3,500 MB/s (NVMe) |
| Tiempo de arranque del SO | 30-60 segundos | 8-15 segundos |
| Ruido | Sí (partes mecánicas) | No |
| Resistencia a golpes | Baja | Alta |
| Precio por TB | Bajo | Alto |
| Vida útil | Larga | Limitada por ciclos de escritura |

### Memoria USB (pendrive)

- Almacenamiento portátil con memoria flash
- Capacidad: 4 GB a 1 TB
- Conexión: USB-A, USB-C
- Uso: transportar archivos entre computadoras

### Almacenamiento en la nube

- Los archivos se guardan en servidores remotos accesibles por internet
- Ejemplos: Google Drive, OneDrive, Dropbox, iCloud
- Ventajas: acceso desde cualquier dispositivo, respaldo automático
- Desventajas: requiere internet, preocupaciones de privacidad

### Medios ópticos (en desuso)

- CD: 700 MB
- DVD: 4.7 GB (simple capa) / 8.5 GB (doble capa)
- Blu-ray: 25 GB (simple capa) / 50 GB (doble capa)

---

## ¿Qué es la ofimática?

La **ofimática** es el conjunto de herramientas informáticas que se utilizan para
optimizar y automatizar las tareas de oficina. Las tres herramientas principales
son:

1. **Procesador de texto** (Word, Google Docs, LibreOffice Writer)
2. **Hoja de cálculo** (Excel, Google Sheets, LibreOffice Calc)
3. **Presentaciones** (PowerPoint, Google Slides, LibreOffice Impress)

---

## Procesadores de texto

Un procesador de texto permite crear, editar y dar formato a documentos escritos.

### Funciones básicas

| Función | Descripción | Atajo común |
|---------|------------|-------------|
| Nuevo documento | Crear un documento en blanco | Ctrl + N |
| Abrir | Abrir un documento existente | Ctrl + O |
| Guardar | Guardar cambios | Ctrl + S |
| Guardar como | Guardar con otro nombre o formato | Ctrl + Shift + S |
| Deshacer | Revertir la última acción | Ctrl + Z |
| Rehacer | Repetir la acción deshecha | Ctrl + Y |
| Copiar | Copiar texto seleccionado | Ctrl + C |
| Pegar | Pegar texto copiado | Ctrl + V |
| Cortar | Cortar texto seleccionado | Ctrl + X |
| Buscar | Buscar texto en el documento | Ctrl + F |
| Reemplazar | Buscar y reemplazar texto | Ctrl + H |

### Formato de texto

- **Fuente:** tipo de letra (Arial, Times New Roman, Calibri)
- **Tamaño:** medido en puntos (pt). Texto normal: 11-12 pt, títulos: 14-24 pt
- **Estilo:** negrita (Ctrl+B), cursiva (Ctrl+I), subrayado (Ctrl+U)
- **Color:** color del texto y color de resaltado
- **Alineación:** izquierda, centrado, derecha, justificado

### Estilos y estructura

Los estilos permiten dar formato consistente al documento:

- **Título 1:** para secciones principales
- **Título 2:** para subsecciones
- **Normal:** para texto del cuerpo
- **Lista:** para enumeraciones

Usar estilos permite generar automáticamente una tabla de contenido.

---

## Hojas de cálculo

Una hoja de cálculo organiza datos en una cuadrícula de **filas** (números) y
**columnas** (letras). La intersección de una fila y una columna es una **celda**.

### Referencia de celdas

```
    A       B       C       D
1 | Nombre | Nota1 | Nota2 | Promedio |
2 | Ana    | 40    | 35    |          |
3 | Luis   | 28    | 42    |          |
4 | María  | 45    | 38    |          |
```

- La celda B2 contiene el valor 40 (Nota1 de Ana)
- La celda C3 contiene el valor 42 (Nota2 de Luis)

### Fórmulas

Las fórmulas siempre comienzan con el signo **=**

```
Celda D2: =( B2 + C2 ) / 2     → (40 + 35) / 2 = 37.5
Celda D3: =( B3 + C3 ) / 2     → (28 + 42) / 2 = 35
Celda D4: =( B4 + C4 ) / 2     → (45 + 38) / 2 = 41.5
```

### Funciones básicas

| Función | Descripción | Ejemplo |
|---------|------------|---------|
| SUMA | Suma un rango de celdas | =SUMA(B2:B4) → 113 |
| PROMEDIO | Calcula el promedio | =PROMEDIO(B2:B4) → 37.67 |
| MAX | Valor máximo | =MAX(B2:B4) → 45 |
| MIN | Valor mínimo | =MIN(B2:B4) → 28 |
| CONTAR | Cuenta celdas con números | =CONTAR(B2:B4) → 3 |
| SI | Condicional | =SI(D2>=30,"Aprobado","Reprobado") |

### Ejemplo práctico: notas de un curso

```
    A        B      C      D          E
1 | Nombre | Nota1 | Nota2 | Promedio | Estado    |
2 | Ana    | 40    | 35    | 37.5     | Aprobado  |
3 | Luis   | 28    | 22    | 25       | Reprobado |
4 | María  | 45    | 38    | 41.5     | Aprobado  |
```

Fórmulas:
- D2: `=(B2+C2)/2`
- E2: `=SI(D2>=30,"Aprobado","Reprobado")`

### Gráficos

Las hojas de cálculo permiten crear gráficos a partir de los datos:

- **Barras:** comparar cantidades entre categorías
- **Líneas:** mostrar tendencias en el tiempo
- **Circular (torta):** mostrar proporciones de un total
- **Dispersión:** mostrar relación entre dos variables

---

## Presentaciones

Las presentaciones son herramientas para comunicar ideas de forma visual ante una
audiencia.

### Elementos de una diapositiva

- **Título:** texto principal de la diapositiva
- **Contenido:** texto, imágenes, gráficos, tablas, videos
- **Fondo:** color o imagen de fondo
- **Transiciones:** efectos al pasar de una diapositiva a otra
- **Animaciones:** efectos en los elementos dentro de una diapositiva

### Buenas prácticas para presentaciones

1. **Regla 6×6:** máximo 6 líneas por diapositiva, máximo 6 palabras por línea
2. **Poco texto:** la diapositiva apoya tu discurso, no lo reemplaza
3. **Imágenes de calidad:** una buena imagen vale más que un párrafo
4. **Contraste:** texto oscuro sobre fondo claro o viceversa
5. **Consistencia:** usar la misma fuente y colores en toda la presentación
6. **Tamaño de fuente:** mínimo 24 pt para que se lea desde lejos

---

## Archivos y formatos comunes

| Extensión | Tipo | Programa asociado |
|-----------|------|-------------------|
| .docx | Documento de texto | Word |
| .xlsx | Hoja de cálculo | Excel |
| .pptx | Presentación | PowerPoint |
| .pdf | Documento portable | Acrobat Reader |
| .txt | Texto plano | Bloc de notas |
| .csv | Valores separados por comas | Excel / cualquier editor |
| .jpg / .png | Imagen | Visor de imágenes |
| .mp4 | Video | Reproductor multimedia |
| .mp3 | Audio | Reproductor de música |
| .zip / .rar | Archivo comprimido | WinRAR / 7-Zip |

---

## Ejercicios prácticos

### Ejercicio 1: Jerarquía de memoria

Ordena de más rápida a más lenta: RAM, SSD, Caché L1, Disco duro HDD, Nube

<details>
<summary>Solución</summary>

1. Caché L1 (la más rápida)
2. RAM
3. SSD
4. Disco duro HDD
5. Nube (la más lenta, depende de internet)

</details>

---

### Ejercicio 2: Capacidad de almacenamiento

Si tienes una USB de 16 GB y quieres guardar:
- 200 fotos de 5 MB cada una
- 50 documentos Word de 500 KB cada uno
- 10 canciones de 4 MB cada una

¿Cabe todo? ¿Cuánto espacio libre queda?

<details>
<summary>Solución</summary>

- Fotos: 200 × 5 MB = 1,000 MB
- Documentos: 50 × 500 KB = 25,000 KB = 24.41 MB ≈ 25 MB
- Canciones: 10 × 4 MB = 40 MB
- Total: 1,000 + 25 + 40 = 1,065 MB ≈ 1.04 GB

USB disponible: 16 GB
Espacio libre: 16 - 1.04 = 14.96 GB

Sí cabe todo, y sobra mucho espacio.

</details>

---

### Ejercicio 3: Fórmulas en hoja de cálculo

Dada la siguiente tabla de ventas:

```
    A          B        C        D
1 | Producto | Enero  | Febrero | Total |
2 | Lápices  | 15000  | 18000   |       |
3 | Cuadernos| 25000  | 22000   |       |
4 | Borradores| 8000  | 9500    |       |
5 | TOTAL    |        |         |       |
```

Escribe las fórmulas para:
a) Calcular el total de cada producto (columna D)
b) Calcular el total de ventas de enero (celda B5)
c) Calcular el gran total (celda D5)

<details>
<summary>Solución</summary>

a) Totales por producto:
- D2: `=B2+C2` → 33,000
- D3: `=B3+C3` → 47,000
- D4: `=B4+C4` → 17,500

b) Total enero:
- B5: `=SUMA(B2:B4)` → 48,000

c) Gran total:
- D5: `=SUMA(D2:D4)` → 97,500
  (también valdría: `=SUMA(B2:C4)`)

</details>

---

### Ejercicio 4: Función SI

Escribe la fórmula para una celda que muestre:
- "Excelente" si la nota es >= 45
- "Aprobado" si la nota es >= 30
- "Reprobado" si la nota es < 30

Asume que la nota está en la celda B2.

<details>
<summary>Solución</summary>

```
=SI(B2>=45, "Excelente", SI(B2>=30, "Aprobado", "Reprobado"))
```

Prueba:
- Si B2 = 48 → "Excelente"
- Si B2 = 35 → "Aprobado"
- Si B2 = 22 → "Reprobado"

</details>

---

### Ejercicios para practicar por tu cuenta

1. Crea un documento en Word con tu hoja de vida. Usa estilos de título, listas y formato de texto.
2. En Excel, crea una tabla con los gastos de una semana (transporte, comida, entretenimiento). Calcula el total diario, el total por categoría y el gran total. Haz un gráfico de barras.
3. Crea una presentación de 5 diapositivas sobre un tema que te guste. Aplica la regla 6×6.
4. Investiga: ¿qué es un archivo CSV y por qué es útil para intercambiar datos entre programas?
5. Compara el tamaño de un mismo documento guardado como .docx, .pdf y .txt. ¿Cuál pesa más? ¿Por qué?
