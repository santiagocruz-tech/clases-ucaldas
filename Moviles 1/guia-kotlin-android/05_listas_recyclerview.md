# Capítulo 5: Listas con RecyclerView

## Objetivo

Mostrar la lista de transacciones de MisFinanzas usando RecyclerView, el componente estándar de Android para listas eficientes. Aprenderemos el patrón Adapter + ViewHolder.

---

## 5.1 ¿Qué es RecyclerView?

RecyclerView es el componente de Android para mostrar listas largas de forma eficiente. En lugar de crear una vista por cada elemento (lo cual consumiría mucha memoria), **recicla** las vistas que salen de pantalla y las reutiliza para los nuevos elementos que entran.

Es el equivalente al `ListView.builder()` de Flutter.

Para usarlo necesitamos tres piezas:
1. **El layout del item** — un XML que define cómo se ve cada elemento de la lista
2. **El Adapter** — una clase que conecta los datos con las vistas
3. **El RecyclerView** — el componente en el layout de la Activity

---

## 5.2 Layout del item

📁 Crear `app/src/main/res/layout/item_transaccion.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- item_transaccion.xml -->
<!-- Este layout define cómo se ve CADA elemento de la lista de transacciones -->
<!-- Se repite una vez por cada transacción en la lista -->
<com.google.android.material.card.MaterialCardView
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_marginHorizontal="16dp"
    android:layout_marginVertical="4dp"
    app:cardCornerRadius="12dp"
    app:cardElevation="2dp">
    <!-- layout_marginHorizontal = margen izquierdo y derecho -->
    <!-- layout_marginVertical = margen arriba y abajo -->

    <!-- Fila horizontal: emoji | nombre+categoría | monto -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="horizontal"
        android:padding="16dp"
        android:gravity="center_vertical">

        <!-- Emoji de la categoría dentro de un fondo circular -->
        <TextView
            android:id="@+id/tvEmoji"
            android:layout_width="44dp"
            android:layout_height="44dp"
            android:gravity="center"
            android:textSize="22sp"
            android:background="@color/gris_claro" />
        <!-- gravity="center" centra el emoji dentro del cuadro de 44x44 -->

        <!-- Columna central: descripción y categoría -->
        <LinearLayout
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:orientation="vertical"
            android:layout_marginStart="12dp">

            <!-- Nombre/descripción de la transacción -->
            <TextView
                android:id="@+id/tvDescripcion"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:textSize="16sp"
                android:textStyle="bold"
                android:textColor="@color/negro_texto"
                android:maxLines="1"
                android:ellipsize="end" />
            <!-- maxLines="1" = máximo una línea de texto -->
            <!-- ellipsize="end" = si no cabe, muestra "..." al final -->

            <!-- Nombre de la categoría -->
            <TextView
                android:id="@+id/tvCategoria"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:textSize="12sp"
                android:textColor="@color/gris_texto"
                android:layout_marginTop="2dp" />
        </LinearLayout>

        <!-- Monto alineado a la derecha -->
        <TextView
            android:id="@+id/tvMonto"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:textSize="16sp"
            android:textStyle="bold" />
        <!-- El color del monto se establece desde Kotlin (verde o rojo) -->

    </LinearLayout>
</com.google.android.material.card.MaterialCardView>
```

---

## 5.3 El Adapter

El Adapter es el puente entre los datos y las vistas. Tiene tres responsabilidades:
1. **Crear** las vistas (inflar el XML del item)
2. **Vincular** los datos a cada vista (poner el texto, color, etc.)
3. **Contar** cuántos elementos hay

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/TransaccionAdapter.kt`:

```kotlin
// TransaccionAdapter.kt
// Adapter que conecta la lista de transacciones con el RecyclerView
package com.ejemplo.misfinanzas

// LayoutInflater convierte XML en objetos View
import android.view.LayoutInflater
// ViewGroup es el contenedor padre donde se insertan las vistas
import android.view.ViewGroup
// RecyclerView es el componente de lista
import androidx.recyclerview.widget.RecyclerView
// Importamos el binding generado para el layout del item
import com.ejemplo.misfinanzas.databinding.ItemTransaccionBinding

