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
				 
screen_drawer screen( 
	.clk(VGA_CLK),
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
