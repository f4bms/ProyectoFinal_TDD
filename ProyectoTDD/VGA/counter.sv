module counter #(parameter N) (
	input logic clk, enable, reset, 
	input logic [N-1:0] max,
	output logic done,
	output logic [N-1:0] q
);

assign done = (q == max);

always @(posedge clk) begin
	if(reset)
		q <= 0;
	else begin
		if(enable) begin
			if (q==max) begin
				q <= 0;
			end else begin
				q <= q+1;
			end
		end
	end
end

endmodule