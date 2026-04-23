# Capítulo 8: Persistencia con Room

## Objetivo

Guardar las transacciones de MisFinanzas en una base de datos local usando Room, el ORM oficial de Google para SQLite en Android. Así los datos sobreviven al cierre de la app.

---

## 8.1 ¿Qué es Room?

Room es una capa de abstracción sobre SQLite que facilita el acceso a la base de datos. En lugar de escribir SQL crudo, definimos clases y anotaciones que Room convierte en tablas y consultas.

| Concepto | En SQL | En Room |
|----------|--------|---------|
| Tabla | `CREATE TABLE` | `@Entity` (una data class) |
| Consultas | `SELECT`, `INSERT`, etc. | `@Dao` (una interfaz) |
| Base de datos | Archivo `.db` | `@Database` (una clase abstracta) |

Room tiene tres componentes:
1. **Entity** — define la estructura de una tabla
2. **DAO** (Data Access Object) — define las consultas
3. **Database** — la base de datos que contiene las tablas

---

## 8.2 Configurar las dependencias

🔧 Modificar `app/build.gradle.kts`:

```kotlin
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // kapt es el procesador de anotaciones de Kotlin
    // Room lo necesita para generar código a partir de las anotaciones
    id("kotlin-kapt")
}

dependencies {
    // ... las que ya tienen

    // Room: base de datos local
    // room-runtime: el motor de Room
    implementation("androidx.room:room-runtime:2.6.1")
    // room-ktx: extensiones de Kotlin para Room (soporte de coroutines)
    implementation("androidx.room:room-ktx:2.6.1")
    // room-compiler: genera código a partir de las anotaciones (solo en compilación)
    kapt("androidx.room:room-compiler:2.6.1")
}
```

Sincronizar Gradle después de agregar las dependencias.

---

## 8.3 Entity: definir la tabla

Vamos a convertir nuestra data class `Transaccion` en una Entity de Room.

✏️ Modificar `app/src/main/java/com/ejemplo/misfinanzas/Transaccion.kt`:

```kotlin
// Transaccion.kt
// Entity de Room que representa la tabla "transacciones" en la base de datos
package com.ejemplo.misfinanzas

// Importaciones de Room
// @Entity marca esta clase como una tabla de la base de datos
import androidx.room.Entity
// @PrimaryKey marca el campo que es la clave primaria
import androidx.room.PrimaryKey
import java.io.Serializable

// @Entity indica que esta clase es una tabla en la base de datos
// tableName define el nombre de la tabla en SQLite
@Entity(tableName = "transacciones")
data class Transaccion(
    // @PrimaryKey marca este campo como la clave primaria
    // autoGenerate = true hace que Room genere el id automáticamente (autoincrement)
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,                    // 0 = Room asignará el id al insertar

    val monto: Double,                  // positivo = ingreso, negativo = gasto
    val descripcion: String,            // nombre descriptivo
    val categoriaNombre: String,        // nombre de la categoría como String
    // Room no puede guardar enums directamente, así que guardamos el nombre
    // y lo convertimos a enum cuando lo necesitemos
    val fecha: Long = System.currentTimeMillis()  // timestamp de creación
) : Serializable {

    // Propiedad calculada que convierte el String a enum Categoria
    // No se guarda en la base de datos porque es un getter sin backing field
    // Room solo persiste las propiedades del constructor primario
    val categoria: Categoria
        get() = try {
            // valueOf busca un valor del enum por su nombre
            Categoria.valueOf(categoriaNombre)
        } catch (e: Exception) {
            // Si el nombre no coincide con ningún valor, usar OTROS
            Categoria.OTROS
        }

    // Retorna true si el monto es positivo (ingreso)
    fun esIngreso(): Boolean = monto > 0

    // Retorna el monto formateado como moneda colombiana
    fun montoFormateado(): String {
        val signo = if (esIngreso()) "+" else ""
        return "$signo$ ${String.format("%,.0f", monto)}"
    }

    // Funciones de fábrica y datos de prueba
    companion object {
        // Genera datos de ejemplo para desarrollo y pruebas
        fun datosDePrueba(): List<Transaccion> {
            return listOf(
                Transaccion(1, 2500000.0, "Salario mensual", Categoria.SALARIO.name),
                Transaccion(2, -150000.0, "Almuerzo restaurante", Categoria.COMIDA.name),
                Transaccion(3, -80000.0, "Uber al trabajo", Categoria.TRANSPORTE.name),
                Transaccion(4, -200000.0, "Recibo de luz", Categoria.SERVICIOS.name),
                Transaccion(5, 500000.0, "Proyecto web", Categoria.FREELANCE.name),
                Transaccion(6, -50000.0, "Netflix", Categoria.ENTRETENIMIENTO.name),
                Transaccion(7, -35000.0, "Medicinas", Categoria.SALUD.name),
                Transaccion(8, -120000.0, "Mercado", Categoria.COMIDA.name)
            )
        }
    }
}
```

