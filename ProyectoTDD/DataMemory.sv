module DataMemory(
    input logic clk,
    input logic reset,
    input logic [31:0] addr_A,  // Dirección de memoria
    input logic [31:0] addr_B, // Dirección de memoria para lectura de VGA
    input logic [31:0] WD, // Datos a escribir
    input logic WE, // Señal de escritura
	 input logic [3:0]   posJ1,
	 input logic [3:0]   posJ2,
    input logic time_up,
    output logic [31:0] RD, // Datos leídos
    output logic [31:0] DataVideo, // Datos de video para VGA
	 output logic [1:0] pos_J1,
	 output logic [1:0] pos_J2
);

    // Instancia del módulo Deco
    logic wenRAM;
    logic [2:0] rdsel;
    logic [31:0] RDataRAM, RDataIO1, RDataIO2, RDataRamNum, RDataTimeUp;
    logic [2:0] ramdNum;
	 
	 assign pos_J1 = RDataIO1[1:0];
	 assign pos_J2 = RDataIO2[1:0];

    assign RDataRamNum = {29'b0, ramdNum}; 
    assign RDataTimeUp = {31'b0, time_up};

    Deco deco_inst (
        .addr(addr_A),
        .memWrite(WE),
        .wenRAM(wenRAM), // Write enable para RAM
        .rdsel(rdsel)
    );
	 

	 
    //la vga no ocupa escribir en memoria entonces el enable de b y el dato no se ocupan
        
    ram_vid mi_ram (
            .address_a((addr_A == 32'h00006000) ? 3'd0 :
                       (addr_A == 32'h00007000) ? 3'd1 :
                       (addr_A == 32'h00008000) ? 3'd2 :
                       (addr_A == 32'h00009000) ? 3'd3 :
                       (addr_A == 32'h00010000) ? 3'd4 :
                       3'd0), // default a 0 si no coincide
            .address_b((addr_B == 32'h00006000) ? 3'd0 :
                       (addr_B == 32'h00007000) ? 3'd1 :
                       (addr_B == 32'h00008000) ? 3'd2 :
                       (addr_B == 32'h00009000) ? 3'd3 :
                       (addr_B == 32'h00010000) ? 3'd4 :
                       3'd0), // default a 0 si no coincide
            .clock(clk),
            .data_a(WD), //dato que se va a escribir
            .data_b(32'b0), //no ocupo que escriba
            .wren_a(wenRAM),  //enable para escribir
            .wren_b(1'b0), //no sirve
            .q_a(RDataRAM), 
            .q_b(DataVideo)
        );
        
    readMUX mux_u(
        .rdsel(rdsel),
        .rdata0(RDataRAM),
        .rdata1(RDataIO1),
        .rdata2(RDataIO2),
        .rdata3(RDataRamNum),
        .rdata4(RDataTimeUp),
        .readData(RD)
    );
        
    RegBotones reg_botones1 (
        .clk(clk),
        .reset(reset),
        .botones(posJ1),
        .we(1), // Habilita escritura en el registro de botones
        .data_out(RDataIO1)
    );

    RegBotones reg_botones2 (
        .clk(clk),
        .reset(reset),
        .botones(posJ2),
        .we(1), // Habilita escritura en el registro de botones
        .data_out(RDataIO2)
    );

    random_gen rand_door(
        .clk(clk),            // reloj del sistema
        .rst(reset),            // reset síncrono
        .numero(ramdNum)    // número aleatorio del 1 al 6
    );

	 
	 
	 
	 

endmodule