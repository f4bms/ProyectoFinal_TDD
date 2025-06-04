module RegisterFile(
    input logic clk, reset,
    input logic [3:0] A1, A2, A3, // Direcciones de los registros
    input logic [31:0] WD3, // Dato a escribir
    input logic [31:0]R15,
    input logic WE, // Señal de escritura
    output logic [31:0] RD1, RD2 // Datos leídos
);

    logic [31:0] registers [15:0]; // 16 registros de 32 bits

    // Inicialización de los registros
    initial begin
        registers[0] = 32'h00000000; // R0
        registers[1] = 32'h00000000; // R1
        registers[2] = 32'h00000000; // R2
        registers[3] = 32'h00000000; // R3
        registers[4] = 32'h00000000; // R4
        registers[5] = 32'h00000000; // R5
        registers[6] = 32'h00000000; // R6
        registers[7] = 32'h00000000; // R7
        registers[8] = 32'h00000000; // R8
        registers[9] = 32'h00000000; // R9
        registers[10] = 32'h00000000; // R10
        registers[11] = 32'h00000000; // R11
        registers[12] = 32'h00000000; // R12
        registers[13] = 32'h00000000; // R13 (SP)
        registers[14] = 32'h00000000; // R14 (LR)
        registers[15] = R15; // R15 (PC)
    end

    // Lectura de los registros en cada ciclo de reloj
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            RD1 <= 32'h00000000;
            RD2 <= 32'h00000000;
        end else begin
            RD1 <= (A1 != 4'b1111) ? registers[A1] : R15; // Leer R15 si A1 es R15
            RD2 <= (A2 != 4'b1111) ? registers[A2] : R15; // Leer R15 si A2 es R15
            if (WE && A3 != 4'b1111) begin // No escribir en R15 (PC)
                registers[A3] <= WD3;
            end
        end
    end



	

endmodule