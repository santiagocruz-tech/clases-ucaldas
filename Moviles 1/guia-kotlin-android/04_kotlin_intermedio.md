# Capítulo 4: Kotlin intermedio — Clases, data classes y enums

## Objetivo

Aprender programación orientada a objetos en Kotlin para crear el modelo de datos de MisFinanzas. Al final de este capítulo tendremos una clase `Transaccion` que representa cada ingreso o gasto.

---

## 4.1 Clases en Kotlin

Una clase agrupa datos y comportamiento. En Kotlin se declaran con `class`:

```kotlin
// Clase básica con propiedades en el constructor primario
// Las propiedades se declaran directamente en los paréntesis del constructor
// "val" = propiedad de solo lectura, "var" = propiedad modificable
class Cuenta(
    val nombre: String,       // propiedad inmutable
    var balance: Double       // propiedad mutable
) {
    // Función dentro de la clase (método)
    // Puede acceder a las propiedades de la clase directamente
    fun depositar(monto: Double) {
        balance += monto  // modifica la propiedad "balance"
    }

    // Función que retorna un String formateado
    fun resumen(): String {
        return "$nombre: $$balance"
    }
}

// Crear una instancia (no se usa "new" en Kotlin)
val miCuenta = Cuenta("Ahorros", 1000000.0)
miCuenta.depositar(500000.0)
println(miCuenta.resumen())  // "Ahorros: $1500000.0"
```

### Valores por defecto en el constructor

```kotlin
// Los parámetros pueden tener valores por defecto
// Si no se pasan al crear la instancia, se usan los valores por defecto
class Transaccion(
    val monto: Double,
    val descripcion: String,
    val categoria: String = "General",  // valor por defecto: "General"
    val fecha: Long = System.currentTimeMillis()  // valor por defecto: fecha actual
)

// Se puede crear con todos los parámetros
val t1 = Transaccion(50000.0, "Almuerzo", "Comida")

// O solo con los obligatorios (los opcionales usan su valor por defecto)
val t2 = Transaccion(2500000.0, "Salario")

// También se pueden usar parámetros nombrados para mayor claridad
val t3 = Transaccion(
    monto = -80000.0,
    descripcion = "Uber",
    categoria = "Transporte"
)
```

---

## 4.2 Data Classes

Las data classes son clases diseñadas para guardar datos. Kotlin genera automáticamente `toString()`, `equals()`, `hashCode()` y `copy()`:

```kotlin
// "data class" genera automáticamente:
// - toString(): representación legible → "Transaccion(monto=-15000.0, descripcion=Almuerzo, ...)"
// - equals(): compara por contenido, no por referencia
// - hashCode(): para usar en colecciones como HashMap
// - copy(): crea una copia con la posibilidad de cambiar algunos campos
data class Transaccion(
    val id: Int,                // identificador único
    val monto: Double,          // positivo = ingreso, negativo = gasto
    val descripcion: String,    // nombre de la transacción
    val categoria: String,      // categoría (comida, transporte, etc.)
    val fecha: Long = System.currentTimeMillis()  // timestamp de creación
)

// Crear instancias
val t1 = Transaccion(1, -15000.0, "Almuerzo", "Comida")
val t2 = Transaccion(2, 2500000.0, "Salario mensual", "Salario")

// toString() se genera automáticamente
println(t1)  // Transaccion(id=1, monto=-15000.0, descripcion=Almuerzo, ...)

// equals() compara por contenido
val t3 = Transaccion(1, -15000.0, "Almuerzo", "Comida")
println(t1 == t3)  // true (mismo contenido)

// copy() crea una copia, opcionalmente cambiando algunos campos
// Útil porque las data classes son inmutables (val)
val t4 = t1.copy(monto = -20000.0)  // copia de t1 pero con monto diferente
println(t4)  // Transaccion(id=1, monto=-20000.0, descripcion=Almuerzo, ...)
```

💡 **¿Por qué data class y no class normal?** Porque para modelos de datos (como una transacción, un usuario, un producto) necesitamos comparar por contenido, imprimir de forma legible y copiar con cambios. Con `data class` todo eso viene gratis.

---

## 4.3 Enums

Los enums representan un conjunto fijo de opciones. Son perfectos para las categorías de MisFinanzas:

