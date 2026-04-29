# 4. Colas (Queues)

## 🎮 Proyecto incremental: RPG por consola — Parte 2

En el capítulo anterior construimos un sistema de acciones con undo/redo, un historial de hechizos y una calculadora de daño, todo usando **pilas**.

Ahora agregaremos al proyecto:
- Un **sistema de turnos de combate** (cola FIFO)
- Una **cola de eventos** del juego
- Un **sistema de misiones con prioridad**
- **Generación de oleadas de enemigos** usando colas y recursividad

---

## Teoría

Una **cola** es una estructura de datos que funciona con el principio **FIFO** (First In, First Out): el primer elemento que entra es el primero que sale.

### 🏦 Analogía: fila en un banco

```
    Imagina una fila para pagar en un banco:

    ENTRADA (por atrás)                              SALIDA (por adelante)
         ↓                                                ↓
    ┌─────────┬─────────┬─────────┬─────────┐       ┌──────────┐
    │ Carlos  │  María  │  Pedro  │   Ana   │ ────→ │ CAJERO   │
    └─────────┴─────────┴─────────┴─────────┘       └──────────┘
    (último)                        (primera)

    Ana llegó PRIMERO → Ana es atendida PRIMERO
    Carlos llegó DE ÚLTIMO → Carlos espera hasta el final

    FIFO = First In, First Out
    El PRIMERO que entró es el PRIMERO que sale.
```

### 🔄 Pila vs. Cola: la diferencia clave

```
    PILA (LIFO)                         COLA (FIFO)
    Como platos apilados               Como fila en el banco

    Entran y salen                      Entran por un lado,
    por el MISMO lado:                  salen por el OTRO:

    ┌───┐                               ENTRADA          SALIDA
    │ C │ ← entra y sale por aquí       ↓                  ↓
    ├───┤                               ┌───┬───┬───┐
    │ B │                               │ C │ B │ A │ ──→ sale A
    ├───┤                               └───┴───┴───┘
    │ A │
    └───┘                               Sale A (el primero)
    Sale C (el último)
```

### Operaciones fundamentales

```
    enqueue(valor)                     dequeue()
    "Ponerse en la fila"               "Ser atendido"

    ANTES:                              ANTES:
    frente → [ A ][ B ][ C ] ← fin     frente → [ A ][ B ][ C ] ← fin

    enqueue(D):                         dequeue() → retorna A:
    frente → [ A ][ B ][ C ][ D ] ←    frente → [ B ][ C ] ← fin
                               fin
    D se pone AL FINAL                  A sale del FRENTE


    peek()                              isEmpty()
    "¿Quién sigue?"                     "¿Hay alguien en la fila?"

    frente → [ A ][ B ][ C ]           ┌ ─ ─ ─ ─ ─ ┐
             ↑                                         → true (vacía)
             retorna A                  └ ─ ─ ─ ─ ─ ┘
             (A sigue en la cola)
```

- **enqueue(valor):** agregar un elemento al final de la cola
- **dequeue():** quitar y retornar el elemento del frente
- **peek():** ver el elemento del frente sin quitarlo
- **isEmpty():** verificar si la cola está vacía

---

## Implementación con arreglo circular

Un arreglo simple tiene un problema: al hacer `dequeue`, el espacio al inicio se desperdicia. La solución es un **arreglo circular** donde los índices "dan la vuelta" usando el operador `%`.

```java
class Cola<T> {

    private Object[] datos;
    private int frente;
    private int fin;
    private int tamaño;
    private int capacidad;

    public Cola(int capacidad) {
        this.capacidad = capacidad;
        datos = new Object[capacidad];
        frente = 0;
        fin = -1;
        tamaño = 0;
    }

    public void enqueue(T valor) {
        if (tamaño == capacidad) {
            throw new RuntimeException("Cola llena");
        }
        fin = (fin + 1) % capacidad;
        datos[fin] = valor;
        tamaño++;
    }

    @SuppressWarnings("unchecked")
    public T dequeue() {
        if (tamaño == 0) {
            throw new RuntimeException("Cola vacía");
        }
        T valor = (T) datos[frente];
        frente = (frente + 1) % capacidad;
        tamaño--;
        return valor;
    }

    @SuppressWarnings("unchecked")
    public T peek() {
        if (tamaño == 0) {
            throw new RuntimeException("Cola vacía");
        }
        return (T) datos[frente];
    }

    public boolean isEmpty() {
        return tamaño == 0;
    }

    public int tamaño() {
        return tamaño;
    }
}
```

