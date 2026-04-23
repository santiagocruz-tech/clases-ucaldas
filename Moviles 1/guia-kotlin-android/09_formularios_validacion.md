# Capítulo 9: Formularios y validación

## Objetivo

Mejorar el formulario de agregar transacción en MisFinanzas con Material Design, validación robusta y mejor experiencia de usuario. También agregaremos la funcionalidad de eliminar transacciones.

---

## 9.1 TextInputLayout: campos de texto Material Design

Ya usamos `TextInputLayout` en el capítulo 6. Ahora vamos a profundizar en sus capacidades.

```xml
<!-- TextInputLayout envuelve a un TextInputEditText -->
<!-- Proporciona: label flotante, mensajes de error, iconos, contadores -->
<com.google.android.material.textfield.TextInputLayout
    android:id="@+id/tilNombre"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:hint="Nombre completo"
    app:helperText="Mínimo 3 caracteres"
    app:counterEnabled="true"
    app:counterMaxLength="50"
    app:startIconDrawable="@android:drawable/ic_menu_myplaces"
    app:errorEnabled="true"
    style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox">
    <!-- helperText = texto de ayuda debajo del campo (gris) -->
    <!-- counterEnabled = muestra un contador de caracteres -->
    <!-- counterMaxLength = máximo de caracteres (el contador se pone rojo al pasar) -->
    <!-- startIconDrawable = ícono al inicio del campo -->
    <!-- errorEnabled = reserva espacio para el mensaje de error -->

    <com.google.android.material.textfield.TextInputEditText
        android:id="@+id/etNombre"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:inputType="textPersonName"
        android:maxLines="1" />
</com.google.android.material.textfield.TextInputLayout>
```

### Estilos disponibles

```xml
<!-- Estilo con borde (el más común) -->
style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox"

<!-- Estilo con fondo relleno -->
style="@style/Widget.MaterialComponents.TextInputLayout.FilledBox"
```

### Mostrar y limpiar errores desde Kotlin

```kotlin
// Mostrar un error: el borde se pone rojo y aparece el mensaje debajo
binding.tilNombre.error = "El nombre es obligatorio"

// Limpiar el error: el borde vuelve a la normalidad
binding.tilNombre.error = null

// Verificar si hay error activo
val tieneError = binding.tilNombre.error != null
```

---

## 9.2 Validación de campos

La validación consiste en verificar que los datos ingresados sean correctos antes de guardarlos. Vamos a crear funciones de validación reutilizables.

```kotlin
// Funciones de validación reutilizables
// Cada una retorna un mensaje de error o null si es válido

// Valida que un texto no esté vacío
// trim() elimina espacios al inicio y final
fun validarNoVacio(texto: String, nombreCampo: String): String? {
    return if (texto.trim().isEmpty()) {
        "$nombreCampo es obligatorio"  // retorna el mensaje de error
    } else {
        null  // null significa que no hay error
    }
}

// Valida que un texto tenga un largo mínimo
fun validarLargoMinimo(texto: String, minimo: Int, nombreCampo: String): String? {
    return if (texto.trim().length < minimo) {
        "$nombreCampo debe tener al menos $minimo caracteres"
    } else {
        null
    }
}

// Valida que un texto sea un número válido mayor a cero
fun validarMontoPositivo(texto: String): String? {
    val numero = texto.toDoubleOrNull()  // intenta convertir a Double
    return when {
        texto.trim().isEmpty() -> "El monto es obligatorio"
        numero == null -> "Ingresa un número válido"
        numero <= 0 -> "El monto debe ser mayor a 0"
        else -> null
    }
}

// Valida un email con el patrón de Android
fun validarEmail(texto: String): String? {
    return when {
        texto.trim().isEmpty() -> "El email es obligatorio"
        !android.util.Patterns.EMAIL_ADDRESS.matcher(texto).matches() -> "Email inválido"
        else -> null
    }
}
```

---

## 9.3 Validación en tiempo real

Podemos validar mientras el usuario escribe usando `TextWatcher`:

