# 5. Algoritmos de ordenamiento

## 🎮 Proyecto incremental: RPG por consola — Parte 3

En los capítulos anteriores construimos un sistema de acciones con undo/redo (pilas) y un sistema de turnos de combate con eventos (colas).

Ahora agregaremos al proyecto:
- Un **ranking de héroes** ordenado por diferentes criterios
- Un **inventario ordenable** por valor, peso o rareza
- **Búsqueda eficiente** de objetos usando búsqueda binaria
- **Merge Sort** para ordenar el historial de combates
- **Quick Sort** para el ranking competitivo

---

## ¿Por qué importa ordenar?

- Buscar en datos ordenados es mucho más rápido (búsqueda binaria: O(log n) vs. O(n))
- Muchos algoritmos requieren datos ordenados como precondición
- En nuestro RPG: mostrar rankings, encontrar el mejor objeto, organizar el inventario

---

## 🎮 Paso 11: La clase Item para el inventario

Antes de ordenar, necesitamos objetos que ordenar. Creemos los ítems del juego:

```java
class Item {

    String nombre;
    String tipo;       // "arma", "armadura", "pocion", "material"
    int valor;         // precio en oro
    int peso;          // en unidades de peso
    int rareza;        // 1=común, 2=poco común, 3=raro, 4=épico, 5=legendario

    Item(String nombre, String tipo, int valor, int peso, int rareza) {
        this.nombre = nombre;
        this.tipo = tipo;
        this.valor = valor;
        this.peso = peso;
        this.rareza = rareza;
    }

    String etiquetaRareza() {
        switch (rareza) {
            case 1: return "⚪ Común";
            case 2: return "🟢 Poco común";
            case 3: return "🔵 Raro";
            case 4: return "🟣 Épico";
            case 5: return "🟡 Legendario";
            default: return "???";
        }
    }

    String toString() {
        return etiquetaRareza() + " | " + nombre + " (" + tipo + ") - "
            + valor + " oro, " + peso + " kg";
    }
}
```

---

## 5.1 Bubble Sort — Ordenar el inventario básico

El algoritmo más simple. Compara pares adyacentes y los intercambia si están desordenados. Ideal para entender el concepto.

### 🖼 ¿Cómo funciona Bubble Sort?

```
    Imagina burbujas en el agua: las más grandes SUBEN.
    En Bubble Sort, los números más grandes "burbujean" hacia la derecha.

    Arreglo: [ 5 ] [ 3 ] [ 8 ] [ 1 ]

    PASADA 1: comparamos pares de izquierda a derecha

    [ 5 ] [ 3 ]  →  5 > 3? SÍ → intercambiar  →  [ 3 ] [ 5 ] [ 8 ] [ 1 ]
          [ 5 ] [ 8 ]  →  5 > 8? NO → dejar     →  [ 3 ] [ 5 ] [ 8 ] [ 1 ]
                [ 8 ] [ 1 ]  →  8 > 1? SÍ → swap →  [ 3 ] [ 5 ] [ 1 ] [ 8 ]
                                                                          ↑
                                                              8 ya está en su lugar ✔

    PASADA 2: (ya no tocamos el último)

    [ 3 ] [ 5 ]  →  3 > 5? NO                    →  [ 3 ] [ 5 ] [ 1 ] [ 8 ]
          [ 5 ] [ 1 ]  →  5 > 1? SÍ → swap       →  [ 3 ] [ 1 ] [ 5 ] [ 8 ]
                                                               ↑
                                                   5 ya está en su lugar ✔

    PASADA 3:

    [ 3 ] [ 1 ]  →  3 > 1? SÍ → swap             →  [ 1 ] [ 3 ] [ 5 ] [ 8 ]
                                                       ↑
                                                   ¡TODO ORDENADO! ✔

    Resumen visual:
    Inicio:   [ 5 ][ 3 ][ 8 ][ 1 ]
    Pasada 1: [ 3 ][ 5 ][ 1 ][ 8 ]  ← 8 llegó al final
    Pasada 2: [ 3 ][ 1 ][ 5 ][ 8 ]  ← 5 llegó a su lugar
    Pasada 3: [ 1 ][ 3 ][ 5 ][ 8 ]  ← todo ordenado ✔
```