// El Adapter recibe:
// - transacciones: la lista de datos a mostrar
// - onItemClick: una lambda que se ejecuta cuando el usuario toca un item
//   (recibe la Transaccion tocada como parámetro)
class TransaccionAdapter(
    private val transacciones: List<Transaccion>,
    private val onItemClick: (Transaccion) -> Unit
) : RecyclerView.Adapter<TransaccionAdapter.TransaccionViewHolder>() {
    // RecyclerView.Adapter requiere un tipo ViewHolder como parámetro genérico

    // ViewHolder: contenedor que guarda las referencias a las vistas de UN item
    // Evita llamar a findViewById repetidamente (optimización)
    // "inner class" puede acceder a los miembros de la clase externa
    inner class TransaccionViewHolder(
        val binding: ItemTransaccionBinding  // binding del layout item_transaccion.xml
    ) : RecyclerView.ViewHolder(binding.root)
    // RecyclerView.ViewHolder requiere la vista raíz como parámetro

    // onCreateViewHolder: se llama cuando RecyclerView necesita una vista NUEVA
    // Esto pasa pocas veces: solo crea las vistas visibles + unas pocas extra
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TransaccionViewHolder {
        // Inflar el XML del item: convierte item_transaccion.xml en objetos View
        // parent = el RecyclerView, false = no adjuntar al padre todavía
        val binding = ItemTransaccionBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        // Retornar un nuevo ViewHolder con el binding
        return TransaccionViewHolder(binding)
    }

    // onBindViewHolder: se llama para VINCULAR datos a una vista existente
    // Esto pasa cada vez que un item aparece en pantalla (incluyendo reciclados)
    // position = índice del elemento en la lista
    override fun onBindViewHolder(holder: TransaccionViewHolder, position: Int) {
        // Obtener la transacción correspondiente a esta posición
        val transaccion = transacciones[position]

        // Vincular los datos a las vistas del item
        // holder.binding da acceso a todos los elementos del XML por su id
        holder.binding.tvEmoji.text = transaccion.categoria.emoji
        holder.binding.tvDescripcion.text = transaccion.descripcion
        holder.binding.tvCategoria.text = transaccion.categoria.etiqueta
        holder.binding.tvMonto.text = transaccion.montoFormateado()

        // Cambiar el color del monto según si es ingreso (verde) o gasto (rojo)
        // itemView.context da acceso al contexto para obtener colores
        val colorMonto = if (transaccion.esIngreso()) {
            holder.itemView.context.getColor(R.color.verde_claro)
        } else {
            holder.itemView.context.getColor(R.color.rojo_gasto)
        }
        holder.binding.tvMonto.setTextColor(colorMonto)

        // Configurar el click en todo el item
        // Cuando el usuario toca la tarjeta, se ejecuta la lambda onItemClick
        holder.itemView.setOnClickListener {
            onItemClick(transaccion)
        }
    }

    // getItemCount: retorna el número total de elementos
    // RecyclerView lo usa para saber cuántos items hay
    override fun getItemCount(): Int = transacciones.size
}
```

---

## 5.4 Configurar el RecyclerView en el layout

✏️ Modificar `activity_main.xml` — reemplazar la tarjeta de ejemplo por un RecyclerView:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- activity_main.xml -->
<!-- Pantalla principal con lista de transacciones -->
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:background="@color/gris_claro">

    <!-- ===== TARJETA DE BALANCE (parte superior fija) ===== -->
    <com.google.android.material.card.MaterialCardView
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_margin="16dp"
        app:cardCornerRadius="16dp"
        app:cardElevation="4dp"
        app:cardBackgroundColor="@color/verde_primario">

        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="vertical"
            android:padding="20dp">

            <TextView
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="Balance total"
                android:textSize="14sp"
                android:textColor="#B9F6CA" />

            <TextView
                android:id="@+id/tvBalance"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="$ 0"
                android:textSize="32sp"
                android:textStyle="bold"
                android:textColor="@color/blanco"
                android:layout_marginTop="4dp" />

            <!-- Fila de ingresos y gastos -->
            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="horizontal"
                android:layout_marginTop="16dp">

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

    <!-- ===== ENCABEZADO DE TRANSACCIONES ===== -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="horizontal"
        android:paddingHorizontal="16dp"
        android:gravity="center_vertical">

        <TextView
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:text="Transacciones"
            android:textSize="18sp"
            android:textStyle="bold"
            android:textColor="@color/negro_texto" />

        <TextView
            android:id="@+id/tvNumTransacciones"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:textSize="14sp"
            android:textColor="@color/gris_texto" />
    </LinearLayout>

    <!-- ===== LISTA DE TRANSACCIONES ===== -->
    <!-- RecyclerView muestra la lista de forma eficiente -->
    <!-- layout_weight="1" hace que ocupe todo el espacio restante -->
    <androidx.recyclerview.widget.RecyclerView
        android:id="@+id/rvTransacciones"
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1"
        android:layout_marginTop="8dp"
        android:clipToPadding="false"
        android:paddingBottom="80dp" />
    <!-- clipToPadding="false" permite que el contenido se vea debajo del padding -->
    <!-- paddingBottom="80dp" deja espacio para el botón flotante -->

    <!-- ===== BOTÓN AGREGAR ===== -->
    <Button
        android:id="@+id/btnAgregar"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="+ Agregar transacción"
        android:layout_margin="16dp"
        android:backgroundTint="@color/verde_primario"
        android:textColor="@color/blanco"
        android:padding="12dp" />

</LinearLayout>
```

