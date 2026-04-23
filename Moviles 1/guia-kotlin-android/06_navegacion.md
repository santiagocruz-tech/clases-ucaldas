# Capítulo 6: Navegación entre pantallas

## Objetivo

Crear una segunda pantalla en MisFinanzas para agregar nuevas transacciones. Aprenderemos a navegar entre Activities, pasar datos y regresar con resultados.

---

## 6.1 ¿Cómo funciona la navegación en Android?

En Android se navega entre pantallas (Activities) usando **Intents**. Un Intent es un mensaje que le dice al sistema: "quiero abrir esta pantalla" y opcionalmente le pasa datos.

| Acción | En Flutter | En Android |
|--------|-----------|------------|
| Ir a otra pantalla | `Navigator.push()` | `startActivity(Intent)` |
| Regresar | `Navigator.pop()` | `finish()` |
| Pasar datos | Constructor del Widget | `intent.putExtra()` |
| Recibir resultado | `Navigator.pop(context, dato)` | `registerForActivityResult` |

---

## 6.2 Crear la Activity para agregar transacciones

Necesitamos crear dos archivos: el layout XML y la clase Kotlin. También hay que registrar la Activity en el AndroidManifest.

📁 Crear `app/src/main/res/layout/activity_agregar.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- activity_agregar.xml -->
<!-- Pantalla para agregar una nueva transacción -->
<!-- ScrollView por si el teclado empuja el contenido -->
<ScrollView
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="24dp">

        <!-- Título de la pantalla -->
        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Nueva transacción"
            android:textSize="24sp"
            android:textStyle="bold"
            android:textColor="@color/verde_primario" />

        <!-- ===== CAMPO: DESCRIPCIÓN ===== -->
        <!-- TextInputLayout es la versión Material Design del EditText -->
        <!-- Muestra el hint como label flotante y soporta mensajes de error -->
        <com.google.android.material.textfield.TextInputLayout
            android:id="@+id/tilDescripcion"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:hint="Descripción"
            android:layout_marginTop="24dp"
            style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox">
            <!-- OutlinedBox = estilo con borde rectangular -->

            <!-- TextInputEditText va DENTRO del TextInputLayout -->
            <com.google.android.material.textfield.TextInputEditText
                android:id="@+id/etDescripcion"
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:inputType="text"
                android:maxLines="1" />
            <!-- inputType="text" = teclado normal de texto -->
        </com.google.android.material.textfield.TextInputLayout>

        <!-- ===== CAMPO: MONTO ===== -->
        <com.google.android.material.textfield.TextInputLayout
            android:id="@+id/tilMonto"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:hint="Monto"
            android:layout_marginTop="16dp"
            app:prefixText="$ "
            style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox">
            <!-- prefixText muestra "$ " antes del texto que escribe el usuario -->

            <com.google.android.material.textfield.TextInputEditText
                android:id="@+id/etMonto"
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:inputType="numberDecimal"
                android:maxLines="1" />
            <!-- inputType="numberDecimal" = teclado numérico con punto decimal -->
        </com.google.android.material.textfield.TextInputLayout>

        <!-- ===== TIPO: INGRESO O GASTO ===== -->
        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Tipo"
            android:textSize="16sp"
            android:textStyle="bold"
            android:layout_marginTop="20dp"
            android:textColor="@color/negro_texto" />

        <!-- RadioGroup agrupa RadioButtons para que solo uno esté seleccionado -->
        <RadioGroup
            android:id="@+id/rgTipo"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="horizontal"
            android:layout_marginTop="8dp">

            <!-- RadioButton: opción seleccionable (solo una a la vez dentro del grupo) -->
            <RadioButton
                android:id="@+id/rbGasto"
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:text="Gasto"
                android:checked="true" />
            <!-- checked="true" = esta opción está seleccionada por defecto -->

            <RadioButton
                android:id="@+id/rbIngreso"
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:text="Ingreso" />
        </RadioGroup>

        <!-- ===== CATEGORÍA ===== -->
        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Categoría"
            android:textSize="16sp"
            android:textStyle="bold"
            android:layout_marginTop="20dp"
            android:textColor="@color/negro_texto" />

        <!-- Spinner es un dropdown (menú desplegable) -->
        <!-- Lo configuraremos desde Kotlin con las categorías del enum -->
        <Spinner
            android:id="@+id/spCategoria"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginTop="8dp"
            android:padding="12dp" />

        <!-- ===== BOTONES ===== -->
        <!-- Botón de guardar -->
        <Button
            android:id="@+id/btnGuardar"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="Guardar transacción"
            android:layout_marginTop="32dp"
            android:backgroundTint="@color/verde_primario"
            android:textColor="@color/blanco"
            android:padding="12dp" />

        <!-- Botón de cancelar (estilo texto, sin fondo) -->
        <Button
            android:id="@+id/btnCancelar"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="Cancelar"
            android:layout_marginTop="8dp"
            style="@style/Widget.MaterialComponents.Button.TextButton" />
        <!-- TextButton = botón sin fondo, solo texto -->

    </LinearLayout>
</ScrollView>
```

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/AgregarActivity.kt`:

```kotlin
// AgregarActivity.kt
// Pantalla para agregar una nueva transacción
package com.ejemplo.misfinanzas

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
// Intent se usa para pasar datos entre Activities
import android.content.Intent
// ArrayAdapter conecta un array de datos con un Spinner (dropdown)
import android.widget.ArrayAdapter
import android.widget.Toast
import com.ejemplo.misfinanzas.databinding.ActivityAgregarBinding

