module InstMemory(input logic clk, reset,
                  input logic [31:0] PC,
                  output logic [31:0] Instruction);

    
    logic [31:0] instructionMemory [255:0]; // 256 words of memory

    // Instrciones de inicialización, PRUEBAS
    initial begin
        instructionMemory[0] = 32'hE3A00001; // MOV R0, #1
        instructionMemory[1] = 32'hE3A01002; // MOV R1, #2
        instructionMemory[2] = 32'hE0800001; // ADD R0, R0, R1
    end

    // Actualizar la instrucción en cada ciclo de reloj
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            Instruction <= 32'h00000000; 
        end else begin
            Instruction <= instructionMemory[PC >> 2]; // Dividir por 4 para obtener la dirección de palabra
        end
    end

endmodule