```java
class Inventario {

    private Item[] items;
    private int cantidad;

    Inventario(int capacidad) {
        items = new Item[capacidad];
        cantidad = 0;
    }

    void agregar(Item item) {
        if (cantidad < items.length) {
            items[cantidad++] = item;
            System.out.println("  + " + item.nombre + " agregado al inventario.");
        }
    }

    void mostrar() {
        System.out.println("\n=== Inventario (" + cantidad + " objetos) ===");
        for (int i = 0; i < cantidad; i++) {
            System.out.println("  " + (i + 1) + ". " + items[i].toString());
        }
    }

    // Bubble Sort por valor (oro)
    void ordenarPorValor() {
        System.out.println("\n🔄 Ordenando por valor (Bubble Sort)...");

        for (int i = 0; i < cantidad - 1; i++) {

            boolean huboIntercambio = false;

            for (int j = 0; j < cantidad - 1 - i; j++) {

                if (items[j].valor > items[j + 1].valor) {
                    Item temp = items[j];
                    items[j] = items[j + 1];
                    items[j + 1] = temp;
                    huboIntercambio = true;
                }
            }

            if (!huboIntercambio) break;
        }

        System.out.println("✔ Inventario ordenado por valor.");
    }
}
```

### Traza con inventario

```
Items: [Espada(100), Poción(15), Escudo(80), Hierba(5)]

Pasada 1: compara pares adyacentes
  Espada(100) > Poción(15) → intercambiar → [Poción, Espada, Escudo, Hierba]
  Espada(100) > Escudo(80) → intercambiar → [Poción, Escudo, Espada, Hierba]
  Espada(100) > Hierba(5)  → intercambiar → [Poción, Escudo, Hierba, Espada]

Pasada 2:
  Poción(15) < Escudo(80)  → no cambia
  Escudo(80) > Hierba(5)   → intercambiar → [Poción, Hierba, Escudo, Espada]

Pasada 3:
  Poción(15) > Hierba(5)   → intercambiar → [Hierba, Poción, Escudo, Espada]

Resultado: [Hierba(5), Poción(15), Escudo(80), Espada(100)] ✓
```

Complejidad: **O(n²)** peor caso, **O(n)** mejor caso (ya ordenado).

---

## 5.2 Selection Sort — Encontrar el mejor objeto

Encuentra el mínimo (o máximo) y lo coloca en su posición. Útil cuando queremos encontrar "el más valioso", "el más raro", etc.

### 🖼 ¿Cómo funciona Selection Sort?

```
    Imagina que tienes cartas desordenadas y quieres ordenarlas.
    Buscas la MÁS PEQUEÑA de todas y la pones en la primera posición.
    Luego buscas la más pequeña del RESTO y la pones en la segunda. Y así.

    Arreglo: [ 40 ] [ 10 ] [ 30 ] [ 20 ]

    PASO 1: buscar el MÍNIMO de todo el arreglo
            [ 40 ] [ 10 ] [ 30 ] [ 20 ]
                     ↑
                   mínimo = 10 (posición 1)
            Intercambiar con posición 0:
            [ 10 ] [ 40 ] [ 30 ] [ 20 ]
              ✔

    PASO 2: buscar el MÍNIMO desde posición 1 en adelante
            [ 10 ] [ 40 ] [ 30 ] [ 20 ]
                                    ↑
                                  mínimo = 20 (posición 3)
            Intercambiar con posición 1:
            [ 10 ] [ 20 ] [ 30 ] [ 40 ]
              ✔      ✔

    PASO 3: buscar el MÍNIMO desde posición 2 en adelante
            [ 10 ] [ 20 ] [ 30 ] [ 40 ]
                            ↑
                          mínimo = 30 (ya está en su lugar)
            [ 10 ] [ 20 ] [ 30 ] [ 40 ]
              ✔      ✔      ✔      ✔    ← ¡ORDENADO!
```