💡 **¿Por qué `categoriaNombre: String` en lugar de `categoria: Categoria`?** Room solo puede guardar tipos primitivos (Int, Double, String, Long, Boolean). No puede guardar enums directamente. Guardamos el nombre del enum como String y lo convertimos cuando lo necesitamos.

---

## 8.4 DAO: definir las consultas

El DAO (Data Access Object) es una interfaz donde definimos las operaciones de la base de datos.

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/TransaccionDao.kt`:

```kotlin
// TransaccionDao.kt
// DAO (Data Access Object) que define las operaciones sobre la tabla transacciones
package com.ejemplo.misfinanzas

// Importaciones de Room
import androidx.room.Dao      // marca la interfaz como un DAO
import androidx.room.Insert   // anotación para insertar registros
import androidx.room.Update   // anotación para actualizar registros
import androidx.room.Delete   // anotación para eliminar registros
import androidx.room.Query    // anotación para consultas SQL personalizadas
// LiveData permite que la UI se actualice automáticamente cuando los datos cambian
import androidx.lifecycle.LiveData

// @Dao marca esta interfaz como un Data Access Object
// Room genera la implementación automáticamente en tiempo de compilación
@Dao
interface TransaccionDao {

    // @Query ejecuta una consulta SQL personalizada
    // Retorna LiveData: la UI se actualiza automáticamente cuando la tabla cambia
    // Las funciones que retornan LiveData NO necesitan ser "suspend"
    // porque Room las ejecuta en segundo plano automáticamente
    @Query("SELECT * FROM transacciones ORDER BY fecha DESC")
    fun obtenerTodas(): LiveData<List<Transaccion>>

    // Consulta que filtra solo ingresos (monto > 0)
    @Query("SELECT * FROM transacciones WHERE monto > 0 ORDER BY fecha DESC")
    fun obtenerIngresos(): LiveData<List<Transaccion>>

    // Consulta que filtra solo gastos (monto < 0)
    @Query("SELECT * FROM transacciones WHERE monto < 0 ORDER BY fecha DESC")
    fun obtenerGastos(): LiveData<List<Transaccion>>

    // Consulta que suma todos los montos (balance total)
    // COALESCE retorna 0.0 si no hay registros (evita null)
    @Query("SELECT COALESCE(SUM(monto), 0.0) FROM transacciones")
    fun obtenerBalance(): LiveData<Double>

    // Consulta que suma solo los ingresos
    @Query("SELECT COALESCE(SUM(monto), 0.0) FROM transacciones WHERE monto > 0")
    fun obtenerTotalIngresos(): LiveData<Double>

    // Consulta que suma solo los gastos (valor absoluto)
    @Query("SELECT COALESCE(SUM(ABS(monto)), 0.0) FROM transacciones WHERE monto < 0")
    fun obtenerTotalGastos(): LiveData<Double>

    // Cuenta el número total de transacciones
    @Query("SELECT COUNT(*) FROM transacciones")
    fun obtenerCantidad(): LiveData<Int>

    // @Insert inserta un registro en la tabla
    // "suspend" indica que esta función se ejecuta en una coroutine (segundo plano)
    // Las operaciones de escritura DEBEN ser suspend para no bloquear el hilo principal
    @Insert
    suspend fun insertar(transaccion: Transaccion)

    // Inserta múltiples registros de una vez
    @Insert
    suspend fun insertarTodas(transacciones: List<Transaccion>)

    // @Update actualiza un registro existente (busca por primary key)
    @Update
    suspend fun actualizar(transaccion: Transaccion)

    // @Delete elimina un registro (busca por primary key)
    @Delete
    suspend fun eliminar(transaccion: Transaccion)

