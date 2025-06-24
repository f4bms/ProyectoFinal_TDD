module seven_segment_driver(
	input  logic[3:0] data_in,
	output logic[6:0] data_out
);

always @(*) begin
	case (data_in)
		4'b0000: data_out[6:0] = ~7'b0111111; 
		4'b0001: data_out[6:0] = ~7'b0000110;
		4'b0010: data_out[6:0] = ~7'b1011011;
		4'b0011: data_out[6:0] = ~7'b1001111;
		4'b0100: data_out[6:0] = ~7'b1100110;
		4'b0101: data_out[6:0] = ~7'b1101101;
		4'b0110: data_out[6:0] = ~7'b1111101;
		4'b0111: data_out[6:0] = ~7'b0000111;
		4'b1000: data_out[6:0] = ~7'b1111111;
		4'b1001: data_out[6:0] = ~7'b1101111;
		default: data_out[6:0] = ~7'b0001000;
	endcase
end

endmodule