class AgregarActivity : AppCompatActivity() {

    private lateinit var binding: ActivityAgregarBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Inflar el layout de esta pantalla
        binding = ActivityAgregarBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Configurar el Spinner (dropdown) con las categorías del enum
        configurarSpinnerCategorias()

        // Configurar los botones
        configurarBotones()
    }

    // Llena el Spinner con las categorías del enum Categoria
    private fun configurarSpinnerCategorias() {
        // Obtener las etiquetas de todas las categorías
        // .values() retorna todos los valores del enum
        // .map { } transforma cada valor en su etiqueta legible
        val etiquetas = Categoria.values().map { "${it.emoji} ${it.etiqueta}" }

        // ArrayAdapter conecta la lista de strings con el Spinner
        // android.R.layout.simple_spinner_item = layout predefinido para cada item
        val adapter = ArrayAdapter(
            this,                                    // contexto
            android.R.layout.simple_spinner_item,    // layout de cada item
            etiquetas                                // datos
        )
        // setDropDownViewResource define cómo se ve el menú desplegable
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)

        // Asignar el adapter al Spinner
        binding.spCategoria.adapter = adapter
    }

    // Configura las acciones de los botones
    private fun configurarBotones() {
        // Botón GUARDAR: valida los campos y devuelve la transacción
        binding.btnGuardar.setOnClickListener {
            // Intentar crear la transacción
            val transaccion = crearTransaccion()
            if (transaccion != null) {
                // Si la validación pasó, devolver el resultado a la pantalla anterior
                devolverResultado(transaccion)
            }
        }

        // Botón CANCELAR: cierra esta pantalla sin devolver nada
        binding.btnCancelar.setOnClickListener {
            // finish() cierra la Activity actual y regresa a la anterior
            finish()
        }
    }

    // Valida los campos y crea una Transaccion, o retorna null si hay errores
    private fun crearTransaccion(): Transaccion? {
        // Obtener los valores de los campos
        // .toString().trim() convierte a String y elimina espacios al inicio/final
        val descripcion = binding.etDescripcion.text.toString().trim()
        val montoTexto = binding.etMonto.text.toString().trim()

        // Validar descripción
        if (descripcion.isEmpty()) {
            // .error muestra un mensaje de error debajo del campo
            binding.tilDescripcion.error = "La descripción es obligatoria"
            return null  // retorna null para indicar que la validación falló
        } else {
            // Limpiar el error si el campo es válido
            binding.tilDescripcion.error = null
        }

        // Validar monto
        if (montoTexto.isEmpty()) {
            binding.tilMonto.error = "El monto es obligatorio"
            return null
        }

        // toDoubleOrNull() intenta convertir el texto a Double
        // Retorna null si el texto no es un número válido
        val montoNumero = montoTexto.toDoubleOrNull()
        if (montoNumero == null || montoNumero <= 0) {
            binding.tilMonto.error = "Ingresa un monto válido mayor a 0"
            return null
        } else {
            binding.tilMonto.error = null
        }

        // Determinar si es gasto o ingreso según el RadioButton seleccionado
        // rbGasto.isChecked retorna true si el RadioButton de gasto está seleccionado
        val esGasto = binding.rbGasto.isChecked

        // El monto es negativo si es gasto, positivo si es ingreso
        val montoFinal = if (esGasto) -montoNumero else montoNumero

        // Obtener la categoría seleccionada del Spinner
        // selectedItemPosition retorna el índice seleccionado (0, 1, 2, ...)
        // Lo usamos para obtener el valor correspondiente del enum
        val categoriaIndex = binding.spCategoria.selectedItemPosition
        val categoria = Categoria.values()[categoriaIndex]

        // Crear y retornar la transacción
        return Transaccion(
            id = 0,  // el id se asignará después (por la base de datos)
            monto = montoFinal,
            descripcion = descripcion,
            categoria = categoria
        )
    }

    // Devuelve la transacción creada a la Activity que la llamó
    private fun devolverResultado(transaccion: Transaccion) {
        // Crear un Intent para devolver datos
        val resultadoIntent = Intent()
        // putExtra guarda la transacción en el Intent con una clave
        // La transacción debe ser Serializable (lo definimos en el capítulo 4)
        resultadoIntent.putExtra("NUEVA_TRANSACCION", transaccion)

        // setResult indica que la operación fue exitosa y adjunta los datos
        // RESULT_OK es una constante que indica éxito
        setResult(RESULT_OK, resultadoIntent)

        // Cerrar esta Activity y regresar a la anterior
        finish()
    }
}
```

---

## 6.3 Registrar la Activity en el Manifest

✏️ Modificar `AndroidManifest.xml` — agregar la nueva Activity dentro de `<application>`:

```xml
<!-- Registrar AgregarActivity -->
<!-- Toda Activity debe estar registrada aquí, si no la app crashea -->
<activity android:name=".AgregarActivity" />
```

El manifest completo debería verse así:

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:allowBackup="true"
        android:label="MisFinanzas"
        android:theme="@style/Theme.MaterialComponents.Light.NoActionBar">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- Nueva Activity para agregar transacciones -->
        <activity android:name=".AgregarActivity" />

    </application>
</manifest>
```

