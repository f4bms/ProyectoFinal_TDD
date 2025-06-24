module RegBotones (
    input  logic clk,
    input  logic reset,
    input  logic [3:0] botones,
    input  logic we,
    output logic [31:0] data_out
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            data_out <= 32'b0;
        else if (we)
        case (botones)
            4'b1000: data_out <= 32'h00000000; // Botón 1
            4'b0100: data_out <= 32'h00000001; // Botón 2
            4'b0010: data_out <= 32'h00000002; // Botón 3
            4'b0001: data_out <= 32'h00000003; // Botón 4
            default: data_out <= data_out; // No hacer nada si no coincide
        endcase
        else data_out <= data_out; // Mantener el valor actual si no se escribe
    end

endmodule