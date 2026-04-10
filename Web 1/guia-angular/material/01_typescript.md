# 1. TypeScript para Angular

## ¿Por qué TypeScript?

Angular está escrito en TypeScript y obliga a usarlo. TypeScript es JavaScript con tipos. Las ventajas:

- El editor detecta errores **antes** de ejecutar el código.
- Autocompletado inteligente (sabés qué propiedades tiene un objeto).
- Código más legible y mantenible en equipos.
- Refactorización segura.

TypeScript compila a JavaScript. El navegador nunca ejecuta TypeScript directamente.

---

## Tipos básicos

```typescript
// Tipos primitivos
let nombre: string = "Ana";
let edad: number = 25;
let activo: boolean = true;

// Arrays
let numeros: number[] = [1, 2, 3];
let nombres: string[] = ["Ana", "Luis"];
let mixto: Array<number> = [1, 2, 3]; // Sintaxis alternativa

// Any — evitar siempre que sea posible
let cualquierCosa: any = "hola";
cualquierCosa = 42; // No da error, pero perdés el tipado

// Unknown — más seguro que any
let dato: unknown = "hola";
// dato.toUpperCase(); // ERROR: hay que verificar el tipo primero
if (typeof dato === "string") {
    dato.toUpperCase(); // OK
}

// Void — funciones que no retornan nada
function saludar(): void {
    console.log("Hola");
}

// Null y Undefined
let nulo: null = null;
let indefinido: undefined = undefined;
```

---

## Interfaces

Las interfaces definen la forma de un objeto. Son fundamentales en Angular para tipar datos de APIs.

```typescript
// Definir una interfaz
interface Producto {
    id: number;
    nombre: string;
    precio: number;
    descripcion?: string;  // Propiedad opcional (?)
    activo: boolean;
}

// Usar la interfaz
const laptop: Producto = {
    id: 1,
    nombre: "Laptop Pro",
    precio: 1500,
    activo: true
    // descripcion es opcional, no es obligatorio
};

// Interfaz para respuesta de API
interface ApiResponse {
    results: Producto[];
    total: number;
    page: number;
}

// Función tipada
function buscarProducto(id: number): Producto | undefined {
    const productos: Producto[] = [laptop];
    return productos.find(p => p.id === id);
}
```

---

## Types

Similar a interfaces pero con sintaxis diferente. Útiles para uniones y tipos complejos.

```typescript
// Type alias
type ID = number | string;

// Unión de tipos
type Estado = "activo" | "inactivo" | "pendiente";

let estadoUsuario: Estado = "activo";
// estadoUsuario = "eliminado"; // ERROR: no es un valor válido

// Type para objetos (similar a interface)
type Coordenada = {
    x: number;
    y: number;
};
```

### ¿Interface o Type?

- Usar **interface** para definir la forma de objetos y datos de API.
- Usar **type** para uniones, alias y tipos complejos.
- En Angular, la convención es usar interfaces para modelos de datos.

---

## Clases con tipado

```typescript
class Persona {
    // Propiedades tipadas
    nombre: string;
    edad: number;
    private email: string;

    constructor(nombre: string, edad: number, email: string) {
        this.nombre = nombre;
        this.edad = edad;
        this.email = email;
    }

    // Método tipado
    saludar(): string {
        return `Hola, soy ${this.nombre}`;
    }

    // Getter
    get correo(): string {
        return this.email;
    }
}

// Atajo del constructor (muy usado en Angular)
class Estudiante {
    constructor(
        public nombre: string,
        public edad: number,
        private carrera: string
    ) {}
    // TypeScript crea las propiedades automáticamente
}

const est = new Estudiante("Carlos", 20, "Ingeniería");
console.log(est.nombre); // "Carlos"
```

---

## Enums

```typescript
enum Rol {
    Admin = "ADMIN",
    Usuario = "USUARIO",
    Invitado = "INVITADO"
}

let rolActual: Rol = Rol.Admin;

// Uso en condicionales
if (rolActual === Rol.Admin) {
    console.log("Acceso total");
}
```

---

## Generics básicos

Los generics permiten crear funciones y clases que trabajan con cualquier tipo.

```typescript
// Función genérica
function primero<T>(array: T[]): T | undefined {
    return array[0];
}

const primerNumero = primero<number>([1, 2, 3]);    // number
const primerTexto = primero<string>(["a", "b"]);     // string

// Interface genérica (muy común para respuestas de API)
interface Respuesta<T> {
    data: T;
    status: number;
    mensaje: string;
}

// Uso
const respuestaProductos: Respuesta<Producto[]> = {
    data: [laptop],
    status: 200,
    mensaje: "OK"
};
```

---

## Módulos (import/export)

```typescript
// archivo: models/producto.ts
export interface Producto {
    id: number;
    nombre: string;
    precio: number;
}

// archivo: services/producto.service.ts
import { Producto } from '../models/producto';

export function obtenerProductos(): Producto[] {
    return [];
}
```

---

## Decoradores

Los decoradores son funciones que modifican clases, métodos o propiedades. Angular los usa en todo.

```typescript
// En Angular, los decoradores más comunes son:

@Component({...})    // Marca una clase como componente
@Injectable({...})   // Marca una clase como servicio inyectable
@Input()             // Marca una propiedad como entrada de datos
@Output()            // Marca una propiedad como salida de eventos

// No necesitás crear decoradores propios.
// Solo necesitás entender que son "etiquetas" que le dicen a Angular
// qué rol tiene cada clase o propiedad.
```

No es necesario entender cómo funcionan internamente los decoradores. Solo saber que Angular los usa para configurar componentes, servicios y otras piezas.

---

## Ejercicios

### Ejercicio 1: Interfaces para una API
Crear las interfaces necesarias para tipar la respuesta de la PokeAPI:
- `Pokemon` con: id, name, height, weight, sprites, types
- `PokemonListResponse` con: count, results (array de {name, url})

### Ejercicio 2: Clase con tipado
Crear una clase `Carrito` con:
- Propiedad privada `items: Producto[]`
- Métodos: `agregar(producto: Producto): void`, `eliminar(id: number): void`, `total(): number`
- Usar el atajo del constructor para alguna propiedad

### Ejercicio 3: Generics
Crear una función genérica `filtrar<T>(array: T[], condicion: (item: T) => boolean): T[]` que filtre cualquier array según una condición.

### Ejercicio 4: Enums y types
Crear un enum `Categoria` con valores para una tienda (Electrónica, Ropa, Hogar, Deportes). Crear un type `FiltroProducto` que sea un objeto con `categoria: Categoria` y `precioMaximo: number`.