### Visualización del arreglo circular

```
    ¿Por qué "circular"?

    Con un arreglo NORMAL, al sacar elementos del frente se desperdicia espacio:

    enqueue(A,B,C):  [ A ][ B ][ C ][   ][   ]
    dequeue() → A:   [   ][ B ][ C ][   ][   ]
    dequeue() → B:   [   ][   ][ C ][   ][   ]
                      ↑↑↑  ↑↑↑
                      ¡Espacio desperdiciado! No se puede reusar.

    Con un arreglo CIRCULAR, los índices "dan la vuelta":

    Paso 1: enqueue(A), enqueue(B), enqueue(C)

        posición:  0     1     2     3     4
                 [ A ] [ B ] [ C ] [   ] [   ]
                   ↑                 ↑
                 frente              fin

    Paso 2: dequeue() → retorna A

        posición:  0     1     2     3     4
                 [   ] [ B ] [ C ] [   ] [   ]
                         ↑           ↑
                       frente        fin

    Paso 3: enqueue(D), enqueue(E), enqueue(F)

        posición:  0     1     2     3     4
                 [ F ] [ B ] [ C ] [ D ] [ E ]
                   ↑     ↑
                  fin  frente

        ¡F se guardó en la posición 0! El índice "dio la vuelta"
        gracias a la fórmula: fin = (fin + 1) % capacidad

        Cuando fin está en 4: (4 + 1) % 5 = 0  ← ¡vuelve al inicio!
```

---

## Implementación con lista enlazada

```java
class ColaEnlazada<T> {

    private Nodo<T> frente;
    private Nodo<T> fin;

    private static class Nodo<T> {
        T valor;
        Nodo<T> siguiente;

        Nodo(T valor) {
            this.valor = valor;
        }
    }

    public void enqueue(T valor) {
        Nodo<T> nuevo = new Nodo<>(valor);
        if (fin != null) {
            fin.siguiente = nuevo;
        }
        fin = nuevo;
        if (frente == null) {
            frente = nuevo;
        }
    }

    public T dequeue() {
        if (frente == null) {
            throw new RuntimeException("Cola vacía");
        }
        T valor = frente.valor;
        frente = frente.siguiente;
        if (frente == null) {
            fin = null;
        }
        return valor;
    }

    public T peek() {
        if (frente == null) {
            throw new RuntimeException("Cola vacía");
        }
        return frente.valor;
    }

    public boolean isEmpty() {
        return frente == null;
    }
}
```

---

## Colas y recursividad

Las colas no tienen una relación tan directa con la recursividad como las pilas. Sin embargo, hay un ejercicio clásico que conecta ambos conceptos:

### Invertir una cola usando recursividad

```java
static <T> void invertirCola(Cola<T> cola) {

    if (cola.isEmpty()) {
        return;
    }

    T valor = cola.dequeue();
    invertirCola(cola);
    cola.enqueue(valor);
}
```

Traza con cola `[10, 20, 30]` (10 al frente):

```
invertirCola([10, 20, 30])
    saca 10 → invertirCola([20, 30])
        saca 20 → invertirCola([30])
            saca 30 → invertirCola([])
                caso base
            enqueue(30) → [30]
        enqueue(20) → [30, 20]
    enqueue(10) → [30, 20, 10]
```

---

## 🎮 Paso 7: Sistema de turnos de combate

En un RPG por turnos, los personajes actúan en el orden en que fueron agregados. Esto es exactamente una **cola FIFO**.

### 🖼 ¿Cómo funciona el sistema de turnos?

