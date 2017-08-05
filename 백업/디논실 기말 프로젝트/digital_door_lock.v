module digital_door_lock(clk, key_row, key_col, fnd_pos, fnd_data);

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

	timer							TTMER (clk, slow_clk);
	seven_segment_display	SEVEN_SEG (slow_clk, display, blink, fnd_pos, fnd_data);
	key_matrix					KEY (slow_clk, num, key_row, key_col);

	
	
// you may add your own codes and variables here
	//Current_State선언과 그에 관련된 parameter
	reg [2:0] 			Current_State;	
	parameter 			reset_State = 0, try_State = 1, initial_State = 2, pre_reset_State = 3 ,pre_initial_State = 4, pre_try_State = 5;
	
	//reset_State선언과 그에 관련된 parameter
	reg [3:0]			R_STATE;
	parameter			RS0 = 1,RS1 = 2, RS2 = 3, RS3 = 4, RS4 = 5;
	parameter			pre_RS0 = 6, pre_RS2 = 7, pre_RS3 = 8, pre_RS4 = 9, R_Confirm = 10;
	
	
	//try_State선언과 그에 관련된 parameter
	reg [3:0]			T_STATE;	
	reg [3:0]			sel;
	reg					correct = 1;
	parameter			TS0 = 0, TS1 = 1, TS2 = 2, TS3 = 3, TS4 = 4, CORRECT = 5, INCORRECT = 6;
	parameter			pre_TS0 = 7, pre_TS2 = 8, pre_TS3 = 9, pre_TS4 = 10, check = 11;	
	parameter			blink_State = 12;
	
	//input을 저장하는 변수
	reg [3:0]			 digit0, digit1, digit2, digit3;
	
	//blink 시간초
	reg [31:0] cnt = 0;
	
	
	//비밀번호 4자리
	reg [3:0]			C3;
	reg [3:0]			C2;
	reg [3:0]			C1;
	reg [3:0]			C0;
	
	
	//초기화
	initial begin
		Current_State = reset_State;
		R_STATE = RS0;
	end

	//MATN STATE TRANSTTTON
	//Current_State와 Tnput에 의해 Next state를 결정함
	always @ (posedge slow_clk) begin
		//리셋상태일 경우 비밀번호 입력
		case(Current_State)
			pre_reset_State: if(num == SN) Current_State = reset_State;
			reset_State:
					case(R_STATE)
						pre_RS0: if(num == SN) R_STATE = RS0;
						RS0:begin
								display[23:20] = SN;
								display[19:16] = SN;
								display[15:12] = SN;
								display[11:8]  = SN;
								display[7:4]	= SN;
								display[3:0]	= SS;
								if(num != SN) R_STATE <= RS1;
							end
						RS1:begin
								if(num != SN) C3 = num;
								else if(num == SN) begin
									display[23:20] = SN;
									display[19:16] = SN;
									display[15:12] = SN;
									display[11:8]  = SN;
									display[7:4]	= SS;
									display[3:0]	= C3;
									R_STATE <= pre_RS2;
								end
							end
						pre_RS2:
								if(num != SN) begin C2 = num; R_STATE <= RS2; end
						RS2:begin
								if(num == SN) begin
									display[23:20] = SN;
									display[19:16] = SN;
									display[15:12] = SN;
									display[11:8]  = SS;
									display[7:4]	= C3;
									display[3:0]	= C2;
									R_STATE <= pre_RS3;
								end
							end
						pre_RS3:
								if(num != SN) begin C1 = num; R_STATE <= RS3; end
						RS3:begin
								if(num == SN) begin
									display[23:20] = SN;
									display[19:16] = SN;
									display[15:12] = SS;
									display[11:8]  = C3;
									display[7:4]	= C2;
									display[3:0]	= C1;
									R_STATE <= pre_RS4;
								end
							end
						pre_RS4:
								if(num != SN) begin C0 = num; R_STATE <= RS4; end								
						RS4:begin
								if(num == SN) begin
									display[23:20] = SN;
									display[19:16] = SS;
									display[15:12] = C3;
									display[11:8]  = C2;
									display[7:4]	= C1;
									display[3:0]	= C0;
									R_STATE <= R_Confirm;
								end
							end
						R_Confirm:begin
								if(num == SS) begin
									R_STATE <= pre_RS0;
									Current_State <= pre_initial_State;
								end
							end
					endcase
					
			pre_initial_State:
				if(num == SN) Current_State <= initial_State;
			
			initial_State:begin
				display[23:20] = SN;
				display[19:16] = SN;
				display[15:12] = SN;
				display[11:8]  = SN;
				display[7:4]	= SN;
				display[3:0]	= SN;
				if(num == SA) begin				
					sel = SA;
					Current_State <= try_State;
					T_STATE <= pre_TS0;
				end
				if(num == SS) begin 				
					sel = SS;
					Current_State <= try_State; 
					T_STATE <= pre_TS0;
				end
			end
			
			pre_try_State:
				if(num == SN) Current_State <= try_State;
				
			try_State:
				case(T_STATE)
					pre_TS0:begin
						display[23:20] = SN;
						display[19:16] = SN;
						display[15:12] = SN;
						display[11:8]  = SN;
						display[7:4]	= SN;
						display[3:0]	= SN;
						if(num == SN) T_STATE <= TS0;
					end
					TS0:begin
						display[23:20] = SN;
						display[19:16] = SN;
						display[15:12] = SN;
						display[11:8]  = SN;
						display[7:4]	= SN;
						display[3:0]	= sel;
						if(num != SN) T_STATE <= TS1;
					end
					TS1:begin
							if(sel == SA && num == SA) Current_State <= pre_initial_State;
							if(num != SN) begin
								digit3 = num;
							end
							if(num == SN) begin
									display[23:20] = SN;
									display[19:16] = SN;
									display[15:12] = SN;
									display[11:8]  = SN;
									display[7:4]	= sel;
									display[3:0]	= digit3;
									if(digit3 != C3) correct = 0;
									T_STATE <= pre_TS2;
								end
						end
					pre_TS2: if(num != SN) T_STATE = TS2;
					TS2:begin
							if(num != SN) begin
								digit2 = num;
							end
							if(num == SN) begin
								display[23:20] = SN;
								display[19:16] = SN;
								display[15:12] = SN;
								display[11:8]  = sel;
								display[7:4]	= digit3;
								display[3:0]	= digit2;
								if(digit2 != C2) correct = 0;
								T_STATE <= pre_TS3;								
							end
						end
					pre_TS3: if(num != SN) T_STATE = TS3;
					TS3:begin
							if(num != SN) begin
								digit1 = num;
							end
							if(num == SN) begin
								display[23:20] = SN;
								display[19:16] = SN;
								display[15:12] = sel;
								display[11:8]  = digit3;
								display[7:4]	= digit2;
								display[3:0]	= digit1;
								if(digit1 != C1) correct = 0;
								T_STATE <= pre_TS4;
							end
						end
					pre_TS4: if(num!= SN) T_STATE <= TS4;
					TS4:begin
							if(num != SN) begin
								digit0 = num;
							end
							if(num == SN) begin
								display[23:20] = SN;
								display[19:16] = sel;
								display[15:12] = digit3;
								display[11:8]  = digit2;
								display[7:4]	= digit1;
								display[3:0]	= digit0;
								if(digit0 != C0) correct = 0;
								T_STATE <= check;							
							end
						end
					check:begin
							if(correct == 0) T_STATE <= INCORRECT;
							else				  T_STATE <= CORRECT;
						end
					CORRECT:begin
							if(num == SA || num == SS) begin
								display[23:20] = SN;
								display[19:16] = sel;
								display[15:12] = digit3;
								display[11:8]  = digit2;
								display[7:4]	= digit1;
								display[3:0]	= digit0;
								T_STATE <= blink_State;				
							end
						end
					blink_State:begin
							cnt = cnt + 1;
							if(cnt >= 0 && cnt < 409600) begin							
								display[23:20] = SN;
								display[19:16] = SN;
								display[15:12] = SN;
								display[11:8]  = SN;
								display[7:4]	= SN;
								display[3:0]	= SN;
							end
							else if(cnt >= 409600 && cnt < 819200) begin
								display[23:20] = SN;
								display[19:16] = sel;
								display[15:12] = digit3;
								display[11:8]  = digit2;
								display[7:4]	= digit1;
								display[3:0]	= digit0;
							end
							else if(cnt >= 819200 && cnt < 1228800) begin
								display[23:20] = SN;
								display[19:16] = SN;
								display[15:12] = SN;
								display[11:8]  = SN;
								display[7:4]	= SN;
								display[3:0]	= SN;
							end
							else begin		
								cnt = 0;		
								T_STATE <= pre_TS0;	
								if(sel == SA) Current_State <= pre_initial_State;
								else if(sel == SS) Current_State <= reset_State;
							end
						end
					INCORRECT:begin
							if(num == SA || num == SS) begin	
								T_STATE <= pre_TS0;
								correct = 1;
							end
						end
				endcase
		endcase
	end
	
/*
// example1 : keymatrix example
	always @(*)
	begin
		if(num != SN) display[3:0] = num;
	end

// example2 : blinking 012345
***********
	always @(*)
	begin
		blink = 1;
		display[23:20] = S0;
		display[19:16] = S1;
		display[15:12] = S2;
		display[11:8] = S3;
		display[7:4] = S4;
		display[3:0] = S5;
	end
*/
endmodule