```java
// Dentro de la clase Inventario

void ordenarPorRareza() {
    System.out.println("\n🔄 Ordenando por rareza (Selection Sort)...");

    for (int i = 0; i < cantidad - 1; i++) {

        int indiceMax = i;

        for (int j = i + 1; j < cantidad; j++) {
            if (items[j].rareza > items[indiceMax].rareza) {
                indiceMax = j;
            }
        }

        // Intercambiar
        Item temp = items[i];
        items[i] = items[indiceMax];
        items[indiceMax] = temp;
    }

    System.out.println("✔ Inventario ordenado por rareza (legendario primero).");
}
```

Complejidad: **O(n²)** siempre.

---

## 5.3 Insertion Sort — Insertar objetos en orden

Toma cada elemento y lo inserta en la posición correcta. Como cuando ordenas cartas en la mano, o cuando un nuevo ítem llega al inventario y lo colocas en su lugar.

### 🖼 ¿Cómo funciona Insertion Sort?

```
    Imagina que estás jugando cartas. Recibes una carta a la vez
    y la colocas en el lugar correcto de tu mano.

    Mano:  [ 5 ]                    ← primera carta, ya está "ordenada"

    Llega 3:
           [ 5 ]  ← 3 es menor que 5, va ANTES
    Mano:  [ 3 ][ 5 ]

    Llega 8:
                  [ 5 ]  ← 8 es mayor que 5, va DESPUÉS
    Mano:  [ 3 ][ 5 ][ 8 ]

    Llega 1:
           [ 3 ]  ← 1 es menor que todos, va AL INICIO
    Mano:  [ 1 ][ 3 ][ 5 ][ 8 ]

    Llega 4:
                  [ 3 ]  [ 5 ]  ← 4 va entre 3 y 5
    Mano:  [ 1 ][ 3 ][ 4 ][ 5 ][ 8 ]


    En el arreglo se ve así:

    Inicio:   [ 5 ][ 3 ][ 8 ][ 1 ][ 4 ]
               ─── 
               ordenado

    Paso 1:   [ 3 ][ 5 ][ 8 ][ 1 ][ 4 ]    ← 3 se insertó antes de 5
               ─────────
                ordenado

    Paso 2:   [ 3 ][ 5 ][ 8 ][ 1 ][ 4 ]    ← 8 ya estaba en su lugar
               ──────────────
                  ordenado

    Paso 3:   [ 1 ][ 3 ][ 5 ][ 8 ][ 4 ]    ← 1 se movió al inicio
               ───────────────────
                    ordenado

    Paso 4:   [ 1 ][ 3 ][ 4 ][ 5 ][ 8 ]    ← 4 se insertó entre 3 y 5
               ──────────────────────────
                      ¡TODO ORDENADO! ✔
```

```java
// Dentro de la clase Inventario

void ordenarPorPeso() {
    System.out.println("\n🔄 Ordenando por peso (Insertion Sort)...");

    for (int i = 1; i < cantidad; i++) {

        Item clave = items[i];
        int j = i - 1;

        while (j >= 0 && items[j].peso > clave.peso) {
            items[j + 1] = items[j];
            j--;
        }

        items[j + 1] = clave;
    }

    System.out.println("✔ Inventario ordenado por peso (más liviano primero).");
}
```

Complejidad: **O(n²)** peor caso, **O(n)** mejor caso (ya ordenado).

---

## 🎮 Paso 12: Probemos el inventario