```
    Los combatientes hacen fila. El del FRENTE ataca, y luego
    se va al FINAL de la fila para esperar su próximo turno.

    TURNO 1: Aldric ataca
    ┌────────┬────────┬────────┬────────┐
    │ Aldric │  Luna  │ Goblin │  Orco  │
    └────────┴────────┴────────┴────────┘
       ↑ sale                              ↓ vuelve al final
       │                                   │
       └──── ataca a Goblin ───────────────┘

    Después:
    ┌────────┬────────┬────────┬────────┐
    │  Luna  │ Goblin │  Orco  │ Aldric │
    └────────┴────────┴────────┴────────┘

    TURNO 2: Luna ataca
    ┌────────┬────────┬────────┬────────┐
    │  Luna  │ Goblin │  Orco  │ Aldric │
    └────────┴────────┴────────┴────────┘
       ↑ sale                              ↓ vuelve al final

    Después:
    ┌────────┬────────┬────────┬────────┐
    │ Goblin │  Orco  │ Aldric │  Luna  │
    └────────┴────────┴────────┴────────┘

    Si un combatiente MUERE, no vuelve a la cola:

    💀 Goblin derrotado → sale y NO regresa
    ┌────────┬────────┬────────┐
    │  Orco  │ Aldric │  Luna  │
    └────────┴────────┴────────┘
```

Primero necesitamos una clase para los combatientes (reutilizamos `Personaje` del capítulo anterior y creamos `Enemigo`):

```java
class Combatiente {

    String nombre;
    int vida;
    int ataque;
    int defensa;
    boolean esHeroe;

    Combatiente(String nombre, int vida, int ataque, int defensa, boolean esHeroe) {
        this.nombre = nombre;
        this.vida = vida;
        this.ataque = ataque;
        this.defensa = defensa;
        this.esHeroe = esHeroe;
    }

    boolean estaVivo() {
        return vida > 0;
    }

    String estado() {
        String tipo = esHeroe ? "🛡" : "👹";
        return tipo + " " + nombre + " [HP: " + vida + "]";
    }
}
```

Ahora el sistema de turnos:

```java
class SistemaTurnos {

    private Cola<Combatiente> turnos;

    SistemaTurnos() {
        turnos = new Cola<>(20);
    }

    void agregarCombatiente(Combatiente c) {
        turnos.enqueue(c);
        System.out.println("  " + c.nombre + " entra al combate.");
    }

    void mostrarOrden() {
        System.out.println("\n=== Orden de turnos ===");
        // Recorrer sin destruir: sacamos y volvemos a meter
        Cola<Combatiente> temp = new Cola<>(20);
        int pos = 1;

        while (!turnos.isEmpty()) {
            Combatiente c = turnos.dequeue();
            System.out.println("  " + pos + ". " + c.estado());
            temp.enqueue(c);
            pos++;
        }

        // Restaurar
        while (!temp.isEmpty()) {
            turnos.enqueue(temp.dequeue());
        }
    }

    void ejecutarRonda() {
        System.out.println("\n⚔ === NUEVA RONDA === ⚔");

        int combatientes = turnos.tamaño();

        for (int i = 0; i < combatientes; i++) {

            Combatiente actual = turnos.dequeue();

            if (!actual.estaVivo()) {
                System.out.println("  💀 " + actual.nombre + " ya fue derrotado.");
                continue;  // no vuelve a la cola
            }

            // Buscar un objetivo (el siguiente vivo del bando contrario)
            Combatiente objetivo = buscarObjetivo(actual);

            if (objetivo != null) {
                int daño = Math.max(1, actual.ataque - objetivo.defensa);
                objetivo.vida -= daño;

                System.out.println("  " + actual.nombre + " ataca a "
                    + objetivo.nombre + " por " + daño + " de daño.");

                if (!objetivo.estaVivo()) {
                    System.out.println("  💀 " + objetivo.nombre + " ha sido derrotado!");
                }
            } else {
                System.out.println("  " + actual.nombre + " no tiene objetivos.");
            }

            // El combatiente vuelve al final de la cola si sigue vivo
            if (actual.estaVivo()) {
                turnos.enqueue(actual);
            }
        }
    }

    private Combatiente buscarObjetivo(Combatiente atacante) {
        int size = turnos.tamaño();

        for (int i = 0; i < size; i++) {
            Combatiente c = turnos.dequeue();
            turnos.enqueue(c);

            if (c.estaVivo() && c.esHeroe != atacante.esHeroe) {
                return c;
            }
        }
        return null;
    }

    boolean combateTerminado() {
        boolean hayHeroes = false;
        boolean hayEnemigos = false;

        int size = turnos.tamaño();
        for (int i = 0; i < size; i++) {
            Combatiente c = turnos.dequeue();
            turnos.enqueue(c);

            if (c.estaVivo() && c.esHeroe) hayHeroes = true;
            if (c.estaVivo() && !c.esHeroe) hayEnemigos = true;
        }

        return !hayHeroes || !hayEnemigos;
    }
}
```

