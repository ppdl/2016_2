module SEVEN_SEGMENT_CONTROLLER(clk,display_state,display_on,i0,i1,i2,i3,i4,i5, seg_data,seg_pos);
	input clk;
	
	//display signal
	input [2:0]display_state;
	localparam PRINT_CLOSE=0,PRINT_OPEN=7,PRINT_NUM1=1,PRINT_NUM2=2,PRINT_NUM3=3,PRINT_NUM4=4,PRINT_NUM5=5,PRINT_NUM6=6;
	input display_on;
	input [3:0]i0,i1,i2,i3,i4,i5;
	
	output [7:0]seg_data;	//data
	output [5:0]seg_pos;		//position 		
	reg [7:0]seg_data;
	reg [5:0]seg_pos;
	
	reg [2:0] fnd_state;	//출력할 곳 지정
	reg [9:0] fnd_count;	//출력을 위한 클락을 만드는 카운터
	reg fnd_clock;			//출력을 위한 클락 
	
	reg [3:0]temp_num;	//출력할 숫자
	reg [7:0]temp_seg;	//출력할 숫자의 세그먼트 값 
	
	initial	begin
		fnd_state = 0;
		fnd_count = 0;
		fnd_clock = 0;
	end
	
	always @ (posedge clk)
	begin
		if(fnd_count == 1000)
			begin
				fnd_count = 0;
				fnd_clock = ~fnd_clock;
			end
		else
			begin
				fnd_count = fnd_count + 1;
			end
	end

	//숫자 표시될값 설정 
	always @(posedge clk)
	begin
		case(fnd_state)
			0: temp_num = i0; 
			1: temp_num = i1;
			2: temp_num = i2;
			3: temp_num = i3;
			4: temp_num = i4;
			5: temp_num = i5;
		endcase
	end
	//숫자 표시될 세그먼트 값 
	always @(posedge clk)
	begin
		case(temp_num)
			0: temp_seg = 8'b11111100;
			1: temp_seg = 8'b01100000;
			2: temp_seg = 8'b11011010;
			3: temp_seg = 8'b11110010;
			4: temp_seg = 8'b01100110;
			5: temp_seg = 8'b10110110;
			6: temp_seg = 8'b10111110;
			7: temp_seg = 8'b11100000;
			8: temp_seg = 8'b11111110;
			9: temp_seg = 8'b11110110;		
		endcase
	end
	
	//7-segment에 표시
	always @ (posedge fnd_clock)
	begin
	if(display_on) begin
		case(display_state)
	//--------------close----------------------------------------------------
		PRINT_CLOSE:
		begin
			if (fnd_state == 0)
			begin
				seg_pos = 6'b011111;
				seg_data = 8'b10011100;
				fnd_state = 1;
			end
			else if	(fnd_state == 1)
			begin
				seg_pos = 6'b101111;
				seg_data = 8'b00011100;
				fnd_state = 2;
			end
			else if	(fnd_state == 2)
			begin
				seg_pos = 6'b110111;
				seg_data = 8'b11111100;
				fnd_state = 3;
			end
			else if	(fnd_state == 3)
			begin
				seg_pos = 6'b111011;
				seg_data = 8'b10110110;
				fnd_state = 4;
			end
			else if	(fnd_state == 4)
			begin
				seg_pos = 6'b111101;
				seg_data = 8'b10011110;
				fnd_state = 5;
			end
			else if	(fnd_state == 5)
			begin
				seg_pos = 6'b111110;
				seg_data = 8'b00000000;
				fnd_state = 0;
			end
		end
	//--------------open----------------------------------------------------
		PRINT_OPEN:
		begin
			if (fnd_state == 0)
			begin
				seg_pos = 6'b011111;
				seg_data = 8'b11111100;
				fnd_state = 1;
			end
			else if	(fnd_state == 1)
			begin
				seg_pos = 6'b101111;
				seg_data = 8'b11001110;
				fnd_state = 2;
			end
			else if	(fnd_state == 2)
			begin
				seg_pos = 6'b110111;
				seg_data = 8'b10011110;
				fnd_state = 3;
			end
			else if	(fnd_state == 3)
			begin
				seg_pos = 6'b111011;
				seg_data = 8'b11101100;
				fnd_state = 4;
			end
			else if	(fnd_state == 4)
			begin
				seg_pos = 6'b111101;
				seg_data = 8'b00000000;
				fnd_state = 5;
			end
			else if	(fnd_state == 5)
			begin
				seg_pos = 6'b111110;
				seg_data = 8'b00000000;
				fnd_state = 0;
			end
		end
	//--------------number 1----------------------------------------------------
		PRINT_NUM1:
		begin
			if (fnd_state == 0)
			begin
				seg_pos = 6'b011111;
				seg_data = temp_seg;
				fnd_state = 1;
			end
			else if	(fnd_state == 1)
			begin
				seg_pos = 6'b101111;
				seg_data = 8'b00000000;
				fnd_state = 2;
			end
			else if	(fnd_state == 2)
			begin
				seg_pos = 6'b110111;
				seg_data = 8'b00000000;
				fnd_state = 3;
			end
			else if	(fnd_state == 3)
			begin
				seg_pos = 6'b111011;
				seg_data = 8'b00000000;
				fnd_state = 4;
			end
			else if	(fnd_state == 4)
			begin
				seg_pos = 6'b111101;
				seg_data = 8'b00000000;
				fnd_state = 5;
			end
			else if	(fnd_state == 5)
			begin
				seg_pos = 6'b111110;
				seg_data = 8'b00000000;
				fnd_state = 0;
			end
		end
	//--------------number 2----------------------------------------------------
		PRINT_NUM2:
		begin
			if (fnd_state == 0)
			begin
				seg_pos = 6'b011111;
				seg_data = temp_seg;
				fnd_state = 1;
			end
			else if	(fnd_state == 1)
			begin
				seg_pos = 6'b101111;
				seg_data = temp_seg;
				fnd_state = 2;
			end
			else if	(fnd_state == 2)
			begin
				seg_pos = 6'b110111;
				seg_data = 8'b00000000;
				fnd_state = 3;
			end
			else if	(fnd_state == 3)
			begin
				seg_pos = 6'b111011;
				seg_data = 8'b00000000;
				fnd_state = 4;
			end
			else if	(fnd_state == 4)
			begin
				seg_pos = 6'b111101;
				seg_data = 8'b00000000;
				fnd_state = 5;
			end
			else if	(fnd_state == 5)
			begin
				seg_pos = 6'b111110;
				seg_data = 8'b00000000;
				fnd_state = 0;
			end
		end
	//--------------number 3----------------------------------------------------
		PRINT_NUM3:
		begin
			if (fnd_state == 0)
			begin
				seg_pos = 6'b011111;
				seg_data = temp_seg;
				fnd_state = 1;
			end
			else if	(fnd_state == 1)
			begin
				seg_pos = 6'b101111;
				seg_data = temp_seg;
				fnd_state = 2;
			end
			else if	(fnd_state == 2)
			begin
				seg_pos = 6'b110111;
				seg_data = temp_seg;
				fnd_state = 3;
			end
			else if	(fnd_state == 3)
			begin
				seg_pos = 6'b111011;
				seg_data = 8'b00000000;
				fnd_state = 4;
			end
			else if	(fnd_state == 4)
			begin
				seg_pos = 6'b111101;
				seg_data = 8'b00000000;
				fnd_state = 5;
			end
			else if	(fnd_state == 5)
			begin
				seg_pos = 6'b111110;
				seg_data = 8'b00000000;
				fnd_state = 0;
			end
		end
	//--------------number 4----------------------------------------------------
		PRINT_NUM4:
		begin
			if (fnd_state == 0)
			begin
				seg_pos = 6'b011111;
				seg_data = temp_seg;
				fnd_state = 1;
			end
			else if	(fnd_state == 1)
			begin
				seg_pos = 6'b101111;
				seg_data = temp_seg;
				fnd_state = 2;
			end
			else if	(fnd_state == 2)
			begin
				seg_pos = 6'b110111;
				seg_data = temp_seg;
				fnd_state = 3;
			end
			else if	(fnd_state == 3)
			begin
				seg_pos = 6'b111011;
				seg_data = temp_seg;
				fnd_state = 4;
			end
			else if	(fnd_state == 4)
			begin
				seg_pos = 6'b111101;
				seg_data = 8'b00000000;
				fnd_state = 5;
			end
			else if	(fnd_state == 5)
			begin
				seg_pos = 6'b111110;
				seg_data = 8'b00000000;
				fnd_state = 0;
			end
		end
	//--------------number 5----------------------------------------------------
		PRINT_NUM5:
		begin
			if (fnd_state == 0)
			begin
				seg_pos = 6'b011111;
				seg_data = temp_seg;
				fnd_state = 1;
			end
			else if	(fnd_state == 1)
			begin
				seg_pos = 6'b101111;
				seg_data = temp_seg;
				fnd_state = 2;
			end
			else if	(fnd_state == 2)
			begin
				seg_pos = 6'b110111;
				seg_data = temp_seg;
				fnd_state = 3;
			end
			else if	(fnd_state == 3)
			begin
				seg_pos = 6'b111011;
				seg_data = temp_seg;
				fnd_state = 4;
			end
			else if	(fnd_state == 4)
			begin
				seg_pos = 6'b111101;
				seg_data = temp_seg;
				fnd_state = 5;
			end
			else if	(fnd_state == 5)
			begin
				seg_pos = 6'b111110;
				seg_data = 8'b00000000;
				fnd_state = 0;
			end
		end
	//--------------number 6----------------------------------------------------
		PRINT_NUM6:
		begin
			if (fnd_state == 0)
			begin
				seg_pos = 6'b011111;
				seg_data = temp_seg;
				fnd_state = 1;
			end
			else if	(fnd_state == 1)
			begin
				seg_pos = 6'b101111;
				seg_data = temp_seg;
				fnd_state = 2;
			end
			else if	(fnd_state == 2)
			begin
				seg_pos = 6'b110111;
				seg_data = temp_seg;
				fnd_state = 3;
			end
			else if	(fnd_state == 3)
			begin
				seg_pos = 6'b111011;
				seg_data = temp_seg;
				fnd_state = 4;
			end
			else if	(fnd_state == 4)
			begin
				seg_pos = 6'b111101;
				seg_data = temp_seg;
				fnd_state = 5;
			end
			else if	(fnd_state == 5)
			begin
				seg_pos = 6'b111110;
				seg_data = temp_seg;
				fnd_state = 0;
			end
		end
		endcase
	end
	else
		seg_data = 0;
	end	
endmodule