```java
public class InventarioRPG {

    public static void main(String[] args) {

        Inventario inv = new Inventario(20);

        inv.agregar(new Item("Espada de fuego", "arma", 250, 8, 4));
        inv.agregar(new Item("Poción menor", "pocion", 15, 1, 1));
        inv.agregar(new Item("Escudo de roble", "armadura", 80, 12, 2));
        inv.agregar(new Item("Hierba curativa", "material", 5, 1, 1));
        inv.agregar(new Item("Anillo del dragón", "accesorio", 1000, 1, 5));
        inv.agregar(new Item("Cota de malla", "armadura", 150, 15, 3));

        inv.mostrar();

        inv.ordenarPorValor();
        inv.mostrar();

        inv.ordenarPorRareza();
        inv.mostrar();

        inv.ordenarPorPeso();
        inv.mostrar();
    }
}
```

---

## 5.4 Merge Sort — Ordenar el historial de combates (recursivo)

Cuando el historial de combates es muy largo, necesitamos un algoritmo más eficiente. **Merge Sort** divide el arreglo a la mitad, ordena cada mitad recursivamente, y luego las combina.

### 🖼 ¿Cómo funciona Merge Sort?

```
    La idea: "Divide y vencerás"

    Si tienes un problema GRANDE, divídelo en problemas PEQUEÑOS,
    resuelve cada uno, y luego COMBINA las soluciones.

    Paso 1: DIVIDIR hasta tener arreglos de 1 elemento (ya están ordenados)

                    [ 38  27  43  3 ]
                    ┌───────┴───────┐
                    ↓               ↓
               [ 38  27 ]      [ 43  3 ]
               ┌────┴────┐    ┌────┴────┐
               ↓         ↓    ↓         ↓
             [ 38 ]    [ 27 ][ 43 ]    [ 3 ]
               ↑         ↑    ↑         ↑
               └─────────┘    └─────────┘
               Un solo elemento = ya ordenado ✔


    Paso 2: COMBINAR (merge) de abajo hacia arriba

             [ 38 ]    [ 27 ][ 43 ]    [ 3 ]
               └────┬────┘    └────┬────┘
                    ↓              ↓
               [ 27  38 ]      [ 3  43 ]      ← se combinan ordenados
                    └──────┬──────┘
                           ↓
                  [ 3  27  38  43 ]            ← resultado final ✔


    ¿Cómo se COMBINAN dos arreglos ordenados?

    Izquierda: [ 27  38 ]     Derecha: [ 3  43 ]
                 ↑                       ↑
                 i                       j

    Comparar: 27 vs 3 → 3 es menor → tomar 3
    Resultado: [ 3 ]

    Izquierda: [ 27  38 ]     Derecha: [ 3  43 ]
                 ↑                            ↑
                 i                            j

    Comparar: 27 vs 43 → 27 es menor → tomar 27
    Resultado: [ 3  27 ]

    Comparar: 38 vs 43 → 38 es menor → tomar 38
    Resultado: [ 3  27  38 ]

    Solo queda 43 → tomar 43
    Resultado: [ 3  27  38  43 ] ✔
```

```java
class RegistroCombate {

    String enemigo;
    int dañoTotal;
    int ronda;

    RegistroCombate(String enemigo, int dañoTotal, int ronda) {
        this.enemigo = enemigo;
        this.dañoTotal = dañoTotal;
        this.ronda = ronda;
    }

    String toString() {
        return "Ronda " + ronda + ": vs " + enemigo + " (" + dañoTotal + " daño)";
    }
}

class HistorialCombates {

    static void ordenarPorDaño(RegistroCombate[] registros, int inicio, int fin) {

        if (inicio >= fin) {
            return;  // caso base: 0 o 1 elemento
        }

        int medio = (inicio + fin) / 2;

        ordenarPorDaño(registros, inicio, medio);       // ordenar mitad izquierda
        ordenarPorDaño(registros, medio + 1, fin);      // ordenar mitad derecha
        merge(registros, inicio, medio, fin);            // combinar
    }

    private static void merge(RegistroCombate[] arr, int inicio, int medio, int fin) {

        RegistroCombate[] temp = new RegistroCombate[fin - inicio + 1];
        int i = inicio;
        int j = medio + 1;
        int k = 0;

        while (i <= medio && j <= fin) {
            if (arr[i].dañoTotal >= arr[j].dañoTotal) {  // mayor daño primero
                temp[k++] = arr[i++];
            } else {
                temp[k++] = arr[j++];
            }
        }

        while (i <= medio) temp[k++] = arr[i++];
        while (j <= fin) temp[k++] = arr[j++];

        for (int m = 0; m < temp.length; m++) {
            arr[inicio + m] = temp[m];
        }
    }
}
```

