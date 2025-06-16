module ALUDecoder(
    input logic ALUOp,
    input logic [4:0] Funct,
    output logic [1:0] ALUControl,
    output logic ALUSrcA,
    output logic [1:0] FlagW,
    output logic NoWrite
);


    // Lógica combinacional para el decodificador de ALU
    always_comb begin
        // Inicializar señales de salida
        ALUControl = 2'b00; // Por defecto, operación de ALU es 0
        FlagW = 2'b00; // Por defecto, no se escriben flags
        NoWrite = 0; // Por defecto, no se escribe en el registro de destino
        ALUSrcA = 1; 

        if (ALUOp) begin
            case (Funct[4:1])
                4'b0100: begin // Suma
                    ALUControl = 2'b00; // Operación de suma
                    FlagW = Funct[0] ? 2'b11 : 2'b00;
                    NoWrite = 0; // Escribir en el registro de destino
                    ALUSrcA = 1; 
                end
                4'b0010: begin // Resta
                    ALUControl = 2'b01; // Operación de resta
                    FlagW = Funct[0] ? 2'b11 : 2'b00;
                    NoWrite = 0; // Escribir en el registro de destino
                    ALUSrcA = 1; 
                end
                4'b0000: begin // AND
                    ALUControl = 2'b10; // Operación AND
                    FlagW = Funct[0] ? 2'b10 : 2'b00;
                    NoWrite = 0; // Escribir en el registro de destino
                    ALUSrcA = 1; 
                end
                4'b1100: begin // OR
                    ALUControl = 2'b11; // Operación OR
                    FlagW = Funct[0] ? 2'b10 : 2'b00;
                    NoWrite = 0; // Escribir en el registro de destino
                    ALUSrcA = 1; 
                end
                4'b1010: begin // CMP
                    ALUControl = 2'b01; // Operación de comparación (resta)
                    FlagW = 2'b11; // Siempre escribir flags
                    NoWrite = 1; // No escribir en el registro de destino
                    ALUSrcA = 1; 
                end

                4'b1101: begin // MOV
                    ALUControl = 2'b00; // Operación de movimiento (copia)
                    FlagW = 2'b00;
                    NoWrite = 0; // Escribir en el registro de destino
                    ALUSrcA = 0; // No usar el registro A como fuente, usa 0 como A
                end
            endcase
        end else begin
            ALUControl = 2'b00;
            FlagW = 2'b00;
        end
    end



endmodule