### Probemos un combate

```java
public class CombateRPG {

    public static void main(String[] args) {

        SistemaTurnos combate = new SistemaTurnos();

        // Agregar héroes
        combate.agregarCombatiente(new Combatiente("Aldric", 100, 20, 8, true));
        combate.agregarCombatiente(new Combatiente("Luna", 70, 25, 5, true));

        // Agregar enemigos
        combate.agregarCombatiente(new Combatiente("Goblin", 40, 12, 3, false));
        combate.agregarCombatiente(new Combatiente("Orco", 80, 18, 6, false));

        combate.mostrarOrden();

        int ronda = 1;
        while (!combate.combateTerminado()) {
            System.out.println("\n--- Ronda " + ronda + " ---");
            combate.ejecutarRonda();
            ronda++;
        }

        System.out.println("\n🏆 ¡Combate terminado!");
    }
}
```

### Traza del sistema de turnos

| Turno | Frente de la cola | Acción | Cola después |
|-------|-------------------|--------|--------------|
| 1 | Aldric | Ataca a Goblin | [Luna, Goblin, Orco, Aldric] |
| 2 | Luna | Ataca a Goblin | [Goblin, Orco, Aldric, Luna] |
| 3 | Goblin | Ataca a Aldric (si vive) | [Orco, Aldric, Luna, Goblin] |
| 4 | Orco | Ataca a Aldric | [Aldric, Luna, Goblin, Orco] |

Cada combatiente sale del frente, actúa, y vuelve al final. Los derrotados no regresan.

---

## 🎮 Paso 8: Cola de eventos del juego

Durante la exploración, ocurren eventos en orden: aparece un cofre, luego un enemigo, luego una trampa. Estos eventos se procesan en orden FIFO.

```java
class EventoJuego {

    String tipo;       // "cofre", "enemigo", "trampa", "tienda", "descanso"
    String descripcion;
    int valor;         // oro del cofre, daño de trampa, etc.

    EventoJuego(String tipo, String descripcion, int valor) {
        this.tipo = tipo;
        this.descripcion = descripcion;
        this.valor = valor;
    }
}

class ColaEventos {

    private Cola<EventoJuego> eventos;

    ColaEventos() {
        eventos = new Cola<>(50);
    }

    void agregarEvento(EventoJuego evento) {
        eventos.enqueue(evento);
    }

    void procesarSiguiente(Combatiente heroe) {
        if (eventos.isEmpty()) {
            System.out.println("No hay más eventos.");
            return;
        }

        EventoJuego evento = eventos.dequeue();

        System.out.println("\n📜 Evento: " + evento.descripcion);

        switch (evento.tipo) {
            case "cofre":
                System.out.println("  💰 Encontraste " + evento.valor + " monedas de oro!");
                break;
            case "enemigo":
                System.out.println("  👹 ¡Un " + evento.descripcion + " aparece!");
                heroe.vida -= evento.valor;
                System.out.println("  Recibes " + evento.valor + " de daño. HP: " + heroe.vida);
                break;
            case "trampa":
                System.out.println("  ⚠ ¡Trampa! Pierdes " + evento.valor + " HP.");
                heroe.vida -= evento.valor;
                break;
            case "descanso":
                System.out.println("  🏕 Descansas y recuperas " + evento.valor + " HP.");
                heroe.vida += evento.valor;
                break;
        }

        System.out.println("  Estado: " + heroe.estado());
    }

    void procesarTodos(Combatiente heroe) {
        System.out.println("=== Explorando la mazmorra ===");
        while (!eventos.isEmpty() && heroe.estaVivo()) {
            procesarSiguiente(heroe);
        }

        if (!heroe.estaVivo()) {
            System.out.println("\n💀 Has sido derrotado en la mazmorra...");
        } else {
            System.out.println("\n🏆 ¡Mazmorra completada!");
        }
    }

    // RECURSIVO: generar eventos aleatorios para una mazmorra de N salas
    void generarMazmorra(int salasRestantes) {
        if (salasRestantes == 0) {
            return;  // caso base
        }

        // Simular un evento según la sala
        if (salasRestantes % 3 == 0) {
            agregarEvento(new EventoJuego("cofre", "Cofre misterioso", 50));
        } else if (salasRestantes % 3 == 1) {
            agregarEvento(new EventoJuego("enemigo", "Esqueleto", 15));
        } else {
            agregarEvento(new EventoJuego("trampa", "Trampa de pinchos", 10));
        }

        generarMazmorra(salasRestantes - 1);  // generar el resto
    }
}
```

