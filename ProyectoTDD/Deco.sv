/* el deco hace lo siguiente:
según el address que se le pase(hay que cambiarlos pq ahorita puse cualquier) y según el memWrite esté en 1 o esté en 0 él va a habilitar 
la salida según el adress, habilita la salida de we ya sea para la 1.memoria, 2. fpga, 3. uart, 4. mem-vid esto significa que habilita el escribir y 
tmb se le da un rd que va a ser mi mux y va a decir cuando se lee cual dato.*/

module Deco (
	input logic [31:0] addr,
	input logic memWrite,
	output logic  wenRAM, // Write enable para RAM
	output logic [2:0] rdsel
);

	always_comb begin

		wenRAM = 0;
		rdsel = 3'b000;

		if (addr >= 32'h00006000 && addr <= 32'h00010000) begin // Dirección de la RAM (salida del procesador)
			rdsel = 3'b000;
			wenRAM = memWrite; // Habilita escritura en RAM si memWrite es 1
		end
		else if (addr == 32'h00001000) begin // Dirección del Jugador 1
			rdsel = 3'b001;
		end
		else if (addr == 32'h00002000) begin // Dirección del Jugador 2
			rdsel = 3'b010;
		end
		else if (addr == 32'h00004000) begin // Dirección del número aleatorio
			rdsel = 3'b011;
		end 
		else if (addr == 32'h00003000) begin // Dirección del tiempo
			rdsel = 3'b100;
		end 
		else begin
			rdsel = 3'b000; // Default case
		end
	end	

endmodule
