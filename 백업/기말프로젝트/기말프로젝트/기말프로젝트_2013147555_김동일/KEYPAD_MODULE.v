module KEYPAD_MODULE(key_col,key_row,clk, key_value,key_number,key_star,key_sharp,buzz_key);
	input clk;
	input [3:0]key_row;
	output [3:0]key_col;
	reg [3:0]key_col;
	
	output buzz_key;
	reg buzz_key;
	
	localparam SHARP = 11, STAR = 12, UNUSED = 15;
	output [3:0]key_value; 
	output key_number,key_star,key_sharp;
	reg [3:0]key_value;
	reg key_number,key_star,key_sharp;	//무슨키가 눌렷는지 신호
	
	reg [1:0]matrix_state;
	
	reg [15:0] count_3k; //3200clock을 카운트  
	reg clock_5khz; //약 5000hz인 클락
	
	//키가 눌렷는지 확인
	reg key_on,key_press;
	reg time_key,reset_time_key;
	reg [3:0] count_time_key;
	
	reg m_sec;
	reg [31:0]count_m_sec;
	reg reset_m_sec;
	
	initial
	begin
		key_number=0; key_star=0; key_sharp=0;
		key_col = 4'b0001;
		key_value = 0;
		matrix_state = 0;
		count_3k = 0; clock_5khz = 0;
		key_on=0; key_press=0; time_key=1; reset_time_key=0;
		count_time_key=0;
		buzz_key = 0;
		m_sec = 1;
	end
	
	always @(posedge clk)
	begin	
		if(reset_m_sec)
		begin
			count_m_sec = 0;
			m_sec = 0;
		end
		else if(m_sec == 0)
		begin
			if(count_m_sec == 32750000/100)
			begin
				count_m_sec = 0;
				m_sec = 1;
			end
			else
				count_m_sec = count_m_sec+1;
		end
	end
	
	always @(posedge clk)
	begin
		if(reset_time_key)
		begin
			time_key=0;
			count_time_key=0;
		end
		else if(count_time_key == 10)
		begin
			time_key = 1;
			count_time_key = 0;
		end
		
		if(count_3k == 3200)
		begin
			clock_5khz = ~clock_5khz;
			count_time_key = count_time_key + 1;
		end
		else
			count_3k = count_3k+1;
	end
	
	always @(negedge clock_5khz)
	begin
		if(matrix_state == 0)		key_col = 4'b1000;
		else if(matrix_state == 1)	key_col = 4'b0100;
		else if(matrix_state == 2) key_col = 4'b0010;	
		else if(matrix_state == 3) key_col = 4'b0001;
		
		if(key_row == 4'b1000)
		begin
			key_press = 1;
			if(matrix_state == 0) 	 	key_value = STAR;
			else if(matrix_state == 1) key_value = UNUSED;
			else if(matrix_state == 2)	key_value = SHARP;
			else if(matrix_state == 3) key_value = 0;
		end
		else if(key_row == 4'b0100)
		begin
			key_press = 1;
			if(matrix_state == 0) 	 	key_value = 7;
			else if(matrix_state == 1) key_value = UNUSED;
			else if(matrix_state == 2)	key_value = 9;
			else if(matrix_state == 3) key_value = 8;
		end
		else if(key_row == 4'b0010)
		begin
			key_press = 1;
			if(matrix_state == 0) 	 	key_value = 4;
			else if(matrix_state == 1) key_value = UNUSED;
			else if(matrix_state == 2)	key_value = 6;
			else if(matrix_state == 3) key_value = 5;
		end
		else if(key_row == 4'b0001)
		begin
			key_press = 1;
			if(matrix_state == 0) 	 	key_value = 1;
			else if(matrix_state == 1) key_value = UNUSED;
			else if(matrix_state == 2)	key_value = 3;
			else if(matrix_state == 3) key_value = 2;
		end
		else
			key_press = 0;
		
	if	(matrix_state == 0) matrix_state = 1;
	else if(matrix_state == 1) matrix_state = 2;
	else if(matrix_state == 2) matrix_state = 3;
	else if(matrix_state == 3) matrix_state = 0;
	
	if(key_press)
	begin
		key_on = 1;
		reset_time_key = 1;
	end
	else
	begin
		reset_time_key = 0;
		if(time_key)
			key_on = 0;
	end
	
	if(m_sec)
	begin
		reset_m_sec = 1;
		if(key_on)
		begin
			buzz_key = 1;
			if(key_value == SHARP)
				key_sharp = 1;
			else if(key_value == STAR)
				key_star = 1;
			else
				key_number = 1;
		end
		else
		begin
			buzz_key = 0;
			key_sharp=0;
			key_star=0;
			key_number=0;
		end
	end
	else
		reset_m_sec = 0;
		
	end	
endmodule
