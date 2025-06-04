module screen_drawer(
	input  logic clk,
	output logic [23:0] rgb_color
);

logic [9:0] x = 0;  
logic [9:0] y = 0;  
logic [9:0] x_max = 799;
logic [9:0] y_max = 524;
logic done;

counter #(10) counter_x(.clk(VGA_CLK), .enable(1), .reset(reset), .max(x_max), .done(done), .q(x));
counter #(10) counter_y(.clk(VGA_CLK), .enable(done), .reset(reset), .max(y_max), .done(), .q(y));
 

parameter offset_x = 184;
parameter offset_y = 128;
parameter hori_back  = 144;
parameter vert_back  = 34;
 

// Door image data
parameter DOOR_WIDTH = 112;
parameter DOOR_HEIGHT = 156;		  
logic [(2**$clog2(DOOR_HEIGHT*DOOR_WIDTH))-1:0] door_address;
logic [23:0] memory_open [0:17471];
logic [23:0] memory_closed [0:17471];

parameter HEART_WH = 20;	  
logic [(2**$clog2(HEART_WH*HEART_WH))-1:0] heart_address;
logic [23:0] memory_heart [0:399];


sprites sprites(
	.door_open(memory_open),
	.door_closed(memory_closed),
	.heart(memory_heart));

always @ (posedge clk)
		begin
			// First row
			if(y > 128 && y <= 284)
				begin
					//First col
					if(x >= 184 && x < 296) begin
						door_address <= ((y - offset_y) * (DOOR_WIDTH)) + (x - offset_x);
						rgb_color <= memory_open[door_address];
					end
					if(x >= 296 && x < 408) begin
						door_address <= ((y - offset_y) * (DOOR_WIDTH)) + (x - offset_x) - DOOR_WIDTH;
						rgb_color <= memory_open[door_address];
					end
					if(x >= 408 && x < 520) begin
						door_address <= ((y - offset_y) * (DOOR_WIDTH)) + (x - offset_x) - DOOR_WIDTH*2;
						rgb_color <= memory_open[door_address];
					end
					if(x >= 520 && x < 632) begin
						door_address <= ((y - offset_y) * (DOOR_WIDTH)) + (x - offset_x) - DOOR_WIDTH*3;
						rgb_color <= memory_open[door_address];
					end
					else
						rgb_color <= 24'hFFFFFF;
				end
			else
				begin
					rgb_color = 24'hFFFFFF;
				end
	end
	

endmodule