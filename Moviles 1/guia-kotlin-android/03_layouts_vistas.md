# Capítulo 3: Layouts y vistas — Diseñando la interfaz

## Objetivo

Aprender a diseñar interfaces en Android usando XML. Vamos a mejorar la pantalla principal de MisFinanzas con un diseño más profesional usando LinearLayout, ConstraintLayout, CardView y recursos de valores.

---

## 3.1 ¿Cómo funciona la UI en Android?

En Android la interfaz se define en archivos XML dentro de `res/layout/`. Cada archivo XML tiene un **contenedor raíz** (layout) que organiza a sus hijos (vistas).

Las vistas más comunes:

| Vista | Para qué sirve | Equivalente en Flutter |
|-------|----------------|----------------------|
| `TextView` | Mostrar texto | `Text()` |
| `EditText` | Campo de texto editable | `TextField()` |
| `Button` | Botón | `ElevatedButton()` |
| `ImageView` | Mostrar imagen | `Image()` |
| `RecyclerView` | Lista eficiente | `ListView.builder()` |

Los layouts (contenedores) más comunes:

| Layout | Cómo organiza | Equivalente en Flutter |
|--------|--------------|----------------------|
| `LinearLayout` | En fila o columna | `Column()` / `Row()` |
| `ConstraintLayout` | Con restricciones relativas | No hay directo (similar a `Stack` con posiciones) |
| `FrameLayout` | Apila uno sobre otro | `Stack()` |
| `ScrollView` | Permite scroll | `SingleChildScrollView()` |

---

## 3.2 Unidades de medida

Esto es importante y genera confusión al principio:

| Unidad | Para qué | Ejemplo |
|--------|----------|---------|
| `dp` | Dimensiones de vistas (independiente de densidad de pantalla) | `android:padding="16dp"` |
| `sp` | Tamaño de texto (respeta preferencias de accesibilidad del usuario) | `android:textSize="16sp"` |
| `match_parent` | Ocupa todo el espacio del padre | `android:layout_width="match_parent"` |
| `wrap_content` | Solo el espacio que necesita el contenido | `android:layout_height="wrap_content"` |

💡 Siempre usen `sp` para texto y `dp` para todo lo demás. Nunca usen `px` (píxeles absolutos) porque se ve diferente en cada pantalla.

---

## 3.3 LinearLayout a fondo

Ya lo usamos en el capítulo anterior. Organiza sus hijos en una dirección: vertical u horizontal.

### layout_weight: distribuir espacio proporcionalmente

```xml
<!-- Ejemplo: campo de búsqueda con botón al lado -->
<!-- LinearLayout horizontal con un EditText que ocupa todo el espacio sobrante -->
<LinearLayout
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="horizontal">
    <!-- orientation="horizontal" = los hijos van de izquierda a derecha -->

    <!-- El EditText usa layout_weight="1" para ocupar todo el espacio disponible -->
    <!-- layout_width="0dp" es obligatorio cuando se usa layout_weight -->
    <!-- El "0dp" le dice al sistema: "no calcules mi ancho, déjalo al weight" -->
    <EditText
        android:id="@+id/etBuscar"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_weight="1"
        android:hint="Buscar transacción..." />

    <!-- El botón usa wrap_content: solo ocupa lo que necesita su texto -->
    <Button
        android:id="@+id/btnBuscar"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Buscar" />
</LinearLayout>
```

---

## 3.4 ConstraintLayout

Es el layout más flexible. Posiciona las vistas con restricciones relativas a los bordes del padre o a otras vistas. Cada vista necesita al menos una restricción horizontal y una vertical.

