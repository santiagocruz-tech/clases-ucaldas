# 3. Pilas (Stacks)

## 🎮 Proyecto incremental: RPG por consola — Parte 1

A lo largo de los capítulos 3, 4 y 5 vamos a construir un **juego de rol por texto (RPG)** donde aprenderás pilas, colas y ordenamientos de forma práctica. Cada capítulo agrega funcionalidad nueva al mismo proyecto.

En este capítulo construiremos:
- Un **sistema de acciones con deshacer (undo/redo)** para el jugador
- Un **historial de hechizos lanzados** con pila
- Un **evaluador de fórmulas de daño** usando notación postfija

Al final del capítulo tendrás un personaje que puede realizar acciones, deshacerlas y lanzar hechizos con fórmulas de daño calculadas con pilas.

---

## Teoría

Una **pila** es una estructura de datos que funciona con el principio **LIFO** (Last In, First Out): el último elemento que entra es el primero que sale.

Analogía: imagina una pila de platos. Solo puedes poner o quitar platos por arriba. No puedes sacar el plato del fondo sin quitar todos los de encima.

Operaciones fundamentales:

- **push(valor):** agregar un elemento al tope
- **pop():** quitar y retornar el elemento del tope
- **peek():** ver el elemento del tope sin quitarlo
- **isEmpty():** verificar si la pila está vacía

---

## Implementación con arreglo

```java
class Pila<T> {

    private Object[] datos;
    private int tope;

    public Pila(int capacidad) {
        datos = new Object[capacidad];
        tope = -1;
    }

    public void push(T valor) {
        if (tope == datos.length - 1) {
            throw new RuntimeException("Pila llena");
        }
        datos[++tope] = valor;
    }

    @SuppressWarnings("unchecked")
    public T pop() {
        if (tope == -1) {
            throw new RuntimeException("Pila vacía");
        }
        return (T) datos[tope--];
    }

    @SuppressWarnings("unchecked")
    public T peek() {
        if (tope == -1) {
            throw new RuntimeException("Pila vacía");
        }
        return (T) datos[tope];
    }

    public boolean isEmpty() {
        return tope == -1;
    }

    public int tamaño() {
        return tope + 1;
    }
}
```

## Implementación con lista enlazada

```java
class PilaEnlazada<T> {

    private Nodo<T> tope;

    private static class Nodo<T> {
        T valor;
        Nodo<T> siguiente;

        Nodo(T valor) {
            this.valor = valor;
        }
    }

    public void push(T valor) {
        Nodo<T> nuevo = new Nodo<>(valor);
        nuevo.siguiente = tope;
        tope = nuevo;
    }

    public T pop() {
        if (tope == null) {
            throw new RuntimeException("Pila vacía");
        }
        T valor = tope.valor;
        tope = tope.siguiente;
        return valor;
    }

    public T peek() {
        if (tope == null) {
            throw new RuntimeException("Pila vacía");
        }
        return tope.valor;
    }

    public boolean isEmpty() {
        return tope == null;
    }
}
```

---

## Visualización de operaciones

```
Operación          Estado de la pila (tope arriba)
─────────          ──────────────────────────────
push(10)           | 10 |

push(20)           | 20 |
                   | 10 |

push(30)           | 30 |  ← tope
                   | 20 |
                   | 10 |

pop() → 30         | 20 |  ← tope
                   | 10 |

peek() → 20        | 20 |  ← tope (no se quita)
                   | 10 |

pop() → 20         | 10 |  ← tope

pop() → 10         (vacía)
```

---

## La pila y la recursividad: una conexión profunda

**La recursividad usa internamente una pila.** Cada llamada recursiva se apila en el call stack de Java. Por eso, todo lo que se puede hacer con recursividad se puede hacer con una pila explícita, y viceversa.

Cuando ejecutamos `factorial(4)`:

```
| factorial(1) |  ← tope (caso base, retorna 1)
| factorial(2) |  ← espera resultado para hacer 2 * resultado
| factorial(3) |  ← espera resultado para hacer 3 * resultado
| factorial(4) |  ← espera resultado para hacer 4 * resultado
```

