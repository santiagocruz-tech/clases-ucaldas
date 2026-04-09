package juego;

import java.util.Scanner;

/**
 * ============================================================
 *  JUEGO: El Calabozo del Inventario
 * ============================================================
 *
 * NO MODIFIQUES ESTE ARCHIVO.
 *
 * Este juego usa TUS implementaciones de ListaDinamica y ListaEnlazada.
 * Si no las implementas correctamente, el juego NO funcionará.
 *
 * - La MOCHILA usa ListaDinamica (arreglo dinámico con redimensionamiento).
 * - El HISTORIAL DE ACCIONES usa ListaEnlazada.
 *
 * Objetivo: Explora habitaciones, recoge objetos, úsalos para avanzar
 *           y escapa del calabozo.
 */
public class JuegoInventario {

    private static IListaDinamica mochila = new ListaDinamica();
    private static IListaEnlazada historial = new ListaEnlazada();
    private static Scanner scanner = new Scanner(System.in);
    private static int habitacionActual = 0;
    private static boolean juegoTerminado = false;

    // Habitaciones del calabozo
    private static String[] nombresHabitacion = {
        "Celda Oscura",
        "Pasillo de Antorchas",
        "Sala del Cofre",
        "Puente Roto",
        "Guarida del Guardián",
        "Puerta de Salida"
    };

    private static String[] descripcionesHabitacion = {
        "Despiertas en una celda húmeda. Hay una LLAVE_OXIDADA en el suelo y una puerta al norte.",
        "Un pasillo iluminado por antorchas. Ves una POCION en una repisa. Hay puertas al norte y al sur.",
        "Una sala con un cofre cerrado con llave. Dentro podría haber algo útil. Puertas al sur y al este.",
        "Un puente roto sobre un abismo. Necesitas una CUERDA para cruzar. Puertas al oeste y al norte (si cruzas).",
        "Un guardián bloquea la salida. Parece sediento... Puerta al sur y al norte (si lo pasas).",
        "¡La puerta de salida! Pero tiene una cerradura especial. Necesitas la LLAVE_DORADA."
    };

    public static void main(String[] args) {
        System.out.println("╔══════════════════════════════════════════╗");
        System.out.println("║     EL CALABOZO DEL INVENTARIO          ║");
        System.out.println("║                                         ║");
        System.out.println("║  Tu mochila usa ListaDinamica           ║");
        System.out.println("║  Tu historial usa ListaEnlazada         ║");
        System.out.println("║                                         ║");
        System.out.println("║  Si no implementaste las listas...      ║");
        System.out.println("║  este juego NO va a funcionar ;)        ║");
        System.out.println("╚══════════════════════════════════════════╝");
        System.out.println();

        // Verificación rápida de implementación
        if (!verificarImplementacion()) {
            return;
        }

        System.out.println("¡Tus listas funcionan! El juego comienza...\n");
        registrar("Inicio de la aventura");

        while (!juegoTerminado) {
            mostrarHabitacion();
            System.out.println();
            mostrarOpciones();
            System.out.print("\n> ");
            String entrada = scanner.nextLine().trim().toLowerCase();
            System.out.println();
            procesarComando(entrada);
        }

        System.out.println("\n=== HISTORIAL DE ACCIONES ===");
        for (int i = 0; i < historial.tamaño(); i++) {
            System.out.println("  " + (i + 1) + ". " + historial.obtener(i));
        }
        System.out.println("=============================");
    }