### Visualización del Merge Sort

```
Registros: [Goblin(25), Dragón(150), Orco(60), Slime(10)]

Dividir:
  [Goblin(25), Dragón(150)]    [Orco(60), Slime(10)]
  [Goblin(25)] [Dragón(150)]   [Orco(60)] [Slime(10)]

Combinar (mayor daño primero):
  [Dragón(150), Goblin(25)]    [Orco(60), Slime(10)]
  [Dragón(150), Orco(60), Goblin(25), Slime(10)]
```

### Ambiente recursivo

```
ordenarPorDaño([G(25), D(150), O(60), S(10)], 0, 3)
    ordenarPorDaño([G, D, O, S], 0, 1)          ← mitad izquierda
        ordenarPorDaño([G, D, O, S], 0, 0)      ← caso base
        ordenarPorDaño([G, D, O, S], 1, 1)      ← caso base
        merge → [D(150), G(25)]
    ordenarPorDaño([G, D, O, S], 2, 3)          ← mitad derecha
        ordenarPorDaño([G, D, O, S], 2, 2)      ← caso base
        ordenarPorDaño([G, D, O, S], 3, 3)      ← caso base
        merge → [O(60), S(10)]
    merge → [D(150), O(60), G(25), S(10)]
```

Complejidad: **O(n log n)** siempre. Usa **O(n)** de espacio extra.

---

## 5.5 Quick Sort — Ranking competitivo (recursivo)

Para el ranking de héroes usamos Quick Sort: elige un **pivote**, coloca todos los menores a la izquierda y los mayores a la derecha, y ordena cada lado recursivamente.

### 🖼 ¿Cómo funciona Quick Sort?

```
    La idea: elegir un PIVOTE y separar en dos grupos.

    Arreglo: [ 40  10  50  30  20 ]
                                ↑
                              pivote = 20

    Pregunta para cada elemento: ¿eres MENOR o MAYOR que el pivote (20)?

    [ 40  10  50  30  20 ]
      40 > 20 → derecha
      10 < 20 → izquierda
      50 > 20 → derecha
      30 > 20 → derecha

    Resultado después de particionar:

    menores que 20    pivote    mayores que 20
    ┌──────────┐    ┌──────┐   ┌──────────────┐
    │   [ 10 ] │    │ [ 20 ]│  │ [ 40  50  30 ]│
    └──────────┘    └──────┘   └──────────────┘
                       ↑
                    20 ya está en su posición FINAL ✔

    Ahora repetimos el proceso con cada lado:

    Izquierda: [ 10 ] → un solo elemento, ya ordenado ✔

    Derecha: [ 40  50  30 ]
                        ↑ pivote = 30
    [ 40  50  30 ]
      40 > 30 → derecha
      50 > 30 → derecha

    Resultado: [ ] [ 30 ] [ 40  50 ]
                     ✔

    [ 40  50 ] → pivote = 50
    40 < 50 → izquierda

    Resultado: [ 40 ] [ 50 ] → ✔

    RESULTADO FINAL: [ 10  20  30  40  50 ] ✔
```

