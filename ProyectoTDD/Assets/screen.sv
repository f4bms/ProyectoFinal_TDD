module screen_drawer(
	input  logic clk,
	input  logic [1:0] correct_door,
	input  logic time_up,
	output logic [23:0] rgb_color
);

logic [9:0] x = 0;  
logic [9:0] y = 0;  
logic [9:0] x_max = 799;
logic [9:0] y_max = 524;
logic done;

counter #(10) counter_x(.clk(clk), .enable(1), .reset(reset), .max(x_max), .done(done), .q(x));
counter #(10) counter_y(.clk(clk), .enable(done), .reset(reset), .max(y_max), .done(), .q(y));
 

parameter hori_back  = 144;
parameter vert_back  = 34;
 

// Door image data
parameter DOOR_WIDTH = 112;
parameter DOOR_HEIGHT = 156;
parameter offset_x = 240;
parameter offset_y = 162;		  
logic [(2**$clog2(DOOR_HEIGHT*DOOR_WIDTH))-1:0] closed_address;
logic [(2**$clog2(DOOR_HEIGHT*DOOR_WIDTH))-1:0] open_address;
logic [3:0] memory_open [0:17471];
logic [3:0] memory_closed [0:17471];

parameter HEART_WIDTH = 22;
parameter HEART_HEIGHT = 20;
parameter heart_offset_x = 240;
parameter heart_offset_y = 100;		  
logic [(2**$clog2(HEART_WIDTH*HEART_HEIGHT))-1:0] heart_address;
logic [3:0] memory_heart [0:439];


sprites sprites(
	.door_open(memory_open),
	.door_closed(memory_closed),
	.heart(memory_heart)
);

logic [3:0] color;

color_decoder decoder(
	.color(color),
	.rgb_color(rgb_color)
);

always @ (posedge clk)
		begin
		//lives
			/*if(y > heart_offset_y && y <= 119) begin
					if(x >= heart_offset_x && x < 259) begin
						heart_address <= ((y - heart_offset_y) * (HEART_WIDTH)) + (x - heart_offset_x);
						color <= memory_heart[heart_address];
					end
					else
						color <= 4'b1110;
				end
			// Doors
			else*/ if(y > offset_y && y <= offset_y + DOOR_HEIGHT)
				begin
					if(x >= offset_x && x < 318) begin
						if(correct_door == 2'b00 && time_up) begin
							open_address <= ((y - offset_y) * (DOOR_WIDTH)) + (x - offset_x);
							color <= memory_open[open_address];
						end
						else begin
							closed_address <= ((y - offset_y) * (DOOR_WIDTH)) + (x - offset_x);
							color <= memory_closed[closed_address];
						end
					end
					else if(x >= 352 && x < 464) begin
						if(correct_door == 2'b01 && time_up) begin
							open_address <= ((y - offset_y) * (DOOR_WIDTH)) + (x - offset_x) - DOOR_WIDTH;
							color <= memory_open[open_address];
						end
						else begin
							closed_address <= ((y - offset_y) * (DOOR_WIDTH)) + (x - offset_x) - DOOR_WIDTH;
							color <= memory_closed[closed_address];
						end
					end
					else if(x >= 464 && x < 576) begin
						if(correct_door == 2'b10 && time_up) begin
							open_address <= ((y - offset_y) * (DOOR_WIDTH)) + (x - offset_x) - DOOR_WIDTH*2;
							color <= memory_open[open_address];
						end
						else begin
							closed_address <= ((y - offset_y) * (DOOR_WIDTH)) + (x - offset_x) - DOOR_WIDTH*2;
							color <= memory_closed[closed_address];
						end
					end
					else if(x >= 576 && x < 688) begin
						if(correct_door == 2'b11 && time_up) begin
							open_address <= ((y - offset_y) * (DOOR_WIDTH)) + (x - offset_x) - DOOR_WIDTH*2;
							color <= memory_open[open_address];
						end
						else begin
							closed_address <= ((y - offset_y) * (DOOR_WIDTH)) + (x - offset_x) - DOOR_WIDTH*2;
							color <= memory_closed[closed_address];
						end
					end
					else
						color <= 4'b1110;
				end
			else
				color <= 4'b1110;
		end
	

endmodule