module InstMemory(
    input logic clk, reset,
    input logic [31:0] PC,
    output logic [31:0] Instruction
);


    logic [31:0] inst_mem [0:1023]; // Memoria de instrucciones de 1024 palabras

    // Inicialización de la memoria de instrucciones
    initial begin
        // Cargar las instrucciones en la memoria
        $readmemh("instMem.hex", inst_mem);
    end
    // Lectura de la instrucción en la dirección del PC
    assign Instruction = inst_mem[PC[31:2]]; // Asumiendo que las direcciones son de 32 bits y las instrucciones son de 32 bits

endmodule