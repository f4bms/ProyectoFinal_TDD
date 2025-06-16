module alu #(
	parameter int W=4
)(

		input logic [W-1:0] A, B,
		
		//operation(identificador que hay que aumentar por la cantidad de cosillas que queramos implementar)
		input logic [1:0] op,
		
		output logic [W-1:0] op_result,
		//lo pongo como un bus por mientras pero se puede tratar como cada una señal por aparte
		output logic N, Z, C, V
  
);
	
	
	//variables para la suma
	logic [W-1:0] sum_y;
	logic sum_cout;

	sum_N #(.m(W)) sumN (
		.a(A),
		.b(B),
		.y(sum_y),
		.cout(sum_cout)
	);
	
	//variables para la resta
	logic [W-1:0] subs_y;
	logic subs_cout;
	
	nBitsSubstractor #(.n(W)) subs (
		.a(A),
		.b(B),
		.s(subs_y),
		.cout(subs_cout)
	);
	
	
	

always_comb begin
	// Inicializar flags
    N = 0;
    Z = 0;
    C = 0;
    V = 0;

	case(op)
	//pongo la asignación del flag ahí solo pq es la suma, si lo pongo afuera se asigna siempre pero no sé como se use sin la suma
		2'b00: begin
			op_result = sum_y;
			C = sum_cout;
		end
		
		2'b01: begin
			op_result = subs_y; // agregarle las flags a la resta
			N = ~subs_cout;
		end
			
		2'b10: begin
			op_result = A & B; // AND
		end

		2'b11: begin
			op_result = A | B; // OR
		end
		
		default: op_result = 0;
	endcase
		
   Z = (op_result == 0);   // Zero
		
	end
		
endmodule
