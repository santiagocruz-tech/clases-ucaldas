# Guía de Kotlin y Android Studio — Aprende Construyendo

## Proyecto: MisFinanzas 💰

Esta guía enseña desarrollo Android nativo con Kotlin a través de **un único proyecto** que crece de forma incremental: una app de finanzas personales llamada **MisFinanzas**.

Cada capítulo agrega funcionalidad real al proyecto. Cada línea de código está comentada. La dificultad sube gradualmente desde "Hola Mundo" hasta una app completa con arquitectura MVVM, base de datos local, consumo de APIs y navegación por pestañas.

---

## ¿Qué vamos a construir?

**MisFinanzas** es una app donde el usuario puede:
- Registrar ingresos y gastos
- Ver un resumen con el balance actual
- Categorizar transacciones (comida, transporte, salario, etc.)
- Ver estadísticas de gastos por categoría
- Consultar tasas de cambio desde una API
- Persistir los datos localmente con Room
- Navegar entre secciones con Bottom Navigation

Al final del curso, tendrán una app funcional que demuestra todos los conceptos fundamentales de Android.

---

## Índice de capítulos

| # | Capítulo | Qué se aprende | Qué se agrega al proyecto |
|---|---------|----------------|--------------------------|
| 00 | [Configuración del entorno](00_entorno.md) | Instalar herramientas, alternativas para hardware limitado | Nada (preparación) |
| 01 | [Proyecto base](01_proyecto_base.md) | Crear proyecto, estructura de archivos, primer Activity | Proyecto vacío con "Hola Mundo" |
| 02 | [Kotlin básico](02_kotlin_basico.md) | Variables, tipos, funciones, control de flujo | Lógica básica de cálculo de balance |
| 03 | [Layouts y vistas](03_layouts_vistas.md) | XML, LinearLayout, ConstraintLayout, View Binding | Pantalla principal con resumen de balance |
| 04 | [Kotlin intermedio](04_kotlin_intermedio.md) | Clases, data classes, herencia, interfaces, enums | Modelo de datos `Transaccion` |
| 05 | [Listas con RecyclerView](05_listas_recyclerview.md) | RecyclerView, Adapter, ViewHolder, CardView | Lista de transacciones en pantalla |
| 06 | [Navegación entre pantallas](06_navegacion.md) | Intents, pasar datos, regresar con resultado | Pantalla para agregar transacción |
| 07 | [Ciclo de vida y ViewModel](07_ciclo_vida_viewmodel.md) | Ciclo de vida, ViewModel, LiveData | Estado que sobrevive rotaciones |
| 08 | [Persistencia con Room](08_persistencia_room.md) | Room, Entity, DAO, Database | Datos guardados en SQLite |
| 09 | [Formularios y validación](09_formularios_validacion.md) | TextInputLayout, validación, Material Design | Formulario mejorado con validación |
| 10 | [Fragments y Bottom Navigation](10_fragments_navegacion.md) | Fragments, BottomNavigationView, menús | App con 3 pestañas |
| 11 | [Consumo de APIs con Retrofit](11_retrofit_api.md) | Retrofit, Gson, coroutines básicas | Consulta de tasas de cambio |
| 12 | [Arquitectura MVVM](12_arquitectura_mvvm.md) | Repository pattern, separación de capas | Refactorización completa |
| 13 | [Kotlin avanzado](13_kotlin_avanzado.md) | Coroutines, sealed classes, extension functions, lambdas | Manejo de estados, código más limpio |
| 14 | [Proyecto final](14_proyecto_final.md) | Buenas prácticas, pulido, resumen | App terminada y pulida |

---

## Requisitos previos

- Conocimientos básicos de programación (variables, funciones, condicionales, ciclos)
- Tener instalado alguno de estos: Android Studio, IntelliJ IDEA Community, o VS Code con el SDK de Android (ver capítulo 00)
- Un celular Android con cable USB o un emulador configurado

---

## Cómo usar esta guía

1. **Sigan el orden.** Cada capítulo depende del anterior.
2. **Escriban el código ustedes mismos.** No copien y peguen. Escribir ayuda a memorizar.
3. **Lean los comentarios.** Cada línea tiene una explicación de por qué está ahí.
4. **Compilen después de cada cambio.** No acumulen código sin probar.
5. **Si algo falla,** lean el error completo. El 90% de los errores se resuelven leyendo el mensaje.

---

## Convenciones de esta guía

- 📁 indica que hay que crear un archivo nuevo
- ✏️ indica que hay que modificar un archivo existente
- 🔧 indica configuración o dependencias
- ▶️ indica que hay que compilar y probar
- 💡 indica un tip o nota importante
