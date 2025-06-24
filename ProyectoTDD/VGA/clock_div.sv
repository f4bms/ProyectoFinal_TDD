module clock_div #(parameter DIV=2)(
	input clk_in, 
	output reg clk_out
);
	reg [$clog2(DIV):0] counter = DIV-1;
	
	always @(posedge clk_in) begin
		if(counter < (DIV-1)) begin
			counter <= counter + 1;	
		end else begin
			counter <= 0;
		end
		clk_out <= (counter < (DIV/2))? 1'b1 : 1'b0;
	end

endmodule