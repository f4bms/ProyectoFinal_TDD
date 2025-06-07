module BaudRate(

	input logic clk, rst_n,
	output logic tick,
	input logic [15:0] baudRate
	
);

logic [15:0] brReg;

always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		brReg <= 16'd0;
	else if (tick)
		brReg <= 16'd0;
	else
		brReg <= brReg + 1'b1;
end

assign tick = (brReg == baudRate);

endmodule