```kotlin
// addTextChangedListener escucha cambios en el texto del EditText
// Cada vez que el usuario escribe o borra un carácter, se ejecuta el bloque
binding.etDescripcion.addTextChangedListener(object : android.text.TextWatcher {
    // beforeTextChanged: se llama ANTES de que el texto cambie
    // Raramente se usa
    override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}

    // onTextChanged: se llama MIENTRAS el texto cambia
    // s = el texto actual, start = posición del cambio
    override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
        // Limpiar el error mientras el usuario escribe
        // Así el usuario sabe que su corrección fue detectada
        binding.tilDescripcion.error = null
    }

    // afterTextChanged: se llama DESPUÉS de que el texto cambió
    // Útil para validaciones que dependen del texto completo
    override fun afterTextChanged(s: android.text.Editable?) {}
})
```

💡 **Forma más corta con extensión de Kotlin:**

```kotlin
// doAfterTextChanged es una extensión de AndroidX que simplifica el TextWatcher
// Solo necesita el bloque afterTextChanged, los otros se ignoran
// Requiere: import androidx.core.widget.doAfterTextChanged
binding.etDescripcion.doAfterTextChanged { texto ->
    // texto es un Editable? (puede ser null)
    if (!texto.isNullOrBlank()) {
        binding.tilDescripcion.error = null
    }
}
```

---

## 9.4 Mejorar el formulario de MisFinanzas

✏️ Modificar `activity_agregar.xml` con mejor diseño y validación visual:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- activity_agregar.xml -->
<!-- Formulario mejorado para agregar transacciones -->
<ScrollView
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/blanco">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="24dp">

        <!-- Título -->
        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Nueva transacción"
            android:textSize="24sp"
            android:textStyle="bold"
            android:textColor="@color/verde_primario" />

        <!-- Subtítulo -->
        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Registra un ingreso o gasto"
            android:textSize="14sp"
            android:textColor="@color/gris_texto"
            android:layout_marginTop="4dp" />

        <!-- ===== TIPO: INGRESO O GASTO ===== -->
        <!-- Ponemos el tipo primero para que el usuario defina el contexto -->
        <com.google.android.material.card.MaterialCardView
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginTop="24dp"
            app:cardCornerRadius="12dp"
            app:cardElevation="0dp"
            app:strokeWidth="1dp"
            app:strokeColor="#E0E0E0">
            <!-- strokeWidth y strokeColor agregan un borde sutil a la tarjeta -->

            <RadioGroup
                android:id="@+id/rgTipo"
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="horizontal"
                android:padding="8dp">

                <RadioButton
                    android:id="@+id/rbGasto"
                    android:layout_width="0dp"
                    android:layout_height="wrap_content"
                    android:layout_weight="1"
                    android:text="❌ Gasto"
                    android:checked="true"
                    android:gravity="center"
                    android:padding="12dp" />

                <RadioButton
                    android:id="@+id/rbIngreso"
                    android:layout_width="0dp"
                    android:layout_height="wrap_content"
                    android:layout_weight="1"
                    android:text="✅ Ingreso"
                    android:gravity="center"
                    android:padding="12dp" />
            </RadioGroup>
        </com.google.android.material.card.MaterialCardView>

        <!-- ===== CAMPO: DESCRIPCIÓN ===== -->
        <com.google.android.material.textfield.TextInputLayout
            android:id="@+id/tilDescripcion"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:hint="¿En qué gastaste / de dónde viene?"
            android:layout_marginTop="20dp"
            app:counterEnabled="true"
            app:counterMaxLength="40"
            app:errorEnabled="true"
            style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox">

            <com.google.android.material.textfield.TextInputEditText
                android:id="@+id/etDescripcion"
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:inputType="text"
                android:maxLength="40"
                android:maxLines="1" />
            <!-- maxLength limita los caracteres que el usuario puede escribir -->
        </com.google.android.material.textfield.TextInputLayout>

        <!-- ===== CAMPO: MONTO ===== -->
        <com.google.android.material.textfield.TextInputLayout
            android:id="@+id/tilMonto"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:hint="Monto"
            android:layout_marginTop="8dp"
            app:prefixText="$ "
            app:errorEnabled="true"
            style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox">

            <com.google.android.material.textfield.TextInputEditText
                android:id="@+id/etMonto"
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:inputType="numberDecimal"
                android:maxLines="1" />
        </com.google.android.material.textfield.TextInputLayout>

        <!-- ===== CATEGORÍA ===== -->
        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Categoría"
            android:textSize="14sp"
            android:textColor="@color/gris_texto"
            android:layout_marginTop="16dp" />

        <Spinner
            android:id="@+id/spCategoria"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginTop="8dp"
            android:padding="12dp"
            android:background="@android:drawable/btn_dropdown" />

        <!-- ===== BOTONES ===== -->
        <Button
            android:id="@+id/btnGuardar"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="💾 Guardar transacción"
            android:layout_marginTop="32dp"
            android:backgroundTint="@color/verde_primario"
            android:textColor="@color/blanco"
            android:padding="14dp"
            android:textSize="16sp" />

        <Button
            android:id="@+id/btnCancelar"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="Cancelar"
            android:layout_marginTop="8dp"
            style="@style/Widget.MaterialComponents.Button.TextButton" />

    </LinearLayout>
