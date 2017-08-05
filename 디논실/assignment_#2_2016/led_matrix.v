module led_matrix(clk, led_state, mat_row, mat_col);


	input					clk;
	input	   [1:0]			led_state;
	output	[6:0]		mat_row;
	output	[4:0]		mat_col;

	reg		[4:0]		mat_col;
	reg      [6:0]    mat_row;	
	reg		[2:0]		state;
	
	
	always @(posedge clk)
	begin
		if			(state == 0)	begin mat_col = 5'b01111;	state = 1;	end
		else if	(state == 1)	begin mat_col = 5'b10111;	state = 2;	end
		else if	(state == 2)	begin mat_col = 5'b11011;	state = 3;	end
		else if	(state == 3)	begin mat_col = 5'b11101;	state = 4;	end
		else if	(state == 4)	begin mat_col = 5'b11110;	state = 0;	end
	end
	
	always @(negedge clk)
	begin
		case(led_state)
			0: begin
					case(mat_col)
						5'b01111 : mat_row = 7'b0111111;
						5'b10111 : mat_row = 7'b1001111;
						5'b11011 : mat_row = 7'b1001101;
						5'b11101 : mat_row = 7'b1001111;
						5'b11110 : mat_row = 7'b0111111;
					endcase
				end
			1: begin
					case(mat_col)
						5'b01111 : mat_row = 7'b0001111;
						5'b10111 : mat_row = 7'b1001111;
						5'b11011 : mat_row = 7'b1001101;
						5'b11101 : mat_row = 7'b1001111;
						5'b11110 : mat_row = 7'b0111111;
					endcase
				end
			default: begin
				case(mat_col)
						5'b01111 : mat_row = 7'b0000000;
						5'b10111 : mat_row = 7'b0000000;
						5'b11011 : mat_row = 7'b0000000;
						5'b11101 : mat_row = 7'b0000000;
						5'b11110 : mat_row = 7'b0000000;
					endcase
				end
		endcase
	end

endmodule