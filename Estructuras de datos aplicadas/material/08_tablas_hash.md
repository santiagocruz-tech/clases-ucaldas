# 8. Tablas Hash y Conjuntos

## Teoría

Una **tabla hash** (hash table) es una estructura que almacena pares **clave-valor** y permite acceso en **O(1)** promedio.

Analogía: un diccionario. Si buscas la palabra "recursión", no lees todo el diccionario desde la A. Vas directamente a la R. La tabla hash hace algo similar: usa una **función hash** para calcular la posición donde almacenar cada dato.

---

## Función hash

Una función hash convierte una clave en un índice del arreglo interno.

```java
int hash(String clave, int capacidad){
    int suma = 0;
    for(int i = 0; i < clave.length(); i++){
        suma += clave.charAt(i);
    }
    return suma % capacidad;
}
```

Ejemplo: `hash("hola", 10)` → suma de caracteres de "hola" módulo 10.

El problema: dos claves diferentes pueden producir el mismo índice. Esto se llama **colisión**.

---

## Manejo de colisiones: encadenamiento

Cada posición del arreglo contiene una **lista enlazada** de pares clave-valor.

```java
class TablaHash {

    private class Entrada {
        String clave;
        int valor;
        Entrada siguiente;

        Entrada(String clave, int valor){
            this.clave = clave;
            this.valor = valor;
        }
    }

    private Entrada[] tabla;
    private int capacidad;

    public TablaHash(int capacidad){
        this.capacidad = capacidad;
        tabla = new Entrada[capacidad];
    }

    private int hash(String clave){
        int suma = 0;
        for(int i = 0; i < clave.length(); i++){
            suma += clave.charAt(i);
        }
        return Math.abs(suma % capacidad);
    }

    public void poner(String clave, int valor){

        int indice = hash(clave);
        Entrada actual = tabla[indice];

        // buscar si la clave ya existe
        while(actual != null){
            if(actual.clave.equals(clave)){
                actual.valor = valor;  // actualizar
                return;
            }
            actual = actual.siguiente;
        }

        // insertar al inicio de la lista
        Entrada nueva = new Entrada(clave, valor);
        nueva.siguiente = tabla[indice];
        tabla[indice] = nueva;
    }

    public int obtener(String clave){

        int indice = hash(clave);
        Entrada actual = tabla[indice];

        while(actual != null){
            if(actual.clave.equals(clave)){
                return actual.valor;
            }
            actual = actual.siguiente;
        }

        throw new RuntimeException("Clave no encontrada: " + clave);
    }

    public boolean contiene(String clave){

        int indice = hash(clave);
        Entrada actual = tabla[indice];

        while(actual != null){
            if(actual.clave.equals(clave)) return true;
            actual = actual.siguiente;
        }

        return false;
    }
}
```

---

## Visualización

```
Tabla con capacidad 5:

Índice 0: ["ana", 25] → ["eva", 30] → null
Índice 1: null
Índice 2: ["carlos", 22] → null
Índice 3: null
Índice 4: ["diana", 28] → null

"ana" y "eva" colisionaron en el índice 0 → se encadenan
```

---

## Complejidad

| Operación | Promedio | Peor caso |
|---|---|---|
| Insertar | O(1) | O(n) |
| Buscar | O(1) | O(n) |
| Eliminar | O(1) | O(n) |

El peor caso ocurre cuando todas las claves colisionan en el mismo índice (toda la tabla es una sola lista enlazada).

---

## Recorrido recursivo de la tabla hash

Podemos recorrer cada lista enlazada de forma recursiva:

```java
void imprimirTabla(TablaHash tabla){

    for(int i = 0; i < tabla.capacidad; i++){
        System.out.print("Índice " + i + ": ");
        imprimirCadena(tabla.tabla[i]);
        System.out.println();
    }
}

void imprimirCadena(Entrada nodo){

    if(nodo == null){
        System.out.print("null");
        return;
    }

    System.out.print("[" + nodo.clave + "=" + nodo.valor + "] → ");
    imprimirCadena(nodo.siguiente);
}
```

---

## Conjuntos (Sets)

Un **conjunto** es una colección de elementos **sin duplicados**. Se puede implementar usando una tabla hash donde solo importan las claves (sin valores).

```java
class Conjunto {

    private TablaHash tabla;

    public Conjunto(int capacidad){
        tabla = new TablaHash(capacidad);
    }

    public void agregar(String elemento){
        if(!tabla.contiene(elemento)){
            tabla.poner(elemento, 1);
        }
    }

    public boolean contiene(String elemento){
        return tabla.contiene(elemento);
    }
}
```

---

## Uso de HashMap y HashSet de Java

Después de entender la implementación interna, podemos usar las versiones optimizadas de Java:

```java
import java.util.HashMap;
import java.util.HashSet;

// HashMap: pares clave-valor
HashMap<String, Integer> edades = new HashMap<>();
edades.put("Ana", 25);
edades.put("Carlos", 22);
System.out.println(edades.get("Ana"));       // 25
System.out.println(edades.containsKey("Ana")); // true

// HashSet: conjunto sin duplicados
HashSet<String> nombres = new HashSet<>();
nombres.add("Ana");
nombres.add("Carlos");
nombres.add("Ana");  // no se agrega (duplicado)
System.out.println(nombres.size());  // 2
```

---

## Aplicación: contar frecuencia de palabras

```java
HashMap<String, Integer> contarPalabras(String texto){

    HashMap<String, Integer> frecuencia = new HashMap<>();
    String[] palabras = texto.split(" ");

    for(String palabra : palabras){
        frecuencia.put(palabra, frecuencia.getOrDefault(palabra, 0) + 1);
    }

    return frecuencia;
}
```

---

## Aplicación: detectar duplicados en O(n)

```java
boolean tieneDuplicados(int[] arr){

    HashSet<Integer> vistos = new HashSet<>();

    for(int num : arr){
        if(vistos.contains(num)) return true;
        vistos.add(num);
    }

    return false;
}
```

Sin HashSet, esto requeriría O(n²) con dos ciclos anidados.

---

## Ejercicios de tablas hash

1. Implementar el método `eliminar(String clave)` en la TablaHash.

2. Implementar redimensionamiento automático: cuando el factor de carga (elementos/capacidad) supere 0.75, duplicar la capacidad y reinsertar todos los elementos.

3. Dado un arreglo de enteros, encontrar dos números que sumen un valor objetivo. Usar HashMap para hacerlo en O(n).

4. Dado un texto, encontrar la primera palabra que no se repite. Usar LinkedHashMap para mantener el orden de inserción.

5. Implementar un caché LRU (Least Recently Used) usando HashMap + lista doblemente enlazada.

---
