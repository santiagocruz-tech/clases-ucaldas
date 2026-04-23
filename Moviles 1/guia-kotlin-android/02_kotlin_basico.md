# Capítulo 2: Kotlin básico — Variables, funciones y lógica

## Objetivo

Aprender la sintaxis fundamental de Kotlin aplicándola directamente en nuestro proyecto MisFinanzas. Al final de este capítulo, la app podrá calcular un balance simple.

💡 Pueden practicar los ejemplos de este capítulo en [play.kotlinlang.org](https://play.kotlinlang.org) antes de integrarlos al proyecto.

---

## 2.1 Variables: val y var

En Kotlin hay dos formas de declarar variables:

```kotlin
// "val" = valor inmutable (no se puede cambiar después de asignar)
// Equivalente a "final" en Java o "const" en JavaScript
val nombre: String = "MisFinanzas"  // tipo explícito
val version = "1.0"                 // tipo inferido (Kotlin lo deduce)

// "var" = valor mutable (se puede cambiar)
var balance: Double = 0.0           // tipo explícito
var contador = 0                    // tipo inferido como Int

// Esto funciona:
balance = 1500.50  // var se puede reasignar
contador = contador + 1

// Esto NO compila:
// nombre = "OtraApp"  // ERROR: val no se puede reasignar
```

💡 **Regla de oro:** usar `val` siempre que sea posible. Solo usar `var` cuando el valor realmente necesite cambiar. Esto previene errores y hace el código más predecible.

### Tipos básicos de Kotlin

```kotlin
// Números enteros
val edad: Int = 25              // entero de 32 bits
val poblacion: Long = 50000000  // entero de 64 bits (números grandes)

// Números decimales
val precio: Double = 29.99      // decimal de 64 bits (el más usado)
val porcentaje: Float = 0.15f   // decimal de 32 bits (la "f" es obligatoria)

// Texto
val nombre: String = "Juan"     // cadena de texto
val inicial: Char = 'J'         // un solo carácter (comillas simples)

// Booleano
val activo: Boolean = true      // true o false

// En la práctica, casi nunca escribimos el tipo porque Kotlin lo infiere:
val edad = 25           // Int
val precio = 29.99      // Double
val nombre = "Juan"     // String
val activo = true       // Boolean
```

### String templates (interpolación de texto)

```kotlin
// En Kotlin se usa "$variable" o "${expresion}" dentro de un String
val nombre = "Carlos"
val balance = 1500.50

// Variable simple: se usa $
val saludo = "Hola, $nombre"  // "Hola, Carlos"

// Expresión: se usa ${}
val mensaje = "Tu balance es: $${balance}"  // "Tu balance es: $1500.5"
val info = "Tienes ${if (balance > 0) "saldo positivo" else "saldo negativo"}"
```

---

## 2.2 Null Safety (seguridad contra nulos)

Kotlin no permite que una variable sea `null` a menos que lo declares explícitamente. Esto evita el famoso `NullPointerException`.

```kotlin
// Variable normal: NO puede ser null
var nombre: String = "Juan"
// nombre = null  // ERROR de compilación

// Variable nullable: SÍ puede ser null (se agrega "?" al tipo)
var apellido: String? = "Pérez"
apellido = null  // esto sí funciona

// Para usar una variable nullable, hay que manejar el caso null:

// Opción 1: "?." (safe call) — si es null, retorna null sin crashear
val longitud = apellido?.length  // null si apellido es null, o el largo si no

// Opción 2: "?:" (Elvis operator) — valor por defecto si es null
val longitudSegura = apellido?.length ?: 0  // 0 si apellido es null

// Opción 3: "!!" (non-null assertion) — PELIGROSO, crashea si es null
// val longitudPeligrosa = apellido!!.length  // NullPointerException si es null
// Evitar "!!" siempre que sea posible
```

💡 **En Android, muchos valores que vienen del sistema pueden ser null** (datos de un Intent, texto de un EditText vacío, etc.). Siempre manejen el caso null.

---

## 2.3 Funciones

```kotlin
// Función básica con tipo de retorno explícito
// "fun" = palabra clave para declarar funciones
// Los parámetros llevan nombre: Tipo
fun sumar(a: Double, b: Double): Double {
    return a + b
}

// Función de una sola expresión (forma corta)
// Cuando el cuerpo es una sola línea, se puede usar "="
fun restar(a: Double, b: Double): Double = a - b

// Función sin retorno (Unit es el equivalente a void)
// Si no retorna nada, se puede omitir ": Unit"
fun mostrarMensaje(mensaje: String) {
    println(mensaje)
}

// Función con valor por defecto en un parámetro
// Si no se pasa "moneda", usa "COP" por defecto
fun formatearMonto(monto: Double, moneda: String = "COP"): String {
    return "$moneda ${String.format("%,.2f", monto)}"
}

// Uso:
val resultado = sumar(100.0, 50.0)          // 150.0
val texto = formatearMonto(1500.50)          // "COP 1,500.50"
val enDolares = formatearMonto(50.0, "USD")  // "USD 50.00"

// Parámetros nombrados: se puede especificar el nombre al llamar
val formato = formatearMonto(moneda = "EUR", monto = 99.99)  // "EUR 99.99"
```

---

## 2.4 Condicionales

### if / else

```kotlin
val balance = 1500.0

// if/else clásico
if (balance > 0) {
    println("Saldo positivo")
} else if (balance == 0.0) {
    println("Sin saldo")
} else {
    println("Saldo negativo")
}

// En Kotlin, if es una EXPRESIÓN (retorna un valor)
// Esto reemplaza al operador ternario (? :) que no existe en Kotlin
val estado = if (balance >= 0) "Positivo" else "Negativo"
```

### when (equivalente a switch)

```kotlin
val categoria = "comida"

// "when" es más poderoso que switch de Java
// No necesita "break" y puede evaluar expresiones
when (categoria) {
    "comida" -> println("🍔 Alimentación")
    "transporte" -> println("🚗 Transporte")
    "salario" -> println("💰 Ingreso")
    "entretenimiento" -> println("🎮 Entretenimiento")
    else -> println("📦 Otros")  // "else" es el caso por defecto
}

// "when" también es una expresión (retorna un valor)
val emoji = when (categoria) {
    "comida" -> "🍔"
    "transporte" -> "🚗"
    "salario" -> "💰"
    else -> "📦"
}

// Se puede usar con rangos y condiciones
val monto = 75000.0
val nivel = when {
    monto > 100000 -> "Alto"
    monto > 50000 -> "Medio"
    monto > 0 -> "Bajo"
    else -> "Sin gasto"
}
```

---

## 2.5 Ciclos

```kotlin
// for con rango
// ".." crea un rango inclusivo (1, 2, 3, 4, 5)
for (i in 1..5) {
    println("Mes $i")
}

// for con until (excluye el último)
// "until" crea un rango que NO incluye el final (0, 1, 2)
for (i in 0 until 3) {
    println("Índice: $i")
}

// for con step (saltos)
for (i in 0..10 step 2) {
    println(i)  // 0, 2, 4, 6, 8, 10
}

// for descendente
for (i in 5 downTo 1) {
    println(i)  // 5, 4, 3, 2, 1
}

// for recorriendo una lista
val categorias = listOf("Comida", "Transporte", "Salario")
for (categoria in categorias) {
    println(categoria)
}

// for con índice y valor
for ((indice, categoria) in categorias.withIndex()) {
    println("$indice: $categoria")
}

// while
var intentos = 3
while (intentos > 0) {
    println("Intentos restantes: $intentos")
    intentos--  // decrementa en 1
}
```

---

## 2.6 Colecciones básicas

```kotlin
// Lista inmutable (no se pueden agregar/quitar elementos)
val meses = listOf("Enero", "Febrero", "Marzo")
println(meses[0])       // "Enero" (acceso por índice)
println(meses.size)     // 3

// Lista mutable (se pueden modificar)
val gastos = mutableListOf(50000.0, 30000.0, 15000.0)
gastos.add(25000.0)          // agregar al final
gastos.removeAt(0)           // quitar el primero
gastos[0] = 35000.0          // modificar por índice

// Operaciones funcionales sobre listas (muy usadas en Kotlin)
val numeros = listOf(10000.0, 50000.0, 30000.0, 80000.0, 20000.0)

// filter: filtra elementos que cumplan una condición
val grandes = numeros.filter { it > 25000.0 }  // [50000.0, 30000.0, 80000.0]
// "it" es el nombre por defecto del parámetro en lambdas de un solo parámetro

// map: transforma cada elemento
val formateados = numeros.map { "COP ${it}" }  // ["COP 10000.0", "COP 50000.0", ...]

// sum: suma todos los elementos
val total = numeros.sum()  // 190000.0

// sortedBy: ordena por un criterio
val ordenados = numeros.sortedBy { it }            // ascendente
val ordenadosDesc = numeros.sortedByDescending { it }  // descendente

// Encadenar operaciones
val totalGrandes = numeros
    .filter { it > 25000.0 }  // solo los mayores a 25000
    .sum()                      // sumar esos
// Resultado: 160000.0
```

---

## 2.7 Aplicar al proyecto: Cálculo de balance

Ahora vamos a usar lo aprendido en MisFinanzas. Vamos a hacer que la app muestre un balance calculado.

✏️ Modificar `activity_main.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- activity_main.xml -->
<!-- Pantalla principal de MisFinanzas con resumen de balance -->
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="24dp">

    <!-- Título de la app -->
    <TextView
        android:id="@+id/tvTitulo"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="MisFinanzas"
        android:textSize="28sp"
        android:textStyle="bold"
        android:textColor="#1B5E20" />

    <!-- Texto que muestra el balance total -->
    <TextView
        android:id="@+id/tvBalance"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Balance: $0"
        android:textSize="22sp"
        android:layout_marginTop="16dp" />

    <!-- Texto que muestra el total de ingresos -->
    <TextView
        android:id="@+id/tvIngresos"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Ingresos: $0"
        android:textSize="16sp"
        android:textColor="#2E7D32"
        android:layout_marginTop="12dp" />

    <!-- Texto que muestra el total de gastos -->
    <TextView
        android:id="@+id/tvGastos"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Gastos: $0"
        android:textSize="16sp"
        android:textColor="#C62828"
        android:layout_marginTop="4dp" />

    <!-- Texto que muestra el número de transacciones -->
    <TextView
        android:id="@+id/tvNumTransacciones"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="0 transacciones"
        android:textSize="14sp"
        android:textColor="#999999"
        android:layout_marginTop="8dp" />

</LinearLayout>
```

✏️ Modificar `MainActivity.kt`:

```kotlin
// MainActivity.kt
// Pantalla principal que muestra el resumen financiero
package com.ejemplo.misfinanzas

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.ejemplo.misfinanzas.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    // Variable para acceder a las vistas del layout
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Datos de ejemplo: lista de montos
        // Los positivos son ingresos, los negativos son gastos
        val transacciones = listOf(
            2500000.0,   // Salario
            -150000.0,   // Comida
            -80000.0,    // Transporte
            -200000.0,   // Servicios
            500000.0,    // Freelance
            -50000.0     // Entretenimiento
        )

        // Calcular el balance usando las funciones que definimos abajo
        val ingresos = calcularIngresos(transacciones)
        val gastos = calcularGastos(transacciones)
        val balance = calcularBalance(transacciones)

        // Actualizar la interfaz con los valores calculados
        // Usamos string templates para insertar los valores en el texto
        binding.tvBalance.text = "Balance: ${formatearMonto(balance)}"
        binding.tvIngresos.text = "Ingresos: ${formatearMonto(ingresos)}"
        binding.tvGastos.text = "Gastos: ${formatearMonto(gastos)}"
        binding.tvNumTransacciones.text = "${transacciones.size} transacciones"

        // Cambiar el color del balance según si es positivo o negativo
        // El método getColor obtiene un color definido en los recursos de Android
        if (balance >= 0) {
            binding.tvBalance.setTextColor(getColor(android.R.color.holo_green_dark))
        } else {
            binding.tvBalance.setTextColor(getColor(android.R.color.holo_red_dark))
        }
    }

    // Función que calcula el total de ingresos (montos positivos)
    // "filter" filtra la lista dejando solo los que cumplen la condición
    // "sum" suma todos los elementos de la lista resultante
    private fun calcularIngresos(transacciones: List<Double>): Double {
        return transacciones.filter { it > 0 }.sum()
    }

    // Función que calcula el total de gastos (montos negativos)
    // Usamos Math.abs para obtener el valor absoluto (sin el signo negativo)
    private fun calcularGastos(transacciones: List<Double>): Double {
        return Math.abs(transacciones.filter { it < 0 }.sum())
    }

    // Función que calcula el balance total (suma de todo)
    private fun calcularBalance(transacciones: List<Double>): Double {
        return transacciones.sum()
    }

    // Función que formatea un número como moneda colombiana
    // String.format con "%,.0f" agrega separadores de miles y sin decimales
    private fun formatearMonto(monto: Double): String {
        return "$ ${String.format("%,.0f", monto)}"
    }
}
```

---

## 2.8 Compilar y probar

▶️ Compilar y ejecutar. Deberían ver:

```
MisFinanzas
Balance: $ 2,520,000
Ingresos: $ 3,000,000
Gastos: $ 480,000
6 transacciones
```

El balance aparece en verde porque es positivo. Si cambian los montos para que el balance sea negativo, aparecerá en rojo.

---

## Resumen de conceptos

| Concepto | Ejemplo | Para qué lo usamos |
|----------|---------|---------------------|
| `val` / `var` | `val nombre = "Juan"` | Declarar variables |
| Tipos | `Int`, `Double`, `String`, `Boolean` | Definir qué tipo de dato guarda |
| Null safety | `String?`, `?.`, `?:` | Evitar crashes por valores nulos |
| Funciones | `fun sumar(a: Double, b: Double): Double` | Reutilizar lógica |
| `if` / `when` | `if (x > 0) "positivo" else "negativo"` | Tomar decisiones |
| Listas | `listOf()`, `mutableListOf()` | Guardar colecciones de datos |
| `filter` / `map` / `sum` | `lista.filter { it > 0 }.sum()` | Operar sobre listas |
| String templates | `"Balance: $balance"` | Insertar valores en texto |

---

**Anterior:** [← Capítulo 1 — Proyecto base](01_proyecto_base.md) | **Siguiente:** [Capítulo 3 — Layouts y vistas →](03_layouts_vistas.md)