```xml
<!-- ConstraintLayout: cada vista se posiciona con restricciones -->
<!-- Necesita el namespace "app" para los atributos de constraint -->
<androidx.constraintlayout.widget.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:padding="16dp">

    <!-- Este TextView está anclado al borde superior y a ambos lados del padre -->
    <!-- constraintTop_toTopOf="parent" = mi borde superior va pegado al borde superior del padre -->
    <!-- constraintStart_toStartOf="parent" = mi borde izquierdo va pegado al izquierdo del padre -->
    <!-- constraintEnd_toEndOf="parent" = mi borde derecho va pegado al derecho del padre -->
    <!-- Con width="0dp" + restricciones en ambos lados, se estira para llenar -->
    <TextView
        android:id="@+id/tvTitulo"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:text="MisFinanzas"
        android:textSize="28sp"
        android:textStyle="bold"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent" />

    <!-- Este TextView va debajo del título -->
    <!-- constraintTop_toBottomOf="@id/tvTitulo" = mi borde superior va pegado -->
    <!-- al borde inferior de tvTitulo -->
    <TextView
        android:id="@+id/tvBalance"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:text="Balance: $0"
        android:textSize="22sp"
        android:layout_marginTop="16dp"
        app:layout_constraintTop_toBottomOf="@id/tvTitulo"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

💡 Android Studio tiene un editor visual para ConstraintLayout (pestaña **Design**) donde pueden arrastrar vistas y conectarlas con el mouse. Si usan IntelliJ o VS Code, escriban el XML directamente.

---

## 3.5 CardView

Las tarjetas con sombra y bordes redondeados son muy comunes en apps modernas. Se usan con `MaterialCardView`:

```xml
<!-- MaterialCardView: tarjeta con sombra y bordes redondeados -->
<!-- cardCornerRadius = radio de las esquinas redondeadas -->
<!-- cardElevation = altura de la sombra (más alto = sombra más grande) -->
<com.google.android.material.card.MaterialCardView
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_margin="8dp"
    app:cardCornerRadius="12dp"
    app:cardElevation="4dp">

    <!-- Dentro de la tarjeta va el contenido -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="16dp">

        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Título"
            android:textSize="18sp"
            android:textStyle="bold" />

        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Descripción de la tarjeta"
            android:layout_marginTop="8dp"
            android:textColor="#666666" />
    </LinearLayout>
</com.google.android.material.card.MaterialCardView>
```

---

## 3.6 ScrollView

Cuando el contenido no cabe en pantalla, se envuelve en un ScrollView:

```xml
<!-- ScrollView permite hacer scroll vertical -->
<!-- Solo puede tener UN hijo directo (normalmente un LinearLayout) -->
<ScrollView
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <!-- Todo el contenido va dentro de este LinearLayout -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="16dp">

        <!-- Aquí van todas las vistas -->
        <!-- El ScrollView se encarga de que se pueda desplazar -->

    </LinearLayout>
</ScrollView>
```

---

## 3.7 Recursos en values/

Los colores, strings y dimensiones se definen en archivos XML dentro de `res/values/`. Esto permite cambiarlos en un solo lugar y reutilizarlos.

📁 Crear o modificar `app/src/main/res/values/colors.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- colors.xml -->
<!-- Definimos los colores de la app en un solo lugar -->
<!-- Así si queremos cambiar un color, lo hacemos aquí y se actualiza en toda la app -->
<resources>
    <!-- Colores principales de MisFinanzas -->
    <color name="verde_primario">#1B5E20</color>    <!-- verde oscuro para el tema -->
    <color name="verde_claro">#4CAF50</color>        <!-- verde claro para ingresos -->
    <color name="rojo_gasto">#C62828</color>          <!-- rojo para gastos -->
    <color name="gris_texto">#666666</color>          <!-- gris para texto secundario -->
    <color name="gris_claro">#F5F5F5</color>          <!-- gris claro para fondos -->
    <color name="blanco">#FFFFFF</color>               <!-- blanco -->
    <color name="negro_texto">#212121</color>          <!-- negro para texto principal -->
</resources>
```

📁 Crear o modificar `app/src/main/res/values/strings.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- strings.xml -->
<!-- Todos los textos de la app van aquí -->
<!-- Esto facilita traducir la app a otros idiomas en el futuro -->
<resources>
    <string name="app_name">MisFinanzas</string>
    <string name="titulo_balance">Balance</string>
    <string name="titulo_ingresos">Ingresos</string>
    <string name="titulo_gastos">Gastos</string>
    <string name="sin_transacciones">No hay transacciones</string>
    <string name="formato_transacciones">%d transacciones</string>
</resources>
```

Para usar estos recursos en XML:

```xml
<!-- En lugar de escribir el texto directamente: -->
<TextView android:text="MisFinanzas" />

