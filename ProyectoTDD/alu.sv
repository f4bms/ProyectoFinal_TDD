module alu #(
	parameter int W=4
)(

		input logic [W-1:0] A, B,
		
		//operation(identificador que hay que aumentar por la cantidad de cosillas que queramos implementar)
		input logic [3:0] op,
		
		output logic [W-1:0] op_result,
		//lo pongo como un bus por mientras pero se puede tratar como cada una señal por aparte
		output logic N, Z, C, V
  
);
	
	
	//variables para la suma
	logic [W-1:0] sum_y;
	logic sum_cout;
	logic [2*W-1:0] mul_result; // Resultado de la multiplicación (doble ancho)

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
	
	//variables para la division
	logic [W-1:0] div_c;  
   logic [W-1:0] div_r;
	
	division #(.m(W)) div(
		.dividendo(A),
		.divisor(B),
		.cociente(div_c),
      .residuo(div_r)
	);
	
	
	

always_comb begin
	// Inicializar flags
    N = 0;
    Z = 0;
    C = 0;
    V = 0;
	 mul_result = 0;

	case(op)
	//pongo la asignación del flag ahí solo pq es la suma, si lo pongo afuera se asigna siempre pero no sé como se use sin la suma
		4'b0000: begin
		op_result = sum_y;
		C = sum_cout;
		end
		
		4'b0001: begin
		op_result = subs_y; // agregarle las flags a la resta
		N = ~subs_cout;
		end
			
		4'b0010: begin
		mul_result = A * B;
		op_result = mul_result[W-1:0]; // Tomar solo los W bits inferiores
		C = |mul_result[2*W-1:W]; // Carry si hay bits en la parte alta
		end
		
		4'b0011: op_result = div_c;
		4'b0100: op_result = div_r;
		4'b0101: op_result = A & B;
		4'b0110: op_result = A | B;
		4'b0111: op_result = A ^ B;
		4'b1000: op_result = A << 1;
		4'b1001: op_result = A >> 1;
		default: op_result = 0;
		endcase
		
   Z = (op_result == 0);   // Zero
		
	end
		
endmodule
