module RegBotones (
    input  logic clk,
    input  logic reset,
    input  logic [1:0] botones,
    input  logic we,
    output logic [31:0] data_out
);
	always_ff @(posedge clk or posedge reset) begin
		if (reset)
			data_out <= 32'b0;
		else if (we)
			data_out <= {30'b0, botones};  // Zero-extend a 32 bits
	end

endmodule