Si un algoritmo recursivo causa `StackOverflowError`, puedes convertirlo a iterativo usando tu propia pila.

---

## 🎮 Paso 1: La clase Personaje

Empecemos creando nuestro héroe. Por ahora solo tiene nombre, vida y poder de ataque.

```java
class Personaje {

    String nombre;
    int vida;
    int ataque;
    int defensa;

    Personaje(String nombre, int vida, int ataque, int defensa) {
        this.nombre = nombre;
        this.vida = vida;
        this.ataque = ataque;
        this.defensa = defensa;
    }

    String estado() {
        return nombre + " [HP: " + vida + " | ATK: " + ataque + " | DEF: " + defensa + "]";
    }
}
```

---

## 🎮 Paso 2: Sistema de acciones con Undo/Redo

En muchos juegos puedes deshacer tu última acción. Esto se implementa con **dos pilas**: una para deshacer y otra para rehacer. Es el mismo patrón que usan los editores de texto (Ctrl+Z / Ctrl+Y).

Primero definimos qué es una acción:

```java
class Accion {

    String descripcion;
    int cambioVida;      // cuánto cambió la vida
    int cambioAtaque;    // cuánto cambió el ataque
    int cambioDefensa;   // cuánto cambió la defensa

    Accion(String descripcion, int cambioVida, int cambioAtaque, int cambioDefensa) {
        this.descripcion = descripcion;
        this.cambioVida = cambioVida;
        this.cambioAtaque = cambioAtaque;
        this.cambioDefensa = cambioDefensa;
    }
}
```

Ahora el sistema de undo/redo:

```java
class SistemaAcciones {

    private Pila<Accion> historial;    // para deshacer
    private Pila<Accion> rehecho;      // para rehacer
    private Personaje personaje;

    SistemaAcciones(Personaje personaje) {
        this.personaje = personaje;
        historial = new Pila<>(100);
        rehecho = new Pila<>(100);
    }

    void ejecutar(Accion accion) {
        // Aplicar la acción al personaje
        personaje.vida += accion.cambioVida;
        personaje.ataque += accion.cambioAtaque;
        personaje.defensa += accion.cambioDefensa;

        // Guardar en historial
        historial.push(accion);

        // Limpiar la pila de rehacer (nueva acción invalida el futuro)
        rehecho = new Pila<>(100);

        System.out.println("✔ " + accion.descripcion);
        System.out.println("  " + personaje.estado());
    }

    void deshacer() {
        if (historial.isEmpty()) {
            System.out.println("⚠ No hay acciones para deshacer.");
            return;
        }

        Accion accion = historial.pop();

        // Revertir los cambios (aplicar lo opuesto)
        personaje.vida -= accion.cambioVida;
        personaje.ataque -= accion.cambioAtaque;
        personaje.defensa -= accion.cambioDefensa;

        rehecho.push(accion);

        System.out.println("↩ Deshecho: " + accion.descripcion);
        System.out.println("  " + personaje.estado());
    }

    void rehacer() {
        if (rehecho.isEmpty()) {
            System.out.println("⚠ No hay acciones para rehacer.");
            return;
        }

        Accion accion = rehecho.pop();

        personaje.vida += accion.cambioVida;
        personaje.ataque += accion.cambioAtaque;
        personaje.defensa += accion.cambioDefensa;

        historial.push(accion);

        System.out.println("↪ Rehecho: " + accion.descripcion);
        System.out.println("  " + personaje.estado());
    }
}
```

### Probemos el sistema

```java
public class JuegoRPG {

    public static void main(String[] args) {

        Personaje heroe = new Personaje("Aldric", 100, 15, 10);
        SistemaAcciones sistema = new SistemaAcciones(heroe);

        System.out.println("=== Estado inicial ===");
        System.out.println(heroe.estado());
        System.out.println();

        // El héroe bebe una poción de fuerza
        sistema.ejecutar(new Accion("Beber poción de fuerza", 0, 5, 0));

        // El héroe equipa un escudo
        sistema.ejecutar(new Accion("Equipar escudo de hierro", 0, 0, 8));

        // El héroe recibe daño
        sistema.ejecutar(new Accion("Recibir golpe de goblin", -20, 0, 0));

        System.out.println("\n=== Deshaciendo acciones ===");
        sistema.deshacer();  // deshace el golpe del goblin
        sistema.deshacer();  // deshace el escudo

        System.out.println("\n=== Rehaciendo ===");
        sistema.rehacer();   // rehace el escudo
    }
}
```