    // Elimina todos los registros de la tabla
    @Query("DELETE FROM transacciones")
    suspend fun eliminarTodas()
}
```

---

## 8.5 Database: la base de datos

📁 Crear `app/src/main/java/com/ejemplo/misfinanzas/AppDatabase.kt`:

```kotlin
// AppDatabase.kt
// Clase principal de la base de datos Room
package com.ejemplo.misfinanzas

// Context se necesita para crear la base de datos
import android.content.Context
// Importaciones de Room
import androidx.room.Database   // marca la clase como una base de datos Room
import androidx.room.Room       // builder para crear la instancia
import androidx.room.RoomDatabase  // clase base

// @Database define:
// - entities: las tablas de la base de datos (array de clases @Entity)
// - version: número de versión (incrementar cuando se cambia el esquema)
// - exportSchema: si se exporta el esquema a un archivo JSON (false para simplificar)
@Database(
    entities = [Transaccion::class],
    version = 1,
    exportSchema = false
)
abstract class AppDatabase : RoomDatabase() {

    // Función abstracta que retorna el DAO
    // Room genera la implementación automáticamente
    abstract fun transaccionDao(): TransaccionDao

    // companion object implementa el patrón Singleton
    // Garantiza que solo exista UNA instancia de la base de datos en toda la app
    companion object {
        // @Volatile asegura que los cambios a INSTANCE sean visibles
        // inmediatamente en todos los hilos
        @Volatile
        private var INSTANCE: AppDatabase? = null

        // Función que retorna la instancia única de la base de datos
        // Si no existe, la crea. Si ya existe, la retorna.
        fun obtenerInstancia(context: Context): AppDatabase {
            // Si ya existe una instancia, retornarla directamente
            // ?: (Elvis operator) ejecuta el bloque de la derecha si INSTANCE es null
            return INSTANCE ?: synchronized(this) {
                // synchronized evita que dos hilos creen la instancia al mismo tiempo
                // (condición de carrera)

                // Crear la base de datos usando el builder de Room
                val instancia = Room.databaseBuilder(
                    context.applicationContext,  // contexto de la aplicación (no de la Activity)
                    AppDatabase::class.java,     // clase de la base de datos
                    "misfinanzas_database"       // nombre del archivo de la base de datos
                )
                // fallbackToDestructiveMigration: si la versión cambia, borra y recrea
                // En producción se usarían migraciones, pero para aprender es más simple así
                .fallbackToDestructiveMigration()
                .build()

                // Guardar la instancia para reutilizarla
                INSTANCE = instancia
                // Retornar la instancia creada
                instancia
            }
        }
    }
}
```

---

## 8.6 Actualizar el ViewModel para usar Room

✏️ Modificar `MainViewModel.kt`:

```kotlin
// MainViewModel.kt
// ViewModel que usa Room para persistir las transacciones
package com.ejemplo.misfinanzas

// Application se necesita para obtener el contexto de la app
import android.app.Application
// AndroidViewModel recibe Application como parámetro (a diferencia de ViewModel)
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
// viewModelScope proporciona un scope de coroutines ligado al ciclo de vida del ViewModel
import androidx.lifecycle.viewModelScope
// launch inicia una coroutine
import kotlinx.coroutines.launch

// AndroidViewModel en lugar de ViewModel porque necesitamos el contexto
// para acceder a la base de datos
// NUNCA guardar una referencia a una Activity en el ViewModel (causa memory leaks)
// Application es seguro porque vive tanto como la app
class MainViewModel(application: Application) : AndroidViewModel(application) {

    // Obtener el DAO de la base de datos
    // El DAO es nuestra puerta de entrada a la base de datos
    private val dao = AppDatabase.obtenerInstancia(application).transaccionDao()

    // LiveData que viene directamente de Room
    // Room actualiza estos LiveData automáticamente cuando la tabla cambia
    // No necesitamos MutableLiveData porque Room se encarga de todo
    val transacciones: LiveData<List<Transaccion>> = dao.obtenerTodas()
    val balance: LiveData<Double> = dao.obtenerBalance()
    val ingresos: LiveData<Double> = dao.obtenerTotalIngresos()
    val gastos: LiveData<Double> = dao.obtenerTotalGastos()
    val cantidad: LiveData<Int> = dao.obtenerCantidad()

    // init se ejecuta al crear el ViewModel
    init {
        // No cargamos datos aquí porque LiveData de Room necesita un observer activo
        // para tener un .value. La carga de datos de prueba se hace desde la Activity
        // cuando observa que la lista está vacía (ver MainActivity.kt)
    }