```kotlin
// "enum class" define un conjunto cerrado de valores posibles
// Cada valor es una instancia única del enum
enum class Categoria(
    val emoji: String,       // cada categoría tiene un emoji asociado
    val etiqueta: String     // y una etiqueta legible
) {
    // Cada línea es un valor posible del enum
    // Se definen con los parámetros del constructor
    COMIDA("🍔", "Comida"),
    TRANSPORTE("🚗", "Transporte"),
    SALARIO("💰", "Salario"),
    ENTRETENIMIENTO("🎮", "Entretenimiento"),
    SERVICIOS("🏠", "Servicios"),
    SALUD("🏥", "Salud"),
    EDUCACION("📚", "Educación"),
    FREELANCE("💻", "Freelance"),
    OTROS("📦", "Otros");

    // Función que determina si esta categoría es un ingreso
    // Solo SALARIO y FREELANCE son ingresos, el resto son gastos
    fun esIngreso(): Boolean {
        return this == SALARIO || this == FREELANCE
    }
}

// Uso del enum
val cat = Categoria.COMIDA
println(cat.emoji)      // "🍔"
println(cat.etiqueta)   // "Comida"
println(cat.esIngreso()) // false

// Iterar sobre todos los valores del enum
// .values() retorna un array con todos los valores
for (c in Categoria.values()) {
    println("${c.emoji} ${c.etiqueta}")
}

// Usar enum en un when (el compilador verifica que cubras todos los casos)
fun obtenerColor(categoria: Categoria): String {
    return when (categoria) {
        Categoria.SALARIO, Categoria.FREELANCE -> "#2E7D32"  // verde para ingresos
        Categoria.COMIDA -> "#E65100"       // naranja
        Categoria.TRANSPORTE -> "#1565C0"   // azul
        Categoria.SERVICIOS -> "#6A1B9A"    // morado
        Categoria.SALUD -> "#C62828"        // rojo
        Categoria.EDUCACION -> "#00838F"    // teal
        Categoria.ENTRETENIMIENTO -> "#AD1457"  // rosa
        Categoria.OTROS -> "#546E7A"        // gris azulado
    }
}
```

---

## 4.4 Herencia e interfaces

### Herencia

En Kotlin las clases son `final` por defecto (no se pueden heredar). Para permitir herencia hay que marcarlas como `open`:

```kotlin
// "open" permite que otras clases hereden de esta
// Sin "open", la clase es final y no se puede heredar
open class Movimiento(
    val monto: Double,
    val descripcion: String
) {
    // "open" en una función permite que las subclases la sobreescriban
    open fun resumen(): String {
        return "$descripcion: $$monto"
    }
}

// Ingreso hereda de Movimiento usando ":"
// Llama al constructor del padre con los parámetros necesarios
class Ingreso(
    monto: Double,           // sin val/var porque no es propiedad nueva
    descripcion: String,
    val fuente: String       // propiedad nueva exclusiva de Ingreso
) : Movimiento(monto, descripcion) {

    // "override" indica que estamos reemplazando la función del padre
    override fun resumen(): String {
        return "✅ $descripcion ($fuente): +$$monto"
    }
}

// Gasto también hereda de Movimiento
class Gasto(
    monto: Double,
    descripcion: String,
    val categoria: String
) : Movimiento(monto, descripcion) {

    override fun resumen(): String {
        return "❌ $descripcion ($categoria): -$$monto"
    }
}

// Uso: polimorfismo — una lista puede contener Ingresos y Gastos
val movimientos: List<Movimiento> = listOf(
    Ingreso(2500000.0, "Salario", "Empresa"),
    Gasto(150000.0, "Almuerzo", "Comida"),
    Gasto(80000.0, "Uber", "Transporte")
)

// Al llamar resumen(), cada objeto usa SU versión de la función
for (m in movimientos) {
    println(m.resumen())
}
```

### Interfaces

Las interfaces definen un contrato: qué funciones debe tener una clase, sin decir cómo implementarlas:

