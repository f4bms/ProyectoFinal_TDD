module fullAdder (
    input logic a, b, cin, 
    output logic cout, s
);
	
    /* Sumador completo de un bit.

    Entradas:
    - a: bit de entrada.
    - b: bit de entrada.
    - cin: acarreo de entrada.

    Salidas:
    - s: bit de salida.
    - cout: acarreo de salida.
    
    */

	assign s = a ^ b ^ cin;
	assign cout = (a & b) + (a & cin) + (b & cin);

endmodule