    // Función pública para insertar datos de prueba
    // Se llama desde la Activity cuando detecta que la lista está vacía
    fun insertarDatosDePrueba() {
        viewModelScope.launch {
            // insertarTodas es una función suspend del DAO
            // Se ejecuta en segundo plano gracias a la coroutine
            dao.insertarTodas(Transaccion.datosDePrueba())
        }
    }

    // Agrega una nueva transacción a la base de datos
    fun agregarTransaccion(transaccion: Transaccion) {
        // launch inicia una coroutine para ejecutar la operación en segundo plano
        viewModelScope.launch {
            // insertar es suspend: no bloquea el hilo principal
            dao.insertar(transaccion)
            // No necesitamos actualizar LiveData manualmente
            // Room notifica automáticamente a todos los observadores
        }
    }

    // Elimina una transacción de la base de datos
    fun eliminarTransaccion(transaccion: Transaccion) {
        viewModelScope.launch {
            dao.eliminar(transaccion)
        }
    }

    // Elimina todas las transacciones
    fun eliminarTodas() {
        viewModelScope.launch {
            dao.eliminarTodas()
        }
    }
}
```

---

## 8.7 Actualizar AgregarActivity

✏️ Modificar `AgregarActivity.kt` — actualizar `crearTransaccion()` para usar `categoriaNombre`:

```kotlin
// AgregarActivity.kt
// Pantalla para agregar una nueva transacción (actualizada para Room)
package com.ejemplo.misfinanzas

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.content.Intent
import android.widget.ArrayAdapter
import android.widget.Toast
import com.ejemplo.misfinanzas.databinding.ActivityAgregarBinding

class AgregarActivity : AppCompatActivity() {

    private lateinit var binding: ActivityAgregarBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityAgregarBinding.inflate(layoutInflater)
        setContentView(binding.root)

