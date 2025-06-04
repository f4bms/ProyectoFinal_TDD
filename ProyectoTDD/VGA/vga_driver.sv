//VGA driver 640x480 60Hz 
module vga_driver(
	input  logic VGA_CLK, 
	input  logic reset,
	input	 logic [23:0] rgb_color,
	output logic VGA_HS,      
	output logic VGA_VS,	     
	output logic [7:0] VGA_R,
	output logic [7:0] VGA_B,
	output logic [7:0] VGA_G, 
	output logic VGA_BLANK_N
);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// position counter and sync generation	
video_sync_generator video_sync (
	.vga_clk(VGA_CLK),
	.reset(reset),
	.blank_n(VGA_BLANK_N),
	.HS(VGA_HS),
	.VS(VGA_VS));

assign VGA_R = rgb_color[23:16];
assign VGA_G = rgb_color[15:8];
assign VGA_B = rgb_color[7:0];
	
	
endmodule  // VGA_image_gen