### Uso

```java
Combatiente heroe = new Combatiente("Aldric", 100, 20, 8, true);
ColaEventos mazmorra = new ColaEventos();

mazmorra.generarMazmorra(6);
mazmorra.procesarTodos(heroe);
```

---

## 🎮 Paso 9: Sistema de misiones con prioridad

No todas las misiones son iguales. Las misiones urgentes deben completarse primero. Esto es una **cola de prioridad**.

### 🖼 Cola normal vs. Cola de prioridad

```
    COLA NORMAL (FIFO):
    Sale el que llegó PRIMERO, sin importar la urgencia.

    Llegan en este orden:
    1. Recoger hierbas (baja)
    2. Salvar la aldea (urgente)
    3. Limpiar cueva (media)

    Cola: [ Hierbas ][ Aldea ][ Cueva ]
           ↑ sale primero
    ¡Recoger hierbas sale antes que salvar la aldea! 😱


    COLA DE PRIORIDAD:
    Sale el MÁS URGENTE, sin importar cuándo llegó.

    Llegan en el mismo orden, pero se organizan por prioridad:

    Cola: [ 🔴 Aldea ][ 🟡 Cueva ][ 🟢 Hierbas ]
            ↑ sale primero (es la más urgente)
    ¡Salvar la aldea sale primero! ✔


    Analogía: urgencias de un hospital
    ┌──────────────────────────────────────────┐
    │  🔴 Infarto        → se atiende primero  │
    │  🟡 Brazo roto     → espera un poco      │
    │  🟢 Dolor de cabeza → espera más          │
    └──────────────────────────────────────────┘
    No importa quién llegó primero, importa la GRAVEDAD.
```

```java
class Mision implements Comparable<Mision> {

    String nombre;
    String descripcion;
    int prioridad;     // 1 = urgente, 5 = opcional
    int recompensa;

    Mision(String nombre, String descripcion, int prioridad, int recompensa) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.prioridad = prioridad;
        this.recompensa = recompensa;
    }

    public int compareTo(Mision otra) {
        return this.prioridad - otra.prioridad;  // menor número = mayor prioridad
    }

    String toString() {
        String urgencia;
        switch (prioridad) {
            case 1: urgencia = "🔴 URGENTE"; break;
            case 2: urgencia = "🟠 Alta"; break;
            case 3: urgencia = "🟡 Media"; break;
            default: urgencia = "🟢 Baja"; break;
        }
        return urgencia + " | " + nombre + " (+" + recompensa + " oro)";
    }
}
```

Implementación simple de cola de prioridad (inserción ordenada):