<!-- Se referencia el recurso con @string/ o @color/ -->
<TextView
    android:text="@string/app_name"
    android:textColor="@color/verde_primario" />
```

Para usarlos desde Kotlin:

```kotlin
// getString() obtiene un string de los recursos
binding.tvTitulo.text = getString(R.string.app_name)

// getColor() obtiene un color de los recursos
binding.tvBalance.setTextColor(getColor(R.color.verde_primario))
```

---

## 3.8 Vistas comunes desde Kotlin

### Controlar visibilidad

```kotlin
// VISIBLE = se ve y ocupa espacio
binding.tvError.visibility = View.VISIBLE

// INVISIBLE = no se ve pero SÍ ocupa espacio (deja un hueco)
binding.tvError.visibility = View.INVISIBLE

// GONE = no se ve y NO ocupa espacio (como si no existiera)
binding.tvError.visibility = View.GONE
```

### Botones y clicks

```kotlin
// Escuchar click en un botón
// setOnClickListener recibe una lambda que se ejecuta al hacer click
binding.btnAgregar.setOnClickListener {
    // Código que se ejecuta al presionar el botón
    agregarTransaccion()
}

// Habilitar o deshabilitar un botón
// Cuando está deshabilitado, se ve gris y no responde a clicks
binding.btnGuardar.isEnabled = false
```

### Obtener texto de un EditText

```kotlin
// .text devuelve un Editable, hay que convertirlo a String con .toString()
// .trim() elimina espacios al inicio y al final
val monto = binding.etMonto.text.toString().trim()

