module digital_door_lock(clk, key_row, key_col, fnd_pos, fnd_data, reset, mat_row, mat_col, LED, buzzer);

	input 				reset;
	input					clk;
	input		[3:0]		key_row;
	output	[2:0]		key_col;
	output	[5:0]		fnd_pos;
	output	[7:0]		fnd_data;

	
	reg		[23:0]	display;
	reg					blink;
	wire		[3:0]		num;
	
	parameter			SN=0, SA=1, SS=2;
	parameter			S0=3, S1=4, S2=5, S3=6, S4=7, S5=8, S6=9, S7=10, S8=11, S9=12;

	timer							TIMER (clk, slow_clk);
	seven_segment_display	SEVEN_SEG (slow_clk, display, blink, fnd_pos, fnd_data);
	key_matrix					KEY (slow_clk, num, key_row, key_col);
	led_matrix              led (clk, led_state, mat_row, mat_col);
	//D_FF							buzzer1 (buzzer, num, slow_clk);
	music							MUSIC (clk, num, buzzer);
	
// you may add your own codes and variables here

	output [7:0] LED;
	reg [7:0] LED;
	
	output buzzer;
	output [4:0] mat_col;
	output [6:0] mat_row;
	reg [1:0] led_state = 2;
	
	reg [5:0] state = 0;
	reg [31:0]	cnt = 0;
	reg [3:0] pw0 = SN;
	reg [3:0] pw1 = SN;
	reg [3:0] pw2 = SN;
	reg [3:0] pw3 = SN;
	
	reg [3:0] i_pw0 = SN;
	reg [3:0] i_pw1 = SN;
	reg [3:0] i_pw2 = SN;
	reg [3:0] i_pw3 = SN;
	
	reg [3:0] c_pw0 = SN;
	reg [3:0] c_pw1 = SN;
	reg [3:0] c_pw2 = SN;
	reg [3:0] c_pw3 = SN;
	
	

// example1 : keymatrix example