```java
class ColaMisiones {

    private Mision[] misiones;
    private int tamaño;

    ColaMisiones(int capacidad) {
        misiones = new Mision[capacidad];
        tamaño = 0;
    }

    void agregar(Mision mision) {
        // Insertar en la posición correcta (ordenado por prioridad)
        int i = tamaño - 1;

        while (i >= 0 && misiones[i].prioridad > mision.prioridad) {
            misiones[i + 1] = misiones[i];
            i--;
        }

        misiones[i + 1] = mision;
        tamaño++;

        System.out.println("📋 Nueva misión: " + mision.toString());
    }

    Mision completarSiguiente() {
        if (tamaño == 0) {
            System.out.println("No hay misiones pendientes.");
            return null;
        }

        Mision mision = misiones[0];

        // Desplazar todo hacia adelante
        for (int i = 1; i < tamaño; i++) {
            misiones[i - 1] = misiones[i];
        }
        tamaño--;

        System.out.println("✅ Misión completada: " + mision.nombre
            + " | Recompensa: " + mision.recompensa + " oro");
        return mision;
    }

    void verMisiones() {
        System.out.println("\n=== Tablero de misiones ===");
        for (int i = 0; i < tamaño; i++) {
            System.out.println("  " + (i + 1) + ". " + misiones[i].toString());
        }
    }
}
```

### Uso en el juego

```java
ColaMisiones tablero = new ColaMisiones(20);

tablero.agregar(new Mision("Recoger hierbas", "Buscar 5 hierbas medicinales", 4, 20));
tablero.agregar(new Mision("Salvar la aldea", "Derrotar al dragón del norte", 1, 500));
tablero.agregar(new Mision("Escoltar mercader", "Proteger al mercader hasta la ciudad", 2, 100));
tablero.agregar(new Mision("Limpiar cueva", "Eliminar las ratas de la cueva", 3, 50));

tablero.verMisiones();
// 1. 🔴 URGENTE | Salvar la aldea (+500 oro)
// 2. 🟠 Alta    | Escoltar mercader (+100 oro)
// 3. 🟡 Media   | Limpiar cueva (+50 oro)
// 4. 🟢 Baja    | Recoger hierbas (+20 oro)

tablero.completarSiguiente();
// ✅ Misión completada: Salvar la aldea | Recompensa: 500 oro
```

---

## 🎮 Paso 10: Papa caliente — Eliminación en el combate

El clásico problema de Josefo aplicado al juego: los combatientes están en círculo y cada K turnos uno es eliminado. Esto se resuelve con una cola.

### 🖼 ¿Cómo funciona?

```
    6 guerreros en círculo, se cuenta hasta 3 (k=3):

    Ronda 1: contamos 1, 2, 3...
                    ①        ②        ③ ← ¡ELIMINADO!
    Cola:  [ Aldric ][ Luna ][ Goblin ][ Orco ][ Elfo ][ Enano ]

    ¿Cómo lo hacemos con la cola?
    - dequeue + enqueue (pasar al final) → cuenta 1: Aldric va al final
    - dequeue + enqueue (pasar al final) → cuenta 2: Luna va al final
    - dequeue (sin enqueue) → cuenta 3: Goblin ELIMINADO 💀

    Antes:  frente → [Aldric][Luna][Goblin][Orco][Elfo][Enano]
    Paso 1: frente → [Luna][Goblin][Orco][Elfo][Enano][Aldric]  (Aldric pasó al final)
    Paso 2: frente → [Goblin][Orco][Elfo][Enano][Aldric][Luna]  (Luna pasó al final)
    Paso 3: frente → [Orco][Elfo][Enano][Aldric][Luna]          (Goblin eliminado 💀)

    Se repite hasta que quede uno solo → ¡ese es el ganador! 🏆
```

```java
class PapaCaliente {

    static String jugar(String[] nombres, int k) {

        Cola<String> circulo = new Cola<>(nombres.length);

        for (String nombre : nombres) {
            circulo.enqueue(nombre);
        }

        System.out.println("=== Papa Caliente (k=" + k + ") ===");

        int ronda = 1;
        while (circulo.tamaño() > 1) {

            // Pasar la papa k-1 veces
            for (int i = 0; i < k - 1; i++) {
                circulo.enqueue(circulo.dequeue());
            }

            // El k-ésimo es eliminado
            String eliminado = circulo.dequeue();
            System.out.println("  Ronda " + ronda + ": " + eliminado + " es eliminado.");
            ronda++;
        }

        String ganador = circulo.dequeue();
        System.out.println("🏆 Ganador: " + ganador);
        return ganador;
    }
}
```

