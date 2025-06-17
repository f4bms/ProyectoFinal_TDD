module DataMemory(
    input logic clk,
    input logic reset,
    input logic [31:0] A, // Dirección de memoria
    input logic [31:0] WD, // Datos a escribir
    input logic WE, // Señal de escritura
    output logic [31:0] RD // Datos leídos
);

    // Instancia del módulo Deco
    logic wem, we1, we2, we3;
    logic [1:0] rdsel;

    Deco deco_inst (
        .addr(A[21:2]),    // Asumiendo que la dirección relevante son los bits [21:2]
        .memWrite(WE),
        .wem(wem),
        .we1(we1),
        .we2(we2),
        .we3(we3),
        .rdsel(rdsel)
    );

endmodule