</ScrollView>
```

---

## 9.5 Actualizar AgregarActivity con validación mejorada

✏️ Modificar `AgregarActivity.kt`:

```kotlin
// AgregarActivity.kt
// Formulario con validación mejorada y limpieza de errores en tiempo real
package com.ejemplo.misfinanzas

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.content.Intent
import android.widget.ArrayAdapter
import android.widget.Toast
// doAfterTextChanged simplifica el TextWatcher
import androidx.core.widget.doAfterTextChanged
import com.ejemplo.misfinanzas.databinding.ActivityAgregarBinding

class AgregarActivity : AppCompatActivity() {

    private lateinit var binding: ActivityAgregarBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityAgregarBinding.inflate(layoutInflater)
        setContentView(binding.root)

        configurarSpinnerCategorias()
        configurarValidacionEnTiempoReal()
        configurarBotones()
    }

    // Llena el Spinner con las categorías
    private fun configurarSpinnerCategorias() {
        val etiquetas = Categoria.values().map { "${it.emoji} ${it.etiqueta}" }
        val adapter = ArrayAdapter(
            this,
            android.R.layout.simple_spinner_item,
            etiquetas
        )
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        binding.spCategoria.adapter = adapter
    }

    // Configura la limpieza de errores mientras el usuario escribe
    private fun configurarValidacionEnTiempoReal() {
        // Cuando el usuario escribe en descripción, limpiar el error
        // doAfterTextChanged es más simple que implementar TextWatcher completo
        binding.etDescripcion.doAfterTextChanged { texto ->
            // Si el texto no está vacío, limpiar el error
            if (!texto.isNullOrBlank()) {
                binding.tilDescripcion.error = null
            }
        }

        // Cuando el usuario escribe en monto, limpiar el error
        binding.etMonto.doAfterTextChanged { texto ->
            if (!texto.isNullOrBlank()) {
                binding.tilMonto.error = null
            }
        }
    }

    // Configura las acciones de los botones
    private fun configurarBotones() {
        binding.btnGuardar.setOnClickListener {
            // Validar todos los campos
            if (validarFormulario()) {
                // Si todo es válido, crear la transacción y devolverla
                val transaccion = crearTransaccion()
                devolverResultado(transaccion)
            }
        }

        binding.btnCancelar.setOnClickListener {
            finish()
        }
    }

    // Valida todos los campos del formulario
    // Retorna true si todo es válido, false si hay errores
    private fun validarFormulario(): Boolean {
        // Variable que rastrea si todo es válido
        var esValido = true

        // Validar descripción
        val descripcion = binding.etDescripcion.text.toString().trim()
        if (descripcion.isEmpty()) {
            binding.tilDescripcion.error = "La descripción es obligatoria"
            esValido = false
        } else if (descripcion.length < 3) {
            binding.tilDescripcion.error = "Mínimo 3 caracteres"
            esValido = false
        } else {
            binding.tilDescripcion.error = null
        }

        // Validar monto
        val montoTexto = binding.etMonto.text.toString().trim()
        val montoNumero = montoTexto.toDoubleOrNull()
        if (montoTexto.isEmpty()) {
            binding.tilMonto.error = "El monto es obligatorio"
            esValido = false
        } else if (montoNumero == null) {
            binding.tilMonto.error = "Ingresa un número válido"
            esValido = false
        } else if (montoNumero <= 0) {
            binding.tilMonto.error = "El monto debe ser mayor a 0"
            esValido = false
        } else if (montoNumero > 999999999) {
            binding.tilMonto.error = "El monto es demasiado grande"
            esValido = false
        } else {
            binding.tilMonto.error = null
        }

        // No validamos esValido = false en cada caso porque queremos
        // mostrar TODOS los errores a la vez, no solo el primero
        return esValido
    }

    // Crea la transacción con los datos del formulario
    // Se llama solo después de que validarFormulario() retorna true
    private fun crearTransaccion(): Transaccion {
        val descripcion = binding.etDescripcion.text.toString().trim()
        val montoNumero = binding.etMonto.text.toString().trim().toDouble()
        val esGasto = binding.rbGasto.isChecked
        val montoFinal = if (esGasto) -montoNumero else montoNumero
        val categoriaIndex = binding.spCategoria.selectedItemPosition
        val categoria = Categoria.values()[categoriaIndex]

        return Transaccion(
            id = 0,
            monto = montoFinal,
            descripcion = descripcion,
            categoriaNombre = categoria.name
        )
    }

    // Devuelve la transacción a la Activity anterior
    private fun devolverResultado(transaccion: Transaccion) {
        val resultadoIntent = Intent()
        resultadoIntent.putExtra("NUEVA_TRANSACCION", transaccion)
        setResult(RESULT_OK, resultadoIntent)
        finish()
    }
}
```

---

## 9.6 Agregar eliminación de transacciones con Snackbar

Vamos a permitir eliminar transacciones con un gesto de deslizar (swipe) y mostrar un Snackbar con opción de deshacer.

✏️ Agregar en `MainActivity.kt` la funcionalidad de swipe para eliminar:

```kotlin
// Agregar estos imports en MainActivity.kt:
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.snackbar.Snackbar