/*
	always @(*)
	begin
		if(num != SN) display[3:0] = num;
	end
*/
	always @(posedge slow_clk)
		begin
			if(reset == 1) state <= 61;
			case (state)
		// Initial State
			61: if(num == SN) begin display = 0; state <= 0; led_state = 2; end
			0 : if(num != SN) begin display[19:16] <= SN; display[15:12] <= SN; display[11:8] <= SN; display[7:4] <= SN; pw3 <= num; display[3:0] <= num; state <= 1; end
			1 : if(num == SN) begin state <= 2; end
			2 : if(num != SN) begin display[7:4] <= pw3; display[3:0] <= num; pw2 <= num; state <= 3;end
			3 : if(num == SN) begin state <= 4; end
			4 : if(num != SN) begin display[11:8] <= pw3; display[7:4] <= pw2; display[3:0] <= num; pw1 <= num; state <= 5; end
			5 : if(num == SN) begin state <= 6; end
			6 : if(num != SN) begin display[15:12] <= pw3; display[11:8] <= pw2; display[7:4] <= pw1; display[3:0] <= num; pw0 <= num; state <= 7; end			
			7 : if(num != SN) begin display[15:12] <= pw3; display[11:8] <= pw2; display[7:4] <= pw1; display[3:0] <= pw0;
								if(num == SS) state <= 50; end
			50: if(num == SN) begin state <= 8; led_state <= 0; end
			8 : begin display <= 0; cnt <= 0; blink = 0; if(num == SA) state <= 9; else if(num == SS) state <= 30; end
			
			
		// Input password, assignment 1	
			9 : if(num == SN) begin state <= 10; display[3:0] <= SA; end
			10 : if(num != SA && num != SN) begin display[7:4] <= SA; i_pw3 <= num; display[3:0] <= num; state <= 11; end
				  else if(num == SA) state <= 23;
			23 : if(num == SN) begin state <= 8; end	  
			11 : if(num == SN) begin state <= 12; end
			12 : if(num != SN) begin display[11:8] <= SA; display[7:4] <= i_pw3; display[3:0] <= num; i_pw2 <= num; state <= 13;end
			13 : if(num == SN) begin state <= 14; end
			14 : if(num != SN) begin display[15:12] <= SA; display[11:8] <= i_pw3; display[7:4] <= i_pw2; display[3:0] <= num; i_pw1 <= num; state <= 15; end
			15 : if(num == SN) begin state <= 16; end
			16 : if(num != SN) begin display[19:16] <= SA; display[15:12] <= i_pw3; display[11:8] <= i_pw2; display[7:4] <= i_pw1; display[3:0] <= num; i_pw0 <= num; state <= 17; end			
			17 : if(num != SN) begin display[19:16] <= SA; display[15:12] <= i_pw3; display[11:8] <= i_pw2; display[7:4] <= i_pw1; display[3:0] <= i_pw0;
								if(num == SA) state <= 18; end
			18 : if((pw3 == i_pw3) && (pw2 == i_pw2) && (pw1 == i_pw1) && (pw0 == i_pw0)) state <= 19;
								else state <= 20;
			
			19 : if(num == SN) begin blink = 1; state <= 24; end
			24 : begin 
					cnt = cnt + 1;
					led_state = 1;
					if		  (cnt == 10240) LED = 8'b00000001;
					else if (cnt == 20480) LED = 8'b00000011;
					else if (cnt == 30720) LED = 8'b00000111;
					else if (cnt == 40960) LED = 8'b00001111;
					else if (cnt == 51200) LED = 8'b00011111;
					else if (cnt == 61440) LED = 8'b00111111;
					else if (cnt == 71680) LED = 8'b01111111;
					else if (cnt == 81920) LED = 8'b11111111;
					else if (cnt == 92160) LED = 8'b00000000;
					else if(cnt == 102400) begin state <= 8; led_state = 0; end
					end
			
			20 : if(num == SN) begin display[19:16] <= SN; display[15:12] <= SN; display[11:8] <= SN; display[7:4] <= SN; display[3:0] <= SN; state <= 9; end
			
			
		// Change password, assignment 2	
			30 : if(num == SN) begin state <= 31; display[3:0] <= SS; end
			31 : if(num != SS && num != SN) begin display[7:4] <= SS; c_pw3 <= num; display[3:0] <= num; state <= 32; end
				  else if(num == SS) state <= 42;
			42 : if(num == SN) begin state <= 8; end	  
			32 : if(num == SN) begin state <= 33; end
			33 : if(num != SN) begin display[11:8] <= SS; display[7:4] <= c_pw3; display[3:0] <= num; c_pw2 <= num; state <= 34;end
			34 : if(num == SN) begin state <= 35; end
			35 : if(num != SN) begin display[15:12] <= SS; display[11:8] <= c_pw3; display[7:4] <= c_pw2; display[3:0] <= num; c_pw1 <= num; state <= 36; end
			36 : if(num == SN) begin state <= 37; end
			37 : if(num != SN) begin display[19:16] <= SS; display[15:12] <= c_pw3; display[11:8] <= c_pw2; display[7:4] <= c_pw1; display[3:0] <= num; c_pw0 <= num; state <= 38; end			
			38 : if(num != SN) begin display[19:16] <= SS; display[15:12] <= c_pw3; display[11:8] <= c_pw2; display[7:4] <= c_pw1; display[3:0] <= c_pw0;
								if(num == SS) state <= 39; end
			39 : if((pw3 == c_pw3) && (pw2 == c_pw2) && (pw1 == c_pw1) && (pw0 == c_pw0)) state <= 40;
								else state <= 41;
			40 : if(num == SN) begin blink = 1; state <= 43; led_state = 1; end
			43 : begin cnt = cnt + 1; if(cnt == 51200) begin blink <= 0; display <= 0; state <= 0; led_state = 2; end end
			41 : if(num == SN) begin display[19:16] <= SN; display[15:12] <= SN; display[11:8] <= SN; display[7:4] <= SN; display[3:0] <= SN; state <= 30; end
			
		endcase
	end
	
	
// Set New password
// example2 : blinking 012345

/*
	always @(*)
	begin
		blink = 1;
		display[23:20] = SN;
		display[19:16] = SA;
		display[17:12] = SS;
		display[11:8] = S3;
		display[7:4] = S4;
		display[3:0] = S5;
	end
*/
	
endmodule
