module main(
    input  logic CLOCK_50,
    input  logic [3:0] KEY,
	 input  logic serial_in,
	 input  logic [ 9: 0] SW,

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

logic time_up = 1;
				 
screen_drawer screen( 
	.clk(VGA_CLK),
	.p1_lives(p1_lives),
	.p2_lives(p2_lives),
	.correct_door_1(SW[2:1]),
	.correct_door_2(SW[4:3]),
	.player_1_pos(SW[8:7]),
	.player_2_pos(SW[6:5]),
	.time_up(time_up),
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


endmodule
