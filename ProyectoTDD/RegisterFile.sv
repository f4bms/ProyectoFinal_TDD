module RegisterFile(
    input logic clk, reset,
    input logic [3:0] A1, A2, A3, // Direcciones de los registros
    input logic [31:0] WD3, // Dato a escribir
    input logic [31:0] R15,
    input logic WE, // Señal de escritura
    output logic [31:0] RD1, RD2, // Datos leídos
    output logic [15:0][31:0] leds_registers // Salida de todos los registros
);

    logic [31:0] registers [15:0] = '{default:32'd0}; // 16 registros de 32 bits

    // Escritura secuencial y actualización de leds_registers
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 16; i++) registers[i] <= 32'h00000000;
        end else if (WE && A3 != 4'b1111) begin // No escribir en R15 (PC)
            registers[A3] <= WD3;
        end
        // Actualiza leds_registers
        for (int i = 0; i < 16; i++) leds_registers[i] <= registers[i];
    end

    // Lectura combinacional
    always_comb begin
        RD1 = (A1 != 4'b1111) ? registers[A1] : R15; // Leer R15 si A1 es R15
        RD2 = (A2 != 4'b1111) ? registers[A2] : R15; // Leer R15 si A2 es R15
    end

endmodule