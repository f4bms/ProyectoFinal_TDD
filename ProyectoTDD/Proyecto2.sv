module Proyecto2( // No es proyecto 1?
	input  logic reset,
    input  logic CLOCK_50,
	input  logic [8:0] SW,
	output logic [6:0] HEX0,
	output logic [6:0] HEX1,
	output logic [9:0] LEDR,
    output logic VGA_CLK,
    output logic VGA_HS,
    output logic VGA_VS,
    output logic [7:0] VGA_R,
    output logic [7:0] VGA_G,
    output logic [7:0] VGA_B,
    output logic VGA_BLANK_N
    //output logic [15:0][31:0] leds_registers,
    //output logic [31:0] instrucciones
);

//  ----------------- Memoria de instrucciones -------------------
logic [31:0] Instruction; // Instrucción de 32 bits
logic [31:0] PC; // Contador de Programa


InstMemory inst_mem (
    .clk(VGA_CLK),
    .reset(reset),
    .PC(PC),
    .Instruction(Instruction)
);

// ----------------- Procesador ARMv4 ---------------------------------
logic [31:0] WriteDataMem; // Datos a escribir en el registro
logic [31:0] AddressDataMem; // Dirección de memoria para escritura
logic WriteEnableMem; // Habilitar escritura en memoria
logic [31:0] ReadData; // Datos leídos de memoria


ProcesadorARMv4 proc (
    .clk(VGA_CLK),
    .reset(reset),
    .Instruction(Instruction), 
    .PC(PC), // Salida del PC
    .WriteDataMem(WriteDataMem),
    .AddressDataMem(AddressDataMem),
    .WriteEnableMem(WriteEnableMem), // No se escribe en memoria en este momento
    .ReadData(ReadData),
    .leds_registers() // Salida para los LEDs de los registros
    , .ALUres() // Salida para el resultado de la ALU
    , .F32()
);

// ----------------- Memoria de video -------------------


logic [31:0] VGAAddr, DataVideo; // Dirección de memoria para lectura
logic time_up = 0;

DataMemory video_memory(
   .clk(VGA_CLK),
	.reset(reset),
	.addr_A(AddressDataMem),  // Dirección de memoria para escritura
	.addr_B(VGAAddr), // Dirección de memoria para lectura de VGA
	.WD(WriteDataMem), // Datos a escribir
	.WE(WriteEnableMem), // Señal de escritura
	.posJ1(SW[7:4]), // Botones del jugador 1
	.posJ2(SW[3:0]), // Botones del jugador 2
	.time_up(time_up), // Indica si el tiempo se ha agotado
	.RD(ReadData), // Datos leídos de memoria
	.DataVideo(DataVideo), // Datos de video para VGA
	.pos_J1(player_1_pos),
	.pos_J2(player_2_pos)
);



//------------------------ VGA ---------------------------------
clock_div clock_divider(
	.clk_in(CLOCK_50),
	.clk_out(VGA_CLK)
);

logic [23:0] rgb_color;

logic [1:0] correct_door_1;
logic [1:0] correct_door_2;
logic [1:0] p1_lives;
logic [1:0] p2_lives;
logic [1:0] player_1_pos;
logic [1:0] player_2_pos;

logic resume;

logic [24:0] sec_1 = 25'd25_000_000;
counter #(25) counter_pause(
	.clk(VGA_CLK), 
	.enable(time_up), 
	.reset(reset), 
	.max(sec_1), 
	.done(resume), 
	.q()
);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SEVEN SEGMENT TIMER

logic [3:0] seg_0, seg_1;
logic [3:0] tics;
logic [3:0] max_time = 4'd10;
logic enable = 1;
logic [11:0] bcd_time;

assign seg_0 = bcd_time[7:4];
assign seg_1 = bcd_time[11:8];

seven_segment_driver seg0(seg_0, HEX0);
seven_segment_driver seg1(seg_1, HEX1);

BinToBCD res_converter(tics, bcd_time);

timer timer_count (
	.clk(VGA_CLK), 
	.reset(resume | reset),
	.enable(enable),
	.seconds(tics)
);   
				 
screen_drawer screen( 
	.clk(VGA_CLK),
	.p1_lives(p1_lives),
	.p2_lives(p2_lives),
	.correct_door_1(correct_door_1),
	.correct_door_2(correct_door_2),
	.player_1_pos(player_1_pos),
	.player_2_pos(player_2_pos),
	.resume(resume),
	.time_up(time_up),
	.reset(reset),
	.rgb_color(rgb_color));

vga_driver driver(
    .reset(reset),
	 .rgb_color(rgb_color),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .VGA_R(VGA_R),
    .VGA_B(VGA_B),
    .VGA_G(VGA_G),
    .VGA_CLK(VGA_CLK),
    .VGA_BLANK_N(VGA_BLANK_N)
);

always@(posedge VGA_CLK) begin
	if(tics >= max_time) begin
		time_up <= 1;
		enable <= 0;
	end
	
	if(resume) begin
		time_up <= 0;
		enable <= 1;
	end
	
	LEDR[0] <= time_up;
	LEDR[1] <= resume;
	
	
end

logic [3:0] count;
counter #(4) counter_read(.clk(VGA_CLK), .enable(1), .reset(reset), .max(4'b0010), .done(), .q(count));

// Datos del procesador a la memoria de video
// Addr 6000: vidas del jugador 1
// Addr 7000: vidas del jugador 2
// Addr 8000: puertas correctas (1100 = puertas 1 y 2 correctas)
// Addr 9000: posición del jugador 1 (00 = puerta 1, 01 = puerta 2, 10 = puerta 3, 11 = puerta 4)
// Addr 10000: posición del jugador 2 (00 = puerta 1, 01 = puerta 2, 10 = puerta 3, 11 = puerta 4)
always_ff @(posedge VGA_CLK) begin
	if(count == 4'b0000) begin
		VGAAddr <= 32'h00006000;
		p1_lives <= DataVideo[1:0];
		LEDR[9:8] <= p1_lives;
	end
	else if(count == 4'b0001) begin
		VGAAddr <= 32'h00007000;
		p2_lives <= DataVideo[1:0];
		LEDR[7:6] <= p2_lives;
	end
	else if(count == 4'b0010) begin
		VGAAddr <= 32'h00008000;
		correct_door_1 <= DataVideo[1:0];
		correct_door_2 <= DataVideo[3:2];
		LEDR[5:4] <= correct_door_1;
		LEDR[3:2] <= correct_door_2;

	end		
end



endmodule