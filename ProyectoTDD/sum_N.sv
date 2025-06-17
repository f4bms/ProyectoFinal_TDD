
/* sumador de n bits */
module sum_N #(
	parameter int m=4 // tamaño del sumador

)(
		input logic [m-1:0] a,b,
		output logic cout,
		output logic [m-1:0] y
);
				
	logic [m-1:0] c;

	always_comb begin
		c = '0; // Initialize carry vector to zero to avoid X propagation

			
		c[0] = a[0] & b[0]; 
		y[0] = a[0] ^ b[0];
	
		
		for (int i = 1; i < m; i++) begin
			c[i] = (a[i] & b[i]) | (a[i] & c[i-1] ) | (b[i] & c[i-1]);
			y[i] = a[i] ^ b[i] ^ c[i-1];
			
		end //el del for
		
		cout = c[m-1];
		
	end //el del always comb
	
endmodule 