// Agregar este método en MainActivity y llamarlo desde onCreate:
private fun configurarSwipeEliminar() {
    // ItemTouchHelper detecta gestos de swipe y drag en el RecyclerView
    // SimpleCallback define qué direcciones soportar
    // 0 = no soportar drag, ItemTouchHelper.LEFT = soportar swipe a la izquierda
    val swipeHandler = object : ItemTouchHelper.SimpleCallback(0, ItemTouchHelper.LEFT) {

        // onMove se llama al arrastrar (drag). No lo usamos, retornamos false
        override fun onMove(
            recyclerView: RecyclerView,
            viewHolder: RecyclerView.ViewHolder,
            target: RecyclerView.ViewHolder
        ): Boolean = false

        // onSwiped se llama cuando el usuario completa el swipe
        override fun onSwiped(viewHolder: RecyclerView.ViewHolder, direction: Int) {
            // Obtener la posición del item deslizado
            val posicion = viewHolder.adapterPosition
            // Obtener la transacción de la lista actual
            val lista = viewModel.transacciones.value ?: return
            if (posicion < lista.size) {
                val transaccion = lista[posicion]

                // Eliminar del ViewModel (y de Room)
                viewModel.eliminarTransaccion(transaccion)

                // Mostrar Snackbar con opción de deshacer
                // Snackbar es como un Toast pero con acción
                Snackbar.make(
                    binding.root,                    // vista padre
                    "Transacción eliminada",         // mensaje
                    Snackbar.LENGTH_LONG             // duración
                ).setAction("Deshacer") {
                    // Si el usuario presiona "Deshacer", volver a insertar
                    viewModel.agregarTransaccion(transaccion)
                }.show()
            }
        }
    }

    // Adjuntar el handler al RecyclerView
    ItemTouchHelper(swipeHandler).attachToRecyclerView(binding.rvTransacciones)
}
```

---

## 9.7 Compilar y probar

▶️ Compilar y ejecutar. Verificar:
1. El formulario muestra errores si los campos están vacíos
2. Los errores se limpian al empezar a escribir
3. El contador de caracteres funciona en la descripción
4. Deslizar una transacción a la izquierda la elimina
5. El Snackbar permite deshacer la eliminación

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| `TextInputLayout` | Campo de texto Material Design con label flotante y errores |
| `.error = "mensaje"` | Mostrar error debajo del campo |
| `.error = null` | Limpiar el error |
| `doAfterTextChanged` | Escuchar cambios de texto de forma simple |
| `TextWatcher` | Escuchar cambios de texto (versión completa) |
| `toDoubleOrNull()` | Convertir texto a número de forma segura |
| `Snackbar` | Mensaje con acción (como "Deshacer") |
| `ItemTouchHelper` | Detectar gestos de swipe y drag en RecyclerView |
| Validación en tiempo real | Limpiar errores mientras el usuario escribe |

---

**Anterior:** [← Capítulo 8 — Persistencia con Room](08_persistencia_room.md) | **Siguiente:** [Capítulo 10 — Fragments y Bottom Navigation →](10_fragments_navegacion.md)