### Traza paso a paso

| Acción | vida | ataque | defensa | historial | rehecho |
|--------|------|--------|---------|-----------|---------|
| Inicio | 100 | 15 | 10 | [] | [] |
| Poción de fuerza | 100 | 20 | 10 | [poción] | [] |
| Escudo de hierro | 100 | 20 | 18 | [poción, escudo] | [] |
| Golpe de goblin | 80 | 20 | 18 | [poción, escudo, golpe] | [] |
| Deshacer (golpe) | 100 | 20 | 18 | [poción, escudo] | [golpe] |
| Deshacer (escudo) | 100 | 20 | 10 | [poción] | [golpe, escudo] |
| Rehacer (escudo) | 100 | 20 | 18 | [poción, escudo] | [golpe] |

---

## 🎮 Paso 3: Historial de hechizos lanzados

El mago del grupo tiene un libro de hechizos. Cada hechizo lanzado se apila en su historial. Podemos ver el último hechizo lanzado, o revisar todo el historial.

```java
class Hechizo {

    String nombre;
    int daño;
    String elemento;  // "fuego", "hielo", "rayo"

    Hechizo(String nombre, int daño, String elemento) {
        this.nombre = nombre;
        this.daño = daño;
        this.elemento = elemento;
    }

    String toString() {
        return nombre + " (" + elemento + ", " + daño + " dmg)";
    }
}

class LibroHechizos {

    private Pila<Hechizo> historial;

    LibroHechizos() {
        historial = new Pila<>(50);
    }

    void lanzar(Hechizo hechizo) {
        historial.push(hechizo);
        System.out.println("🔥 Lanzaste: " + hechizo.toString());
    }

    void verUltimo() {
        if (historial.isEmpty()) {
            System.out.println("No has lanzado ningún hechizo.");
            return;
        }
        System.out.println("Último hechizo: " + historial.peek().toString());
    }

    void verHistorial() {
        if (historial.isEmpty()) {
            System.out.println("Historial vacío.");
            return;
        }

        System.out.println("=== Historial de hechizos (más reciente primero) ===");
        Pila<Hechizo> temporal = new Pila<>(50);

        while (!historial.isEmpty()) {
            Hechizo h = historial.pop();
            System.out.println("  - " + h.toString());
            temporal.push(h);
        }

        // Restaurar la pila original
        while (!temporal.isEmpty()) {
            historial.push(temporal.pop());
        }
    }

    // RECURSIVO: contar hechizos de un elemento específico
    int contarPorElemento(String elemento) {
        return contarRecursivo(elemento);
    }

    private int contarRecursivo(String elemento) {
        if (historial.isEmpty()) {
            return 0;
        }

        Hechizo h = historial.pop();
        int cuenta = contarRecursivo(elemento);

        if (h.elemento.equals(elemento)) {
            cuenta++;
        }

        historial.push(h);  // restaurar
        return cuenta;
    }
}
```

### Uso en el juego

```java
LibroHechizos libro = new LibroHechizos();

libro.lanzar(new Hechizo("Bola de fuego", 25, "fuego"));
libro.lanzar(new Hechizo("Rayo gélido", 18, "hielo"));
libro.lanzar(new Hechizo("Llamarada", 30, "fuego"));
libro.lanzar(new Hechizo("Tormenta eléctrica", 35, "rayo"));

libro.verUltimo();
// Último hechizo: Tormenta eléctrica (rayo, 35 dmg)

libro.verHistorial();
// Tormenta eléctrica, Llamarada, Rayo gélido, Bola de fuego

System.out.println("Hechizos de fuego: " + libro.contarPorElemento("fuego"));
// Hechizos de fuego: 2
```

