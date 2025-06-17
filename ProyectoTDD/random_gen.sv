module random_gen (
    input  logic clk,            // reloj del sistema
    input  logic rst,            // reset síncrono
    output logic [2:0] numero    // número aleatorio del 1 al 6
);

    logic [3:0] lfsr;
    logic [2:0] valor_tmp;

    // LFSR de 4 bits con taps en bits 4 y 3 (x^4 + x^3 + 1)
    always_ff @(posedge clk) begin
        if (rst)
            lfsr <= 4'b0001;  // semilla
        else
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
    end

    // Mapear valor del LFSR a 1–6
    always_comb begin
        case (lfsr % 6)
            0: valor_tmp = 3'd1;
            1: valor_tmp = 3'd2;
            2: valor_tmp = 3'd3;
            3: valor_tmp = 3'd4;
            4: valor_tmp = 3'd5;
            5: valor_tmp = 3'd6;
            default: valor_tmp = 3'd1;
        endcase
    end

    // Actualizar salida en cada ciclo de reloj
    always_ff @(posedge clk) begin
        if (rst)
            numero <= 3'd0;
        else
            numero <= valor_tmp;
    end

endmodule
