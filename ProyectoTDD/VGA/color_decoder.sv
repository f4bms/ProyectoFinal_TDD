module color_decoder(
	input  logic [3:0] color,
	output logic [23:0] rgb_color
);

always_comb
	begin
		case(color)
			4'b0000 : rgb_color = 24'hffffff; 		
			4'b0001 : rgb_color = 24'h4cfffc; 		
			4'b0010 : rgb_color = 24'h52bac3;  		
			4'b0011 : rgb_color = 24'h66989f; 
			4'b0100 : rgb_color = 24'haaa4ae; 
			4'b0101 : rgb_color = 24'h292e31; 
			4'b0110 : rgb_color = 24'h3a4342; 
			4'b0111 : rgb_color = 24'h000909; 
			4'b1000 : rgb_color = 24'h8f4017; 
			4'b1001 : rgb_color = 24'h702a00; 
			4'b1010 : rgb_color = 24'hd56e45; 
			4'b1011 : rgb_color = 24'hbf6540; 
			4'b1100 : rgb_color = 24'hf9d080; 
			4'b1101 : rgb_color = 24'hfb8347; 
			4'b1110 : rgb_color = 24'h2f2a4b;
			4'b1111 : rgb_color = 24'he01f1f;
			default : rgb_color = 24'h2f2a4b; 
		endcase
	end
endmodule