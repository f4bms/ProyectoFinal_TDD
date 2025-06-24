/**
 * Módulo: division
 * Descripción: Implementa un divisor de 4 bits utilizando el algoritmo de resta y desplazamiento.
 *              Este diseño sigue el enfoque descrito en la Sección 5.2.7 del libro "Digital Design and Computer Architecture".
 * Parámetros:
 *   - m: Ancho de los operandos (por defecto 4 bits).
 * Entradas:
 *   - dividendo: número a dividir.
 *   - divisor: número por el cual se divide.
 * Salidas:
 *   - cociente: resultado de la división.
 *   - residuo: resto de la división.
 */
module division #(parameter m = 4) (
    input  logic [m-1:0] dividendo,
    input  logic [m-1:0] divisor,
    output logic [m-1:0] cociente,
    output logic [m-1:0] residuo
);

    // Registros internos
    logic [2*m-1:0] dividendo_reg;  // Registro de 8 bits para el dividendo y el resto
    logic [m-1:0] divisor_reg;      // Registro para el divisor
    logic [m-1:0] cociente_reg;     // Registro para el cociente
    logic [m-1:0] temp;             // Variable temporal para la resta
    integer i;                      // Contador para el bucle

    /**
     * Bloque always_comb: Implementa el algoritmo de división.
     * Descripción:
     *   1. Inicializa los registros con los valores de entrada.
     *   2. Realiza la división utilizando un bucle de 4 iteraciones.
     *   3. En cada iteración:
     *      - Desplaza el registro de 8 bits a la izquierda.
     *      - Resta el divisor de la mitad superior del registro.
     *      - Si la resta es no negativa, actualiza el registro y el cociente.
     */
    always_comb begin
        // Inicialización
        dividendo_reg = {4'b0, dividendo}; // Cargar el dividendo en la mitad inferior
        divisor_reg  = divisor;           // Cargar el divisor
        cociente_reg = 0;                 // Inicializar el cociente

        // Algoritmo de división
        for (i = 0; i < m; i = i + 1) begin
            // Desplazar el registro de 8 bits a la izquierda
            dividendo_reg = dividendo_reg << 1;

            // Restar el divisor de la mitad superior del registro
            temp = dividendo_reg[2*m-1:m] - divisor_reg;

            // Si la resta es no negativa, actualizar el registro y el cociente
            if (!temp[m-1]) begin
                dividendo_reg[2*m-1:m] = temp; // Actualizar la mitad superior
                cociente_reg[m-1-i] = 1;         // Establecer el bit correspondiente del cociente
            end
        end
    end

    // Asignar las salidas
    assign cociente  = cociente_reg;
    assign residuo = dividendo_reg[2*m-1:m];

endmodule