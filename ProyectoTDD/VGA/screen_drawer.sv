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

//image pixel colors				 
parameter mem_door_closed = "Assets/memory.mem";
/*parameter mem_door_open = "Assets/memory.mem";
parameter mem_heart_full = "Assets/memory.mem";
parameter mem_heart_closed = "Assets/memory.mem";*/

parameter IMAGE_WIDTH = 160;
parameter IMAGE_HEIGHT = 224;

(* RAM_STYLE="BLOCK" *)
logic [23:0]REGMEM_door_closed[0:(2**$clog2(IMAGE_HEIGHT*IMAGE_WIDTH))-1];
/*logic [23:0]REGMEM_door_open[0:(2**$clog2(IMAGE_HEIGHT*IMAGE_WIDTH))-1];
logic [23:0]REGMEM_heart_full[0:(2**$clog2(IMAGE_HEIGHT*IMAGE_WIDTH))-1];
logic [23:0]REGMEM_heart_empty[0:(2**$clog2(IMAGE_HEIGHT*IMAGE_WIDTH))-1];*/

initial 
	//$readmemh("hex_memory_file.mem", memory_array, [start_address], [end_address])
	begin
		$readmemh(mem_door_closed, REGMEM_door_closed, 0,  IMAGE_WIDTH*IMAGE_HEIGHT);
	end
		  
logic [(2**$clog2(IMAGE_HEIGHT*IMAGE_WIDTH))-1:0] address;

always @ (posedge clk)
		begin
			// First row
			if(y > 128 && y <= 352)
				begin
					//First col
					if(x >= 184 && x < 344) begin
						address <= ((y - offset_y) * (IMAGE_WIDTH)) + (x - offset_x);
						rgb_color <= REGMEM_door_closed[address];
					end
					if(x >= 344 && x < 504) begin
						address <= ((y - offset_y) * (IMAGE_WIDTH)) + (x - offset_x) - IMAGE_WIDTH;
						rgb_color <= REGMEM_door_closed[address];
					end
					if(x >= 504 && x < 664) begin
						address <= ((y - offset_y) * (IMAGE_WIDTH)) + (x - offset_x) - IMAGE_WIDTH*2;
						rgb_color <= REGMEM_door_closed[address];
					end
					if(x >= 664 && x < 824) begin
						address <= ((y - offset_y) * (IMAGE_WIDTH)) + (x - offset_x) - IMAGE_WIDTH*3;
						rgb_color <= REGMEM_door_closed[address];
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