---

## 5.5 Conectar todo en la Activity

✏️ Modificar `MainActivity.kt`:

```kotlin
// MainActivity.kt
// Pantalla principal con RecyclerView para mostrar transacciones
package com.ejemplo.misfinanzas

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
// LinearLayoutManager organiza los items del RecyclerView en una lista vertical
import androidx.recyclerview.widget.LinearLayoutManager
import com.ejemplo.misfinanzas.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    // Guardamos la lista como propiedad para poder modificarla después
    private val transacciones = Transaccion.datosDePrueba().toMutableList()
    // Guardamos el adapter como propiedad para poder notificarle cambios
    private lateinit var adapter: TransaccionAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Configurar el RecyclerView
        configurarRecyclerView()

        // Actualizar los totales en la tarjeta de balance
        actualizarBalance()

        // Botón de agregar transacción
        binding.btnAgregar.setOnClickListener {
            Toast.makeText(this, "Próximamente: agregar transacción", Toast.LENGTH_SHORT).show()
        }
    }

    // Configura el RecyclerView con su adapter y layout manager
    private fun configurarRecyclerView() {
        // Crear el adapter pasándole los datos y la acción al hacer click
        adapter = TransaccionAdapter(transacciones) { transaccion ->
            // Esta lambda se ejecuta cuando el usuario toca una transacción
            Toast.makeText(
                this,
                "${transaccion.descripcion}: ${transaccion.montoFormateado()}",
                Toast.LENGTH_SHORT
            ).show()
        }

        // LinearLayoutManager organiza los items en una lista vertical
        // Es el equivalente a un ListView normal
        binding.rvTransacciones.layoutManager = LinearLayoutManager(this)

        // Asignar el adapter al RecyclerView
        // Esto conecta los datos con la vista
        binding.rvTransacciones.adapter = adapter
    }

    // Calcula y muestra los totales en la tarjeta de balance
    private fun actualizarBalance() {
        // sumOf aplica una transformación y suma los resultados
        val ingresos = transacciones.filter { it.esIngreso() }.sumOf { it.monto }
        val gastos = transacciones.filter { !it.esIngreso() }.sumOf { Math.abs(it.monto) }
        val balance = transacciones.sumOf { it.monto }

        // Actualizar las vistas
        binding.tvBalance.text = formatearMonto(balance)
        binding.tvIngresos.text = formatearMonto(ingresos)
        binding.tvGastos.text = formatearMonto(gastos)
        binding.tvNumTransacciones.text = "${transacciones.size}"
    }

    // Formatea un número como moneda colombiana
    private fun formatearMonto(monto: Double): String {
        return "$ ${String.format("%,.0f", monto)}"
    }
}
```

---

## 5.6 Compilar y probar

▶️ Compilar y ejecutar. Deberían ver:
- La tarjeta de balance arriba con los totales
- Una lista scrolleable de transacciones con emoji, descripción, categoría y monto
- Los montos en verde (ingresos) o rojo (gastos)
- Al tocar una transacción, aparece un Toast con su información

---

## 5.7 Extras: GridLayoutManager

Si quisieran mostrar los items en cuadrícula en lugar de lista:

```kotlin
// GridLayoutManager organiza los items en una cuadrícula
// El segundo parámetro es el número de columnas
// binding.rvTransacciones.layoutManager = GridLayoutManager(this, 2)
```

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| `RecyclerView` | Mostrar listas largas de forma eficiente |
| `Adapter` | Conectar datos con vistas (puente) |
| `ViewHolder` | Contenedor que guarda referencias a las vistas de un item |
| `onCreateViewHolder` | Crear vistas nuevas (se llama pocas veces) |
| `onBindViewHolder` | Vincular datos a una vista (se llama muchas veces) |
| `getItemCount` | Decirle al RecyclerView cuántos items hay |
| `LinearLayoutManager` | Organizar items en lista vertical |
| `GridLayoutManager` | Organizar items en cuadrícula |
| `setOnClickListener` en items | Responder a clicks en elementos de la lista |

---

**Anterior:** [← Capítulo 4 — Kotlin intermedio](04_kotlin_intermedio.md) | **Siguiente:** [Capítulo 6 — Navegación entre pantallas →](06_navegacion.md)