### Uso

```java
String[] guerreros = {"Aldric", "Luna", "Goblin", "Orco", "Elfo", "Enano"};
PapaCaliente.jugar(guerreros, 3);
```

### Traza con k=3

| Ronda | Cola (frente → fin) | Eliminado |
|-------|---------------------|-----------|
| 1 | Aldric, Luna, Goblin, Orco, Elfo, Enano | Goblin |
| 2 | Orco, Elfo, Enano, Aldric, Luna | Enano |
| 3 | Aldric, Luna, Orco, Elfo | Orco |
| 4 | Elfo, Aldric, Luna | Luna |
| 5 | Elfo, Aldric | Aldric |
| 🏆 | Elfo | Ganador |

---

## Comparación: Pila vs. Cola

| Aspecto | Pila (LIFO) | Cola (FIFO) |
|---|---|---|
| Orden de salida | Último en entrar | Primero en entrar |
| Analogía RPG | Mochila (último objeto guardado) | Fila de turnos de combate |
| Uso en recursión | Directamente (call stack) | Indirectamente (BFS) |
| Aplicaciones | Undo/redo, hechizos, DFS | Turnos, eventos, BFS |
| push/enqueue | O(1) | O(1) |
| pop/dequeue | O(1) | O(1) |

---

## Conexión con la biblioteca estándar de Java

```java
import java.util.LinkedList;
import java.util.Queue;
import java.util.PriorityQueue;

// Cola normal
Queue<String> cola = new LinkedList<>();
cola.add("Aldric");
cola.add("Luna");
System.out.println(cola.poll());  // "Aldric"

// Cola de prioridad
PriorityQueue<Mision> colaPrioridad = new PriorityQueue<>();
colaPrioridad.add(new Mision("Misión A", "", 3, 50));
colaPrioridad.add(new Mision("Misión B", "", 1, 200));
System.out.println(colaPrioridad.poll().nombre);  // "Misión B" (prioridad 1)
```

---

## 🎮 Ejercicios del proyecto

### Básicos

1. Agrega un método `saltarTurno()` al `SistemaTurnos` que mueva al combatiente del frente al final sin que ataque.

2. Modifica la `ColaEventos` para que al encontrar un cofre, el héroe pueda elegir abrirlo o dejarlo (simula con un parámetro booleano).

3. Implementa `intercalarColas(Cola a, Cola b)` para mezclar dos grupos de enemigos alternando: a1, b1, a2, b2...

### Intermedios

4. Implementa una **cola usando dos pilas** (del capítulo anterior). Una pila para enqueue, otra para dequeue. Úsala en el sistema de turnos.

5. Crea un sistema de **oleadas de enemigos**: la oleada 1 tiene 2 enemigos, la oleada 2 tiene 3, la oleada 3 tiene 5 (Fibonacci). Genera las oleadas recursivamente y agrégalas a la cola de combate.

6. Implementa un **sistema de buffs temporales** con cola: cada buff dura N turnos. Al inicio de cada turno, verifica si el buff del frente ya expiró (dequeue) o sigue activo.

### Avanzados

7. Combina el `SistemaAcciones` (pilas, cap. 3) con el `SistemaTurnos` (colas): cada combatiente tiene su propio historial de acciones con undo. El turno determina quién actúa, y las acciones se pueden deshacer.

8. (Recursivo) Implementa un generador de mazmorras recursivo: cada sala puede tener 0-2 puertas que llevan a más salas. Usa una cola para recorrer la mazmorra nivel por nivel (BFS) y generar los eventos.

---

## 🔜 Siguiente capítulo

En el **capítulo 5 (Ordenamientos)** agregaremos al proyecto:
- Un **ranking de héroes** ordenado por nivel, daño o victorias
- **Ordenar el inventario** por valor, peso o rareza
- **Búsqueda eficiente** de objetos en el inventario ordenado
