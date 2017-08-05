module key_matrix(clk, num, key_row, key_col);
	input					clk;
	output	[3:0]		num;
	input		[3:0]		key_row;
	output	[2:0]		key_col;
	
	reg		[3:0]		num;
	reg		[2:0]		key_col;
	
	reg		[1:0]		state;
	reg 		[2:0]   	pCol = 0;
	reg     [3:0] 		pRow = 0;
	
	parameter			SN=0, SA=1, SS=2;
	parameter			S0=3, S1=4, S2=5, S3=6, S4=7, S5=8, S6=9, S7=10, S8=11, S9=12;
	
	always @(posedge clk)
	begin
		if			(state == 0)	begin key_col = 3'b100;	state = 1;	end
		else if	(state == 1)	begin key_col = 3'b010;	state = 2;	end
		else if	(state == 2)	begin key_col = 3'b001;	state = 0;	end
	end
	
	always @(negedge clk)
	begin
		if			(key_row[3] && pCol == 0)	begin num = key_col[2]?S1:(key_col[1]?S2:S3); pRow = 3; pCol <= key_col; end
		else if	(key_row[2] && pCol == 0)	begin num = key_col[2]?S4:(key_col[1]?S5:S6); pRow = 2; pCol <= key_col; end
		else if	(key_row[1] && pCol == 0)	begin num = key_col[2]?S7:(key_col[1]?S8:S9); pRow = 1; pCol <= key_col; end
		else if	(key_row[0] && pCol == 0)	begin num = key_col[2]?SA:(key_col[1]?S0:SS); pRow = 0; pCol <= key_col; end
		else if	((key_col == pCol) && pCol != 0)
			begin
				case(pRow)
					0 : if(key_row[0] == 0) begin num = SN; pCol <= 0; end
					1 : if(key_row[1] == 0) begin num = SN; pCol <= 0; end
					2 : if(key_row[2] == 0) begin num = SN; pCol <= 0; end
					3 : if(key_row[3] == 0) begin num = SN; pCol <= 0; end
				endcase
			end
	end
		
endmodule
