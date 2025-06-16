module PCLogic(
    input logic [3:0] Rd, // Registro de destino
    input logic Branch,
    input logic RegW,
    output logic PCS // Señal de control para el PC
);

    // Lógica combinacional para determinar la señal PCS
    always_comb begin
        
        PCS = Branch | (RegW & Rd == 4'b1111);

        
    end

endmodule