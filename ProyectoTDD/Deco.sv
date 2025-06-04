/* el deco hace lo siguiente:
según el address que se le pase(hay que cambiarlos pq ahorita puse cualquier) y según el memWrite esté en 1 o esté en 0 él va a habilitar 
la salida según el adress, habilita la salida de we ya sea para la 1.memoria, 2. fpga, 3. uart, 4. mem-vid esto significa que habilita el escribir y 
tmb se le da un rd que va a ser mi mux y va a decir cuando se lee cual dato.*/

module Deco (
	input logic [19:0] addr,
	input logic memWrite,
	output logic wem, we1, we2, we3,
	output logic [1:0] rdsel
);

	always_comb begin
	
		wem   = 0;
		we1   = 0;
		we2   = 0;
		we3   = 0;
		rdsel = 2'b00;

		if (addr == 20'h20000) begin
			rdsel = 2'b00;
			if (memWrite)
				wem = 1;
		end
		else if (addr >= 20'h18000 && addr <= 20'h1FFFF) begin
			rdsel = 2'b01;
			if (memWrite)
			we1 = 1;
		end
		else if (addr == 20'h10000) begin
			rdsel = 2'b10;
			if (memWrite)
				we2 = 1;
		end
		else if (addr == 20'h003EB) begin
			rdsel = 2'b11;
			if (memWrite)
				we3 = 1;
		end
	end	

endmodule
