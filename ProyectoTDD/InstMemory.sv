module InstMemory(input logic clk, reset,
                  input logic [31:0] PC,
                  output logic [31:0] Instruction);

    
    logic [31:0] instructionMemory [255:0]; // 256 words of memory

    // Instrciones de inicialización, PRUEBAS
    initial begin
        instructionMemory[0] = 32'hE3A00003; // MOV R0, #3
        instructionMemory[1] = 32'hE3500000; // CMP R0, #0
        instructionMemory[2] = 32'h0A000002; // BEQ end (PC + 8 + 4*2 = PC + 16)
        instructionMemory[3] = 32'hE2400001; // SUB R0, R0, #1
        instructionMemory[4] = 32'hEAFFFFFC; // B loop (salta 3 instrucciones hacia atrás)
        instructionMemory[5] = 32'hE3A0102A; // end: MOV R1, #42
    end


    // Actualizar la instrucción en cada ciclo de reloj
    always_comb begin

        Instruction = instructionMemory[PC[31:2]];
        
    end

endmodule