```kotlin
// Una interfaz define funciones que las clases deben implementar
// Puede tener funciones con implementación por defecto
interface Formateador {
    // Función abstracta: las clases que implementen esta interfaz
    // DEBEN proporcionar una implementación
    fun formatear(monto: Double): String

    // Función con implementación por defecto: las clases PUEDEN sobreescribirla
    // pero no están obligadas
    fun formatearConSigno(monto: Double): String {
        val signo = if (monto >= 0) "+" else ""
        return "$signo${formatear(monto)}"
    }
}

// Una clase implementa una interfaz usando ":"
// (igual que la herencia, pero las interfaces no tienen constructor)
class FormateadorCOP : Formateador {
    // Implementación obligatoria de formatear()
    override fun formatear(monto: Double): String {
        return "COP ${String.format("%,.0f", monto)}"
    }
}

class FormateadorUSD : Formateador {
    override fun formatear(monto: Double): String {
        return "USD ${String.format("%,.2f", monto)}"
    }
}

// Uso
val formateador: Formateador = FormateadorCOP()
println(formateador.formatear(1500000.0))         // "COP 1,500,000"
println(formateador.formatearConSigno(-50000.0))   // "-COP 50,000"
```

---

## 4.5 Companion object y constantes

```kotlin
// companion object es un bloque estático dentro de una clase
// Contiene funciones y constantes que pertenecen a la clase, no a una instancia
class Transaccion(
    val id: Int,
    val monto: Double,
    val descripcion: String,
    val categoria: Categoria,
    val fecha: Long = System.currentTimeMillis()
) {
    // companion object contiene miembros "estáticos"
    // Se acceden con Transaccion.MAX_DESCRIPCION, sin crear una instancia
    companion object {
        // Constantes de la clase
        const val MAX_DESCRIPCION = 50   // largo máximo de la descripción
        const val MONTO_MINIMO = 100.0   // monto mínimo permitido

        // Función de fábrica: crea una transacción de ejemplo
        fun ejemplo(): Transaccion {
            return Transaccion(
                id = 0,
                monto = -15000.0,
                descripcion = "Almuerzo",
                categoria = Categoria.COMIDA
            )
        }
    }

    // Función que determina si es ingreso o gasto
    fun esIngreso(): Boolean = monto > 0
}

// Uso del companion object
println(Transaccion.MAX_DESCRIPCION)  // 50
val ejemplo = Transaccion.ejemplo()    // crea una transacción de ejemplo
```

---

## 4.6 Aplicar al proyecto: Modelo de datos de MisFinanzas

Vamos a crear los archivos del modelo de datos que usaremos en toda la app.

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/Categoria.kt`:

```kotlin
// Categoria.kt
// Enum que define las categorías posibles para las transacciones
package com.ejemplo.misfinanzas

// Cada categoría tiene un emoji y una etiqueta legible
enum class Categoria(
    val emoji: String,
    val etiqueta: String
) {
    COMIDA("🍔", "Comida"),
    TRANSPORTE("🚗", "Transporte"),
    SALARIO("💰", "Salario"),
    ENTRETENIMIENTO("🎮", "Entretenimiento"),
    SERVICIOS("🏠", "Servicios"),
    SALUD("🏥", "Salud"),
    EDUCACION("📚", "Educación"),
    FREELANCE("💻", "Freelance"),
    OTROS("📦", "Otros");

    // Retorna true si esta categoría representa un ingreso
    fun esIngreso(): Boolean {
        return this == SALARIO || this == FREELANCE
    }
}
```

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/Transaccion.kt`:

