module MainDecoder(
    input logic [1:0] OpCode,
    input logic Funct5,
    input logic Funct0,
    output logic Branch,
    output logic MemtoReg,
    output logic MemW,
    output logic ALUSrcB,
    output logic [1:0] ImmSrc,
    output logic RegW,
    output logic [1:0] RegSrc,
    output logic  ALUOp
);

    // Lógica combinacional para el decodificador
    always_comb begin
        

        // Decodificación basada en el OpCode y Funct5/Funct0
        case (OpCode)
            2'b00: begin
                Branch = 0;
                MemtoReg = 0;
                MemW = 0;
                ALUSrcB = Funct5; // Si Funct5 es 1, usar inmediato
                ImmSrc = 2'b00;
                RegW = 1; // Habilitar escritura en registro
                RegSrc = 2'b00; // Origen del registro es ALU
                ALUOp = 1; // Habilitar ALU
            end
            2'b01: begin
                Branch = 0; 
                MemtoReg = Funct0; // Si Funct0 es 1, usar memoria
                MemW = ~Funct0; // Habilitar escritura en memoria si Funct0 es 0
                ALUSrcB = 1;
                ImmSrc = 2'b01;
                RegW = Funct0; // Habilitar escritura en registro si Funct0 es 1
                RegSrc = 2'b10; // Origen del registro es memoria
                ALUOp = 0;
            end
            2'b10: begin
                Branch = 1; 
                MemtoReg = 0;
                MemW = 0;
                ALUSrcB = 1;
                ImmSrc = 2'b10;
                RegW = 0; 
                RegSrc = 2'b01;
                ALUOp = 0; 
            end
            default: begin
                // Inicializar señales de salida
                Branch = 0;
                MemtoReg = 0;
                MemW = 0;
                ALUSrcB = 0;
                ImmSrc = 0;
                RegW = 0;
                RegSrc = 2'b00; // Por defecto, origen del registro es 0
                ALUOp = 0;
            end
            

        endcase
    end



endmodule