// Verificar si está vacío
if (monto.isEmpty()) {
    // Mostrar error
}
```

### Toast: mensaje breve

```kotlin
// Toast muestra un mensaje pequeño que desaparece solo
// LENGTH_SHORT = ~2 segundos, LENGTH_LONG = ~3.5 segundos
// "this" se refiere a la Activity actual (el contexto)
Toast.makeText(this, "Transacción guardada", Toast.LENGTH_SHORT).show()
```

---

## 3.9 Aplicar al proyecto: Pantalla principal mejorada

Vamos a rediseñar la pantalla principal de MisFinanzas con tarjetas, mejor organización y un botón para agregar transacciones.

✏️ Modificar `app/src/main/res/layout/activity_main.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- activity_main.xml -->
<!-- Pantalla principal de MisFinanzas con diseño mejorado -->
<!-- Usamos ScrollView por si el contenido crece más que la pantalla -->
<ScrollView
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/gris_claro">
    <!-- background = color de fondo de toda la pantalla -->

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="16dp">

        <!-- ===== ENCABEZADO ===== -->
        <!-- Título de la app -->
        <TextView
            android:id="@+id/tvTitulo"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="@string/app_name"
            android:textSize="28sp"
            android:textStyle="bold"
            android:textColor="@color/verde_primario" />

        <!-- ===== TARJETA DE BALANCE ===== -->
        <!-- MaterialCardView crea una tarjeta con sombra y bordes redondeados -->
        <com.google.android.material.card.MaterialCardView
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginTop="16dp"
            app:cardCornerRadius="16dp"
            app:cardElevation="4dp"
            app:cardBackgroundColor="@color/verde_primario">
            <!-- cardBackgroundColor = color de fondo de la tarjeta -->

            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="vertical"
                android:padding="20dp">

                <!-- Etiqueta "Balance total" en blanco -->
                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="Balance total"
                    android:textSize="14sp"
                    android:textColor="#B9F6CA" />
                <!-- #B9F6CA = verde muy claro, para contraste sobre fondo verde oscuro -->

                <!-- Monto del balance, grande y en blanco -->
                <TextView
                    android:id="@+id/tvBalance"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="$ 0"
                    android:textSize="32sp"
                    android:textStyle="bold"
                    android:textColor="@color/blanco"
                    android:layout_marginTop="4dp" />

                <!-- Fila con ingresos y gastos lado a lado -->
                <LinearLayout
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:orientation="horizontal"
                    android:layout_marginTop="16dp">

                    <!-- Columna de ingresos (ocupa la mitad) -->
                    <LinearLayout
                        android:layout_width="0dp"
                        android:layout_height="wrap_content"
                        android:layout_weight="1"
                        android:orientation="vertical">

                        <TextView
                            android:layout_width="wrap_content"
                            android:layout_height="wrap_content"
                            android:text="▲ Ingresos"
                            android:textSize="12sp"
                            android:textColor="#B9F6CA" />

                        <TextView
                            android:id="@+id/tvIngresos"
                            android:layout_width="wrap_content"
                            android:layout_height="wrap_content"
                            android:text="$ 0"
                            android:textSize="18sp"
                            android:textStyle="bold"
                            android:textColor="@color/blanco" />
                    </LinearLayout>

                    <!-- Columna de gastos (ocupa la otra mitad) -->
                    <LinearLayout
                        android:layout_width="0dp"
                        android:layout_height="wrap_content"
                        android:layout_weight="1"
                        android:orientation="vertical">

                        <TextView
                            android:layout_width="wrap_content"
                            android:layout_height="wrap_content"
                            android:text="▼ Gastos"
                            android:textSize="12sp"
                            android:textColor="#FFCDD2" />
                        <!-- #FFCDD2 = rojo claro para contraste -->

                        <TextView
                            android:id="@+id/tvGastos"
                            android:layout_width="wrap_content"
                            android:layout_height="wrap_content"
                            android:text="$ 0"
                            android:textSize="18sp"
                            android:textStyle="bold"
                            android:textColor="@color/blanco" />
                    </LinearLayout>
                </LinearLayout>
            </LinearLayout>
        </com.google.android.material.card.MaterialCardView>

        <!-- ===== SECCIÓN DE TRANSACCIONES ===== -->
        <!-- Fila con título y contador -->
        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="horizontal"
            android:layout_marginTop="24dp"
            android:gravity="center_vertical">
            <!-- gravity="center_vertical" = centra los hijos verticalmente -->

            <!-- Título "Transacciones recientes" ocupa el espacio sobrante -->
            <TextView
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:text="Transacciones recientes"
                android:textSize="18sp"
                android:textStyle="bold"
                android:textColor="@color/negro_texto" />

            <!-- Contador de transacciones -->
            <TextView
                android:id="@+id/tvNumTransacciones"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="0"
                android:textSize="14sp"
                android:textColor="@color/gris_texto" />
        </LinearLayout>

        <!-- Tarjeta de ejemplo de transacción (después será un RecyclerView) -->
        <com.google.android.material.card.MaterialCardView
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginTop="12dp"
            app:cardCornerRadius="12dp"
            app:cardElevation="2dp">

            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="horizontal"
                android:padding="16dp"
                android:gravity="center_vertical">

                <!-- Emoji de categoría -->
                <TextView
                    android:id="@+id/tvEmojiEjemplo"
                    android:layout_width="40dp"
                    android:layout_height="40dp"
                    android:text="🍔"
                    android:textSize="24sp"
                    android:gravity="center"
                    android:background="@color/gris_claro" />

                <!-- Nombre y categoría -->
                <LinearLayout
                    android:layout_width="0dp"
                    android:layout_height="wrap_content"
                    android:layout_weight="1"
                    android:orientation="vertical"
                    android:layout_marginStart="12dp">
                    <!-- layout_marginStart = margen a la izquierda (en idiomas LTR) -->

                    <TextView
                        android:id="@+id/tvNombreEjemplo"
                        android:layout_width="wrap_content"
                        android:layout_height="wrap_content"
                        android:text="Almuerzo"
                        android:textSize="16sp"
                        android:textStyle="bold" />

                    <TextView
                        android:id="@+id/tvCategoriaEjemplo"
                        android:layout_width="wrap_content"
                        android:layout_height="wrap_content"
                        android:text="Comida"
                        android:textSize="12sp"
                        android:textColor="@color/gris_texto" />
                </LinearLayout>

                <!-- Monto alineado a la derecha -->
                <TextView
                    android:id="@+id/tvMontoEjemplo"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="-$ 15,000"
                    android:textSize="16sp"
                    android:textStyle="bold"
                    android:textColor="@color/rojo_gasto" />
            </LinearLayout>
        </com.google.android.material.card.MaterialCardView>

        <!-- ===== BOTÓN AGREGAR ===== -->
        <!-- Botón Material Design con ancho completo -->
        <Button
            android:id="@+id/btnAgregar"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="+ Agregar transacción"
            android:layout_marginTop="24dp"
            android:backgroundTint="@color/verde_primario"
            android:textColor="@color/blanco"
            android:padding="12dp" />
        <!-- backgroundTint = color de fondo del botón -->

    </LinearLayout>
