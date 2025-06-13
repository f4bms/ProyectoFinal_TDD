module screen_drawer(
	input  logic clk,
	input  logic [1:0] correct_door, p1_lives, p2_lives, player_1_pos, player_2_pos,
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

parameter PLAYER_WIDTH = 24;
parameter PLAYER_HEIGHT = 30;
parameter p1_offset_x = 256;
parameter p2_offset_x = 312;
parameter player_offset_y = 320;
logic [(2**$clog2(PLAYER_WIDTH*PLAYER_HEIGHT))-1:0] p1_address;
logic [(2**$clog2(PLAYER_WIDTH*PLAYER_HEIGHT))-1:0] p2_address;		
logic [3:0] memory_player_1 [0:719];
logic [3:0] memory_player_2 [0:719];

sprites sprites(
	.door_open(memory_open),
	.door_closed(memory_closed),
	.heart(memory_heart),
	.player_1(memory_player_1),
	.player_2(memory_player_2)
);

logic [3:0] color;

color_decoder decoder(
	.color(color),
	.rgb_color(rgb_color)
);

always @ (posedge clk)
		begin
		   // Lives  ///////////////////////////////////////////////////////////////////////
			if(y > heart_offset_y && y <= 119) begin
				if(x >= hori_back && x < heart_offset_x || x >= 688)
					color <= 4'b1110;
				else if(p1_lives == 2'b01 && x >= heart_offset_x && x < 262) begin
					heart_address <= ((y - heart_offset_y) * (HEART_WIDTH)) + (x - heart_offset_x);
					color <= memory_heart[heart_address];
				end
				else if(p1_lives == 2'b01 && x >= 262 && x < 284) begin
					color <= 4'b1110;
				end
				else if(p1_lives == 2'b01 && x >= 284 && x < 306) begin
					color <= 4'b1110;
				end
				if(p1_lives == 2'b10 && x >= heart_offset_x && x < 262) begin
					heart_address <= ((y - heart_offset_y) * (HEART_WIDTH)) + (x - heart_offset_x);
					color <= memory_heart[heart_address];
				end
				else if(p1_lives == 2'b10 && x >= 262 && x < 284) begin
					heart_address <= ((y - heart_offset_y) * (HEART_WIDTH)) + (x - heart_offset_x) - HEART_WIDTH;
					color <= memory_heart[heart_address];
				end
				else if(p1_lives == 2'b10 && x >= 284 && x < 306) begin
					color <= 4'b1110;
				end
				if(p1_lives == 2'b11 && x >= heart_offset_x && x < 262) begin
					heart_address <= ((y - heart_offset_y) * (HEART_WIDTH)) + (x - heart_offset_x);
					color <= memory_heart[heart_address];
				end
				else if(p1_lives == 2'b11 && x >= 262 && x < 284) begin
					heart_address <= ((y - heart_offset_y) * (HEART_WIDTH)) + (x - heart_offset_x) - HEART_WIDTH;
					color <= memory_heart[heart_address];
				end
				else if(p1_lives == 2'b11 && x >= 284 && x < 306) begin
					heart_address <= ((y - heart_offset_y) * (HEART_WIDTH)) + (x - heart_offset_x) - HEART_WIDTH*2;
					color <= memory_heart[heart_address];
				end
				if(x >= 306 && x < 622) begin
					color <= 4'b1110;
				end
				if(p2_lives == 2'b01 && x >= 622 && x < 644) begin
					heart_address <= ((y - heart_offset_y -158) * (HEART_WIDTH)) + (x - heart_offset_x);
					color <= memory_heart[heart_address];
				end
				else if(p2_lives == 2'b01 && x >= 644 && x < 666) begin
					color <= 4'b1110;
				end
				else if(p2_lives == 2'b01 && x >= 666 && x < 688) begin
					color <= 4'b1110;
				end
				
				if(p2_lives == 2'b10 && x >= 622 && x < 644) begin
					heart_address <= ((y - heart_offset_y -158) * (HEART_WIDTH)) + (x - heart_offset_x);
					color <= memory_heart[heart_address];
				end
				else if(p2_lives == 2'b10 && x >= 644 && x < 666) begin
					heart_address <= ((y - heart_offset_y -158) * (HEART_WIDTH)) + (x - heart_offset_x) - HEART_WIDTH;
					color <= memory_heart[heart_address];
				end
				else if(p2_lives == 2'b10 && x >= 666 && x < 688) begin
					color <= 4'b1110;
				end

				if(p2_lives == 2'b11 && x >= 622 && x < 644) begin
					heart_address <= ((y - heart_offset_y -158) * (HEART_WIDTH)) + (x - heart_offset_x);
					color <= memory_heart[heart_address];
				end
				else if(p2_lives == 2'b11 && x >= 644 && x < 666) begin
					heart_address <= ((y - heart_offset_y -158) * (HEART_WIDTH)) + (x - heart_offset_x) - HEART_WIDTH;
					color <= memory_heart[heart_address];
				end
				else if(p2_lives == 2'b11 && x >= 666 && x < 688) begin
					heart_address <= ((y - heart_offset_y -158) * (HEART_WIDTH)) + (x - heart_offset_x) - HEART_WIDTH*2;
					color <= memory_heart[heart_address];
				end
			end
			// Doors ////////////////////////////////////////////////////////////////////////
			else if(y > offset_y && y <= 317)
				begin
					if(x >= offset_x && x < 352) begin
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
							open_address <= ((y - offset_y) * (DOOR_WIDTH)) + (x - offset_x) - DOOR_WIDTH*3;
							color <= memory_open[open_address];
						end
						else begin
							closed_address <= ((y - offset_y) * (DOOR_WIDTH)) + (x - offset_x) - DOOR_WIDTH*3;
							color <= memory_closed[closed_address];
						end
					end
					else
						color <= 4'b1110;
				end
			// Players //////////////////////////////////////////////////////////////////////
			else if(y > player_offset_y && y <= 349) begin
				if(x >= p1_offset_x && x < 280) begin
					if(player_1_pos == 2'b00) begin
						p1_address <= ((y - player_offset_y) * (PLAYER_WIDTH)) + (x - p1_offset_x);
						color <= memory_player_1[p1_address];
					end
					else 
						color <= 4'b1110;
				end
				else if(x >= p2_offset_x && x < 336) begin
					if(player_2_pos == 2'b00) begin
						p2_address <= ((y - player_offset_y) * (PLAYER_WIDTH)) + (x - p2_offset_x);
						color <= memory_player_2[p2_address];
					end
					else 
						color <= 4'b1110;
				end
				//-------------------------------------------------------
				else if(x >= 368 && x < 392) begin
					if(player_1_pos == 2'b01) begin
						p1_address <= ((y - player_offset_y) * (PLAYER_WIDTH)) + (x - p1_offset_x - DOOR_WIDTH) - PLAYER_WIDTH;
						color <= memory_player_1[p1_address];
					end
					else 
						color <= 4'b1110;
				end
				else if(x >= 424 && x < 448) begin
					if(player_2_pos == 2'b01) begin
						p2_address <= ((y - player_offset_y) * (PLAYER_WIDTH)) + (x - p2_offset_x - DOOR_WIDTH) - PLAYER_WIDTH;
						color <= memory_player_2[p2_address];
					end
					else 
						color <= 4'b1110;
				end
				//-------------------------------------------------------
				else if(x >= 480 && x < 504) begin
					if(player_1_pos == 2'b10) begin
						p1_address <= ((y - player_offset_y+2) * (PLAYER_WIDTH)) + (x - p1_offset_x - DOOR_WIDTH*2) - PLAYER_WIDTH*2;
						color <= memory_player_1[p1_address];
					end
					else 
						color <= 4'b1110;
				end
				else if(x >= 536 && x < 560) begin
					if(player_2_pos == 2'b10) begin
						p2_address <= ((y - player_offset_y+2) * (PLAYER_WIDTH)) + (x - p2_offset_x - DOOR_WIDTH*2) - PLAYER_WIDTH*2;
						color <= memory_player_2[p2_address];
					end
					else 
						color <= 4'b1110;
				end
				//-------------------------------------------------------
				else if(x >= 592 && x < 616) begin
					if(player_1_pos == 2'b11) begin
						p1_address <= ((y - player_offset_y+2) * (PLAYER_WIDTH)) + (x - p1_offset_x - DOOR_WIDTH*3) - PLAYER_WIDTH*3;
						color <= memory_player_1[p1_address];
					end
					else 
						color <= 4'b1110;
				end
				else if(x >= 648 && x < 672) begin
					if(player_2_pos == 2'b11) begin
						p2_address <= ((y - player_offset_y+2) * (PLAYER_WIDTH)) + (x - p2_offset_x - DOOR_WIDTH*3) - PLAYER_WIDTH*3;
						color <= memory_player_2[p2_address];
					end
					else 
						color <= 4'b1110;
				end
				//-------------------------------------------------------
				else
					color <= 4'b1110;
			end
			else
				color <= 4'b1110;
		end
	

endmodule