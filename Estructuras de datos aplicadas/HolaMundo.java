public class HolaMundo {
    public static void main(String[] args) {
        System.out.println("¡Hola, Mundo!");
    }

    public static int suma(int numero1, int numero2){
        return numero1 + numero2;
    }

    public static int operacion(int n){
        int resultado = 0;
        
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n/2 + Math.pow(n, j); j++) {
                resultado += j;
            }
            resultado += i;
        }

        return resultado;
    }
}