---

## 🎮 Paso 4: Calculadora de daño con notación postfija

En nuestro RPG, las fórmulas de daño pueden ser complejas. Por ejemplo:

> Daño = (ataque_base + bonus_arma) × multiplicador_crítico - defensa_enemigo

En notación postfija esto se escribe: `ataque bonus + multiplicador * defensa -`

La ventaja: **no necesita paréntesis** y se evalúa con una pila.

```java
class CalculadoraDaño {

    static int evaluar(String formula) {

        Pila<Integer> pila = new Pila<>(100);
        String[] tokens = formula.split(" ");

        for (String token : tokens) {

            if (token.matches("-?\\d+")) {
                pila.push(Integer.parseInt(token));
            } else {
                int b = pila.pop();
                int a = pila.pop();

                switch (token) {
                    case "+": pila.push(a + b); break;
                    case "-": pila.push(a - b); break;
                    case "*": pila.push(a * b); break;
                    case "/": pila.push(a / b); break;
                }
            }
        }

        return pila.pop();
    }
}
```

### Ejemplo en el juego

```java
// Fórmula: (15 + 5) * 2 - 8
// Postfija: 15 5 + 2 * 8 -
int daño = CalculadoraDaño.evaluar("15 5 + 2 * 8 -");
System.out.println("Daño infligido: " + daño);  // 32
```

### Traza paso a paso

| Token | Acción | Pila |
|-------|--------|------|
| 15 | push(15) | [15] |
| 5 | push(5) | [15, 5] |
| + | pop 5, pop 15, push(20) | [20] |
| 2 | push(2) | [20, 2] |
| * | pop 2, pop 20, push(40) | [40] |
| 8 | push(8) | [40, 8] |
| - | pop 8, pop 40, push(32) | [32] |

Resultado: **32 de daño**

---

## 🎮 Paso 5: Verificar hechizos con paréntesis balanceados

Los hechizos del juego tienen encantamientos con símbolos que deben estar balanceados. Si un mago escribe mal la fórmula, el hechizo falla.

```java
class ValidadorHechizo {

    static boolean formulaValida(String encantamiento) {

        Pila<Character> pila = new Pila<>(encantamiento.length());

        for (int i = 0; i < encantamiento.length(); i++) {

            char c = encantamiento.charAt(i);

            if (c == '(' || c == '[' || c == '{') {
                pila.push(c);
            } else if (c == ')' || c == ']' || c == '}') {

                if (pila.isEmpty()) return false;

                char abierto = pila.pop();
                if (c == ')' && abierto != '(') return false;
                if (c == ']' && abierto != '[') return false;
                if (c == '}' && abierto != '{') return false;
            }
        }

        return pila.isEmpty();
    }
}
```

### Uso en el juego

```java
String hechizo1 = "{fuego[rayo(explosión)]}";
String hechizo2 = "{fuego[rayo(explosión]}";

System.out.println("Hechizo 1: " +
    (ValidadorHechizo.formulaValida(hechizo1) ? "✔ Válido" : "✘ Inválido"));
// ✔ Válido

System.out.println("Hechizo 2: " +
    (ValidadorHechizo.formulaValida(hechizo2) ? "✔ Válido" : "✘ Inválido"));
// ✘ Inválido
```

---

## 🎮 Paso 6: Invertir pila de recompensas (recursivo)

Al completar una mazmorra, el héroe recibe recompensas apiladas. Pero las quiere en orden inverso (la primera recompensa obtenida primero).

```java
class Recompensas {

    static void insertarAlFondo(Pila<String> pila, String valor) {
        if (pila.isEmpty()) {
            pila.push(valor);
            return;
        }

        String temp = pila.pop();
        insertarAlFondo(pila, valor);
        pila.push(temp);
    }

    static void invertir(Pila<String> pila) {
        if (pila.isEmpty()) {
            return;
        }

        String temp = pila.pop();
        invertir(pila);
        insertarAlFondo(pila, temp);
    }
}
```

### Uso

