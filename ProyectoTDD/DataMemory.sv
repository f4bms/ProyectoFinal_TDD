module DataMemory(
    input logic clk,
    input logic reset,
    input logic [31:0] A, // Dirección de memoria
    input logic [31:0] WD, // Datos a escribir
    input logic WE, // Señal de escritura
    output logic [31:0] RD // Datos leídos
);

    // Instancia del módulo Deco
    logic wem, we1, we2, we3;
    logic [1:0] rdsel;
    logic [31:0] RDataRAM, RDataIO1, RDataIO2, RDataIO3;

    Deco deco_inst (
        .addr(A[21:2]),    // Asumiendo que la dirección relevante son los bits [21:2]
        .memWrite(WE),
        .wem(wem),
        .we1(we1),
        .we2(we2),
        .we3(we3),
        .rdsel(rdsel)
    );
	 
	 //ocupo un read del vga
	 //ocupo un read del cpu
	 //ocupo que la cpu escriba en mem
	 
//la vga no ocupa escribir en memoria entonces el enable de b y el dato no se ocupan
	 
ram_vid mi_ram (
        .address_a(A),
        .address_b(addr_b), //este es el address q se le ocupa pasar
        .clock(clk),
        .data_a(WD), //dato que se va a escribir
        .data_b(32'b0), //no ocupo que escriba
        .wren_a(we3),  //enable para escribir
        .wren_b(1'b0), //no sirve
        .q_a(RDataIO3), 
        .q_b(q_b) //vga
    );
	 
readMUX mux_u (
        .rdsel    (rdsel),
        .rdata0   (RDataRAM),
        .rdata1   (RDataIO1),
        .rdata2   (RDataIO2),
        .rdata3   (RDataIO3), //va conectado a la salida del 
        .readData (RD) //siempre va conectado al proce
    );
	 
	 
	 
	 

endmodule