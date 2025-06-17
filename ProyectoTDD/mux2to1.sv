module mux2to1 #(
    parameter int m = 4
)(
    input  logic [m-1:0] a, // Entrada A
    input  logic [m-1:0] b, // Entrada B
    input  logic sel, // Selector
    output logic [m-1:0] y   // Salida
);
    always_comb begin
        case (sel)
            1'b0: y = a;
            1'b1: y = b;
            default: y = '0;
        endcase
    end
endmodule