```kotlin
// Transaccion.kt
// Data class que representa una transacción financiera (ingreso o gasto)
package com.ejemplo.misfinanzas

// Importamos Serializable para poder pasar transacciones entre pantallas
import java.io.Serializable

// data class genera automáticamente toString(), equals(), hashCode() y copy()
// Implementa Serializable para poder enviarla con Intent.putExtra()
data class Transaccion(
    val id: Int,                    // identificador único
    val monto: Double,              // positivo = ingreso, negativo = gasto
    val descripcion: String,        // nombre descriptivo
    val categoria: Categoria,       // categoría del enum
    val fecha: Long = System.currentTimeMillis()  // timestamp de creación
) : Serializable {

    // Retorna true si el monto es positivo (ingreso)
    fun esIngreso(): Boolean = monto > 0

    // Retorna el monto formateado como moneda colombiana
    fun montoFormateado(): String {
        val signo = if (esIngreso()) "+" else ""
        return "$signo$ ${String.format("%,.0f", monto)}"
    }

    // Constantes y funciones de fábrica
    companion object {
        // Genera datos de ejemplo para desarrollo y pruebas
        fun datosDePrueba(): List<Transaccion> {
            return listOf(
                Transaccion(1, 2500000.0, "Salario mensual", Categoria.SALARIO),
                Transaccion(2, -150000.0, "Almuerzo restaurante", Categoria.COMIDA),
                Transaccion(3, -80000.0, "Uber al trabajo", Categoria.TRANSPORTE),
                Transaccion(4, -200000.0, "Recibo de luz", Categoria.SERVICIOS),
                Transaccion(5, 500000.0, "Proyecto web", Categoria.FREELANCE),
                Transaccion(6, -50000.0, "Netflix", Categoria.ENTRETENIMIENTO),
                Transaccion(7, -35000.0, "Medicinas", Categoria.SALUD),
                Transaccion(8, -120000.0, "Mercado", Categoria.COMIDA)
            )
        }
    }
}
```

✏️ Modificar `MainActivity.kt` para usar el nuevo modelo:

```kotlin
// MainActivity.kt
// Pantalla principal usando el modelo de datos Transaccion
package com.ejemplo.misfinanzas

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import com.ejemplo.misfinanzas.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Ahora usamos el modelo Transaccion en lugar de una lista de Doubles
        val transacciones = Transaccion.datosDePrueba()

        // Calcular totales usando las funciones del modelo
        // filter + sumOf es más expresivo que trabajar con Doubles sueltos
        val ingresos = transacciones.filter { it.esIngreso() }.sumOf { it.monto }
        val gastos = transacciones.filter { !it.esIngreso() }.sumOf { Math.abs(it.monto) }
        val balance = transacciones.sumOf { it.monto }

        // Actualizar la interfaz
        binding.tvBalance.text = formatearMonto(balance)
        binding.tvIngresos.text = formatearMonto(ingresos)
        binding.tvGastos.text = formatearMonto(gastos)
        binding.tvNumTransacciones.text = "${transacciones.size}"

        // Mostrar la primera transacción en la tarjeta de ejemplo
        // .firstOrNull() retorna null si la lista está vacía (seguro)
        val primera = transacciones.firstOrNull()
        if (primera != null) {
            binding.tvEmojiEjemplo.text = primera.categoria.emoji
            binding.tvNombreEjemplo.text = primera.descripcion
            binding.tvCategoriaEjemplo.text = primera.categoria.etiqueta
            binding.tvMontoEjemplo.text = primera.montoFormateado()
        }

        // Botón de agregar (por ahora solo muestra un Toast)
        binding.btnAgregar.setOnClickListener {
            Toast.makeText(this, "Próximamente", Toast.LENGTH_SHORT).show()
        }
    }

    // Formatea un número como moneda colombiana
    private fun formatearMonto(monto: Double): String {
        return "$ ${String.format("%,.0f", monto)}"
    }
}
```

---

## 4.7 Compilar y probar

▶️ Compilar y ejecutar. La app debería verse igual que antes, pero ahora el código está mejor organizado con clases propias. La tarjeta de ejemplo muestra los datos de la primera transacción con emoji y categoría.

---

## Resumen de conceptos

| Concepto | Para qué | Ejemplo |
|----------|----------|---------|
| `class` | Agrupar datos y comportamiento | `class Cuenta(val nombre: String)` |
| `data class` | Modelo de datos con toString/equals/copy | `data class Transaccion(...)` |
| `enum class` | Conjunto fijo de opciones | `enum class Categoria { COMIDA, ... }` |
| Herencia (`open`, `override`) | Reutilizar y especializar comportamiento | `class Gasto : Movimiento()` |
| Interfaces | Definir contratos | `interface Formateador { ... }` |
| `companion object` | Constantes y funciones estáticas | `Transaccion.datosDePrueba()` |
| `Serializable` | Pasar objetos entre pantallas | `data class X(...) : Serializable` |

---

**Anterior:** [← Capítulo 3 — Layouts y vistas](03_layouts_vistas.md) | **Siguiente:** [Capítulo 5 — Listas con RecyclerView →](05_listas_recyclerview.md)