---

## 6.4 Navegar desde MainActivity y recibir el resultado

✏️ Modificar `MainActivity.kt`:

```kotlin
// MainActivity.kt
// Pantalla principal con navegación a AgregarActivity
package com.ejemplo.misfinanzas

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.content.Intent
import android.widget.Toast
import androidx.recyclerview.widget.LinearLayoutManager
// ActivityResultContracts permite registrar callbacks para resultados de Activities
import androidx.activity.result.contract.ActivityResultContracts
import com.ejemplo.misfinanzas.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    // Lista mutable de transacciones (mutable para poder agregar nuevas)
    private val transacciones = Transaccion.datosDePrueba().toMutableList()
    private lateinit var adapter: TransaccionAdapter

    // registerForActivityResult registra un callback que se ejecuta
    // cuando la Activity lanzada devuelve un resultado
    // Esto reemplaza al antiguo onActivityResult (que está deprecado)
    private val lanzarAgregar = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { resultado ->
        // Este bloque se ejecuta cuando AgregarActivity termina
        // resultado.resultCode indica si fue exitoso o cancelado
        if (resultado.resultCode == RESULT_OK) {
            // Obtener la transacción del Intent de resultado
            // getSerializableExtra obtiene un objeto Serializable por su clave
            // "as?" hace un cast seguro (retorna null si el tipo no coincide)
            val nueva = resultado.data?.getSerializableExtra("NUEVA_TRANSACCION") as? Transaccion
            if (nueva != null) {
                // Agregar la nueva transacción al inicio de la lista
                transacciones.add(0, nueva)
                // Notificar al adapter que se insertó un item en la posición 0
                adapter.notifyItemInserted(0)
                // Hacer scroll al inicio para ver la nueva transacción
                binding.rvTransacciones.scrollToPosition(0)
                // Recalcular los totales
                actualizarBalance()
                // Mostrar confirmación
                Toast.makeText(this, "Transacción agregada", Toast.LENGTH_SHORT).show()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        configurarRecyclerView()
        actualizarBalance()

        // Botón de agregar: abre AgregarActivity
        binding.btnAgregar.setOnClickListener {
            // Crear un Intent para abrir AgregarActivity
            // "this" = contexto actual, AgregarActivity::class.java = destino
            val intent = Intent(this, AgregarActivity::class.java)
            // Lanzar la Activity y esperar resultado
            lanzarAgregar.launch(intent)
        }
    }

    private fun configurarRecyclerView() {
        adapter = TransaccionAdapter(transacciones) { transaccion ->
            Toast.makeText(
                this,
                "${transaccion.descripcion}: ${transaccion.montoFormateado()}",
                Toast.LENGTH_SHORT
            ).show()
        }
        binding.rvTransacciones.layoutManager = LinearLayoutManager(this)
        binding.rvTransacciones.adapter = adapter
    }

    private fun actualizarBalance() {
        val ingresos = transacciones.filter { it.esIngreso() }.sumOf { it.monto }
        val gastos = transacciones.filter { !it.esIngreso() }.sumOf { Math.abs(it.monto) }
        val balance = transacciones.sumOf { it.monto }

        binding.tvBalance.text = formatearMonto(balance)
        binding.tvIngresos.text = formatearMonto(ingresos)
        binding.tvGastos.text = formatearMonto(gastos)
        binding.tvNumTransacciones.text = "${transacciones.size}"
    }

    private fun formatearMonto(monto: Double): String {
        return "$ ${String.format("%,.0f", monto)}"
    }
}
```

