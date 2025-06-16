module main(
    input  logic CLOCK_50,
    input  logic [3:0] KEY,
	 input  logic serial_in,
	 input  logic [ 9: 0] SW,

	 output logic [ 6: 0]   HEX0,
	 output logic [ 6: 0]   HEX1,
	 output logic [ 6: 0]   HEX2,
	 output logic [ 6: 0]   HEX3,
	 output logic [ 6: 0]   HEX4,
	 output logic [ 6: 0]   HEX5,

    output logic VGA_CLK,
    output logic VGA_HS,
    output logic VGA_VS,
    output logic [7:0] VGA_R,
    output logic [7:0] VGA_G,
    output logic [7:0] VGA_B,
    output logic VGA_BLANK_N
);
clock_div clock_divider(
	.clk_in(CLOCK_50),
	.clk_out(VGA_CLK));

logic [23:0] rgb_color;

logic [1:0] correct_door_1 = 2'b01;
logic [1:0] correct_door_2 = 2'b00;
logic [1:0] p1_lives = 2'b10;
logic [1:0] p2_lives = 2'b11;
logic time_up = 0;
logic [23:0] sec_1 = 2'b101111101011110000100000;
logic [27:0] sec_10 = 2'b1110111001101011001010000000;
logic [28:0] sec_11 = 2'b10000011001000010101011000000;
logic resume = 0;
//counter #(28) counter_play(.clk(VGA_CLK), .enable(1), .reset(resume), .max(sec_10), .done(time_up), .q());
counter #(24) counter_pause(.clk(VGA_CLK), .enable(time_up), .reset(reset), .max(sec_1), .done(resume), .q());

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
	.reset(SW[9]),
	.enable(enable),
	.seconds(tics)
);   
				 
screen_drawer screen( 
	.clk(VGA_CLK),
	.p1_lives(p1_lives),
	.p2_lives(p2_lives),
	.correct_door_1(SW[2:1]),
	.correct_door_2(SW[4:3]),
	.player_1_pos(SW[8:7]),
	.player_2_pos(SW[6:5]),
	.resume(resume),
	.rgb_color(rgb_color));

vga_driver driver(
    .reset(SW[9]),
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
	if(tics == 2'b1010)
		time_up <= !time_up;
	if(resume)
		time_up <= 0;
	
end

endmodule