    private static boolean verificarImplementacion() {
        System.out.println("Verificando implementación de ListaDinamica...");
        try {
            IListaDinamica prueba = new ListaDinamica();
            prueba.agregar("test");
            if (prueba.tamaño() != 1) {
                System.out.println("  ✗ tamaño() no retorna el valor correcto.");
                return false;
            }
            if (!"test".equals(prueba.obtener(0))) {
                System.out.println("  ✗ obtener() no retorna el valor correcto.");
                return false;
            }
            if (!prueba.contiene("test")) {
                System.out.println("  ✗ contiene() no funciona correctamente.");
                return false;
            }
            if (prueba.indexOf("test") != 0) {
                System.out.println("  ✗ indexOf() no funciona correctamente.");
                return false;
            }
            prueba.agregar("a");
            prueba.agregar("b");
            prueba.agregar("c");
            prueba.agregar("d"); // Esto fuerza redimensionamiento (capacidad inicial = 4)
            if (prueba.tamaño() != 5) {
                System.out.println("  ✗ El redimensionamiento no funciona.");
                return false;
            }
            String eliminado = prueba.eliminar(1);
            if (!"a".equals(eliminado) || prueba.tamaño() != 4) {
                System.out.println("  ✗ eliminar() no funciona correctamente.");
                return false;
            }
            System.out.println("  ✓ ListaDinamica OK\n");
        } catch (UnsupportedOperationException e) {
            System.out.println("  ✗ " + e.getMessage());
            System.out.println("  ¡Debes implementar los métodos de ListaDinamica!\n");
            return false;
        } catch (Exception e) {
            System.out.println("  ✗ Error: " + e.getMessage());
            return false;
        }

        System.out.println("Verificando implementación de ListaEnlazada...");
        try {
            IListaEnlazada prueba = new ListaEnlazada();
            prueba.agregar("test");
            if (prueba.tamaño() != 1) {
                System.out.println("  ✗ tamaño() no retorna el valor correcto.");
                return false;
            }
            if (!"test".equals(prueba.obtener(0))) {
                System.out.println("  ✗ obtener() no retorna el valor correcto.");
                return false;
            }
            if (!prueba.contiene("test")) {
                System.out.println("  ✗ contiene() no funciona correctamente.");
                return false;
            }
            prueba.insertar(0, "primero");
            if (!"primero".equals(prueba.obtener(0)) || prueba.tamaño() != 2) {
                System.out.println("  ✗ insertar() no funciona correctamente.");
                return false;
            }
            String eliminado = prueba.eliminar(0);
            if (!"primero".equals(eliminado) || prueba.tamaño() != 1) {
                System.out.println("  ✗ eliminar() no funciona correctamente.");
                return false;
            }
            System.out.println("  ✓ ListaEnlazada OK\n");
        } catch (UnsupportedOperationException e) {
            System.out.println("  ✗ " + e.getMessage());
            System.out.println("  ¡Debes implementar los métodos de ListaEnlazada!\n");
            return false;
        } catch (Exception e) {
            System.out.println("  ✗ Error: " + e.getMessage());
            return false;
        }

        return true;
    }

    private static void mostrarHabitacion() {
        System.out.println("═══════════════════════════════════════");
        System.out.println("📍 " + nombresHabitacion[habitacionActual]);
        System.out.println("═══════════════════════════════════════");
        System.out.println(descripcionesHabitacion[habitacionActual]);
    }

    private static void mostrarOpciones() {
        System.out.println("Comandos: recoger <objeto> | soltar <objeto> | usar <objeto>");
        System.out.println("          mochila | historial | norte | sur | este | oeste");
    }

    private static void procesarComando(String entrada) {
        if (entrada.startsWith("recoger ")) {
            recogerObjeto(entrada.substring(8).toUpperCase());
        } else if (entrada.startsWith("soltar ")) {
            soltarObjeto(entrada.substring(7).toUpperCase());
        } else if (entrada.startsWith("usar ")) {
            usarObjeto(entrada.substring(5).toUpperCase());
        } else if (entrada.equals("mochila")) {
            mostrarMochila();
        } else if (entrada.equals("historial")) {
            mostrarHistorial();
        } else if (entrada.equals("norte")) {
            mover(1);
        } else if (entrada.equals("sur")) {
            mover(-1);
        } else if (entrada.equals("este")) {
            moverEste();
        } else if (entrada.equals("oeste")) {
            moverOeste();
        } else {
            System.out.println("No entiendo ese comando.");
        }
    }

    private static void recogerObjeto(String objeto) {
        boolean valido = false;

        switch (habitacionActual) {
            case 0:
                if (objeto.equals("LLAVE_OXIDADA")) valido = true;
                break;
            case 1:
                if (objeto.equals("POCION")) valido = true;
                break;
        }

        if (!valido) {
            System.out.println("No puedes recoger eso aquí.");
            return;
        }

        if (mochila.contiene(objeto)) {
            System.out.println("Ya tienes " + objeto + " en tu mochila.");
            return;
        }

        mochila.agregar(objeto);
        registrar("Recogiste " + objeto + " en " + nombresHabitacion[habitacionActual]);
        System.out.println("✓ " + objeto + " añadido a tu mochila.");
    }

    private static void soltarObjeto(String objeto) {
        int idx = mochila.indexOf(objeto);
        if (idx == -1) {
            System.out.println("No tienes " + objeto + " en tu mochila.");
            return;
        }
        mochila.eliminar(idx);
        registrar("Soltaste " + objeto);
        System.out.println("Soltaste " + objeto + ".");
    }