---

## 6.5 Pasar datos a otra pantalla (extra)

Si quisiéramos abrir una pantalla de detalle pasándole una transacción:

```kotlin
// Enviar datos con putExtra
// putExtra guarda pares clave-valor en el Intent
val intent = Intent(this, DetalleActivity::class.java).apply {
    // .apply permite configurar el objeto dentro del bloque
    putExtra("TRANSACCION", transaccion)  // objeto Serializable
    putExtra("POSICION", posicion)         // entero
}
startActivity(intent)

// Recibir datos en la otra Activity
// intent.getSerializableExtra obtiene un Serializable por su clave
val transaccion = intent.getSerializableExtra("TRANSACCION") as? Transaccion
// intent.getIntExtra obtiene un Int (el segundo parámetro es el valor por defecto)
val posicion = intent.getIntExtra("POSICION", -1)
```

---

## 6.6 Compilar y probar

▶️ Compilar y ejecutar. Deberían poder:
1. Ver la lista de transacciones de ejemplo
2. Presionar "Agregar transacción"
3. Llenar el formulario con descripción, monto, tipo y categoría
4. Presionar "Guardar" y ver la nueva transacción en la lista
5. Presionar "Cancelar" para regresar sin guardar

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| `Intent` | Mensaje para abrir otra Activity o pasar datos |
| `startActivity(intent)` | Abrir una Activity sin esperar resultado |
| `registerForActivityResult` | Abrir una Activity y recibir un resultado al regresar |
| `putExtra` / `getExtra` | Pasar datos entre Activities |
| `setResult` + `finish()` | Devolver un resultado a la Activity anterior |
| `Serializable` | Permite pasar objetos completos entre Activities |
| `TextInputLayout` | Campo de texto Material Design con validación |
| `Spinner` | Menú desplegable (dropdown) |
| `RadioGroup` / `RadioButton` | Selección de una opción entre varias |

---

**Anterior:** [← Capítulo 5 — Listas con RecyclerView](05_listas_recyclerview.md) | **Siguiente:** [Capítulo 7 — Ciclo de vida y ViewModel →](07_ciclo_vida_viewmodel.md)
