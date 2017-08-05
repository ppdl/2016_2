module seven_segment_display(clk, display, blink, fnd_pos, fnd_data);
	input					clk;
	input		[23:0]	display;
	input					blink;
	output	[5:0]		fnd_pos;
	output	[7:0]		fnd_data;
	
	reg		[5:0]		fnd_pos;
	reg		[7:0]		fnd_data;
	
	reg		[2:0]		state;
	reg		[31:0]	cnt;
	reg		[3:0]		num;
	
	parameter			SN=0, SA=1, SS=2;
	parameter			S0=3, S1=4, S2=5, S3=6, S4=7, S5=8, S6=9, S7=10, S8=11, S9=12;
	
	always @(posedge clk)
	begin
		if			(blink & (cnt == 12800))			state = 6;
		else if	(blink & (cnt == 25600))	begin	state = 0; cnt = 0;	end
		if 		(blink)									cnt = cnt + 1;
		
		if			(state == 0)	begin fnd_pos = 6'b011111;		num = display[23:20];	state = 1;	end
		else if	(state == 1)	begin fnd_pos = 6'b101111;		num = display[19:16];	state = 2;	end
		else if	(state == 2)	begin fnd_pos = 6'b110111;		num = display[15:12];	state = 3;	end
		else if	(state == 3)	begin fnd_pos = 6'b111011;		num = display[11:8];		state = 4;	end
		else if	(state == 4)	begin fnd_pos = 6'b111101;		num = display[7:4];		state = 5;	end
		else if	(state == 5)	begin fnd_pos = 6'b111110;		num = display[3:0];		state = 0;	end
		else							begin	fnd_pos = 6'b111111;														end
		
		
		
		case(num)
			SN:		fnd_data = 8'b00000000;
			SA:		fnd_data = 8'b11000110;
			SS:		fnd_data = 8'b00111010;
			S0:		fnd_data = 8'b11111100;//0;
			S1:		fnd_data = 8'b01100000;//1;
			S2:		fnd_data = 8'b11011010;//2;
			S3:		fnd_data = 8'b11110010;//3;
			S4:		fnd_data = 8'b01100110;//4;
			S5:		fnd_data = 8'b10110110;//5;
			S6:		fnd_data = 8'b10111110;//6;
			S7:		fnd_data = 8'b11100100;//7;
			S8:		fnd_data = 8'b11111110;//8;
			S9:		fnd_data = 8'b11110110;//9;
			default:	fnd_data = 8'b00000000;
		endcase
	end
	
endmodule