```java
class HeroeRanking {

    String nombre;
    int nivel;
    int victorias;
    int dañoTotal;

    HeroeRanking(String nombre, int nivel, int victorias, int dañoTotal) {
        this.nombre = nombre;
        this.nivel = nivel;
        this.victorias = victorias;
        this.dañoTotal = dañoTotal;
    }

    String toString() {
        return nombre + " (Nv." + nivel + " | " + victorias + " victorias | "
            + dañoTotal + " daño total)";
    }
}

class Ranking {

    static void ordenarPorVictorias(HeroeRanking[] heroes, int inicio, int fin) {

        if (inicio >= fin) {
            return;
        }

        int indicePivote = particionar(heroes, inicio, fin);

        ordenarPorVictorias(heroes, inicio, indicePivote - 1);
        ordenarPorVictorias(heroes, indicePivote + 1, fin);
    }

    private static int particionar(HeroeRanking[] arr, int inicio, int fin) {

        int pivote = arr[fin].victorias;
        int i = inicio - 1;

        for (int j = inicio; j < fin; j++) {
            if (arr[j].victorias >= pivote) {  // mayor victorias primero
                i++;
                HeroeRanking temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }

        HeroeRanking temp = arr[i + 1];
        arr[i + 1] = arr[fin];
        arr[fin] = temp;

        return i + 1;
    }

    static void mostrar(HeroeRanking[] heroes, int cantidad) {
        System.out.println("\n🏆 === RANKING DE HÉROES ===");
        for (int i = 0; i < cantidad; i++) {
            String medalla;
            switch (i) {
                case 0: medalla = "🥇"; break;
                case 1: medalla = "🥈"; break;
                case 2: medalla = "🥉"; break;
                default: medalla = "  " + (i + 1) + "."; break;
            }
            System.out.println(medalla + " " + heroes[i].toString());
        }
    }
}
```

### Uso

```java
HeroeRanking[] heroes = {
    new HeroeRanking("Aldric", 15, 42, 3200),
    new HeroeRanking("Luna", 18, 67, 5100),
    new HeroeRanking("Thorin", 12, 28, 1800),
    new HeroeRanking("Elara", 20, 89, 7500),
    new HeroeRanking("Kael", 16, 55, 4300)
};

Ranking.ordenarPorVictorias(heroes, 0, heroes.length - 1);
Ranking.mostrar(heroes, heroes.length);

// 🏆 === RANKING DE HÉROES ===
// 🥇 Elara (Nv.20 | 89 victorias | 7500 daño total)
// 🥈 Luna (Nv.18 | 67 victorias | 5100 daño total)
// 🥉 Kael (Nv.16 | 55 victorias | 4300 daño total)
//   4. Aldric (Nv.15 | 42 victorias | 3200 daño total)
//   5. Thorin (Nv.12 | 28 victorias | 1800 daño total)
```

Complejidad: **O(n log n)** promedio, **O(n²)** peor caso.

Ventaja sobre Merge Sort: ordena **in-place** (no necesita arreglo auxiliar).

---

## 5.6 Comparación de algoritmos

| Algoritmo | Peor caso | Mejor caso | Espacio | Estable | Uso en el RPG |
|---|---|---|---|---|---|
| Bubble Sort | O(n²) | O(n) | O(1) | Sí | Inventario pequeño |
| Selection Sort | O(n²) | O(n²) | O(1) | No | Encontrar el mejor ítem |
| Insertion Sort | O(n²) | O(n) | O(1) | Sí | Insertar ítems en orden |
| Merge Sort | O(n log n) | O(n log n) | O(n) | Sí | Historial de combates |
| Quick Sort | O(n²) | O(n log n) | O(log n) | No | Ranking competitivo |

**Estable** significa que elementos iguales mantienen su orden relativo original.

---

## 5.7 Búsqueda binaria — Encontrar objetos rápido

Ahora que el inventario está ordenado, podemos buscar objetos eficientemente.

### 🖼 ¿Cómo funciona la búsqueda binaria?