</ScrollView>
```

✏️ Modificar `MainActivity.kt` para usar los nuevos elementos:

```kotlin
// MainActivity.kt
// Pantalla principal con diseño mejorado usando tarjetas
package com.ejemplo.misfinanzas

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
// Toast muestra mensajes breves en pantalla
import android.widget.Toast
import com.ejemplo.misfinanzas.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    // Variable para acceder a las vistas del layout
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Inflar el layout: convierte el XML en objetos visibles
        binding = ActivityMainBinding.inflate(layoutInflater)
        // Establecer el layout como contenido de la pantalla
        setContentView(binding.root)

        // Datos de ejemplo (después vendrán de una base de datos)
        val transacciones = listOf(
            2500000.0,   // Salario
            -150000.0,   // Comida
            -80000.0,    // Transporte
            -200000.0,   // Servicios
            500000.0,    // Freelance
            -50000.0     // Entretenimiento
        )

        // Calcular totales usando las funciones de abajo
        val ingresos = calcularIngresos(transacciones)
        val gastos = calcularGastos(transacciones)
        val balance = calcularBalance(transacciones)

        // Actualizar la interfaz con los valores calculados
        binding.tvBalance.text = formatearMonto(balance)
        binding.tvIngresos.text = formatearMonto(ingresos)
        binding.tvGastos.text = formatearMonto(gastos)
        binding.tvNumTransacciones.text = "${transacciones.size}"

        // Configurar el botón de agregar transacción
        // setOnClickListener define qué pasa cuando se presiona el botón
        binding.btnAgregar.setOnClickListener {
            // Por ahora solo mostramos un mensaje
            // Más adelante abrirá una nueva pantalla
            Toast.makeText(this, "Próximamente: agregar transacción", Toast.LENGTH_SHORT).show()
        }
    }

    // Función que suma solo los montos positivos (ingresos)
    private fun calcularIngresos(transacciones: List<Double>): Double {
        return transacciones.filter { it > 0 }.sum()
    }

    // Función que suma los montos negativos y devuelve el valor absoluto
    private fun calcularGastos(transacciones: List<Double>): Double {
        return Math.abs(transacciones.filter { it < 0 }.sum())
    }

    // Función que suma todos los montos (ingresos - gastos)
    private fun calcularBalance(transacciones: List<Double>): Double {
        return transacciones.sum()
    }

    // Función que formatea un número como moneda colombiana
    // "%,.0f" agrega separadores de miles y cero decimales
    private fun formatearMonto(monto: Double): String {
        return "$ ${String.format("%,.0f", monto)}"
    }
}
```

---

## 3.10 Compilar y probar

▶️ Compilar y ejecutar. Deberían ver:
- Una tarjeta verde con el balance total, ingresos y gastos
- Una sección de "Transacciones recientes" con una tarjeta de ejemplo
- Un botón "Agregar transacción" que muestra un Toast al presionarlo

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| `LinearLayout` | Organizar vistas en fila o columna |
| `ConstraintLayout` | Posicionar vistas con restricciones relativas |
| `MaterialCardView` | Tarjetas con sombra y bordes redondeados |
| `ScrollView` | Permitir scroll cuando el contenido no cabe |
| `layout_weight` | Distribuir espacio proporcionalmente |
| `colors.xml` / `strings.xml` | Centralizar colores y textos |
| `View.VISIBLE` / `GONE` | Controlar visibilidad de vistas |
| `setOnClickListener` | Responder a clicks |
| `Toast` | Mostrar mensajes breves |

---

**Anterior:** [← Capítulo 2 — Kotlin básico](02_kotlin_basico.md) | **Siguiente:** [Capítulo 4 — Kotlin intermedio →](04_kotlin_intermedio.md)