```java
Pila<String> cofre = new Pila<>(10);
cofre.push("Espada oxidada");
cofre.push("Poción menor");
cofre.push("Anillo de poder");
cofre.push("Armadura de dragón");

System.out.println("Tope antes: " + cofre.peek());
// Armadura de dragón

Recompensas.invertir(cofre);

System.out.println("Tope después: " + cofre.peek());
// Espada oxidada
```

### Traza recursiva

```
invertir(| Armadura | Anillo | Poción | Espada |)
    pop Armadura → invertir(| Anillo | Poción | Espada |)
        pop Anillo → invertir(| Poción | Espada |)
            pop Poción → invertir(| Espada |)
                pop Espada → invertir(vacía)
                    caso base
                insertarAlFondo(vacía, Espada) → | Espada |
            insertarAlFondo(| Espada |, Poción) → | Espada | Poción |
        insertarAlFondo(| Espada | Poción |, Anillo) → | Espada | Poción | Anillo |
    insertarAlFondo(| Espada | Poción | Anillo |, Armadura) → | Espada | Poción | Anillo | Armadura |
```

---

## Ventajas y desventajas: Pila con arreglo vs. lista enlazada

| Criterio | Arreglo | Lista enlazada |
|---|---|---|
| Capacidad | Fija (o con redimensionamiento) | Ilimitada |
| Memoria | Puede desperdiciar espacio | Usa lo necesario + overhead por nodos |
| Velocidad | Ligeramente más rápida | Ligeramente más lenta |
| Cache-friendly | Sí (datos contiguos) | No (nodos dispersos) |

## Complejidad de operaciones

| Operación | Arreglo | Lista enlazada |
|---|---|---|
| push | O(1) amortizado | O(1) |
| pop | O(1) | O(1) |
| peek | O(1) | O(1) |
| buscar | O(n) | O(n) |

---

## Conexión con la biblioteca estándar de Java

```java
import java.util.ArrayDeque;
import java.util.Deque;

Deque<Integer> pila = new ArrayDeque<>();
pila.push(10);
pila.push(20);
System.out.println(pila.pop());    // 20
```

`ArrayDeque` es más rápida que `java.util.Stack` porque `Stack` hereda de `Vector` (sincronizado, más lento).

---

## 🎮 Ejercicios del proyecto

### Básicos

1. Agrega un método `verHistorialAcciones()` al `SistemaAcciones` que imprima todas las acciones realizadas sin destruir la pila.

2. Implementa un método `deshacerTodo()` que revierta todas las acciones de una sola vez.

3. Agrega al `LibroHechizos` un método `hechizoMasPoderoso()` que recorra la pila recursivamente y retorne el hechizo con mayor daño.

### Intermedios

4. Crea una clase `Mochila` que funcione como pila: el héroe solo puede acceder al último objeto que guardó. Implementa `guardar(item)`, `sacar()`, `verContenido()`.

5. Implementa una fórmula de daño más compleja que considere resistencias elementales. Por ejemplo: `"ataque bonus + defensa - resistencia - 2 *"` donde el resultado final se multiplica por 2 si el enemigo es débil al elemento.

6. Crea un sistema de **mazmorras anidadas**: el héroe entra a una mazmorra (push), puede entrar a una sub-mazmorra dentro de ella (push), y al salir (pop) vuelve a la anterior. Muestra el nivel de profundidad actual.

### Avanzados

7. Implementa un sistema de **combos de hechizos**: si el mago lanza 3 hechizos del mismo elemento seguidos, se activa un combo especial. Usa la pila para verificar los últimos 3 hechizos.

8. (Backtracking) El héroe tiene N pociones con diferentes efectos. Encuentra todas las combinaciones de pociones que sumen exactamente un valor objetivo de curación. Usa una pila para almacenar las decisiones.

---

## 🔜 Siguiente capítulo

En el **capítulo 4 (Colas)** agregaremos al proyecto:
- Un **sistema de turnos de combate** donde héroes y enemigos esperan su turno
- Una **cola de eventos** del juego (aparecen enemigos, se encuentran cofres, etc.)
- Un **sistema de misiones** con cola de prioridad