```
    Imagina un diccionario con 1000 páginas. Buscas la palabra "mango".

    ❌ Búsqueda LINEAL (una por una):
    Página 1... no. Página 2... no. Página 3... no...
    ¡Podrías necesitar revisar las 1000 páginas!

    ✔ Búsqueda BINARIA (dividir a la mitad):
    Abres en la mitad (página 500): "perro" → M está ANTES → descarto 500-1000
    Abres en la mitad de lo que queda (página 250): "gato" → M está DESPUÉS → descarto 1-250
    Abres en la mitad (página 375): "luna" → M está DESPUÉS → descarto 250-375
    Abres en la mitad (página 437): "mango" → ¡ENCONTRADO!

    Solo necesitaste 4 intentos en vez de 1000. 🚀


    Ejemplo con números — buscar 27 en un arreglo ordenado:

    [ 3 ][ 9 ][ 10 ][ 27 ][ 38 ][ 43 ][ 82 ]
      0    1     2     3     4     5     6      ← índices

    Intento 1: medio = (0+6)/2 = 3
    [ 3 ][ 9 ][ 10 ][ 27 ][ 38 ][ 43 ][ 82 ]
                       ↑
                    arr[3] = 27 = 27 → ¡ENCONTRADO! 🎯

    Solo 1 comparación.


    Buscar 10:

    Intento 1: medio = 3 → arr[3] = 27 > 10 → buscar a la IZQUIERDA
    [ 3 ][ 9 ][ 10 ]  ←  solo miramos esta mitad
      0    1     2

    Intento 2: medio = 1 → arr[1] = 9 < 10 → buscar a la DERECHA
                     [ 10 ]  ←  solo queda este
                       2

    Intento 3: medio = 2 → arr[2] = 10 = 10 → ¡ENCONTRADO! 🎯

    3 comparaciones en un arreglo de 7 elementos.
    Con 1,000,000 de elementos solo necesitarías ~20 comparaciones.
```

### Iterativa

```java
// Dentro de la clase Inventario (asumiendo ordenado por valor)

Item buscarPorValor(int valorBuscado) {

    int inicio = 0;
    int fin = cantidad - 1;

    while (inicio <= fin) {

        int medio = (inicio + fin) / 2;

        if (items[medio].valor == valorBuscado) {
            return items[medio];
        }

        if (items[medio].valor < valorBuscado) {
            inicio = medio + 1;
        } else {
            fin = medio - 1;
        }
    }

    return null;  // no encontrado
}
```

### Recursiva

```java
Item buscarPorValorRecursivo(int valorBuscado, int inicio, int fin) {

    if (inicio > fin) {
        return null;  // caso base: no encontrado
    }

    int medio = (inicio + fin) / 2;

    if (items[medio].valor == valorBuscado) {
        return items[medio];  // caso base: encontrado
    }

    if (items[medio].valor < valorBuscado) {
        return buscarPorValorRecursivo(valorBuscado, medio + 1, fin);
    }

    return buscarPorValorRecursivo(valorBuscado, inicio, medio - 1);
}
```

### Traza buscando un ítem de valor 150

```
Inventario ordenado por valor: [5, 15, 80, 150, 250, 1000]

buscar(150, 0, 5)
    medio = 2, items[2].valor = 80 < 150 → buscar derecha
    buscar(150, 3, 5)
        medio = 4, items[4].valor = 250 > 150 → buscar izquierda
        buscar(150, 3, 3)
            medio = 3, items[3].valor = 150 → ¡encontrado!
```

Complejidad: **O(log n)**. Con 1000 objetos, máximo 10 comparaciones.

---

## 🎮 Paso 13: Juntando todo — La tienda del RPG

Combinemos inventario, ordenamiento y búsqueda en una tienda del juego:

```java
class Tienda {

    private Inventario stock;

    Tienda() {
        stock = new Inventario(50);

        // Llenar la tienda
        stock.agregar(new Item("Daga de sombras", "arma", 120, 3, 3));
        stock.agregar(new Item("Poción de vida", "pocion", 25, 1, 1));
        stock.agregar(new Item("Armadura de placas", "armadura", 300, 20, 3));
        stock.agregar(new Item("Amuleto ancestral", "accesorio", 500, 1, 4));
        stock.agregar(new Item("Hierba silvestre", "material", 3, 1, 1));
        stock.agregar(new Item("Espada del alba", "arma", 800, 10, 5));
        stock.agregar(new Item("Escudo menor", "armadura", 60, 8, 2));
        stock.agregar(new Item("Elixir de maná", "pocion", 45, 1, 2));
    }

    void verPorPrecio() {
        stock.ordenarPorValor();
        stock.mostrar();
    }

    void verPorRareza() {
        stock.ordenarPorRareza();
        stock.mostrar();
    }

    void buscarItem(int presupuesto) {
        stock.ordenarPorValor();
        Item encontrado = stock.buscarPorValor(presupuesto);

        if (encontrado != null) {
            System.out.println("🔍 Encontrado: " + encontrado.toString());
        } else {
            System.out.println("🔍 No hay ítems con ese precio exacto.");
        }
    }
}
```

---

## 🎮 Ejercicios del proyecto

### Básicos

1. Agrega al inventario un método `ordenarPorNombre()` usando Bubble Sort que ordene alfabéticamente. Pista: usa `nombre.compareTo(otroNombre)`.

2. Implementa un método `itemMasValioso()` que use Selection Sort para encontrar el ítem más caro sin ordenar todo el arreglo (solo necesitas una pasada).

3. Crea un método `filtrarPorTipo(String tipo)` que retorne un nuevo arreglo solo con los ítems de ese tipo, y luego ordénalo por valor.

### Intermedios

4. Implementa Merge Sort para ordenar el inventario por **múltiples criterios**: primero por rareza (descendente), y si tienen la misma rareza, por valor (descendente). Esto se llama ordenamiento estable con criterio compuesto.

5. Modifica el ranking de héroes para que se pueda ordenar por diferentes criterios (victorias, nivel, daño total) sin duplicar código. Pista: usa una interfaz `Comparator` o pasa el criterio como parámetro.

6. Implementa **Bubble Sort recursivo** para el inventario: cada llamada recursiva realiza una "pasada" del bubble sort.

### Avanzados

7. Combina el sistema de turnos (cap. 4) con el ranking: después de cada combate, actualiza las estadísticas de los héroes y reordena el ranking automáticamente.

8. (Backtracking) El héroe tiene un presupuesto limitado y quiere comprar la combinación de ítems que maximice la rareza total sin exceder el presupuesto. Implementa la solución con backtracking y muestra todas las combinaciones posibles.

9. Implementa un sistema de **subastas**: varios héroes pujan por un ítem. Las pujas se procesan en orden (cola del cap. 4), y al final se ordena por monto para determinar el ganador.

---

## 🎮 Resumen del proyecto completo

A lo largo de los capítulos 3, 4 y 5 construimos un RPG con:

```
Capítulo 3 — Pilas
├── Sistema de acciones con Undo/Redo (dos pilas)
├── Historial de hechizos (pila)
├── Calculadora de daño postfija (pila)
├── Validador de fórmulas de hechizos (pila)
└── Recompensas invertidas (recursividad + pila)

Capítulo 4 — Colas
├── Sistema de turnos de combate (cola FIFO)
├── Cola de eventos de mazmorra (cola)
├── Sistema de misiones con prioridad (cola de prioridad)
└── Papa caliente / eliminación circular (cola)

Capítulo 5 — Ordenamientos
├── Inventario ordenable (Bubble, Selection, Insertion Sort)
├── Historial de combates (Merge Sort)
├── Ranking de héroes (Quick Sort)
└── Búsqueda de ítems (búsqueda binaria)
```

Cada estructura de datos resuelve un problema real del juego. Esa es la clave: **las estructuras de datos no son abstractas, son herramientas para resolver problemas concretos**.
