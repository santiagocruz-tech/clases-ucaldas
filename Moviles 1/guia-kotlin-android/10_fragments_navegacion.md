# Capítulo 10: Fragments y Bottom Navigation

## Objetivo

Reorganizar MisFinanzas en tres pestañas usando Fragments y BottomNavigationView: Inicio (resumen), Transacciones (lista completa) y Estadísticas.

---

## 10.1 ¿Qué es un Fragment?

Un Fragment es una porción reutilizable de interfaz que vive dentro de una Activity. Piénsenlo como una "sub-pantalla". La Activity es el contenedor y los Fragments son el contenido que cambia.

¿Para qué sirven?
- Implementar navegación por pestañas (Bottom Navigation)
- Reutilizar la misma UI en diferentes contextos
- Adaptar la UI a tablets (lista y detalle lado a lado)

### Diferencias con una Activity

| Aspecto | Activity | Fragment |
|---------|----------|----------|
| Ciclo de vida | Independiente | Depende de la Activity padre |
| Registro | En AndroidManifest.xml | No se registra |
| Binding | `lateinit var binding` | `_binding` nullable + `binding` non-null |
| Contexto | `this` | `requireContext()` |
| Navegación | `startActivity(Intent)` | Se reemplaza dentro de un contenedor |

---

## 10.2 Crear el menú de navegación

📁 Crear la carpeta `app/src/main/res/menu/` si no existe.

📁 Crear `app/src/main/res/menu/bottom_menu.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- bottom_menu.xml -->
<!-- Define los items del BottomNavigationView -->
<!-- Cada item es una pestaña con ícono y texto -->
<menu xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Pestaña de Inicio (resumen de balance) -->
    <item
        android:id="@+id/nav_inicio"
        android:icon="@android:drawable/ic_menu_compass"
        android:title="Inicio" />
    <!-- android:id = identificador para saber cuál pestaña se seleccionó -->
    <!-- android:icon = ícono que se muestra en la pestaña -->
    <!-- android:title = texto debajo del ícono -->

    <!-- Pestaña de Transacciones (lista completa) -->
    <item
        android:id="@+id/nav_transacciones"
        android:icon="@android:drawable/ic_menu_recent_history"
        android:title="Movimientos" />

    <!-- Pestaña de Estadísticas -->
    <item
        android:id="@+id/nav_estadisticas"
        android:icon="@android:drawable/ic_menu_sort_by_size"
        android:title="Estadísticas" />

</menu>
```

---

## 10.3 Crear los layouts de los Fragments

📁 Crear `app/src/main/res/layout/fragment_inicio.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- fragment_inicio.xml -->
<!-- Fragment que muestra el resumen de balance -->
<ScrollView
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/gris_claro">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="16dp">

        <!-- Saludo -->
        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="MisFinanzas"
            android:textSize="28sp"
            android:textStyle="bold"
            android:textColor="@color/verde_primario" />

        <!-- Tarjeta de balance -->
        <com.google.android.material.card.MaterialCardView
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginTop="16dp"
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

        <!-- Últimas transacciones (preview) -->
        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Últimas transacciones"
            android:textSize="18sp"
            android:textStyle="bold"
            android:textColor="@color/negro_texto"
            android:layout_marginTop="24dp" />

        <!-- RecyclerView con las últimas 5 transacciones -->
        <androidx.recyclerview.widget.RecyclerView
            android:id="@+id/rvUltimas"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginTop="8dp"
            android:nestedScrollingEnabled="false" />
        <!-- nestedScrollingEnabled="false" evita conflictos de scroll -->
        <!-- con el ScrollView padre -->

    </LinearLayout>
</ScrollView>
```