        configurarSpinnerCategorias()
        configurarBotones()
    }

    // Llena el Spinner con las categorías del enum
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

    // Configura las acciones de los botones
    private fun configurarBotones() {
        binding.btnGuardar.setOnClickListener {
            val transaccion = crearTransaccion()
            if (transaccion != null) {
                devolverResultado(transaccion)
            }
        }

        binding.btnCancelar.setOnClickListener {
            finish()
        }
    }

    // Valida los campos y crea una Transaccion
    private fun crearTransaccion(): Transaccion? {
        val descripcion = binding.etDescripcion.text.toString().trim()
        val montoTexto = binding.etMonto.text.toString().trim()

        // Validar descripción
        if (descripcion.isEmpty()) {
            binding.tilDescripcion.error = "La descripción es obligatoria"
            return null
        } else {
            binding.tilDescripcion.error = null
        }

        // Validar monto
        if (montoTexto.isEmpty()) {
            binding.tilMonto.error = "El monto es obligatorio"
            return null
        }

        val montoNumero = montoTexto.toDoubleOrNull()
        if (montoNumero == null || montoNumero <= 0) {
            binding.tilMonto.error = "Ingresa un monto válido mayor a 0"
            return null
        } else {
            binding.tilMonto.error = null
        }

        // Determinar signo según tipo
        val esGasto = binding.rbGasto.isChecked
        val montoFinal = if (esGasto) -montoNumero else montoNumero

        // Obtener la categoría seleccionada
        val categoriaIndex = binding.spCategoria.selectedItemPosition
        val categoria = Categoria.values()[categoriaIndex]

        // Crear la transacción con categoriaNombre (String) para Room
        // id = 0 para que Room lo genere automáticamente (autoGenerate)
        return Transaccion(
            id = 0,
            monto = montoFinal,
            descripcion = descripcion,
            categoriaNombre = categoria.name  // .name convierte el enum a String
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

## 8.8 Actualizar MainActivity para Room

✏️ Modificar `MainActivity.kt`:

```kotlin
// MainActivity.kt
// Pantalla principal con persistencia Room
package com.ejemplo.misfinanzas

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.content.Intent
import android.widget.Toast
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import com.ejemplo.misfinanzas.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private val viewModel: MainViewModel by viewModels()
    private lateinit var adapter: TransaccionAdapter

    // Callback para recibir resultado de AgregarActivity
    private val lanzarAgregar = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { resultado ->
        if (resultado.resultCode == RESULT_OK) {
            val nueva = resultado.data?.getSerializableExtra("NUEVA_TRANSACCION") as? Transaccion
            if (nueva != null) {
                // Delegar al ViewModel que guarda en Room
                viewModel.agregarTransaccion(nueva)
                Toast.makeText(this, "Transacción guardada", Toast.LENGTH_SHORT).show()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        configurarRecyclerView()
        observarDatos()

        // Botón de agregar
        binding.btnAgregar.setOnClickListener {
            val intent = Intent(this, AgregarActivity::class.java)
            lanzarAgregar.launch(intent)
        }
    }

    private fun configurarRecyclerView() {
        adapter = TransaccionAdapter(emptyList()) { transaccion ->
            Toast.makeText(
                this,
                "${transaccion.descripcion}: ${transaccion.montoFormateado()}",
                Toast.LENGTH_SHORT
            ).show()
        }
        binding.rvTransacciones.layoutManager = LinearLayoutManager(this)
        binding.rvTransacciones.adapter = adapter
    }

    // Observar los LiveData del ViewModel
    // Room actualiza estos LiveData automáticamente cuando la base de datos cambia
    private fun observarDatos() {
        // Observar la lista de transacciones
        viewModel.transacciones.observe(this) { lista ->
            // Recrear el adapter con la nueva lista
            adapter = TransaccionAdapter(lista) { transaccion ->
                Toast.makeText(
                    this,
                    "${transaccion.descripcion}: ${transaccion.montoFormateado()}",
                    Toast.LENGTH_SHORT
                ).show()
            }
            binding.rvTransacciones.adapter = adapter

            // Si la lista está vacía, cargar datos de prueba
            if (lista.isEmpty()) {
                viewModel.insertarDatosDePrueba()
            }
        }

        // Observar el balance
        viewModel.balance.observe(this) { balance ->
            binding.tvBalance.text = formatearMonto(balance)
        }

        // Observar ingresos
        viewModel.ingresos.observe(this) { ingresos ->
            binding.tvIngresos.text = formatearMonto(ingresos)
        }

        // Observar gastos
        viewModel.gastos.observe(this) { gastos ->
            binding.tvGastos.text = formatearMonto(gastos)
        }

        // Observar cantidad
        viewModel.cantidad.observe(this) { cantidad ->
            binding.tvNumTransacciones.text = "$cantidad"
        }
    }

    private fun formatearMonto(monto: Double): String {
        return "$ ${String.format("%,.0f", monto)}"
    }
}
```

---

## 8.9 Compilar y probar

▶️ Compilar y ejecutar. Ahora:
1. Las transacciones de ejemplo se cargan automáticamente
2. Agregar nuevas transacciones con el botón "+"
3. **Cerrar la app completamente** (deslizar desde recientes)
4. Volver a abrir la app
5. **Los datos siguen ahí** porque están guardados en la base de datos

---

## 8.10 ¿Qué cambió respecto al capítulo anterior?

| Antes (sin Room) | Ahora (con Room) |
|-------------------|------------------|
| Datos en memoria (se pierden al cerrar) | Datos en SQLite (persisten) |
| MutableLiveData manual | LiveData directo de Room |
| Recalcular totales manualmente | Consultas SQL calculan los totales |
| `ViewModel` | `AndroidViewModel` (necesita contexto) |

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| `@Entity` | Definir una tabla de la base de datos |
| `@PrimaryKey(autoGenerate = true)` | Clave primaria autoincremental |
| `@Dao` | Interfaz con las operaciones de la base de datos |
| `@Query` | Consulta SQL personalizada |
| `@Insert` / `@Update` / `@Delete` | Operaciones CRUD automáticas |
| `@Database` | Clase principal de la base de datos |
| `LiveData` desde Room | Se actualiza automáticamente cuando la tabla cambia |
| `suspend` en DAO | Operaciones de escritura en segundo plano |
| `viewModelScope.launch` | Ejecutar operaciones suspend en una coroutine |
| `AndroidViewModel` | ViewModel que recibe Application como contexto |
| Patrón Singleton | Garantizar una sola instancia de la base de datos |

---

**Anterior:** [← Capítulo 7 — Ciclo de vida y ViewModel](07_ciclo_vida_viewmodel.md) | **Siguiente:** [Capítulo 9 — Formularios y validación →](09_formularios_validacion.md)
