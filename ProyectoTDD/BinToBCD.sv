module BinToBCD
  ( input  logic [3      : 0] bin   ,  
    output logic [11: 0] bcd); 
	 

 //counter to stop if all bits have been shifted
  integer i, shifts;

	always @(bin) 
		begin
			for(i = 0; i <= 11 ; i=i+1) 
				begin
					// initialize with zeros
					bcd[i] = 0; 
				end
			//add binary digits to beginning of register
			bcd[3:0] = bin;
			shifts = 0;
			while(shifts < 4) 
				begin
					//checks if first bcd digit is greater than 4
					if(bcd[7:4] > 4)
							 begin
								  bcd[7:4] = bcd[7:4] + 3;
							 end
					//checks if second bcd digit is greater than 4
					if(bcd[11:8] > 4)
							 begin
								  bcd[11:8] = bcd[11:8] + 3;
							 end
					//shifts entire register to the left by 1
					bcd = bcd << 1;
					shifts = shifts + 1;
				end
				
		end

endmodule