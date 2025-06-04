module video_sync_generator(
	input logic reset,
	input logic vga_clk,
	output logic blank_n,
	output logic HS,
	output logic VS
);
                            
parameter hori_line  = 800;                           
parameter hori_back  = 144;
parameter hori_front = 16;
parameter vert_line  = 525;
parameter vert_back  = 34;
parameter vert_front = 11;
parameter H_sync_cycle = 96;
parameter V_sync_cycle = 2;


logic [10:0] h_cnt;
logic [9:0]  v_cnt;
logic cHD,cVD,cDEN,hori_valid,vert_valid;

always@(negedge vga_clk,posedge reset)
begin
  if (reset)
  begin
	  h_cnt<=11'd0;
	  v_cnt<=10'd0;
  end
	 else
	 begin
		if (h_cnt==hori_line-1)
			begin 
				h_cnt<=11'd0;
				if (v_cnt==vert_line-1)
					v_cnt<=10'd0;
				else
					v_cnt<=v_cnt+1;
			end
		else
			h_cnt<=h_cnt+1;
	 end
end
assign cHD = (h_cnt<H_sync_cycle)?1'b0:1'b1;
assign cVD = (v_cnt<V_sync_cycle)?1'b0:1'b1;

assign hori_valid = (h_cnt<(hori_line-hori_front)&& h_cnt>=hori_back)?1'b1:1'b0;
assign vert_valid = (v_cnt<(vert_line-vert_front)&& v_cnt>=vert_back)?1'b1:1'b0;

assign cDEN = hori_valid && vert_valid;

always@(negedge vga_clk)
begin
  HS<=cHD;
  VS<=cVD;
  blank_n<=cDEN;
end

endmodule


