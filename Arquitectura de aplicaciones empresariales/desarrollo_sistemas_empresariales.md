# Desarrollo de Sistemas Empresariales

## Material de Clase Completo

---

> **Asignatura:** Desarrollo de Sistemas Empresariales  
> **Enfoque:** Teórico-Práctico | Aprendizaje Basado en Proyectos (ABP)  
> **Metodología:** Desarrollo incremental de un proyecto integrador durante el semestre

---

## Tabla de Contenidos

1. [Unidad 1: Fundamentos de los Sistemas Empresariales](#unidad-1-fundamentos-de-los-sistemas-empresariales)
2. [Unidad 2: Procesos de Negocio y Análisis Organizacional](#unidad-2-procesos-de-negocio-y-análisis-organizacional)
3. [Unidad 3: Requerimientos y Alcance del Proyecto](#unidad-3-requerimientos-y-alcance-del-proyecto)
4. [Unidad 4: Arquitectura de Sistemas Empresariales](#unidad-4-arquitectura-de-sistemas-empresariales)
5. [Unidad 5: Datos, Integración y Seguridad](#unidad-5-datos-integración-y-seguridad)
6. [Unidad 6: Desarrollo del Proyecto Empresarial](#unidad-6-desarrollo-del-proyecto-empresarial)
7. [Unidad 7: Despliegue, Evaluación y Sostenibilidad](#unidad-7-despliegue-evaluación-y-sostenibilidad)
8. [Metodología y Evaluación](#metodología-y-evaluación)
9. [Glosario](#glosario)
10. [Referencias Bibliográficas](#referencias-bibliográficas)

---

## Objetivos de la Asignatura

### Objetivo General

Formar al estudiante en el análisis, diseño y desarrollo de sistemas empresariales, integrando metodologías de ingeniería de software, modelado de procesos, análisis As-Is / To-Be y arquitectura C4, con el fin de construir soluciones alineadas con las necesidades estratégicas y operativas de las organizaciones.

### Objetivos Específicos

- Comprender los conceptos fundamentales, la importancia y los principales tipos de sistemas empresariales en el contexto organizacional.
- Analizar procesos de negocio y necesidades organizacionales para identificar oportunidades de mejora y transformación digital.
- Elaborar modelos As-Is y To-Be como insumo para la definición de requerimientos y rediseño de procesos.
- Aplicar principios de arquitectura de software empresarial utilizando el modelo C4 para representar contextos, contenedores y componentes.
- Diseñar soluciones empresariales considerando integración, datos, seguridad, escalabilidad y mantenibilidad.
- Desarrollar de manera incremental un proyecto de sistema empresarial que articule análisis funcional, diseño técnico y validación de la solución.
- Fortalecer la capacidad de argumentar decisiones de diseño y de comunicar propuestas técnicas a públicos de negocio y de tecnología.

### Resultados de Aprendizaje

| Código | Resultado de Aprendizaje |
|--------|--------------------------|
| R1 | Analiza problemas organizacionales e identifica requerimientos funcionales y no funcionales para la construcción de sistemas empresariales pertinentes al contexto del negocio. |
| R2 | Modela procesos actuales y futuros mediante enfoques As-Is y To-Be, proponiendo mejoras alineadas con objetivos estratégicos y operativos. |
| R3 | Diseña la arquitectura de una solución empresarial utilizando diagramas del modelo C4, estableciendo relaciones claras entre actores, sistemas, contenedores y componentes. |
| R4 | Construye una propuesta de solución tecnológica viable, integrando criterios de arquitectura, datos, seguridad, escalabilidad y sostenibilidad del sistema. |
| R5 | Desarrolla y presenta un proyecto integrador de sistema empresarial, justificando técnica y funcionalmente las decisiones tomadas durante su evolución. |

---

## Unidad 1: Fundamentos de los Sistemas Empresariales

### 1.1 ¿Qué es un Sistema Empresarial?

Un **sistema empresarial** (Enterprise System) es un conjunto integrado de software, datos, procesos y personas que soporta las operaciones, la gestión y la toma de decisiones de una organización. A diferencia de una aplicación aislada, un sistema empresarial se caracteriza por:

- **Alcance organizacional:** Abarca múltiples departamentos, áreas funcionales o incluso organizaciones completas.
- **Integración de procesos:** Conecta flujos de trabajo que antes operaban de forma independiente.
- **Base de datos centralizada o federada:** Permite una visión unificada de la información del negocio.
- **Soporte multiusuario:** Atiende a diferentes roles con distintos niveles de acceso y funcionalidad.
- **Alineación estratégica:** Responde a objetivos de negocio, no solo a necesidades técnicas.

#### Ejemplo cotidiano

Piense en una universidad: el sistema de matrícula, el sistema de notas, el sistema financiero y el sistema de biblioteca pueden funcionar como aplicaciones separadas. Un sistema empresarial universitario los integra para que cuando un estudiante se matricule, automáticamente se genere su factura, se le asignen horarios y se le habilite el acceso a recursos bibliográficos.

### 1.2 Diferencia entre Software Operativo, Transaccional y Estratégico

Es fundamental distinguir los niveles en los que el software actúa dentro de una organización:

| Nivel | Descripción | Ejemplo | Usuarios típicos |
|-------|-------------|---------|-------------------|
| **Operativo** | Soporta las actividades diarias y rutinarias del negocio. Automatiza tareas repetitivas. | Sistema de punto de venta, registro de asistencia | Empleados operativos, cajeros |
| **Transaccional** | Gestiona transacciones de negocio completas, asegurando integridad y consistencia de datos. | Sistema de facturación, gestión de pedidos, contabilidad | Analistas, supervisores, contadores |
| **Estratégico** | Proporciona información consolidada para la toma de decisiones a nivel gerencial y directivo. | Dashboard ejecutivo, sistema de inteligencia de negocios | Gerentes, directores, CEO |

#### Relación entre niveles

```
┌─────────────────────────────────────────┐
│         NIVEL ESTRATÉGICO               │
│   (BI, DSS, Dashboards ejecutivos)      │
│   Decisiones de largo plazo             │
├─────────────────────────────────────────┤
│         NIVEL TRANSACCIONAL             │
│   (ERP, CRM, SCM)                       │
│   Gestión de procesos de negocio        │
├─────────────────────────────────────────┤
│         NIVEL OPERATIVO                 │
│   (POS, registro, automatización)       │
│   Operaciones del día a día             │
└─────────────────────────────────────────┘
```

### 1.3 Importancia de los Sistemas Empresariales en las Organizaciones

Los sistemas empresariales son el sistema nervioso digital de las organizaciones modernas. Su importancia radica en:

1. **Eficiencia operativa:** Eliminan redundancias, automatizan procesos manuales y reducen errores humanos.
2. **Visibilidad del negocio:** Proporcionan información en tiempo real sobre el estado de las operaciones.
3. **Toma de decisiones informada:** Consolidan datos de múltiples fuentes para generar reportes y análisis.
4. **Estandarización de procesos:** Imponen flujos de trabajo consistentes en toda la organización.
5. **Escalabilidad:** Permiten que la organización crezca sin que sus procesos colapsen.
6. **Cumplimiento regulatorio:** Facilitan la auditoría, trazabilidad y cumplimiento de normativas.
7. **Ventaja competitiva:** Las organizaciones con mejores sistemas pueden responder más rápido al mercado.

#### Caso de reflexión

> Una empresa de distribución de alimentos maneja sus pedidos en hojas de cálculo, su inventario en un cuaderno y su facturación en un software independiente. Cuando un cliente hace un pedido, el vendedor debe verificar manualmente el inventario, luego pasar la información al área de despacho y finalmente al área contable. ¿Qué problemas puede generar esta situación? ¿Cómo un sistema empresarial integrado resolvería estos problemas?


### 1.4 Tipos de Sistemas Empresariales

#### ERP (Enterprise Resource Planning) — Planificación de Recursos Empresariales

El ERP es el tipo de sistema empresarial más conocido. Integra los procesos centrales de una organización en una sola plataforma.

**Módulos típicos de un ERP:**

```
┌──────────────────────────────────────────────────────┐
│                    ERP CENTRAL                        │
├──────────┬──────────┬──────────┬──────────┬──────────┤
│ Finanzas │  RRHH    │Inventario│ Compras  │Producción│
│          │          │          │          │          │
│-Contab.  │-Nómina   │-Stock    │-Órdenes  │-Planif.  │
│-Presup.  │-Selección│-Almacén  │-Proveed. │-Calidad  │
│-Tesorería│-Capacit. │-Logística│-Contratos│-Costos   │
└──────────┴──────────┴──────────┴──────────┴──────────┘
```

**Ejemplos reales:** SAP S/4HANA, Oracle ERP Cloud, Microsoft Dynamics 365, Odoo (open source).

**Características clave:**
- Base de datos única y centralizada
- Flujos de trabajo integrados entre módulos
- Reportes consolidados en tiempo real
- Configuración por roles y permisos

#### CRM (Customer Relationship Management) — Gestión de Relaciones con el Cliente

El CRM se enfoca en gestionar todas las interacciones de la organización con sus clientes actuales y potenciales.

**Funcionalidades principales:**
- Gestión de contactos y cuentas
- Pipeline de ventas (embudo de ventas)
- Automatización de marketing
- Servicio al cliente y soporte (tickets)
- Análisis de comportamiento del cliente

**Ejemplos reales:** Salesforce, HubSpot, Zoho CRM, Microsoft Dynamics CRM.

#### SCM (Supply Chain Management) — Gestión de la Cadena de Suministro

El SCM gestiona el flujo de bienes, información y recursos desde el proveedor hasta el cliente final.

**Procesos que cubre:**
- Planificación de la demanda
- Gestión de proveedores
- Logística y distribución
- Gestión de inventarios
- Trazabilidad de productos

**Ejemplos reales:** SAP SCM, Oracle SCM Cloud, Blue Yonder.

#### BI (Business Intelligence) — Inteligencia de Negocios

Los sistemas de BI transforman datos crudos en información útil para la toma de decisiones.

**Componentes típicos:**
- ETL (Extract, Transform, Load): Extracción y transformación de datos
- Data Warehouse: Almacén de datos consolidado
- OLAP (Online Analytical Processing): Análisis multidimensional
- Dashboards y reportes interactivos
- Minería de datos y análisis predictivo

**Ejemplos reales:** Power BI, Tableau, QlikSense, Looker.

#### BPM (Business Process Management) — Gestión de Procesos de Negocio

Los sistemas BPM permiten modelar, automatizar, ejecutar y optimizar los procesos de negocio.

**Ciclo BPM:**

```
    Modelar → Automatizar → Ejecutar → Monitorear → Optimizar
       ↑                                                  │
       └──────────────────────────────────────────────────┘
                      Mejora continua
```

**Ejemplos reales:** Bizagi, Camunda, Bonita BPM, Appian.

#### Tabla comparativa

| Sistema | Enfoque principal | Usuarios clave | Valor para la organización |
|---------|-------------------|----------------|---------------------------|
| ERP | Procesos internos integrados | Toda la organización | Eficiencia operativa |
| CRM | Relación con el cliente | Ventas, marketing, soporte | Retención y crecimiento de clientes |
| SCM | Cadena de suministro | Logística, compras, producción | Optimización de costos y tiempos |
| BI | Análisis de datos | Gerencia, analistas | Decisiones basadas en datos |
| BPM | Procesos de negocio | Analistas de procesos, TI | Agilidad y mejora continua |

### 1.5 El Rol del Software en la Transformación Digital

La **transformación digital** no es simplemente digitalizar procesos existentes; es repensar cómo la tecnología puede crear nuevos modelos de negocio, mejorar la experiencia del cliente y generar ventajas competitivas.

**Pilares de la transformación digital:**

1. **Experiencia del cliente:** Interfaces digitales, omnicanalidad, personalización.
2. **Procesos operativos:** Automatización, integración, eficiencia.
3. **Modelos de negocio:** Nuevas formas de generar valor mediante tecnología.
4. **Cultura organizacional:** Mentalidad digital, agilidad, innovación.

**El software como habilitador:**

```
Necesidad del negocio → Proceso rediseñado → Solución tecnológica → Valor generado
```

El desarrollador de sistemas empresariales no es solo un programador: es un profesional que entiende el negocio, traduce necesidades en soluciones y construye software que genera valor organizacional.

#### Actividad práctica — Unidad 1

> **Taller 1: Análisis de sistemas empresariales**
>
> 1. Seleccione una organización real (puede ser la universidad, una empresa local o una empresa conocida).
> 2. Identifique al menos 3 sistemas de información que utiliza.
> 3. Clasifique cada sistema según su nivel (operativo, transaccional, estratégico).
> 4. Identifique qué tipo de sistema empresarial (ERP, CRM, SCM, BI, BPM) se relaciona con cada uno.
> 5. Proponga una mejora que podría lograrse integrando dos o más de estos sistemas.
> 6. Presente sus hallazgos en un documento de máximo 3 páginas.

---


## Unidad 2: Procesos de Negocio y Análisis Organizacional

### 2.1 Introducción a los Procesos de Negocio

Un **proceso de negocio** es un conjunto de actividades interrelacionadas que transforman entradas (inputs) en salidas (outputs) con valor para un cliente interno o externo.

**Elementos de un proceso de negocio:**

| Elemento | Descripción | Ejemplo (proceso de venta) |
|----------|-------------|---------------------------|
| **Entrada** | Insumo que inicia el proceso | Solicitud de cotización del cliente |
| **Actividades** | Pasos que transforman la entrada | Verificar inventario, calcular precio, generar cotización |
| **Actores** | Personas o sistemas que ejecutan actividades | Vendedor, sistema de inventario |
| **Reglas** | Condiciones que determinan el flujo | Si el monto > $10,000, requiere aprobación del gerente |
| **Salida** | Resultado del proceso | Cotización enviada al cliente |
| **Indicador** | Métrica para medir el desempeño | Tiempo promedio de respuesta a cotización |

**Tipos de procesos:**

- **Procesos estratégicos:** Definen la dirección de la organización (planificación estratégica, gestión de la innovación).
- **Procesos operativos (core):** Generan valor directo al cliente (producción, ventas, servicio al cliente).
- **Procesos de soporte:** Apoyan a los procesos operativos (RRHH, TI, contabilidad).

```
┌─────────────────────────────────────────────────────┐
│              PROCESOS ESTRATÉGICOS                   │
│   Planificación | Innovación | Gestión de calidad    │
├─────────────────────────────────────────────────────┤
│              PROCESOS OPERATIVOS (CORE)              │
│   Marketing → Ventas → Producción → Distribución     │
├─────────────────────────────────────────────────────┤
│              PROCESOS DE SOPORTE                     │
│   RRHH | Finanzas | TI | Compras | Legal             │
└─────────────────────────────────────────────────────┘
```

### 2.2 Identificación de Actores, Áreas y Flujos de Información

Para analizar una organización, debemos identificar:

#### Actores

Son las personas, roles o sistemas que participan en los procesos.

**Clasificación de actores:**
- **Actores internos:** Empleados, departamentos, sistemas internos.
- **Actores externos:** Clientes, proveedores, entidades reguladoras, socios.

#### Áreas funcionales

Son las divisiones organizacionales que agrupan funciones relacionadas.

**Ejemplo de mapa de áreas:**

```
                    ┌──────────────┐
                    │  Dirección   │
                    │   General    │
                    └──────┬───────┘
           ┌───────────────┼───────────────┐
    ┌──────┴──────┐ ┌──────┴──────┐ ┌──────┴──────┐
    │   Comercial │ │  Operaciones│ │  Finanzas   │
    │             │ │             │ │             │
    │ -Ventas     │ │ -Producción │ │ -Contabilid.│
    │ -Marketing  │ │ -Logística  │ │ -Tesorería  │
    │ -Servicio   │ │ -Calidad    │ │ -Presupuesto│
    └─────────────┘ └─────────────┘ └─────────────┘
```

#### Flujos de información

Representan cómo se mueve la información entre actores y áreas.

**Ejemplo de flujo de información en un proceso de compra:**

```
Área solicitante          Compras              Proveedor           Almacén
      │                      │                     │                  │
      │──Requisición────────>│                     │                  │
      │                      │──Solicitud cotiz.──>│                  │
      │                      │<──Cotización────────│                  │
      │<──Aprobación─────────│                     │                  │
      │                      │──Orden de compra───>│                  │
      │                      │                     │──Despacho───────>│
      │                      │                     │                  │──Recepción
      │                      │<──────────────────────────Notificación─│
```

### 2.3 Levantamiento de Requerimientos Orientado al Negocio

El levantamiento de requerimientos en sistemas empresariales tiene una particularidad: debe partir del entendimiento del negocio, no de la tecnología.

**Técnicas de levantamiento:**

| Técnica | Descripción | Cuándo usarla |
|---------|-------------|---------------|
| **Entrevistas** | Conversaciones estructuradas con stakeholders | Para entender la visión y necesidades de cada rol |
| **Observación directa** | Observar cómo se ejecutan los procesos actualmente | Para identificar pasos no documentados |
| **Talleres (workshops)** | Sesiones grupales con múltiples stakeholders | Para alinear visiones y resolver conflictos |
| **Análisis documental** | Revisión de documentos, formatos, reportes existentes | Para entender reglas de negocio formales |
| **Cuestionarios** | Formularios estructurados | Para recopilar información de muchos usuarios |
| **Prototipado** | Maquetas o prototipos de la solución | Para validar entendimiento con el usuario |

**Preguntas clave para el levantamiento:**

1. ¿Cuál es el objetivo de este proceso?
2. ¿Quiénes participan y qué rol cumplen?
3. ¿Qué información se necesita para iniciar?
4. ¿Qué decisiones se toman durante el proceso?
5. ¿Qué problemas o dificultades existen actualmente?
6. ¿Qué resultados se esperan?
7. ¿Cómo se mide el éxito del proceso?

### 2.4 Análisis del Estado Actual (As-Is)

El modelo **As-Is** ("como es") documenta cómo funcionan los procesos actualmente, sin idealizaciones ni mejoras. Es una fotografía del estado real.

**¿Por qué es importante?**
- Establece una línea base para medir mejoras.
- Identifica problemas, redundancias y cuellos de botella.
- Permite que todos los stakeholders tengan una visión compartida.
- Sirve como insumo para diseñar el estado futuro.

**Elementos del modelo As-Is:**

```
┌─────────────────────────────────────────────────────────┐
│                    MODELO AS-IS                          │
├─────────────────────────────────────────────────────────┤
│ 1. Mapa de procesos actual                              │
│ 2. Diagrama de flujo detallado de cada proceso          │
│ 3. Actores y roles involucrados                         │
│ 4. Sistemas y herramientas utilizadas actualmente       │
│ 5. Datos e información que fluyen entre actividades     │
│ 6. Tiempos promedio de cada actividad                   │
│ 7. Problemas identificados (pain points)                │
│ 8. Reglas de negocio actuales                           │
└─────────────────────────────────────────────────────────┘
```

**Ejemplo de diagrama As-Is (proceso de aprobación de crédito):**

```
CLIENTE           ASESOR              ANALISTA           COMITÉ
   │                 │                    │                  │
   │──Solicitud──>   │                    │                  │
   │  (presencial)   │                    │                  │
   │                 │──Recibe docs───>   │                  │
   │                 │  (papel)           │                  │
   │                 │                    │──Verifica────>   │
   │                 │                    │  (manual, 3 días)│
   │                 │                    │                  │──Decide
   │                 │                    │                  │  (reunión
   │                 │                    │<──Resultado──────│   semanal)
   │                 │<──Notifica─────────│                  │
   │<──Llama─────────│                    │                  │
   │  (teléfono)     │                    │                  │
   
   ⚠ Problemas identificados:
   - Proceso 100% presencial y en papel
   - Verificación manual toma 3 días
   - Comité solo se reúne una vez por semana
   - Notificación al cliente por teléfono (puede no contestar)
   - No hay trazabilidad del estado de la solicitud
```

### 2.5 Identificación de Problemas, Cuellos de Botella y Oportunidades de Mejora

Una vez documentado el As-Is, se analizan los problemas:

**Categorías de problemas comunes:**

| Categoría | Descripción | Indicadores |
|-----------|-------------|-------------|
| **Cuellos de botella** | Puntos donde el flujo se detiene o ralentiza | Tiempos de espera altos, acumulación de trabajo |
| **Redundancias** | Actividades duplicadas o información ingresada múltiples veces | Mismos datos en diferentes sistemas |
| **Errores frecuentes** | Actividades propensas a errores humanos | Reprocesos, quejas, inconsistencias |
| **Falta de visibilidad** | No se puede conocer el estado de un proceso | Preguntas frecuentes tipo "¿en qué va mi solicitud?" |
| **Dependencias manuales** | Procesos que dependen de intervención humana innecesaria | Aprobaciones por correo, firmas físicas |
| **Islas de información** | Datos aislados en sistemas o archivos no conectados | Hojas de cálculo personales, sistemas legacy |

**Herramienta de análisis: Diagrama de Ishikawa (causa-efecto)**

```
        Personas        Procesos        Tecnología
            \              |              /
             \             |             /
              \            |            /
               ─────────────────────────
                    PROBLEMA:
               "Demora en aprobación
                   de créditos"
               ─────────────────────────
              /            |            \
             /             |             \
            /              |              \
        Datos          Políticas       Infraestructura
```

### 2.6 Diseño del Estado Futuro (To-Be)

El modelo **To-Be** ("como será") representa el proceso rediseñado, incorporando mejoras y soluciones tecnológicas.

**Principios para el diseño To-Be:**

1. **Eliminar:** Actividades que no agregan valor.
2. **Simplificar:** Reducir la complejidad de actividades necesarias.
3. **Automatizar:** Usar tecnología para actividades repetitivas.
4. **Integrar:** Conectar sistemas y datos que hoy están aislados.
5. **Paralelizar:** Ejecutar actividades simultáneamente cuando sea posible.

**Ejemplo de diagrama To-Be (mismo proceso de aprobación de crédito):**

```
CLIENTE              SISTEMA              ANALISTA          SISTEMA
   │                    │                    │                 │
   │──Solicitud──>      │                    │                 │
   │  (portal web)      │                    │                 │
   │                    │──Verifica auto──>   │                 │
   │                    │  (scoring, 5 min)   │                 │
   │                    │                     │                 │
   │                    │──[Si score OK]──────────────────>     │
   │                    │  Aprobación automática               │
   │                    │                                      │
   │                    │──[Si requiere revisión]──>│           │
   │                    │                          │──Revisa    │
   │                    │                          │  (1 día)   │
   │                    │<─────────────────────────│            │
   │<──Notificación─────│                          │            │
   │  (email + app)     │                          │            │
   
   ✅ Mejoras logradas:
   - Solicitud digital (portal web)
   - Verificación automática por scoring (de 3 días a 5 minutos)
   - Aprobación automática para casos de bajo riesgo
   - Revisión manual solo para casos excepcionales
   - Notificación multicanal (email + app)
   - Trazabilidad completa del proceso
```

**Tabla comparativa As-Is vs To-Be:**

| Aspecto | As-Is | To-Be | Mejora |
|---------|-------|-------|--------|
| Canal de solicitud | Presencial | Portal web | Accesibilidad 24/7 |
| Verificación | Manual (3 días) | Automática (5 min) | -99.8% tiempo |
| Aprobación | Comité semanal | Automática + excepciones | De 7 días a minutos |
| Notificación | Teléfono | Email + App | Multicanal, trazable |
| Trazabilidad | Ninguna | Completa | Visibilidad total |

#### Actividad práctica — Unidad 2

> **Taller 2: Análisis As-Is / To-Be**
>
> 1. Seleccione un proceso de negocio de la organización elegida en el Taller 1.
> 2. Documente el proceso actual (As-Is) incluyendo: actores, actividades, flujos de información, tiempos estimados y herramientas utilizadas.
> 3. Identifique al menos 5 problemas o puntos de dolor en el proceso actual.
> 4. Diseñe el proceso futuro (To-Be) aplicando los principios de mejora.
> 5. Elabore una tabla comparativa As-Is vs To-Be con las mejoras propuestas.
> 6. Justifique cada mejora desde la perspectiva del negocio.

---


## Unidad 3: Requerimientos y Alcance del Proyecto

### 3.1 Repaso Conceptual: Requerimientos Funcionales y No Funcionales

#### Requerimientos Funcionales (RF)

Describen **qué debe hacer** el sistema. Son las funcionalidades, comportamientos y operaciones que el sistema debe soportar.

**Características de un buen requerimiento funcional:**
- **Específico:** Describe una funcionalidad concreta.
- **Medible:** Se puede verificar si se cumple o no.
- **Alcanzable:** Es técnicamente viable.
- **Relevante:** Responde a una necesidad real del negocio.
- **Trazable:** Se puede rastrear hasta la necesidad que lo originó.

**Ejemplos:**

| ID | Requerimiento Funcional | Prioridad |
|----|------------------------|-----------|
| RF-001 | El sistema debe permitir registrar clientes con nombre, identificación, teléfono y correo electrónico. | Alta |
| RF-002 | El sistema debe generar automáticamente un número de pedido único al crear una nueva orden. | Alta |
| RF-003 | El sistema debe enviar una notificación por correo electrónico al cliente cuando su pedido cambie de estado. | Media |
| RF-004 | El sistema debe permitir generar reportes de ventas filtrados por fecha, vendedor y producto. | Media |
| RF-005 | El sistema debe calcular automáticamente el impuesto según la categoría del producto y la ubicación del cliente. | Alta |

#### Requerimientos No Funcionales (RNF)

Describen **cómo debe comportarse** el sistema. Son restricciones, cualidades y atributos de calidad.

**Categorías principales:**

| Categoría | Descripción | Ejemplo |
|-----------|-------------|---------|
| **Rendimiento** | Velocidad y capacidad de respuesta | El sistema debe responder en menos de 2 segundos para consultas estándar |
| **Disponibilidad** | Tiempo que el sistema está operativo | El sistema debe estar disponible el 99.5% del tiempo |
| **Seguridad** | Protección de datos y acceso | Las contraseñas deben almacenarse con hash bcrypt |
| **Escalabilidad** | Capacidad de crecer | El sistema debe soportar hasta 10,000 usuarios concurrentes |
| **Usabilidad** | Facilidad de uso | Un usuario nuevo debe poder completar un pedido en menos de 5 minutos |
| **Mantenibilidad** | Facilidad de modificar | El código debe seguir el patrón MVC y tener cobertura de pruebas > 80% |
| **Portabilidad** | Capacidad de funcionar en diferentes entornos | El sistema debe funcionar en Chrome, Firefox y Edge |
| **Interoperabilidad** | Capacidad de comunicarse con otros sistemas | El sistema debe exponer APIs REST para integración |

### 3.2 Historias de Usuario y Casos de Uso

#### Historias de Usuario

Formato ágil para expresar requerimientos desde la perspectiva del usuario.

**Formato estándar:**

```
Como [rol de usuario]
Quiero [acción o funcionalidad]
Para [beneficio o valor de negocio]
```

**Ejemplo completo con criterios de aceptación:**

```
Historia de Usuario: HU-003
Título: Consulta de estado de pedido

Como cliente registrado
Quiero consultar el estado actual de mis pedidos
Para saber cuándo recibiré mis productos

Criterios de aceptación:
  ✓ El cliente puede ver la lista de sus pedidos ordenados por fecha
  ✓ Cada pedido muestra: número, fecha, estado, monto total
  ✓ Los estados posibles son: Pendiente, En proceso, Enviado, Entregado, Cancelado
  ✓ El cliente puede filtrar por estado
  ✓ Al hacer clic en un pedido, se muestra el detalle con los productos
  ✓ Si el pedido está "Enviado", se muestra el número de guía de transporte

Prioridad: Alta
Estimación: 5 puntos de historia
```

#### Casos de Uso

Formato más formal que describe la interacción entre un actor y el sistema.

**Ejemplo de caso de uso:**

```
Caso de Uso: CU-005 — Registrar Pedido
Actor principal: Vendedor
Precondiciones: El vendedor ha iniciado sesión. El cliente existe en el sistema.
Postcondiciones: El pedido queda registrado con estado "Pendiente".

Flujo principal:
  1. El vendedor selecciona "Nuevo Pedido".
  2. El sistema solicita seleccionar o buscar un cliente.
  3. El vendedor selecciona el cliente.
  4. El sistema muestra los datos del cliente y un formulario de pedido vacío.
  5. El vendedor agrega productos al pedido (código o búsqueda).
  6. El sistema valida disponibilidad y muestra precio unitario.
  7. El vendedor indica la cantidad.
  8. El sistema calcula subtotal, impuestos y total.
  9. El vendedor confirma el pedido.
  10. El sistema genera el número de pedido y registra la transacción.
  11. El sistema muestra confirmación con el resumen del pedido.

Flujos alternativos:
  5a. El producto no existe → El sistema muestra mensaje de error.
  6a. No hay disponibilidad → El sistema indica stock actual y sugiere cantidad máxima.
  9a. El vendedor cancela → El sistema descarta el pedido sin registrar.

Flujos de excepción:
  *a. Pérdida de conexión → El sistema guarda borrador automáticamente.
```

### 3.3 Priorización de Requerimientos

No todos los requerimientos tienen la misma importancia. La priorización permite enfocar el esfuerzo en lo que genera más valor.

#### Método MoSCoW

| Categoría | Significado | Descripción |
|-----------|-------------|-------------|
| **M**ust have | Debe tener | Requerimientos esenciales. Sin ellos, el sistema no funciona. |
| **S**hould have | Debería tener | Importantes pero no críticos. El sistema funciona sin ellos, pero con limitaciones. |
| **C**ould have | Podría tener | Deseables. Mejoran la experiencia pero no son necesarios. |
| **W**on't have (this time) | No tendrá (por ahora) | Fuera del alcance actual. Se consideran para futuras versiones. |

**Ejemplo aplicado:**

```
MUST HAVE (Obligatorio):
  ☑ Registro de clientes
  ☑ Creación de pedidos
  ☑ Gestión de inventario básico
  ☑ Facturación

SHOULD HAVE (Importante):
  ☐ Notificaciones por email
  ☐ Reportes de ventas
  ☐ Dashboard de indicadores

COULD HAVE (Deseable):
  ☐ App móvil para vendedores
  ☐ Integración con pasarela de pagos
  ☐ Chat de soporte al cliente

WON'T HAVE (Futuro):
  ☐ Módulo de inteligencia artificial para predicción de demanda
  ☐ Integración con redes sociales
  ☐ Marketplace para terceros
```

#### Matriz de Valor vs Esfuerzo

```
         Alto valor
              │
    ┌─────────┼─────────┐
    │ HACER   │ PLANEAR  │
    │ PRIMERO │ CON      │
    │         │ CUIDADO  │
    │─────────┼──────────│
    │ VICTORIAS│ EVITAR  │
    │ RÁPIDAS │ O        │
    │         │ POSPONER │
    └─────────┼──────────┘
              │
         Bajo valor
    Bajo esfuerzo ──── Alto esfuerzo
```

### 3.4 Definición del Alcance del Proyecto

El alcance define los límites del proyecto: qué se incluye y qué no.

**Documento de alcance (estructura sugerida):**

```
1. NOMBRE DEL PROYECTO
   Sistema de Gestión de Pedidos — Distribuidora XYZ

2. OBJETIVO DEL PROYECTO
   Desarrollar un sistema web que permita gestionar el ciclo completo
   de pedidos, desde la solicitud hasta la entrega, integrando
   inventario, facturación y notificaciones.

3. ALCANCE INCLUIDO
   - Módulo de gestión de clientes
   - Módulo de catálogo de productos
   - Módulo de pedidos
   - Módulo de inventario
   - Módulo de facturación básica
   - Módulo de reportes

4. ALCANCE EXCLUIDO
   - Módulo de contabilidad (se integra con sistema existente)
   - Aplicación móvil nativa
   - Módulo de recursos humanos
   - Integración con transportadoras

5. SUPUESTOS
   - La empresa cuenta con infraestructura de red e internet
   - Los usuarios tienen conocimientos básicos de computación
   - Se dispondrá de un servidor para despliegue

6. RESTRICCIONES
   - Presupuesto limitado a $X
   - Plazo de entrega: 16 semanas
   - Equipo de desarrollo: 4 personas
   - Tecnología: Stack web (a definir en fase de arquitectura)

7. ENTREGABLES
   - Documento de requerimientos
   - Modelos As-Is y To-Be
   - Diagramas de arquitectura C4
   - Prototipo funcional
   - Sistema desplegado en ambiente de pruebas
   - Manual de usuario
   - Presentación final
```

### 3.5 Trazabilidad entre Necesidad del Negocio y Solución Propuesta

La **trazabilidad** asegura que cada decisión técnica responde a una necesidad real del negocio.

**Matriz de trazabilidad:**

| Necesidad del negocio | Proceso afectado | Requerimiento | Componente técnico | Criterio de validación |
|----------------------|------------------|---------------|-------------------|----------------------|
| Reducir tiempo de respuesta a cotizaciones | Ventas | RF-001: Generar cotización automática | Módulo de cotizaciones + Motor de precios | Cotización generada en < 1 minuto |
| Evitar ventas sin stock | Inventario + Ventas | RF-012: Validar disponibilidad en tiempo real | Servicio de inventario + API de consulta | 0% de pedidos con productos sin stock |
| Cumplir regulación fiscal | Facturación | RF-020: Generar factura electrónica | Módulo de facturación + Integración DIAN | 100% de facturas válidas ante la DIAN |

#### Actividad práctica — Unidad 3

> **Taller 3: Requerimientos y alcance**
>
> Para el proyecto seleccionado:
> 1. Escriba al menos 10 requerimientos funcionales y 5 no funcionales.
> 2. Redacte 5 historias de usuario con criterios de aceptación.
> 3. Desarrolle 2 casos de uso completos (flujo principal, alternativo y de excepción).
> 4. Priorice los requerimientos usando MoSCoW.
> 5. Elabore el documento de alcance del proyecto.
> 6. Construya una matriz de trazabilidad con al menos 5 entradas.

---


## Unidad 4: Arquitectura de Sistemas Empresariales

### 4.1 Fundamentos de Arquitectura de Software

La **arquitectura de software** es la estructura fundamental de un sistema, compuesta por sus componentes, las relaciones entre ellos y los principios que guían su diseño y evolución.

**¿Por qué importa la arquitectura?**

- Define cómo se organiza el código y los componentes.
- Determina los atributos de calidad del sistema (rendimiento, escalabilidad, seguridad).
- Facilita la comunicación entre equipos técnicos y de negocio.
- Reduce el riesgo de decisiones técnicas costosas de revertir.
- Permite que múltiples equipos trabajen en paralelo.

**Principios fundamentales:**

| Principio | Descripción |
|-----------|-------------|
| **Separación de responsabilidades** | Cada componente tiene una responsabilidad clara y definida |
| **Alta cohesión** | Los elementos dentro de un componente están fuertemente relacionados |
| **Bajo acoplamiento** | Los componentes dependen lo mínimo posible entre sí |
| **Abstracción** | Ocultar la complejidad interna y exponer interfaces simples |
| **Reutilización** | Diseñar componentes que puedan usarse en diferentes contextos |
| **Modularidad** | Dividir el sistema en módulos independientes y manejables |

### 4.2 Arquitectura por Capas

La arquitectura por capas es uno de los patrones más utilizados en sistemas empresariales. Organiza el sistema en niveles horizontales, donde cada capa tiene una responsabilidad específica.

**Modelo clásico de 3 capas:**

```
┌─────────────────────────────────────────────────┐
│            CAPA DE PRESENTACIÓN                  │
│                                                  │
│  Interfaz de usuario (Web, Móvil, Desktop)       │
│  Formularios, vistas, navegación                 │
│  Validaciones de entrada                         │
│                                                  │
├─────────────────────────────────────────────────┤
│            CAPA DE LÓGICA DE NEGOCIO             │
│                                                  │
│  Reglas de negocio                               │
│  Servicios y casos de uso                        │
│  Orquestación de procesos                        │
│  Validaciones de negocio                         │
│                                                  │
├─────────────────────────────────────────────────┤
│            CAPA DE DATOS                         │
│                                                  │
│  Acceso a base de datos                          │
│  Repositorios                                    │
│  Consultas y persistencia                        │
│  Integración con fuentes externas                │
│                                                  │
└─────────────────────────────────────────────────┘
```

**Modelo extendido para sistemas empresariales (N capas):**

```
┌──────────────────────────────────────────────────────┐
│  CAPA DE PRESENTACIÓN                                 │
│  (Web App, Mobile App, API Gateway)                   │
├──────────────────────────────────────────────────────┤
│  CAPA DE SERVICIOS / API                              │
│  (REST APIs, GraphQL, Controladores)                  │
├──────────────────────────────────────────────────────┤
│  CAPA DE APLICACIÓN                                   │
│  (Casos de uso, orquestación, DTOs)                   │
├──────────────────────────────────────────────────────┤
│  CAPA DE DOMINIO / NEGOCIO                            │
│  (Entidades, reglas de negocio, validaciones)         │
├──────────────────────────────────────────────────────┤
│  CAPA DE INFRAESTRUCTURA                              │
│  (Repositorios, servicios externos, mensajería)       │
├──────────────────────────────────────────────────────┤
│  CAPA DE DATOS                                        │
│  (Base de datos, caché, almacenamiento)               │
└──────────────────────────────────────────────────────┘
```

**Regla fundamental:** Cada capa solo puede comunicarse con la capa inmediatamente inferior. Nunca se salta capas.

### 4.3 Introducción al Modelo C4

El **modelo C4** fue creado por Simon Brown como una forma de describir la arquitectura de software en diferentes niveles de detalle, de manera similar a cómo Google Maps permite hacer zoom desde un país hasta una calle.

**C4 = Context, Containers, Components, Code**

```
Nivel 1: CONTEXTO (Context)
  └── Nivel 2: CONTENEDORES (Containers)
       └── Nivel 3: COMPONENTES (Components)
            └── Nivel 4: CÓDIGO (Code)
```

**Filosofía del modelo C4:**
- Cada nivel responde a una audiencia diferente.
- Se va de lo general a lo específico.
- No es necesario crear todos los niveles; se crean según la necesidad.
- Usa notación simple y comprensible, no requiere conocer UML.

| Nivel | ¿Qué muestra? | ¿Para quién? | ¿Cuándo crearlo? |
|-------|---------------|--------------|-------------------|
| Contexto | El sistema y su entorno | Todos (negocio + técnico) | Siempre |
| Contenedores | Las piezas técnicas principales | Equipo técnico | Siempre |
| Componentes | La estructura interna de un contenedor | Desarrolladores | Cuando sea necesario |
| Código | Clases y relaciones detalladas | Desarrolladores | Rara vez (se genera del código) |

### 4.4 Diagrama de Contexto (Nivel 1)

El diagrama de contexto muestra el sistema como una caja negra y su relación con los usuarios y sistemas externos.

**Elementos:**
- **Persona:** Un usuario humano del sistema (representado como figura).
- **Sistema de software (nuestro):** El sistema que estamos construyendo (caja central).
- **Sistema de software externo:** Sistemas con los que nos integramos (cajas externas).
- **Relaciones:** Flechas que indican interacción, con descripción de qué se comunica.

**Ejemplo: Sistema de Gestión de Pedidos**

```
    ┌─────────┐                              ┌──────────────┐
    │ Cliente  │                              │  Sistema de  │
    │ (persona)│                              │  Contabilidad│
    └────┬─────┘                              │  (externo)   │
         │                                    └──────┬───────┘
         │ Consulta pedidos,                         │
         │ realiza compras                           │ Envía facturas
         │                                           │ para registro
         ▼                                           │ contable
    ┌─────────────────────────────────────┐          │
    │                                     │◄─────────┘
    │   SISTEMA DE GESTIÓN DE PEDIDOS     │
    │                                     │─────────────────┐
    │   Permite gestionar el ciclo        │                 │
    │   completo de pedidos, inventario   │                 │
    │   y facturación                     │                 │
    │                                     │                 ▼
    └──────────┬──────────────────────────┘     ┌──────────────┐
               │                                │  Pasarela de │
               │                                │  Pagos       │
               │ Gestiona pedidos,              │  (externo)   │
               │ inventario, reportes           └──────────────┘
               ▼
    ┌──────────────┐        ┌──────────────┐
    │  Vendedor    │        │  Administrador│
    │  (persona)   │        │  (persona)    │
    └──────────────┘        └──────────────┘
```

### 4.5 Diagrama de Contenedores (Nivel 2)

El diagrama de contenedores hace zoom dentro del sistema y muestra las piezas técnicas principales que lo componen.

**¿Qué es un contenedor?** Es una unidad desplegable que ejecuta código o almacena datos:
- Aplicación web (frontend)
- API / Backend
- Base de datos
- Aplicación móvil
- Servicio de mensajería
- Sistema de archivos

**Ejemplo: Sistema de Gestión de Pedidos**

```
    ┌─────────┐         ┌──────────────┐        ┌──────────────┐
    │ Cliente  │         │  Vendedor    │        │ Administrador│
    └────┬─────┘         └──────┬───────┘        └──────┬───────┘
         │                      │                       │
         │ HTTPS                │ HTTPS                 │ HTTPS
         ▼                      ▼                       ▼
    ┌──────────────────────────────────────────────────────────┐
    │                    APLICACIÓN WEB                         │
    │              (React / Angular / Vue)                      │
    │         Single Page Application (SPA)                     │
    │    Interfaz de usuario para todos los roles               │
    └────────────────────────┬─────────────────────────────────┘
                             │
                             │ JSON / HTTPS
                             ▼
    ┌──────────────────────────────────────────────────────────┐
    │                    API BACKEND                            │
    │              (Java Spring Boot / .NET / Node.js)          │
    │                                                          │
    │  Expone servicios REST para:                             │
    │  - Gestión de clientes                                   │
    │  - Gestión de productos e inventario                     │
    │  - Procesamiento de pedidos                              │
    │  - Facturación                                           │
    │  - Reportes                                              │
    │  - Autenticación y autorización                          │
    └───────┬──────────────┬───────────────┬───────────────────┘
            │              │               │
            │ SQL          │ SMTP          │ HTTPS
            ▼              ▼               ▼
    ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
    │  BASE DE     │ │  SERVICIO    │ │  PASARELA    │
    │  DATOS       │ │  DE EMAIL    │ │  DE PAGOS    │
    │ (PostgreSQL) │ │  (externo)   │ │  (externo)   │
    │              │ │              │ │              │
    │ Almacena:    │ │ Envía:       │ │ Procesa:     │
    │ -Clientes    │ │ -Notificac.  │ │ -Pagos       │
    │ -Productos   │ │ -Facturas    │ │ -Reembolsos  │
    │ -Pedidos     │ │ -Alertas     │ │              │
    │ -Facturas    │ │              │ │              │
    └──────────────┘ └──────────────┘ └──────────────┘
```

### 4.6 Diagrama de Componentes (Nivel 3)

El diagrama de componentes hace zoom dentro de un contenedor específico para mostrar su estructura interna.

**Ejemplo: Componentes del API Backend**

```
┌─────────────────────────────────────────────────────────────────┐
│                        API BACKEND                               │
│                                                                  │
│  ┌─────────────────┐  ┌─────────────────┐  ┌────────────────┐  │
│  │  Controlador    │  │  Controlador    │  │  Controlador   │  │
│  │  de Clientes    │  │  de Pedidos     │  │  de Productos  │  │
│  │  [REST API]     │  │  [REST API]     │  │  [REST API]    │  │
│  └────────┬────────┘  └────────┬────────┘  └───────┬────────┘  │
│           │                    │                    │            │
│           ▼                    ▼                    ▼            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌────────────────┐  │
│  │  Servicio       │  │  Servicio       │  │  Servicio      │  │
│  │  de Clientes    │  │  de Pedidos     │  │  de Inventario │  │
│  │  [Lógica]       │  │  [Lógica]       │  │  [Lógica]      │  │
│  └────────┬────────┘  └───┬────┬────────┘  └───────┬────────┘  │
│           │               │    │                    │            │
│           │               │    │                    │            │
│           ▼               │    ▼                    ▼            │
│  ┌─────────────────┐     │  ┌──────────────────────────────┐   │
│  │  Repositorio    │     │  │  Servicio de Facturación     │   │
│  │  de Clientes    │     │  │  [Lógica]                    │   │
│  │  [Datos]        │     │  └──────────────┬───────────────┘   │
│  └────────┬────────┘     │                 │                    │
│           │              │                 │                    │
│           ▼              ▼                 ▼                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              CAPA DE ACCESO A DATOS                       │  │
│  │         (Repositorios, ORM, Conexiones)                   │  │
│  └──────────────────────────┬───────────────────────────────┘  │
│                              │                                   │
└──────────────────────────────┼───────────────────────────────────┘
                               │ SQL
                               ▼
                      ┌──────────────┐
                      │  BASE DE     │
                      │  DATOS       │
                      │ (PostgreSQL) │
                      └──────────────┘
```

### 4.7 Relación entre Arquitectura y Decisiones de Negocio

Cada decisión arquitectónica debe estar justificada por una necesidad del negocio.

**Registro de Decisiones Arquitectónicas (ADR):**

```
ADR-001: Uso de arquitectura de microservicios para el módulo de pagos

Estado: Aceptada
Fecha: 2025-03-15

Contexto:
  El módulo de pagos requiere alta disponibilidad (99.99%) y debe
  poder escalar independientemente del resto del sistema durante
  temporadas de alta demanda (Black Friday, Navidad).

Decisión:
  Implementar el módulo de pagos como un microservicio independiente,
  con su propia base de datos y despliegue autónomo.

Consecuencias:
  (+) El módulo de pagos puede escalar independientemente.
  (+) Una falla en otro módulo no afecta los pagos.
  (+) Se puede actualizar sin afectar el resto del sistema.
  (-) Mayor complejidad operativa (despliegue, monitoreo).
  (-) Necesidad de gestionar comunicación entre servicios.
  (-) Requiere equipo con experiencia en sistemas distribuidos.

Alternativas consideradas:
  1. Mantener como módulo dentro del monolito → Descartada por
     riesgo de disponibilidad.
  2. Usar servicio externo de pagos completamente → Descartada
     por costos y dependencia de terceros.
```

**Tabla de decisiones arquitectónicas vinculadas al negocio:**

| Necesidad del negocio | Atributo de calidad | Decisión arquitectónica |
|----------------------|--------------------|-----------------------|
| Operación 24/7 sin interrupciones | Disponibilidad | Despliegue en la nube con redundancia |
| Crecimiento de 200% en usuarios el próximo año | Escalabilidad | Arquitectura basada en contenedores |
| Cumplimiento de ley de protección de datos | Seguridad | Cifrado en tránsito y en reposo, auditoría |
| Integración con sistema contable existente | Interoperabilidad | API REST con estándar OpenAPI |
| Equipo de desarrollo junior | Mantenibilidad | Arquitectura por capas, framework maduro |

#### Actividad práctica — Unidad 4

> **Taller 4: Arquitectura C4**
>
> Para el proyecto del curso:
> 1. Elabore el diagrama de contexto (Nivel 1) identificando todos los actores y sistemas externos.
> 2. Elabore el diagrama de contenedores (Nivel 2) definiendo las piezas técnicas principales.
> 3. Seleccione el contenedor más importante y elabore su diagrama de componentes (Nivel 3).
> 4. Documente al menos 3 decisiones arquitectónicas usando el formato ADR.
> 5. Construya una tabla que vincule cada decisión arquitectónica con la necesidad de negocio que la justifica.
> 6. Justifique la selección de tecnologías propuestas.

---


## Unidad 5: Datos, Integración y Seguridad

### 5.1 Modelado de Datos para Sistemas Empresariales

El modelado de datos en sistemas empresariales va más allá de crear tablas en una base de datos. Requiere entender las entidades del negocio, sus relaciones y las reglas que las gobiernan.

#### Modelo Entidad-Relación (ejemplo para sistema de pedidos)

```
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│   CLIENTE    │       │   PEDIDO     │       │  PRODUCTO    │
├──────────────┤       ├──────────────┤       ├──────────────┤
│ PK id        │       │ PK id        │       │ PK id        │
│ nombre       │1    N │ FK cliente_id│ N   M │ nombre       │
│ email        │───────│ fecha        │───────│ descripcion  │
│ telefono     │       │ estado       │       │ precio       │
│ direccion    │       │ total        │       │ stock        │
│ tipo         │       │ FK vendedor  │       │ FK categoria │
│ fecha_reg    │       │ observaciones│       │ activo       │
└──────────────┘       └──────┬───────┘       └──────────────┘
                              │
                              │ 1
                              │
                              │ N
                       ┌──────────────┐
                       │DETALLE_PEDIDO│
                       ├──────────────┤
                       │ PK id        │
                       │ FK pedido_id │
                       │ FK producto  │
                       │ cantidad     │
                       │ precio_unit  │
                       │ subtotal     │
                       └──────┬───────┘
                              │
                              │ 1
                              │
                              │ 1
                       ┌──────────────┐
                       │   FACTURA    │
                       ├──────────────┤
                       │ PK id        │
                       │ FK pedido_id │
                       │ numero       │
                       │ fecha        │
                       │ subtotal     │
                       │ impuesto     │
                       │ total        │
                       │ estado       │
                       └──────────────┘
```

#### Consideraciones para datos empresariales

| Aspecto | Descripción | Ejemplo |
|---------|-------------|---------|
| **Integridad referencial** | Las relaciones entre tablas deben ser consistentes | Un pedido no puede referenciar un cliente que no existe |
| **Auditoría** | Registrar quién, cuándo y qué se modificó | Campos: created_at, updated_at, created_by, updated_by |
| **Soft delete** | No eliminar registros, sino marcarlos como inactivos | Campo: activo (boolean) o deleted_at (timestamp) |
| **Versionamiento** | Mantener historial de cambios en datos críticos | Tabla de historial de precios de productos |
| **Normalización** | Evitar redundancia de datos | Separar dirección en tabla aparte si un cliente tiene múltiples direcciones |
| **Índices** | Optimizar consultas frecuentes | Índice en pedido.fecha para reportes por rango de fechas |

### 5.2 Integración entre Módulos y Servicios

En un sistema empresarial, los módulos no operan de forma aislada. La integración es clave.

**Patrones de integración:**

#### Integración sincrónica (Request-Response)

```
Módulo A ──── solicitud ────> Módulo B
         <─── respuesta ─────
         
Ejemplo: El módulo de pedidos consulta el inventario en tiempo real
         antes de confirmar un pedido.
         
Ventajas: Respuesta inmediata, flujo simple.
Desventajas: Acoplamiento, si B falla, A falla.
```

#### Integración asincrónica (Eventos / Mensajería)

```
Módulo A ──── evento ────> Cola de mensajes ────> Módulo B
                                              ────> Módulo C
         
Ejemplo: Cuando se confirma un pedido, se publica un evento
         "PedidoConfirmado" que es consumido por:
         - Módulo de inventario (para descontar stock)
         - Módulo de facturación (para generar factura)
         - Módulo de notificaciones (para avisar al cliente)
         
Ventajas: Desacoplamiento, escalabilidad, resiliencia.
Desventajas: Complejidad, eventual consistency.
```

#### Integración por base de datos compartida

```
Módulo A ────┐
             ├────> Base de datos compartida
Módulo B ────┘

Ejemplo: Módulo de ventas y módulo de reportes leen
         de la misma base de datos.
         
Ventajas: Simple, datos siempre consistentes.
Desventajas: Acoplamiento a nivel de datos, difícil de escalar.
```

### 5.3 APIs y Servicios Empresariales

Las APIs (Application Programming Interfaces) son el mecanismo estándar para la comunicación entre sistemas y módulos.

#### Diseño de API REST para sistemas empresariales

**Convenciones de diseño:**

```
Recurso: /api/v1/pedidos

GET    /api/v1/pedidos              → Listar pedidos (con paginación)
GET    /api/v1/pedidos/{id}         → Obtener un pedido específico
POST   /api/v1/pedidos              → Crear un nuevo pedido
PUT    /api/v1/pedidos/{id}         → Actualizar un pedido completo
PATCH  /api/v1/pedidos/{id}         → Actualizar parcialmente un pedido
DELETE /api/v1/pedidos/{id}         → Cancelar/eliminar un pedido

Relaciones:
GET    /api/v1/pedidos/{id}/detalles    → Detalles de un pedido
GET    /api/v1/clientes/{id}/pedidos    → Pedidos de un cliente

Filtros y paginación:
GET    /api/v1/pedidos?estado=pendiente&fecha_desde=2025-01-01&page=1&size=20
```

**Ejemplo de respuesta API:**

```json
{
  "data": {
    "id": 1234,
    "numero": "PED-2025-001234",
    "fecha": "2025-03-15T10:30:00Z",
    "estado": "confirmado",
    "cliente": {
      "id": 56,
      "nombre": "Empresa ABC S.A.S."
    },
    "items": [
      {
        "producto_id": 101,
        "nombre": "Producto X",
        "cantidad": 5,
        "precio_unitario": 25000,
        "subtotal": 125000
      }
    ],
    "subtotal": 125000,
    "impuesto": 23750,
    "total": 148750
  },
  "meta": {
    "timestamp": "2025-03-15T10:30:05Z",
    "version": "1.0"
  }
}
```

**Códigos de respuesta HTTP relevantes:**

| Código | Significado | Uso |
|--------|-------------|-----|
| 200 | OK | Consulta exitosa |
| 201 | Created | Recurso creado exitosamente |
| 400 | Bad Request | Datos de entrada inválidos |
| 401 | Unauthorized | No autenticado |
| 403 | Forbidden | Sin permisos |
| 404 | Not Found | Recurso no encontrado |
| 409 | Conflict | Conflicto (ej: stock insuficiente) |
| 500 | Internal Server Error | Error del servidor |

### 5.4 Seguridad Básica en Sistemas Empresariales

La seguridad en sistemas empresariales no es opcional; es un requisito fundamental.

**Capas de seguridad:**

```
┌─────────────────────────────────────────────────────┐
│  1. SEGURIDAD DE RED                                 │
│     Firewall, HTTPS/TLS, VPN                         │
├─────────────────────────────────────────────────────┤
│  2. AUTENTICACIÓN                                    │
│     ¿Quién eres? (Login, tokens, MFA)                │
├─────────────────────────────────────────────────────┤
│  3. AUTORIZACIÓN                                     │
│     ¿Qué puedes hacer? (Roles, permisos)             │
├─────────────────────────────────────────────────────┤
│  4. SEGURIDAD DE DATOS                               │
│     Cifrado, enmascaramiento, respaldos              │
├─────────────────────────────────────────────────────┤
│  5. AUDITORÍA Y MONITOREO                            │
│     Logs, alertas, trazabilidad                      │
└─────────────────────────────────────────────────────┘
```

#### Autenticación

**Mecanismos comunes:**
- **Usuario y contraseña:** El más básico. Las contraseñas deben almacenarse con hash (bcrypt, argon2).
- **Tokens JWT (JSON Web Token):** Estándar para APIs. El servidor genera un token firmado que el cliente envía en cada solicitud.
- **OAuth 2.0:** Protocolo para autorización delegada (ej: "Iniciar sesión con Google").
- **MFA (Multi-Factor Authentication):** Combina algo que sabes (contraseña) + algo que tienes (código SMS/app).

**Flujo de autenticación con JWT:**

```
Cliente                    Servidor
   │                          │
   │── POST /auth/login ─────>│
   │   {email, password}      │
   │                          │── Valida credenciales
   │                          │── Genera JWT
   │<── 200 {token: "eyJ..."} │
   │                          │
   │── GET /api/pedidos ─────>│
   │   Header: Authorization: │
   │   Bearer eyJ...          │
   │                          │── Valida token
   │                          │── Verifica permisos
   │<── 200 {data: [...]}     │
```

### 5.5 Roles, Permisos, Auditoría y Trazabilidad

#### Modelo RBAC (Role-Based Access Control)

```
USUARIOS ──── tienen ────> ROLES ──── tienen ────> PERMISOS

Ejemplo:
  Usuario: Juan Pérez
  Rol: Vendedor
  Permisos:
    ✓ pedidos.crear
    ✓ pedidos.ver
    ✓ pedidos.editar (solo propios)
    ✗ pedidos.eliminar
    ✓ clientes.ver
    ✓ clientes.crear
    ✗ reportes.ver
    ✗ configuracion.editar
```

**Matriz de permisos por rol:**

| Permiso | Admin | Gerente | Vendedor | Cliente |
|---------|-------|---------|----------|---------|
| Gestionar usuarios | ✓ | ✗ | ✗ | ✗ |
| Ver reportes gerenciales | ✓ | ✓ | ✗ | ✗ |
| Crear pedidos | ✓ | ✓ | ✓ | ✓ |
| Aprobar descuentos > 20% | ✓ | ✓ | ✗ | ✗ |
| Ver todos los pedidos | ✓ | ✓ | ✗ | ✗ |
| Ver pedidos propios | ✓ | ✓ | ✓ | ✓ |
| Modificar precios | ✓ | ✗ | ✗ | ✗ |
| Cancelar pedidos | ✓ | ✓ | ✓* | ✓* |

*Solo si el pedido está en estado "Pendiente".

#### Auditoría y trazabilidad

Todo sistema empresarial debe registrar las acciones realizadas para cumplimiento, seguridad y resolución de problemas.

**Estructura de un registro de auditoría:**

```json
{
  "id": "audit-2025-0001",
  "timestamp": "2025-03-15T14:23:45Z",
  "usuario": "jperez",
  "rol": "vendedor",
  "accion": "CREAR",
  "recurso": "pedido",
  "recurso_id": "PED-2025-001234",
  "ip": "192.168.1.100",
  "datos_anteriores": null,
  "datos_nuevos": {
    "cliente_id": 56,
    "total": 148750,
    "items": 3
  },
  "resultado": "EXITOSO"
}
```

#### Actividad práctica — Unidad 5

> **Taller 5: Datos, integración y seguridad**
>
> Para el proyecto del curso:
> 1. Diseñe el modelo entidad-relación con al menos 8 entidades.
> 2. Defina al menos 5 endpoints de API REST con sus métodos, parámetros y respuestas esperadas.
> 3. Identifique los puntos de integración entre módulos y seleccione el patrón adecuado (sincrónico/asincrónico) para cada uno, justificando su elección.
> 4. Defina los roles del sistema y construya la matriz de permisos.
> 5. Diseñe la estructura de los registros de auditoría para las operaciones críticas.

---


## Unidad 6: Desarrollo del Proyecto Empresarial

### 6.1 Construcción Incremental de la Solución

El desarrollo de un sistema empresarial no se hace de una sola vez. Se construye de forma incremental, entregando valor en cada iteración.

**Enfoque incremental:**

```
Iteración 1          Iteración 2          Iteración 3          Iteración 4
┌──────────┐        ┌──────────┐        ┌──────────┐        ┌──────────┐
│ Módulo   │        │ + Módulo │        │ + Módulo │        │ + Módulo │
│ Clientes │        │ Productos│        │ Pedidos  │        │ Reportes │
│          │        │ Inventar.│        │ Facturac.│        │ Dashboard│
│ Base de  │        │          │        │          │        │          │
│ datos    │        │ APIs     │        │ Integrac.│        │ Optimiz. │
│ Auth     │        │ CRUD     │        │ Reglas   │        │ Ajustes  │
└──────────┘        └──────────┘        └──────────┘        └──────────┘
   Semanas 1-4         Semanas 5-8        Semanas 9-12       Semanas 13-16
```

**Principios del desarrollo incremental:**

1. **Entregar valor temprano:** Cada iteración produce algo funcional y demostrable.
2. **Retroalimentación continua:** Cada entrega se revisa con stakeholders.
3. **Adaptación:** El plan se ajusta según lo aprendido en cada iteración.
4. **Integración continua:** Cada nuevo módulo se integra con los anteriores.
5. **Calidad desde el inicio:** No dejar la calidad para el final.

### 6.2 Validación Funcional con Escenarios de Uso

La validación funcional verifica que el sistema cumple con los requerimientos desde la perspectiva del usuario.

**Escenarios de prueba funcional:**

```
Escenario: Crear pedido exitosamente
  Dado que soy un vendedor autenticado
  Y existe un cliente "Empresa ABC" en el sistema
  Y el producto "Laptop HP" tiene 10 unidades en stock
  
  Cuando creo un nuevo pedido para "Empresa ABC"
  Y agrego 3 unidades de "Laptop HP"
  Y confirmo el pedido
  
  Entonces el sistema genera un número de pedido único
  Y el estado del pedido es "Pendiente"
  Y el stock de "Laptop HP" se reduce a 7 unidades
  Y se envía una notificación al cliente
  Y el pedido aparece en la lista de pedidos del vendedor
```

```
Escenario: Intentar crear pedido sin stock suficiente
  Dado que soy un vendedor autenticado
  Y el producto "Monitor Dell" tiene 2 unidades en stock
  
  Cuando intento agregar 5 unidades de "Monitor Dell" al pedido
  
  Entonces el sistema muestra un mensaje: "Stock insuficiente.
    Disponible: 2 unidades"
  Y no permite agregar la cantidad solicitada
  Y sugiere la cantidad máxima disponible
```

**Matriz de pruebas funcionales:**

| ID | Escenario | Precondiciones | Acción | Resultado esperado | Estado |
|----|-----------|----------------|--------|-------------------|--------|
| PF-001 | Login exitoso | Usuario registrado | Ingresar credenciales válidas | Acceso al dashboard | ☐ |
| PF-002 | Login fallido | Usuario registrado | Ingresar contraseña incorrecta | Mensaje de error, 3 intentos | ☐ |
| PF-003 | Crear cliente | Vendedor autenticado | Completar formulario de cliente | Cliente registrado | ☐ |
| PF-004 | Crear pedido | Cliente y productos existen | Crear pedido con items | Pedido generado | ☐ |
| PF-005 | Pedido sin stock | Producto con stock = 0 | Intentar agregar al pedido | Mensaje de error | ☐ |

### 6.3 Prototipado y Revisión del Diseño

El prototipado permite validar ideas antes de invertir tiempo en desarrollo completo.

**Niveles de prototipado:**

| Nivel | Tipo | Herramientas | Propósito |
|-------|------|-------------|-----------|
| 1 | Sketch (boceto en papel) | Papel, pizarra | Explorar ideas rápidamente |
| 2 | Wireframe (baja fidelidad) | Balsamiq, Excalidraw | Definir estructura y flujo |
| 3 | Mockup (alta fidelidad) | Figma, Adobe XD | Validar diseño visual |
| 4 | Prototipo interactivo | Figma, InVision | Simular la experiencia de usuario |
| 5 | Prototipo funcional | Código real (MVP) | Validar viabilidad técnica |

**Checklist de revisión de diseño:**

```
☐ ¿El diseño responde a los requerimientos funcionales?
☐ ¿Los flujos de usuario son intuitivos y eficientes?
☐ ¿Se consideraron los diferentes roles y sus necesidades?
☐ ¿El diseño es consistente (colores, tipografía, componentes)?
☐ ¿Se manejan adecuadamente los estados de error?
☐ ¿Se consideró la accesibilidad?
☐ ¿El diseño es responsive (se adapta a diferentes pantallas)?
☐ ¿Se validó con usuarios representativos?
☐ ¿Es técnicamente viable con la arquitectura propuesta?
```

### 6.4 Presentación de Avances

La capacidad de comunicar el progreso es tan importante como el desarrollo mismo.

**Estructura sugerida para presentación de avance:**

```
1. CONTEXTO (2 min)
   - Recordar el problema que se está resolviendo
   - Objetivo del sistema

2. PROGRESO (5 min)
   - Qué se planificó para esta iteración
   - Qué se logró
   - Demostración funcional (demo en vivo o video)

3. DECISIONES TÉCNICAS (3 min)
   - Decisiones importantes tomadas
   - Justificación de cada decisión
   - Trade-offs considerados

4. OBSTÁCULOS Y APRENDIZAJES (2 min)
   - Problemas encontrados
   - Cómo se resolvieron (o plan para resolverlos)
   - Lecciones aprendidas

5. PLAN SIGUIENTE ITERACIÓN (3 min)
   - Qué se hará en la próxima iteración
   - Ajustes al alcance (si los hay)
   - Riesgos identificados
```

### 6.5 Ajustes de Arquitectura y de Alcance

Durante el desarrollo, es normal que surjan cambios. Lo importante es gestionarlos de forma controlada.

**Gestión de cambios:**

```
┌─────────────────────────────────────────────────────┐
│              SOLICITUD DE CAMBIO                     │
├─────────────────────────────────────────────────────┤
│ Solicitante: [Nombre]                                │
│ Fecha: [Fecha]                                       │
│ Tipo: [ ] Nuevo requerimiento                        │
│       [ ] Modificación de requerimiento existente    │
│       [ ] Cambio de arquitectura                     │
│       [ ] Ajuste de alcance                          │
│                                                      │
│ Descripción del cambio:                              │
│ [Descripción detallada]                              │
│                                                      │
│ Justificación:                                       │
│ [Por qué es necesario]                               │
│                                                      │
│ Impacto estimado:                                    │
│ - Tiempo adicional: [horas/días]                     │
│ - Módulos afectados: [lista]                         │
│ - Riesgo: [bajo/medio/alto]                          │
│                                                      │
│ Decisión: [ ] Aprobado  [ ] Rechazado  [ ] Diferido  │
└─────────────────────────────────────────────────────┘
```

#### Actividad práctica — Unidad 6

> **Entregable de avance del proyecto**
>
> 1. Presente una demostración funcional del avance del sistema (puede ser prototipo funcional o módulos implementados).
> 2. Documente los escenarios de prueba funcional ejecutados y sus resultados.
> 3. Registre los cambios realizados respecto al diseño original y su justificación.
> 4. Prepare una presentación de avance siguiendo la estructura sugerida (máximo 15 minutos).
> 5. Incluya una retrospectiva del equipo: ¿qué funcionó bien? ¿qué se puede mejorar?

---


## Unidad 7: Despliegue, Evaluación y Sostenibilidad

### 7.1 Estrategia de Implementación

La implementación (despliegue) de un sistema empresarial es una fase crítica que requiere planificación cuidadosa.

**Estrategias de despliegue:**

| Estrategia | Descripción | Riesgo | Cuándo usarla |
|------------|-------------|--------|---------------|
| **Big Bang** | Se reemplaza el sistema antiguo por el nuevo en una fecha específica | Alto | Sistemas pequeños, sin sistema previo |
| **Paralelo** | Ambos sistemas funcionan simultáneamente durante un período | Bajo | Sistemas críticos, cuando se necesita validar |
| **Gradual (por fases)** | Se implementa módulo por módulo o área por área | Medio | Sistemas grandes, organizaciones complejas |
| **Piloto** | Se implementa primero en un grupo reducido de usuarios o una sede | Bajo-Medio | Cuando se quiere validar antes de escalar |

**Plan de implementación (ejemplo):**

```
FASE 1: Preparación (Semana 1-2)
  ├── Configurar ambiente de producción
  ├── Migrar datos del sistema anterior
  ├── Capacitar usuarios clave (train the trainers)
  └── Preparar plan de contingencia

FASE 2: Piloto (Semana 3-4)
  ├── Desplegar en sede principal con grupo piloto (20 usuarios)
  ├── Monitorear intensivamente
  ├── Recopilar retroalimentación
  └── Corregir errores críticos

FASE 3: Despliegue general (Semana 5-6)
  ├── Extender a todos los usuarios
  ├── Capacitación masiva
  ├── Soporte intensivo (mesa de ayuda dedicada)
  └── Monitoreo continuo

FASE 4: Estabilización (Semana 7-8)
  ├── Resolver incidencias pendientes
  ├── Optimizar rendimiento
  ├── Documentar lecciones aprendidas
  └── Transición a soporte regular
```

### 7.2 Riesgos del Proyecto

La gestión de riesgos permite anticipar problemas y preparar respuestas.

**Matriz de riesgos:**

| ID | Riesgo | Probabilidad | Impacto | Nivel | Mitigación |
|----|--------|-------------|---------|-------|------------|
| R1 | Cambio de requerimientos a mitad del proyecto | Alta | Alto | Crítico | Gestión de cambios formal, alcance bien definido |
| R2 | Falta de disponibilidad de stakeholders para validación | Media | Alto | Alto | Calendario de reuniones acordado desde el inicio |
| R3 | Problemas de rendimiento en producción | Media | Alto | Alto | Pruebas de carga antes del despliegue |
| R4 | Resistencia al cambio por parte de usuarios | Alta | Medio | Alto | Capacitación temprana, involucrar usuarios en diseño |
| R5 | Datos del sistema anterior con problemas de calidad | Media | Medio | Medio | Limpieza y validación de datos antes de migración |
| R6 | Dependencia de servicios externos no disponibles | Baja | Alto | Medio | Diseñar fallbacks, contratos de nivel de servicio |
| R7 | Rotación de miembros del equipo | Baja | Medio | Bajo | Documentación, pair programming, knowledge sharing |

**Mapa de calor de riesgos:**

```
Impacto
  Alto    │  R5,R7  │  R2,R3  │  R1     │
          │         │  R4     │         │
  Medio   │         │         │         │
          │         │         │         │
  Bajo    │         │  R6     │         │
          │─────────┼─────────┼─────────│
            Baja      Media     Alta
                   Probabilidad
```

### 7.3 Métricas de Éxito del Sistema

Las métricas permiten evaluar objetivamente si el sistema cumple sus objetivos.

**Métricas técnicas:**

| Métrica | Descripción | Meta | Cómo medirla |
|---------|-------------|------|-------------|
| Disponibilidad | % de tiempo que el sistema está operativo | > 99.5% | Monitoreo de uptime |
| Tiempo de respuesta | Tiempo promedio de respuesta de las APIs | < 2 segundos | APM (Application Performance Monitoring) |
| Tasa de errores | % de solicitudes que resultan en error | < 1% | Logs de errores / total de solicitudes |
| Cobertura de pruebas | % del código cubierto por pruebas automatizadas | > 80% | Herramientas de cobertura |

**Métricas de negocio:**

| Métrica | Antes (As-Is) | Meta (To-Be) | Cómo medirla |
|---------|--------------|-------------|-------------|
| Tiempo de procesamiento de pedido | 2 horas | 15 minutos | Timestamp de creación vs confirmación |
| Errores en facturación | 5% de facturas | < 0.5% | Facturas con corrección / total |
| Satisfacción del usuario | No medida | > 4.0/5.0 | Encuesta periódica |
| Tiempo de generación de reportes | 1 día (manual) | 5 minutos (automático) | Tiempo desde solicitud hasta entrega |
| Pedidos perdidos por falta de stock | 8% | < 2% | Pedidos cancelados por stock / total |

### 7.4 Evaluación de Impacto Organizacional

El impacto de un sistema empresarial va más allá de lo técnico.

**Dimensiones de impacto:**

```
┌─────────────────────────────────────────────────────────┐
│                 IMPACTO ORGANIZACIONAL                    │
├──────────────┬──────────────┬──────────────┬────────────┤
│  OPERATIVO   │  FINANCIERO  │   HUMANO     │ ESTRATÉGICO│
│              │              │              │            │
│ -Eficiencia  │ -Reducción   │ -Satisfacción│ -Ventaja   │
│  de procesos │  de costos   │  laboral     │  competit. │
│ -Reducción   │ -ROI del     │ -Nuevas      │ -Nuevos    │
│  de errores  │  proyecto    │  competencias│  modelos   │
│ -Velocidad   │ -Ahorro en   │ -Resistencia │  de negocio│
│  de respuesta│  reprocesos  │  al cambio   │ -Datos para│
│ -Trazabilidad│ -Ingresos    │ -Capacitación│  decisiones│
│              │  adicionales │  requerida   │            │
└──────────────┴──────────────┴──────────────┴────────────┘
```

**Evaluación antes y después:**

| Dimensión | Indicador | Antes | Después | Cambio |
|-----------|-----------|-------|---------|--------|
| Operativo | Pedidos procesados por día | 50 | 200 | +300% |
| Operativo | Tiempo promedio de atención | 4 horas | 30 min | -87.5% |
| Financiero | Costo por transacción | $5,000 | $1,200 | -76% |
| Financiero | Pérdidas por errores/mes | $2M | $200K | -90% |
| Humano | Horas extras del equipo/mes | 120 | 20 | -83% |
| Estratégico | Tiempo para lanzar nuevo producto | 3 meses | 2 semanas | -83% |

### 7.5 Presentación Final del Proyecto

La presentación final es la culminación del trabajo del semestre. Debe demostrar dominio técnico y comprensión del negocio.

**Estructura de la presentación final (30-40 minutos):**

```
1. INTRODUCCIÓN Y CONTEXTO (5 min)
   ├── Organización seleccionada y su contexto
   ├── Problema u oportunidad identificada
   └── Objetivo del sistema

2. ANÁLISIS DEL NEGOCIO (5 min)
   ├── Procesos analizados
   ├── Modelo As-Is (hallazgos clave)
   ├── Modelo To-Be (mejoras propuestas)
   └── Impacto esperado

3. REQUERIMIENTOS Y ALCANCE (5 min)
   ├── Requerimientos principales (funcionales y no funcionales)
   ├── Alcance definido
   ├── Priorización (MoSCoW)
   └── Trazabilidad negocio → solución

4. ARQUITECTURA DE LA SOLUCIÓN (7 min)
   ├── Diagrama de contexto C4
   ├── Diagrama de contenedores C4
   ├── Diagrama de componentes C4
   ├── Decisiones arquitectónicas (ADRs)
   └── Justificación de tecnologías

5. DEMOSTRACIÓN DEL SISTEMA (8 min)
   ├── Demo en vivo o video
   ├── Flujos principales
   ├── Integración entre módulos
   └── Manejo de errores y seguridad

6. LECCIONES APRENDIDAS Y CONCLUSIONES (5 min)
   ├── Desafíos enfrentados
   ├── Decisiones que se tomarían diferente
   ├── Métricas de éxito alcanzadas
   ├── Trabajo futuro
   └── Conclusiones

7. PREGUNTAS Y RESPUESTAS (5 min)
```

**Criterios de evaluación de la presentación:**

| Criterio | Peso | Descripción |
|----------|------|-------------|
| Comprensión del negocio | 20% | Demuestra entendimiento del contexto organizacional |
| Calidad del análisis | 15% | As-Is/To-Be bien fundamentados, requerimientos claros |
| Diseño arquitectónico | 20% | Diagramas C4 correctos, decisiones justificadas |
| Implementación técnica | 20% | Sistema funcional, código de calidad, integración |
| Comunicación | 15% | Claridad, estructura, manejo del tiempo, respuesta a preguntas |
| Trabajo en equipo | 10% | Distribución equitativa, colaboración evidente |

#### Actividad práctica — Unidad 7

> **Entregable final del proyecto**
>
> 1. Documento técnico completo del proyecto que incluya:
>    - Análisis del negocio (As-Is / To-Be)
>    - Documento de requerimientos y alcance
>    - Diagramas de arquitectura C4 (3 niveles)
>    - Modelo de datos
>    - Diseño de APIs
>    - Modelo de seguridad (roles y permisos)
>    - Plan de implementación
>    - Análisis de riesgos
>    - Métricas de éxito
> 2. Sistema funcional desplegado (al menos en ambiente de pruebas).
> 3. Presentación final ante el grupo (30-40 minutos).
> 4. Evaluación cruzada entre equipos.

---


## Metodología y Evaluación

### Metodología del Curso

La asignatura se desarrolla bajo un enfoque teórico-práctico, centrado en el **Aprendizaje Basado en Proyectos (ABP)**.

**Estrategias metodológicas:**

| Estrategia | Descripción | Frecuencia |
|------------|-------------|------------|
| Clases magistrales | Introducción de fundamentos conceptuales con ejemplos reales | Semanal |
| Estudio de casos | Análisis de escenarios organizacionales reales o simulados | Quincenal |
| Talleres aplicados | Ejercicios prácticos de levantamiento, modelado y diseño | Semanal |
| Desarrollo de proyecto | Construcción incremental con entregables parciales | Continuo |
| Sustentaciones | Presentaciones cortas con retroalimentación | Por iteración |
| Trabajo colaborativo | Roles, planeación y toma de decisiones en equipo | Continuo |

**Cronograma general:**

```
Semana  1-2:  Unidad 1 — Fundamentos de sistemas empresariales
Semana  3-4:  Unidad 2 — Procesos de negocio y análisis organizacional
Semana  5-6:  Unidad 3 — Requerimientos y alcance del proyecto
Semana  7-8:  Unidad 4 — Arquitectura de sistemas empresariales
Semana  9-10: Unidad 5 — Datos, integración y seguridad
Semana 11-13: Unidad 6 — Desarrollo del proyecto empresarial
Semana 14-15: Unidad 7 — Despliegue, evaluación y sostenibilidad
Semana    16: Presentaciones finales
```

### Criterios de Evaluación

| Componente | Peso | Descripción |
|------------|------|-------------|
| Exámenes parciales | 25% | Evaluación individual de conceptos teóricos y aplicados |
| Quices | 10% | Evaluaciones cortas sobre lecturas y temas de clase |
| Talleres | 25% | Ejercicios prácticos individuales y grupales (Talleres 1-5) |
| Proyecto del curso | 40% | Proyecto integrador desarrollado durante el semestre |

**Desglose del proyecto del curso (40%):**

| Entregable | Peso | Semana |
|------------|------|--------|
| Entrega 1: Análisis del negocio (As-Is / To-Be) | 8% | Semana 4 |
| Entrega 2: Requerimientos y alcance | 8% | Semana 6 |
| Entrega 3: Arquitectura C4 y diseño técnico | 8% | Semana 8 |
| Entrega 4: Avance de implementación | 6% | Semana 12 |
| Entrega 5: Presentación final y sistema funcional | 10% | Semana 16 |

**El proyecto evalúa:**
- Habilidades de análisis y abstracción de información
- Habilidades comunicativas (orales y escritas)
- Trabajo en equipo
- Capacidad de argumentar decisiones técnicas
- Integración de conocimientos del curso

---

## Glosario

| Término | Definición |
|---------|-----------|
| **ADR** | Architecture Decision Record. Documento que registra una decisión arquitectónica importante, su contexto y consecuencias. |
| **API** | Application Programming Interface. Interfaz que permite la comunicación entre sistemas o componentes de software. |
| **As-Is** | Modelo que representa el estado actual de un proceso o sistema, tal como funciona hoy. |
| **BI** | Business Intelligence. Conjunto de estrategias y herramientas para transformar datos en información útil para la toma de decisiones. |
| **BPM** | Business Process Management. Disciplina de gestión que busca mejorar los procesos de negocio de una organización. |
| **C4 Model** | Modelo de documentación de arquitectura de software creado por Simon Brown, con 4 niveles: Context, Containers, Components, Code. |
| **CRM** | Customer Relationship Management. Sistema para gestionar las relaciones e interacciones con clientes. |
| **CRUD** | Create, Read, Update, Delete. Las cuatro operaciones básicas sobre datos. |
| **DTO** | Data Transfer Object. Objeto utilizado para transferir datos entre capas o servicios. |
| **ERP** | Enterprise Resource Planning. Sistema integrado que gestiona los procesos centrales de una organización. |
| **ETL** | Extract, Transform, Load. Proceso de extracción, transformación y carga de datos. |
| **JWT** | JSON Web Token. Estándar para la creación de tokens de acceso en autenticación. |
| **MFA** | Multi-Factor Authentication. Autenticación que requiere más de un factor de verificación. |
| **MoSCoW** | Método de priorización: Must have, Should have, Could have, Won't have. |
| **MVP** | Minimum Viable Product. Versión mínima de un producto con funcionalidad suficiente para validar una hipótesis. |
| **OAuth** | Protocolo estándar de autorización que permite a aplicaciones acceder a recursos en nombre de un usuario. |
| **OLAP** | Online Analytical Processing. Tecnología para análisis multidimensional de datos. |
| **RBAC** | Role-Based Access Control. Modelo de control de acceso basado en roles. |
| **REST** | Representational State Transfer. Estilo arquitectónico para diseño de APIs web. |
| **SCM** | Supply Chain Management. Sistema para gestionar la cadena de suministro. |
| **Stakeholder** | Persona o grupo con interés o influencia en el proyecto o sistema. |
| **To-Be** | Modelo que representa el estado futuro deseado de un proceso o sistema. |
| **Trazabilidad** | Capacidad de rastrear el origen y destino de un requerimiento, dato o decisión a lo largo del proyecto. |

---

## Referencias Bibliográficas

1. **Laudon, K. C., & Laudon, J. P.** (2020). *Management Information Systems: Managing the Digital Firm* (16th ed.). Pearson. — Referencia fundamental para comprender los sistemas de información en el contexto empresarial.

2. **Brown, S.** (2018). *Software Architecture for Developers* (Vol. 1 & 2). Leanpub. — Creador del modelo C4, referencia principal para la documentación de arquitectura de software.

3. **Bass, L., Clements, P., & Kazman, R.** (2021). *Software Architecture in Practice* (4th ed.). Addison-Wesley. — Texto clásico sobre arquitectura de software y atributos de calidad.

4. **Dumas, M., La Rosa, M., Mendling, J., & Reijers, H. A.** (2018). *Fundamentals of Business Process Management* (2nd ed.). Springer. — Referencia para modelado y gestión de procesos de negocio.

5. **Sommerville, I.** (2016). *Software Engineering* (10th ed.). Pearson. — Fundamentos de ingeniería de software, requerimientos y diseño.

6. **Fowler, M.** (2002). *Patterns of Enterprise Application Architecture*. Addison-Wesley. — Patrones de arquitectura para aplicaciones empresariales.

7. **Richardson, C.** (2018). *Microservices Patterns*. Manning Publications. — Patrones de arquitectura de microservicios para sistemas empresariales modernos.

8. **Newman, S.** (2021). *Building Microservices* (2nd ed.). O'Reilly Media. — Diseño de sistemas distribuidos y estrategias de integración.

### Recursos en línea

- **Modelo C4:** [https://c4model.com](https://c4model.com) — Sitio oficial del modelo C4 con ejemplos y herramientas.
- **BPMN 2.0:** [https://www.bpmn.org](https://www.bpmn.org) — Estándar de notación para modelado de procesos de negocio.
- **OpenAPI Specification:** [https://swagger.io/specification/](https://swagger.io/specification/) — Estándar para documentación de APIs REST.
- **OWASP:** [https://owasp.org](https://owasp.org) — Recursos de seguridad para aplicaciones web.
- **Martin Fowler's Blog:** [https://martinfowler.com](https://martinfowler.com) — Artículos sobre arquitectura y patrones de software empresarial.

---

> **Nota para el estudiante:** Este material es una guía de referencia para el desarrollo de la asignatura. Se complementa con las clases magistrales, los talleres prácticos y el desarrollo progresivo del proyecto integrador. Se recomienda consultar las referencias bibliográficas para profundizar en cada tema.