📁 Crear `app/src/main/res/layout/fragment_transacciones.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- fragment_transacciones.xml -->
<!-- Fragment con la lista completa de transacciones y botón de agregar -->
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:background="@color/gris_claro">

    <!-- Encabezado -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="horizontal"
        android:padding="16dp"
        android:gravity="center_vertical">

        <TextView
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:text="Transacciones"
            android:textSize="22sp"
            android:textStyle="bold"
            android:textColor="@color/negro_texto" />

        <TextView
            android:id="@+id/tvCantidad"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:textSize="14sp"
            android:textColor="@color/gris_texto" />
    </LinearLayout>

    <!-- Lista de transacciones -->
    <androidx.recyclerview.widget.RecyclerView
        android:id="@+id/rvTransacciones"
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1"
        android:clipToPadding="false"
        android:paddingBottom="80dp" />

    <!-- Botón de agregar -->
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

📁 Crear `app/src/main/res/layout/fragment_estadisticas.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- fragment_estadisticas.xml -->
<!-- Fragment que muestra estadísticas por categoría -->
<ScrollView
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/gris_claro">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="16dp">

        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Estadísticas"
            android:textSize="22sp"
            android:textStyle="bold"
            android:textColor="@color/negro_texto" />

        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Gastos por categoría"
            android:textSize="14sp"
            android:textColor="@color/gris_texto"
            android:layout_marginTop="4dp" />

        <!-- Texto para mostrar las categorías con sus totales -->
        <!-- Se llena desde Kotlin con los datos calculados -->
        <TextView
            android:id="@+id/tvDetalleCategorias"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginTop="16dp"
            android:textSize="14sp"
            android:lineSpacingExtra="4dp" />

        <!-- Resumen general -->
        <com.google.android.material.card.MaterialCardView
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginTop="16dp"
            app:cardCornerRadius="12dp"
            app:cardElevation="2dp">

            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="vertical"
                android:padding="16dp">

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="Resumen"
                    android:textSize="16sp"
                    android:textStyle="bold" />

                <TextView
                    android:id="@+id/tvTotalTransacciones"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="Total de transacciones: 0"
                    android:textSize="14sp"
                    android:textColor="@color/gris_texto"
                    android:layout_marginTop="8dp" />

                <TextView
                    android:id="@+id/tvPromedioGasto"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="Promedio por gasto: $ 0"
                    android:textSize="14sp"
                    android:textColor="@color/gris_texto"
                    android:layout_marginTop="4dp" />

            </LinearLayout>
        </com.google.android.material.card.MaterialCardView>

    </LinearLayout>
</ScrollView>
```

---

## 10.4 Crear las clases de los Fragments

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/InicioFragment.kt`:

```kotlin
// InicioFragment.kt
// Fragment que muestra el resumen de balance y las últimas transacciones
package com.ejemplo.misfinanzas

// Fragment es la clase base para todos los fragments
import androidx.fragment.app.Fragment
// LayoutInflater convierte XML en objetos View
import android.view.LayoutInflater
// ViewGroup es el contenedor padre
import android.view.ViewGroup
import android.view.View
import android.os.Bundle
import androidx.recyclerview.widget.LinearLayoutManager
// activityViewModels() comparte el ViewModel con la Activity padre
// Así todos los fragments acceden a los mismos datos
import androidx.fragment.app.activityViewModels
import com.ejemplo.misfinanzas.databinding.FragmentInicioBinding

class InicioFragment : Fragment() {

    // En Fragments, el binding se maneja diferente que en Activities
    // _binding es nullable porque el Fragment puede existir sin vista
    // (entre onDestroyView y onDestroy)
    private var _binding: FragmentInicioBinding? = null
    // binding es un atajo non-null que solo se usa cuando la vista existe
    // "get() = _binding!!" significa que lanza excepción si _binding es null
    private val binding get() = _binding!!

    // activityViewModels() comparte el ViewModel con la Activity
    // Todos los fragments ven los mismos datos
    private val viewModel: MainViewModel by activityViewModels()

    // onCreateView infla el layout del Fragment
    // Es el equivalente a setContentView en una Activity
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        // Inflar el layout del fragment
        _binding = FragmentInicioBinding.inflate(inflater, container, false)
        // Retornar la vista raíz
        return binding.root
    }

    // onViewCreated se llama después de que la vista fue creada
    // Aquí configuramos listeners y observadores
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Observar los datos del ViewModel compartido
        // viewLifecycleOwner es el lifecycle del Fragment (no de la Activity)
        // Usar viewLifecycleOwner en lugar de "this" para evitar memory leaks
        viewModel.balance.observe(viewLifecycleOwner) { balance ->
            binding.tvBalance.text = formatearMonto(balance)
        }

        viewModel.ingresos.observe(viewLifecycleOwner) { ingresos ->
            binding.tvIngresos.text = formatearMonto(ingresos)
        }

        viewModel.gastos.observe(viewLifecycleOwner) { gastos ->
            binding.tvGastos.text = formatearMonto(gastos)
        }

        // Mostrar las últimas 5 transacciones
        viewModel.transacciones.observe(viewLifecycleOwner) { lista ->
            // take(5) obtiene solo los primeros 5 elementos
            val ultimas = lista.take(5)
            val adapter = TransaccionAdapter(ultimas) { /* click */ }
            binding.rvUltimas.layoutManager = LinearLayoutManager(requireContext())
            binding.rvUltimas.adapter = adapter
        }
    }

    // onDestroyView se llama cuando la vista del Fragment se destruye
    // IMPORTANTE: limpiar _binding para evitar memory leaks
    // El Fragment puede seguir existiendo sin vista (en el back stack)
    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null  // evitar memory leaks
    }

    private fun formatearMonto(monto: Double): String {
        return "$ ${String.format("%,.0f", monto)}"
    }
}
```


📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/TransaccionesFragment.kt`:

```kotlin
// TransaccionesFragment.kt
// Fragment con la lista completa de transacciones y botón de agregar
package com.ejemplo.misfinanzas

import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.ViewGroup
import android.view.View
import android.os.Bundle
import android.content.Intent
import android.widget.Toast
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.RecyclerView
import androidx.activity.result.contract.ActivityResultContracts
import androidx.fragment.app.activityViewModels
import com.google.android.material.snackbar.Snackbar
import com.ejemplo.misfinanzas.databinding.FragmentTransaccionesBinding

class TransaccionesFragment : Fragment() {

    private var _binding: FragmentTransaccionesBinding? = null
    private val binding get() = _binding!!
    // Compartir el ViewModel con la Activity y los otros Fragments
    private val viewModel: MainViewModel by activityViewModels()

    // registerForActivityResult en un Fragment funciona igual que en una Activity
    private val lanzarAgregar = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { resultado ->
        if (resultado.resultCode == android.app.Activity.RESULT_OK) {
            val nueva = resultado.data?.getSerializableExtra("NUEVA_TRANSACCION") as? Transaccion
            if (nueva != null) {
                viewModel.agregarTransaccion(nueva)
                Toast.makeText(requireContext(), "Transacción guardada", Toast.LENGTH_SHORT).show()
            }
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentTransaccionesBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Configurar RecyclerView
        binding.rvTransacciones.layoutManager = LinearLayoutManager(requireContext())

        // Observar transacciones
        viewModel.transacciones.observe(viewLifecycleOwner) { lista ->
            val adapter = TransaccionAdapter(lista) { transaccion ->
                Toast.makeText(
                    requireContext(),
                    "${transaccion.descripcion}: ${transaccion.montoFormateado()}",
                    Toast.LENGTH_SHORT
                ).show()
            }
            binding.rvTransacciones.adapter = adapter
            binding.tvCantidad.text = "${lista.size} movimientos"
        }

        // Configurar swipe para eliminar
        configurarSwipeEliminar()

        // Botón de agregar
        binding.btnAgregar.setOnClickListener {
            // requireContext() obtiene el contexto del Fragment
            val intent = Intent(requireContext(), AgregarActivity::class.java)
            lanzarAgregar.launch(intent)
        }
    }

    // Swipe a la izquierda para eliminar con opción de deshacer
    private fun configurarSwipeEliminar() {
        val swipeHandler = object : ItemTouchHelper.SimpleCallback(0, ItemTouchHelper.LEFT) {
            override fun onMove(
                recyclerView: RecyclerView,
                viewHolder: RecyclerView.ViewHolder,
                target: RecyclerView.ViewHolder
            ): Boolean = false

            override fun onSwiped(viewHolder: RecyclerView.ViewHolder, direction: Int) {
                val posicion = viewHolder.adapterPosition
                val lista = viewModel.transacciones.value ?: return
                if (posicion < lista.size) {
                    val transaccion = lista[posicion]
                    viewModel.eliminarTransaccion(transaccion)

                    Snackbar.make(binding.root, "Eliminada", Snackbar.LENGTH_LONG)
                        .setAction("Deshacer") {
                            viewModel.agregarTransaccion(transaccion)
                        }.show()
                }
            }
        }
        ItemTouchHelper(swipeHandler).attachToRecyclerView(binding.rvTransacciones)
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
```

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/EstadisticasFragment.kt`:

```kotlin
// EstadisticasFragment.kt
// Fragment que muestra estadísticas de gastos por categoría
package com.ejemplo.misfinanzas

import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.ViewGroup
import android.view.View
import android.os.Bundle
import androidx.fragment.app.activityViewModels
import androidx.recyclerview.widget.LinearLayoutManager
import com.ejemplo.misfinanzas.databinding.FragmentEstadisticasBinding

class EstadisticasFragment : Fragment() {

    private var _binding: FragmentEstadisticasBinding? = null
    private val binding get() = _binding!!
    private val viewModel: MainViewModel by activityViewModels()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentEstadisticasBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Observar las transacciones para calcular estadísticas
        viewModel.transacciones.observe(viewLifecycleOwner) { lista ->
            mostrarEstadisticas(lista)
        }
    }

    // Calcula y muestra las estadísticas por categoría
    private fun mostrarEstadisticas(transacciones: List<Transaccion>) {
        // Filtrar solo gastos (monto negativo)
        val gastos = transacciones.filter { !it.esIngreso() }

        // Agrupar por categoría y sumar los montos
        // groupBy agrupa los elementos por una clave (la categoría)
        // mapValues transforma los valores de cada grupo (suma los montos)
        val porCategoria = gastos
            .groupBy { it.categoria }  // Map<Categoria, List<Transaccion>>
            .mapValues { (_, transacciones) ->
                // Sumar los valores absolutos de los montos de cada grupo
                transacciones.sumOf { Math.abs(it.monto) }
            }
            .toList()  // Convertir a lista de pares (Categoria, Double)
            .sortedByDescending { it.second }  // Ordenar de mayor a menor gasto

        // Mostrar las categorías con sus totales
        // buildString construye un String de forma eficiente
        val detalle = buildString {
            for ((categoria, total) in porCategoria) {
                appendLine("${categoria.emoji} ${categoria.etiqueta}: ${formatearMonto(total)}")
            }
        }
        binding.tvDetalleCategorias.text = detalle

        // Mostrar resumen general
        binding.tvTotalTransacciones.text = "Total de transacciones: ${transacciones.size}"

        // Calcular promedio de gastos
        val promedioGasto = if (gastos.isNotEmpty()) {
            gastos.sumOf { Math.abs(it.monto) } / gastos.size
        } else {
            0.0
        }
        binding.tvPromedioGasto.text = "Promedio por gasto: ${formatearMonto(promedioGasto)}"
    }

    private fun formatearMonto(monto: Double): String {
        return "$ ${String.format("%,.0f", monto)}"
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
```

---

## 10.5 Actualizar el layout de MainActivity

✏️ Reemplazar `activity_main.xml` con el contenedor de Fragments y el BottomNavigationView:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- activity_main.xml -->
<!-- Layout principal con contenedor de Fragments y navegación inferior -->
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical">

    <!-- Contenedor donde se cargan los Fragments -->
    <!-- FrameLayout es el contenedor más simple: apila vistas una sobre otra -->
    <!-- layout_weight="1" hace que ocupe todo el espacio disponible -->
    <FrameLayout
        android:id="@+id/fragmentContainer"
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1" />

    <!-- Barra de navegación inferior -->
    <!-- BottomNavigationView muestra las pestañas definidas en bottom_menu.xml -->
    <com.google.android.material.bottomnavigation.BottomNavigationView
        android:id="@+id/bottomNav"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        app:menu="@menu/bottom_menu"
        app:labelVisibilityMode="labeled" />
    <!-- labelVisibilityMode="labeled" muestra siempre el texto debajo del ícono -->

</LinearLayout>
```

---

## 10.6 Actualizar MainActivity para manejar Fragments

✏️ Modificar `MainActivity.kt`:

```kotlin
// MainActivity.kt
// Activity principal que maneja la navegación entre Fragments
package com.ejemplo.misfinanzas

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
// Fragment es la clase base
import androidx.fragment.app.Fragment
import androidx.activity.viewModels
import com.ejemplo.misfinanzas.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    // ViewModel compartido entre la Activity y todos los Fragments
    private val viewModel: MainViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Cargar el Fragment inicial solo si es la primera vez
        // savedInstanceState es null la primera vez, pero tiene datos si se recreó
        // Sin esta verificación, al rotar se duplicaría el Fragment
        if (savedInstanceState == null) {
            cargarFragment(InicioFragment())
        }

        // Cargar datos de prueba si la base de datos está vacía
        viewModel.transacciones.observe(this) { lista ->
            if (lista.isEmpty()) {
                viewModel.insertarDatosDePrueba()
            }
        }

        // Configurar la navegación inferior
        // setOnItemSelectedListener se ejecuta cuando el usuario toca una pestaña
        binding.bottomNav.setOnItemSelectedListener { item ->
            // item.itemId es el id definido en bottom_menu.xml
            when (item.itemId) {
                R.id.nav_inicio -> cargarFragment(InicioFragment())
                R.id.nav_transacciones -> cargarFragment(TransaccionesFragment())
                R.id.nav_estadisticas -> cargarFragment(EstadisticasFragment())
            }
            // Retornar true indica que el item fue manejado
            true
        }
    }

    // Reemplaza el Fragment actual por uno nuevo
    private fun cargarFragment(fragment: Fragment) {
        // supportFragmentManager maneja los Fragments de esta Activity
        // beginTransaction inicia una transacción (un conjunto de cambios)
        supportFragmentManager.beginTransaction()
            // replace reemplaza el contenido del contenedor por el nuevo Fragment
            .replace(R.id.fragmentContainer, fragment)
            // commit ejecuta la transacción
            .commit()
    }
}
```

---

## 10.7 Compilar y probar

▶️ Compilar y ejecutar. Deberían ver:
1. Tres pestañas en la parte inferior: Inicio, Movimientos, Estadísticas
2. **Inicio:** tarjeta de balance y últimas 5 transacciones
3. **Movimientos:** lista completa con botón de agregar y swipe para eliminar
4. **Estadísticas:** resumen con totales y promedio
5. Al agregar una transacción en Movimientos, el balance se actualiza en Inicio

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| `Fragment` | Porción reutilizable de UI dentro de una Activity |
| `_binding` / `binding` | Patrón de binding seguro en Fragments |
| `onCreateView` | Inflar el layout del Fragment |
| `onViewCreated` | Configurar listeners y observadores |
| `onDestroyView` | Limpiar binding (evitar memory leaks) |
| `viewLifecycleOwner` | Lifecycle del Fragment para observar LiveData |
| `activityViewModels()` | Compartir ViewModel entre Activity y Fragments |
| `requireContext()` | Obtener el contexto dentro de un Fragment |
| `BottomNavigationView` | Barra de navegación inferior con pestañas |
| `supportFragmentManager` | Manejar transacciones de Fragments |
| `.replace()` + `.commit()` | Reemplazar un Fragment por otro |

---

**Anterior:** [← Capítulo 9 — Formularios y validación](09_formularios_validacion.md) | **Siguiente:** [Capítulo 11 — Consumo de APIs con Retrofit →](11_retrofit_api.md)