    private static void usarObjeto(String objeto) {
        if (!mochila.contiene(objeto)) {
            System.out.println("No tienes " + objeto + ".");
            return;
        }

        switch (habitacionActual) {
            case 2: // Sala del Cofre
                if (objeto.equals("LLAVE_OXIDADA")) {
                    int idx = mochila.indexOf("LLAVE_OXIDADA");
                    mochila.eliminar(idx);
                    mochila.agregar("CUERDA");
                    mochila.agregar("LLAVE_DORADA");
                    registrar("Abriste el cofre con LLAVE_OXIDADA. Obtuviste CUERDA y LLAVE_DORADA");
                    System.out.println("🔓 Usas la llave oxidada... ¡El cofre se abre!");
                    System.out.println("   Dentro encuentras: CUERDA y LLAVE_DORADA");
                    System.out.println("   Ambos objetos fueron añadidos a tu mochila.");
                } else {
                    System.out.println("No puedes usar eso aquí.");
                }
                break;

            case 3: // Puente Roto
                if (objeto.equals("CUERDA")) {
                    registrar("Usaste CUERDA para reparar el puente");
                    System.out.println("🌉 Atas la cuerda y reparas el puente. ¡Ahora puedes cruzar al norte!");
                } else {
                    System.out.println("No puedes usar eso aquí.");
                }
                break;

            case 4: // Guarida del Guardián
                if (objeto.equals("POCION")) {
                    int idx = mochila.indexOf("POCION");
                    mochila.eliminar(idx);
                    registrar("Diste la POCION al guardián");
                    System.out.println("🧙 Le das la poción al guardián. ¡Se la bebe y se queda dormido!");
                    System.out.println("   El camino al norte está libre.");
                } else {
                    System.out.println("El guardián no quiere eso.");
                }
                break;

            case 5: // Puerta de Salida
                if (objeto.equals("LLAVE_DORADA")) {
                    int idx = mochila.indexOf("LLAVE_DORADA");
                    mochila.eliminar(idx);
                    registrar("Usaste LLAVE_DORADA para abrir la puerta de salida");
                    System.out.println("🏆 ¡La llave dorada encaja perfectamente!");
                    System.out.println("   La puerta se abre y la luz del sol te ciega...");
                    System.out.println();
                    System.out.println("   ╔═══════════════════════════════════╗");
                    System.out.println("   ║   ¡FELICIDADES! ¡HAS ESCAPADO!   ║");
                    System.out.println("   ║                                   ║");
                    System.out.println("   ║   Tus listas funcionaron bien :)  ║");
                    System.out.println("   ╚═══════════════════════════════════╝");
                    juegoTerminado = true;
                } else {
                    System.out.println("Eso no abre la puerta.");
                }
                break;

            default:
                System.out.println("No puedes usar objetos aquí.");
        }
    }

    private static void mover(int direccion) {
        int destino = habitacionActual + direccion;

        // Validar movimiento
        if (destino < 0 || destino >= nombresHabitacion.length) {
            System.out.println("No puedes ir en esa dirección.");
            return;
        }

        // Restricciones especiales
        if (habitacionActual == 3 && direccion == 1 && !mochila.contiene("CUERDA")) {
            System.out.println("El puente está roto. Necesitas algo para cruzar...");
            return;
        }

        if (habitacionActual == 4 && direccion == 1) {
            // Verificar si el guardián fue dormido (la POCION ya no está en mochila y fue usada)
            boolean guardianDormido = historial.contiene("Diste la POCION al guardián");
            if (!guardianDormido) {
                System.out.println("El guardián te bloquea el paso. Quizás quiera algo de beber...");
                return;
            }
        }

        // Restricción: no saltar habitaciones
        if (habitacionActual == 0 && direccion == 1) { destino = 1; }
        else if (habitacionActual == 1 && direccion == -1) { destino = 0; }
        else if (habitacionActual == 1 && direccion == 1) { destino = 2; }
        else if (habitacionActual == 2 && direccion == -1) { destino = 1; }

        habitacionActual = destino;
        registrar("Te moviste a " + nombresHabitacion[habitacionActual]);
        System.out.println("Caminas hacia " + nombresHabitacion[habitacionActual] + "...");
    }

    private static void moverEste() {
        if (habitacionActual == 2) {
            habitacionActual = 3;
            registrar("Te moviste a " + nombresHabitacion[habitacionActual]);
            System.out.println("Caminas hacia " + nombresHabitacion[habitacionActual] + "...");
        } else {
            System.out.println("No puedes ir al este desde aquí.");
        }
    }

    private static void moverOeste() {
        if (habitacionActual == 3) {
            habitacionActual = 2;
            registrar("Te moviste a " + nombresHabitacion[habitacionActual]);
            System.out.println("Caminas hacia " + nombresHabitacion[habitacionActual] + "...");
        } else {
            System.out.println("No puedes ir al oeste desde aquí.");
        }
    }

    private static void mostrarMochila() {
        System.out.println("🎒 Mochila (" + mochila.tamaño() + " objetos):");
        if (mochila.tamaño() == 0) {
            System.out.println("   (vacía)");
        }
        for (int i = 0; i < mochila.tamaño(); i++) {
            System.out.println("   " + (i + 1) + ". " + mochila.obtener(i));
        }
    }

    private static void mostrarHistorial() {
        System.out.println("📜 Historial de acciones:");
        if (historial.tamaño() == 0) {
            System.out.println("   (vacío)");
        }
        for (int i = 0; i < historial.tamaño(); i++) {
            System.out.println("   " + (i + 1) + ". " + historial.obtener(i));
        }
    }

    private static void registrar(String accion) {
        historial.agregar(accion);
    }
}
