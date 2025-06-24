module timer (
	input  logic clk, reset, enable, 
	output logic [3:0] seconds
);

logic [24:0] max = 25'd25_000_000;
logic done;
counter #(25) second( .clk(clk), .enable(enable), .reset(reset), .done(done), .max(max), .q());

always @(posedge clk or posedge reset)
begin
    if(reset) begin
        seconds <= 0;
    end else if (done) begin 
        seconds   <= seconds + 1'b1;   
    end 
end

endmodule