module Proyecto2( // No es proyecto 1?
	 input  logic reset,
    input  logic CLOCK_50,
    input  logic [3:0] KEY,
	 input  logic serial_in,
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
);
logic [31:0] Instruction; // Instrucción de 32 bits
logic [31:0] PC; // Contador de Programa

assign instr = Instruction; // Asignar el PC a la salida instr
assign PC_led = PC; // Asignar el PC a la salida PC_led

// Memoria de instrucciones
InstMemory inst_mem (
    .clk(VGA_CLK),
    .reset(reset),
    .PC(PC),
    .Instruction(Instruction)
);

// Memoria de datos
logic [31:0] WriteDataMem; // Datos a escribir en el registro
logic [31:0] AddressDataMem; // Dirección de memoria para escritura
logic WriteEnableMem; // Habilitar escritura en memoria
logic [31:0] ReadData; // Datos leídos de memoria

// Memoria de datos simple: un solo registro de 32 bits
logic [31:0] single_reg;

always_ff @(posedge VGA_CLK or posedge reset) begin
    if (reset) begin
        single_reg <= 32'd0;
    end else if (WriteEnableMem) begin
        single_reg <= WriteDataMem;
    end
end

assign ReadData = single_reg;
assign mem = single_reg;


// Procesador ARMv4
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

logic [31:0] A; // Dirección de memoria
logic [31:0] WD; // Datos a escribir
logic WE; // Señal de escritura
logic [31:0] RD; // Datos leídos

DataMemory video_memory(
    .clk(VGA_CLK),
    .reset(reset),
    .A(A), // Dirección de memoria
    .WD(WD), // Datos a escribir
    .WE(WD), // Señal de escritura
    .RD(RD) // Datos leídos
);


//------------------------ VGA ---------------------------------

clock_div clock_divider(
	.clk_in(CLOCK_50),
	.clk_out(VGA_CLK));

logic [23:0] rgb_color;

logic [1:0] correct_door_1 = 2'b01;
logic [1:0] correct_door_2 = 2'b00;
logic [1:0] p1_lives = 2'b10;
logic [1:0] p2_lives = 2'b11;
logic [1:0] player_1_pos;
logic [1:0] player_2_pos;
logic time_up = 0;
logic resume;

logic [24:0] sec_1 = 25'd25_000_000;
counter #(25) counter_pause(.clk(VGA_CLK), .enable(time_up), .reset(reset), .max(sec_1), .done(resume), .q());

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SEVEN SEGMENT TIMER

logic [3:0] seg_0, seg_1 = 0;
logic [3:0] tics;
logic [3:0] max_time = 4'b1010;
logic enable = 1;
logic [11:0] bcd_time;

seven_segment_driver seg0(seg_0, HEX0);
seven_segment_driver seg1(seg_1, HEX1);

BinToBCD res_converter(tics, bcd_time);

assign seg_0 = bcd_time[7:4];
assign seg_1 = bcd_time[11:8];

timer timer_count (
	.clk(VGA_CLK), 
	.reset(resume),
	.enable(enable),
	.seconds(tics)
);   
				 
screen_drawer screen( 
	.clk(VGA_CLK),
	.p1_lives(p1_lives),
	.p2_lives(p2_lives),
	.correct_door_1(correct_door_1),
	.correct_door_2(SW[4:3]),
	.player_1_pos(SW[8:7]),
	.player_2_pos(SW[6:5]),
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

logic [2:0] numero; 

random_gen rand_door(
    .clk(VGA_CLK),            // reloj del sistema
    .rst(reset),            // reset síncrono
    .numero()    // número aleatorio del 1 al 6
);

always@(posedge VGA_CLK) begin
	if(tics >= 4'b1010) begin
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

logic [2:0] count;
counter #(3) counter_read(.clk(VGA_CLK), .enable(1), .reset(reset), .max(3'b111), .done(), .q(count));

always_ff @(posedge VGA_CLK) begin
	if(count == 2'b00) begin
		A <= 32'h00006000;
		p1_lives <= RD[1:0];
	end
	else if(count == 2'b01) begin
		A <= 32'h00007000;
		p2_lives <= RD[1:0];
	end
	else if(count == 2'b10) begin
		A <= 32'h00003000;
		correct_door_1 <= RD[1:0];
	end
	else if(count == 2'b11) begin
		A <= 32'h00004000;
		correct_door_2 <= RD[1:0];
	end		
end

endmodule