module MAIN_FSM(reset,door,clk, key_value,key_number,key_star,key_sharp, led_end,led_on,buzzer_state,display_state,display_on,i0,i1,i2,i3,i4,i5);
	input reset,door,clk;
	
	//key value 
	input [3:0]key_value;
	input key_number, key_star, key_sharp;
	
	//led control signal
	input led_end;
	output led_on;
	reg led_on;
	
	//buzzer control signal
	output [2:0]buzzer_state;
	reg [2:0]buzzer_state;
	localparam BUZZ_NULL=0,BUZZ_ERR=1,BUZZ_OPEN=2,BUZZ_ONE_MINUTE_LOCK=3,BUZZ_PIPOPIPO=4;
	
	//7-segment control signal 
	output [2:0]display_state;
	reg [2:0]display_state;
	localparam PRINT_CLOSE=0,PRINT_OPEN=7,PRINT_NUM1=1,PRINT_NUM2=2,PRINT_NUM3=3,PRINT_NUM4=4,PRINT_NUM5=5,PRINT_NUM6=6;
	output display_on;
	reg display_on;
	output [3:0]i0,i1,i2,i3,i4,i5;
	reg [3:0]i0,i1,i2,i3,i4,i5;
	
	//main state 
	reg [3:0]main_state;
	localparam SET_READ=0,SET_CHECK=1,FAIL=2,PIPO=3,CLOSE=4,PRE_SET=5,PASSWORD_CHECK=6,LOCK=7,ONE_MINUTE_LOCK=8,OPEN=9;
	reg bad_pw,equal,change,pipo_on,lock_on,new;
	
	//regster to save password, password length & indexes
	reg [2:0]index,index2;
	reg [2:0]length;
	reg [3:0]n0,n1,n2,n3,n4,n5;
	reg [3:0]c0,c1,c2,c3,c4,c5;
	reg [3:0]p0,p1,p2,p3,p4,p5;
	
	//inner state of SET_READ
	reg [4:0]set_read_state;
	localparam SRS_IDLE0=0,SRS_IDLE1=1,SRS_IDLE2=2,SRS_IDLE3=3,SRS_I0=4,SRS_WAIT0=5,SRS_I1=6,SRS_WAIT1=7,SRS_I2=8,SRS_WAIT2=9,SRS_I3=10,SRS_WAIT3=11,SRS_I4=12,SRS_WAIT4=13,SRS_I5=14,SRS_WAIT5=15,SRS_I6=16,SRS_OVER_FLOW=17,SRS_FINISH=24;
	
	//inner state of SET_CHECK
	reg [3:0]set_check_state;
	localparam SCS_IDLE0=0,SCS_IDLE1=1,SCS_IDLE2=2,SCS_IDLE3=3,SCS_PRE=4,SCS_DIV=5,SCS_INDEX3=6,SCS_INDEX4=7,SCS_INDEX5=8,SCS_INDEX6=9,SCS_INDEX7=10,SCS_OK=11,SCS_ERR=12;
	reg [3:0]temp_number;
	
	//inner state of PASSWORD_CHECK
	reg [4:0]password_check_state;
	localparam PCS_IDLE0=0,PCS_IDLE1=1,PCS_IDLE2=2,PCS_IDLE3=3,PCS_I0=4,PCS_WAIT0=5,PCS_I1=6,PCS_WAIT1=7,PCS_I2=8,PCS_WAIT2=9,PCS_I3=10,PCS_WAIT3=11,PCS_I4=12,PCS_WAIT4=13,PCS_I5=14,PCS_WAIT5=15,PCS_I6=16,PCS_PRE3=17,PCS_PRE4=18,PCS_PRE5=19,PCS_PRE6=20,PCS_ERR=22,PCS_OK=23;
	
	//inner state of OPEN
	reg [2:0]open_state;
	localparam OS_IDLE0=0,OS_IDLE1=1,OS_IDLE2=2,OS_IDLE3=3,OS_DOOR_WAIT=4,OS_TIME_WAIL=5,OS_CLOSE=6;
	wire time_to_close;
	reg reset_time_to_close;
	
	//inner state of FAIL
	reg [2:0]fail_state;
	localparam FS_IDLE0=0,FS_IDLE1=1,FS_IDLE2=2,FS_IDLE3=3,FS_TIME_CHECK=4,FS_NUMBER_CHECK=5,FS_RETURN=6,FS_PIPO=7;
	wire time_for_fail;
	reg reset_time_for_fail;
	reg [2:0]number_of_fail;
	
	//inner state of PIPO
	reg [2:0]pipo_state;
	localparam PS_IDLE0=0,PS_IDLE1=1,PS_IDLE2=2,PS_IDLE3=3,PS_ON=4,PS_OFF=5;
	
	//inner state of LOCK
	reg [2:0]lock_state;
	localparam LS_IDLE0=0,LS_IDLE1=1,LS_IDLE2=2,LS_IDLE3=3,LS_TIME_CHECK=4,LS_NUMBER_CHECK=5,LS_RETURN=6,LS_ONE_MINUTE_LOCK=7;
	reg time_for_lock,reset_time_for_lock;
	reg [2:0]number_of_lock;
	
	//inner state of ONE_MINUTE_LOCK
	reg [2:0]one_minute_lock_state;
	localparam OMLS_IDLE0=0,OMLS_IDLE1=1,OMLS_IDLE2=2,OMLS_IDLE3=3,OMLS_LOCK=4,OMLS_OFF=5;
	wire time_one_minute;
	reg reset_time_one_minute;
	
	//inner state of CLOse_state
	reg [1:0]close_state;
	localparam CS_WAIT1=0,CS_WAIT2=1,CS_OK=2;
	
	//end signal of inner state & reset,set signal//
	reg read_end, reset_read_end, set_read_end;
	reg check_end, reset_check_end, set_check_end;
	reg fail_end, reset_fail_end, set_fail_end;
	reg pipo_end, reset_pipo_end, set_pipo_end;
	reg pass_end, reset_pass_end, set_pass_end;
	reg lock_end, reset_lock_end, set_lock_end;
	reg one_minute_end, reset_one_minute_end, set_one_minute_end;
	reg open_end, reset_open_end, set_open_end;
	
	//conter
	COUNTER_FOR_TIME_TO_CLOSE cfttc(clk,reset_time_to_close,time_to_close);
	COUNTER_FOR_TIME_FOR_FAIL cftff(clk,reset_time_for_fail,time_for_fail);
	COUNTER_FOR_TIME_ONE_MINUTE cftom(clk,reset_time_one_minute,time_one_minute);
	
	
	initial begin
		main_state = SET_READ;
		set_read_state = SRS_IDLE0;
		set_check_state = SCS_IDLE0;
		password_check_state = PCS_IDLE0;
		open_state = OS_IDLE0;
		lock_state = LS_IDLE0;
		one_minute_lock_state = OMLS_IDLE0;
		fail_state = FS_IDLE0;
		pipo_state = PS_IDLE0;
		new = 1;	
		number_of_fail = 0;
		number_of_lock = 0;
		reset_time_for_fail = 1;
		reset_time_for_lock = 1;
		reset_time_one_minute = 1;
		led_on = 0;
		close_state=CS_WAIT1;
		
		reset_read_end=0; set_read_end=0; read_end=0;
		check_end=0; reset_check_end=0; set_check_end=0;
		fail_end=0; reset_fail_end=0; set_fail_end=0;
		pipo_end=0; reset_pipo_end=0; set_pipo_end=0;
		pass_end=0; reset_pass_end=0; set_pass_end=0;
		lock_end=0; reset_lock_end=0; set_lock_end=0;
		one_minute_end=0; reset_one_minute_end=0; set_one_minute_end=0;
		open_end=0; reset_open_end=0; set_open_end=0;
	end

	// set&reset of end signal 
	always @(posedge clk)
	begin
		if(reset_read_end)
			read_end = 0;
		else if(set_read_end)
			read_end = 1;
		
		if(reset_check_end)
			check_end = 0;
		else if(set_check_end)
			check_end = 1;
			
		if(reset_fail_end)
			fail_end = 0;
		else if(set_fail_end)
			fail_end = 1;
			
		if(reset_pipo_end)
			pipo_end = 0;
		else if(set_pipo_end)
			pipo_end = 1;
		
		if(reset_pass_end)
			pass_end = 0;
		else if(set_pass_end)
			pass_end = 1;
			
		if(reset_lock_end)
			lock_end = 0;
		else if(set_lock_end)
			lock_end = 1;
			
		if(reset_one_minute_end)
			one_minute_end = 0;
		else if(set_one_minute_end)
			one_minute_end = 1;
			
		if(reset_open_end)
			open_end = 0;
		else if(set_open_end)
			open_end = 1;
	end
	
	
	//ONE_MINUTE_LOCK state 
	always @(posedge clk)
	begin
	if(reset)
	begin
		reset_time_one_minute = 1;
		set_one_minute_end = 0;
		one_minute_lock_state = OMLS_IDLE0;
	end
	if(main_state == ONE_MINUTE_LOCK)
	begin
		case(one_minute_lock_state)
			OMLS_IDLE0: begin
				reset_time_one_minute = 1;
				set_one_minute_end = 0;
				one_minute_lock_state = OMLS_IDLE1;
			end
			OMLS_IDLE1: one_minute_lock_state = OMLS_IDLE2;
			OMLS_IDLE2: one_minute_lock_state = OMLS_IDLE3;
			OMLS_IDLE3: one_minute_lock_state = OMLS_LOCK;
			OMLS_LOCK: begin
				reset_time_one_minute = 0;
				if(time_one_minute)
					one_minute_lock_state = OMLS_OFF;
			end
			OMLS_OFF: begin
				set_one_minute_end = 1;
				one_minute_lock_state = OMLS_IDLE0;
			end	
		endcase
	end	
	end
	
	//LOCK state
	always @(posedge clk)
	begin
	if(reset) 
	begin
		lock_state = LS_IDLE0;
		reset_time_for_lock = 1;
		number_of_lock = 0;
		set_lock_end = 0;
	end
	if(main_state == LOCK)
	begin
		case(lock_state)
			LS_IDLE0: begin
				set_lock_end = 0;
				reset_time_for_lock = 0;
				lock_state = LS_IDLE1;
			end
			LS_IDLE1: lock_state = LS_IDLE2;
			LS_IDLE2: lock_state = LS_IDLE3;
			LS_IDLE3: lock_state = LS_TIME_CHECK;
			LS_TIME_CHECK: begin
				if(time_for_lock)
				begin
					lock_state = LS_RETURN;
					number_of_lock = 1;
				end
				if(~time_for_lock)
				begin
					lock_state = LS_NUMBER_CHECK;
					number_of_lock = number_of_lock + 1;
				end
			end
			LS_NUMBER_CHECK: begin
				if(number_of_lock>=3)
					lock_state = LS_ONE_MINUTE_LOCK;
				else 
					lock_state = LS_RETURN;
			end
			LS_RETURN: begin
				reset_time_for_lock = 1;
				lock_on = 0;
				set_lock_end = 1;
				lock_state = LS_IDLE0;
			end
			LS_ONE_MINUTE_LOCK: begin
				reset_time_for_lock = 1;
				lock_on = 1;
				set_lock_end = 1;
				lock_state = LS_IDLE0;
			end
		endcase
	end
	end
	
	//PIPO state 
	always @(posedge clk)
	begin
	if(reset)
	begin
		set_pipo_end = 0;
		pipo_state = PS_IDLE0;
		led_on = 0;
	end
	if(main_state == PIPO)
	begin
		case(pipo_state)
			PS_IDLE0: begin
				set_pipo_end = 0;
				pipo_state = PS_IDLE1;
			end
			PS_IDLE1: pipo_state = PS_IDLE2;
			PS_IDLE2: pipo_state = PS_IDLE3;
			PS_IDLE3: pipo_state = PS_ON;
			PS_ON: begin
				led_on = 1;
				if(led_end)
					pipo_state = PS_OFF;
			end
			PS_OFF: begin
				led_on = 0;
				set_pipo_end = 1;
			end
		endcase
	end
	end

	//FAIL state
	always @(posedge clk)
	begin
	if(reset)
	begin
		fail_state = FS_IDLE0;
		reset_time_for_fail = 1;
		number_of_fail = 0;
		set_fail_end = 0;
	end
	if(main_state == FAIL)
	begin
		case(fail_state)
			FS_IDLE0: begin
				set_fail_end = 0;
				fail_state = FS_IDLE1;
			end
			FS_IDLE1: fail_state = FS_IDLE2;
			FS_IDLE2: fail_state = FS_IDLE3;
			FS_IDLE3: fail_state = FS_TIME_CHECK;
			FS_TIME_CHECK: begin
				if(time_for_fail)
				begin
					fail_state = FS_RETURN;
					reset_time_for_fail = 1;
					number_of_fail = 1;
				end
				if(~time_for_fail)
				begin
					number_of_fail = number_of_fail + 1;
					fail_state = FS_NUMBER_CHECK;
				end
			end
			FS_NUMBER_CHECK: begin
				if(number_of_fail >= 3)
					fail_state = FS_PIPO;
				else
					fail_state = FS_RETURN;
			end
			FS_RETURN: begin
				reset_time_for_fail = 0;
				pipo_on = 0;
				set_fail_end = 1;
				fail_state = FS_IDLE0;
			end
			FS_PIPO: begin
				pipo_on = 1;
				set_fail_end = 1;
				fail_state = FS_IDLE0;
			end			
		endcase
	end
	end
	
	//OPEN state
	always @(posedge clk)
	begin
	if(reset)
	begin
		open_state = OS_IDLE0;
		set_open_end = 0;		
		reset_time_to_close = 1;
	end
	if(main_state == OPEN)
	begin
		case(open_state)
			OS_IDLE0: begin
				reset_time_to_close = 1;
				set_open_end = 0;
				open_state = OS_IDLE1;
			end
			OS_IDLE1: open_state = OS_IDLE2;
			OS_IDLE2: open_state = OS_IDLE3;
			OS_IDLE3: open_state = OS_DOOR_WAIT;
			OS_DOOR_WAIT: begin
				reset_time_to_close = 1;
				if(~door)
					open_state = OS_TIME_WAIL;
			end
			OS_TIME_WAIL: begin
				reset_time_to_close = 0;
				if(door&~time_to_close)
					open_state = OS_DOOR_WAIT;
				if(time_to_close)
					open_state = OS_CLOSE;
			end
			OS_CLOSE: begin
				set_open_end = 1;
				open_state = OS_IDLE0;
			end
		endcase
	end
	end
	
	//PASSWORD_CHECK state 
	always @(posedge clk)
	begin
	if(reset) begin
		password_check_state = PCS_IDLE0;
		set_pass_end = 0;
	end
	if(main_state == PASSWORD_CHECK)
	begin
		case(password_check_state)
			PCS_IDLE0: begin
				set_pass_end = 0;
				password_check_state = PCS_IDLE1;
				index2 = 0;
			end
			PCS_IDLE1: password_check_state = PCS_IDLE2;
			PCS_IDLE2: password_check_state = PCS_IDLE3;
			PCS_IDLE3: password_check_state = PCS_I0;
			PCS_I0: begin
				if(key_number)
				begin
					p0<=key_value;
					password_check_state = PCS_WAIT0;
					index2 = 1;
				end
			end
			PCS_WAIT0: if(~key_number)
				password_check_state = PCS_I1;
			PCS_I1: begin
				if(key_number)
				begin
					p1<=key_value;
					password_check_state = PCS_WAIT1;
					index2 = 2;
				end
				if(key_star)
					password_check_state = PCS_ERR;				
			end
			PCS_WAIT1: if(~key_number)
				password_check_state = PCS_I2;
			PCS_I2: begin
				if(key_number)
				begin
					p2<=key_value;
					password_check_state = PCS_WAIT2;
					index2 = 3;
				end
				if(key_star)
					password_check_state = PCS_ERR;
			end
			PCS_WAIT2: if(~key_number)
				password_check_state = PCS_I3;
			PCS_I3: begin
				if(key_number)
				begin
					p3<=key_value;
					password_check_state = PCS_WAIT3;
					index2 = 4;
				end
				if(key_star)
					password_check_state = PCS_PRE3;
			end
			PCS_WAIT3: if(~key_number)
				password_check_state = PCS_I4;
			PCS_I4: begin
				if(key_number)
				begin
					p4<=key_value;
					password_check_state = PCS_WAIT4;
					index2 = 5;
				end
				if(key_star)
					password_check_state = PCS_PRE4;
			end
			PCS_WAIT4: if(~key_number)
				password_check_state = PCS_I5;
			PCS_I5: begin
				if(key_number)
				begin
					p5<=key_value;
					password_check_state = PCS_WAIT5;
					index2 = 6;
				end
				if(key_star)
					password_check_state = PCS_PRE5;
			end
			PCS_WAIT5: if(~key_number)
				password_check_state = PCS_I6;
			PCS_I6: begin
				if(key_number)
					password_check_state = PCS_ERR;
				if(key_star)
					password_check_state = PCS_PRE6;
			end
			PCS_PRE3: begin
				if(length != 3)
					password_check_state = PCS_ERR;
				else if((p0==c0)&&(p1==c1)&&(p2==c2))
					password_check_state = PCS_OK;
				else 
					password_check_state = PCS_ERR;
			end
			PCS_PRE4: begin
				if(length != 4)
					password_check_state = PCS_ERR;
				else if((p0==c0)&&(p1==c1)&&(p2==c2)&&(p3==c3))
					password_check_state = PCS_OK;
				else 
					password_check_state = PCS_ERR;
			end
			PCS_PRE5: begin
				if(length != 5)
					password_check_state = PCS_ERR;
				else if((p0==c0)&&(p1==c1)&&(p2==c2)&&(p3==c3)&&(p4==c4))
					password_check_state = PCS_OK;
				else 
					password_check_state = PCS_ERR;
			end
			PCS_PRE6: begin
				if(length != 6)
					password_check_state = PCS_ERR;
				else if((p0==c0)&&(p1==c1)&&(p2==c2)&&(p3==c3)&&(p4==c4)&&(p5==c5))
					password_check_state = PCS_OK;
				else 
					password_check_state = PCS_ERR;
			end
			PCS_ERR: begin
				equal = 0;
				set_pass_end = 1;
				password_check_state  = PCS_IDLE0;
			end				
			PCS_OK: begin
				equal = 1;
				set_pass_end = 1;
				password_check_state  = PCS_IDLE0;
			end					
		endcase
	end
	end	
	
	//SET_CHECK state
	always @(posedge clk)
	begin
	if(reset)
	begin
		set_check_end = 0;
		set_check_state = SCS_IDLE0;
		new = 1;
	end
	if(main_state == SET_CHECK)
	begin
		case(set_check_state)
			SCS_IDLE0: begin
				set_check_end = 0;
				set_check_state = SCS_IDLE1;
			end
			SCS_IDLE1: begin
				if(~key_star&~key_sharp)
					set_check_state = SCS_IDLE2;				
			end
			SCS_IDLE2: set_check_state = SCS_IDLE3;
			SCS_IDLE3: set_check_state = SCS_PRE;
			SCS_PRE: begin
				temp_number = n0;
				set_check_state = SCS_DIV;
			end
			SCS_DIV: begin
				if(index == 3)  set_check_state = SCS_INDEX3;
				else if(index ==4) set_check_state = SCS_INDEX4;
				else if(index ==5) set_check_state = SCS_INDEX5;
				else if(index ==6) set_check_state = SCS_INDEX6;
				else set_check_state = SCS_ERR;
			end
			SCS_INDEX3: begin
				if((n1==temp_number)&&(n2==temp_number))
					set_check_state = SCS_ERR;
				else if((n1==temp_number+1)&&(n2==temp_number+2))
					set_check_state = SCS_ERR;
				else if((n1==temp_number-1)&&(n2==temp_number-2))
					set_check_state = SCS_ERR;
				else set_check_state = SCS_OK;
			end
			SCS_INDEX4: begin
				if((n1==temp_number)&&(n2==temp_number)&&(n3==temp_number))
					set_check_state = SCS_ERR;
				else if((n1==temp_number+1)&&(n2==temp_number+2)&&(n3==temp_number+3))
					set_check_state = SCS_ERR;
				else if((n1==temp_number-1)&&(n2==temp_number-2)&&(n3==temp_number-3))
					set_check_state = SCS_ERR;
				else set_check_state = SCS_OK;				
			end
			SCS_INDEX5: begin
				if((n1==temp_number)&&(n2==temp_number)&&(n3==temp_number)&&(n4==temp_number))
					set_check_state = SCS_ERR;
				else if((n1==temp_number+1)&&(n2==temp_number+2)&&(n3==temp_number+3)&&(n4==temp_number+4))
					set_check_state = SCS_ERR;
				else if((n1==temp_number-1)&&(n2==temp_number-2)&&(n3==temp_number-3)&&(n4==temp_number-4))
					set_check_state = SCS_ERR;
				else set_check_state = SCS_OK;	
			end
			SCS_INDEX6: begin
				if((n1==temp_number)&&(n2==temp_number)&&(n3==temp_number)&&(n4==temp_number)&&(n5==temp_number))
					set_check_state = SCS_ERR;
				else if((n1==temp_number+1)&&(n2==temp_number+2)&&(n3==temp_number+3)&&(n4==temp_number+4)&&(n5==temp_number+5))
					set_check_state = SCS_ERR;
				else if((n1==temp_number-1)&&(n2==temp_number-2)&&(n3==temp_number-3)&&(n4==temp_number-4)&&(n5==temp_number-5))
					set_check_state = SCS_ERR;
				else set_check_state = SCS_OK;					
			end
			SCS_ERR: begin
				bad_pw = 1;
				set_check_end = 1;
				set_check_state = SCS_IDLE0;
			end
			SCS_OK: begin
				length = index;
				c0 <= n0;
				c1 <= n1;
				c2 <= n2;
				c3 <= n3;
				c4 <= n4;
				c5 <= n5;
				bad_pw = 0;
				set_check_end = 1;
				set_check_state = SCS_IDLE0;
				new = 0;
			end
		endcase
	end
	end 
	
	//SET_READ state
	always @(posedge clk)
	begin
	if(reset)
	begin
		set_read_end = 0;
		set_read_state = SRS_IDLE0;
	end
	if(main_state == SET_READ)
	begin
		case(set_read_state)
			SRS_IDLE0: begin 
				set_read_end = 0;
				set_read_state = SRS_IDLE1;
			end
			SRS_IDLE1: set_read_state = SRS_IDLE2;
			SRS_IDLE2: set_read_state = SRS_IDLE3;
			SRS_IDLE3: set_read_state = SRS_I0;
			SRS_I0: begin
				if(key_number)
				begin
					set_read_state = SRS_WAIT0;
					n0 = key_value;
					index = 1;
				end
				else
					index = 0;
			end
			SRS_WAIT0: begin
				if(~key_number)
					set_read_state = SRS_I1;
			end
			SRS_I1: begin
				if(key_number)
				begin
					set_read_state = SRS_WAIT1;
					n1 = key_value;
					index = 2;
				end
			end
			SRS_WAIT1: begin
				if(~key_number)
					set_read_state = SRS_I2;
			end
			SRS_I2: begin
				if(key_number)
				begin
					set_read_state = SRS_WAIT2;
					n2 = key_value;
					index = 3;
				end
			end
			SRS_WAIT2: begin
				if(~key_number)
					set_read_state = SRS_I3;
			end
			SRS_I3: begin
				if(key_number)
				begin
					set_read_state = SRS_WAIT3;
					n3 = key_value;
					index = 4;
				end
				if(key_sharp&!new)
					set_read_state = SRS_FINISH;
				if(key_star&new)
					set_read_state = SRS_FINISH;
			end
			SRS_WAIT3: begin
				if(~key_number)
					set_read_state = SRS_I4;
			end
			SRS_I4: begin
				if(key_number)
				begin
					set_read_state = SRS_WAIT4;
					n4 = key_value;
					index = 5;
				end
				if(key_sharp&!new)
					set_read_state = SRS_FINISH;
				if(key_star&new)
					set_read_state = SRS_FINISH;
			end
			SRS_WAIT4: begin
				if(~key_number)
					set_read_state = SRS_I5;
			end
			SRS_I5: begin
				if(key_number)
				begin
					set_read_state = SRS_WAIT5;
					n5 = key_value;
					index = 6;
				end
				if(key_sharp&!new)
					set_read_state = SRS_FINISH;
				if(key_star&new)
					set_read_state = SRS_FINISH;
			end
			SRS_WAIT5: begin
				if(~key_number)
					set_read_state = SRS_I6;
			end
			SRS_I6: begin//number 6개 까지 받은상태
				if(key_number)
				begin
					set_read_state = SRS_OVER_FLOW;
					index = 7;
				end
				if(key_sharp&!new)
					set_read_state = SRS_FINISH;
				if(key_star&new)
					set_read_state = SRS_FINISH;
			end
			SRS_OVER_FLOW: begin
				set_read_end = 1;
				set_read_state = SRS_IDLE0;
			end
			SRS_FINISH: begin
				set_read_end = 1;
				set_read_state = SRS_IDLE0;
			end
		endcase
	end
	end	
	
	//next state 
	always @(posedge clk)
	begin
		if(reset)
		begin
			main_state = SET_READ;
			reset_read_end=1;
			reset_check_end=1;
			reset_fail_end=1;
			reset_pipo_end=1;
			reset_pass_end=1;
			reset_lock_end=1;
			reset_one_minute_end=1;
			reset_open_end=1;
			close_state=CS_WAIT1;
		end
		
		case(main_state)
		SET_READ: begin
			reset_read_end = 0;
			if(read_end)
			begin
				main_state = SET_CHECK;
				reset_read_end = 1;
			end
		end
		SET_CHECK: begin
			reset_check_end = 0;
			if(check_end&bad_pw)
			begin
				main_state = FAIL;
				reset_check_end = 1;
			end
			if(check_end&~bad_pw)
			begin
				main_state = CLOSE;
				reset_check_end = 1;
			end			
		end
		FAIL: begin
			reset_fail_end = 0;
			if(fail_end&pipo_on)
			begin
				main_state = PIPO;
				reset_fail_end = 1;
			end
			if(fail_end&~pipo_on)
			begin
				main_state = SET_READ;
				reset_fail_end = 1;
			end			
		end
		PIPO: begin
			reset_pipo_end = 0;
			if(pipo_end)
			begin
				main_state = SET_READ;
				reset_pipo_end = 1;
			end
		end
		CLOSE: begin		
			change = 0;
			case(close_state)
			CS_WAIT1: begin
				if(~key_star&~key_sharp&~key_number)
					close_state = CS_WAIT2;
			end
			CS_WAIT2: begin
				if(~key_star&~key_sharp&~key_number)
					close_state = CS_OK;
			end
			CS_OK: begin
				if(key_star)
				begin
					main_state = PASSWORD_CHECK;
					close_state = CS_WAIT1;
				end
				if(key_sharp)
				begin
					main_state = PRE_SET;
					close_state = CS_WAIT1;
				end
			end
			endcase
		end
		PRE_SET: begin
			change = 1;
			if(key_number)
				main_state = PASSWORD_CHECK;
		end
		PASSWORD_CHECK: begin
			reset_pass_end = 0;
			if(pass_end&~equal)
			begin
				reset_pass_end = 1;
				main_state = LOCK;
			end
			if(pass_end&equal&change)
			begin
				reset_pass_end = 1;
				main_state = SET_READ;
			end
			if(pass_end&equal&~change)
			begin
				reset_pass_end = 1;
				main_state = OPEN;
			end			
		end
		LOCK: begin
			reset_lock_end = 0;
			if(lock_end&lock_on)
			begin
				main_state = ONE_MINUTE_LOCK;
				reset_lock_end = 1;
			end
			if(lock_end&~lock_on)
			begin
				main_state = CLOSE;
				reset_lock_end = 1;
			end
		end
		ONE_MINUTE_LOCK: begin
			reset_one_minute_end = 0;
			if(one_minute_end)
			begin
				main_state = CLOSE;
				reset_one_minute_end = 1;
			end
		end
		OPEN: begin
			reset_open_end = 0;
			if(open_end)
			begin
				main_state = CLOSE;
				reset_open_end = 1;
			end			
		end
		endcase
	end	
	
	//output 
	always @(posedge clk)
	begin
		case(main_state)
			SET_READ: begin
				buzzer_state = BUZZ_NULL;
				if(index == 1)
				begin
					i0 = n0;
					display_on = 1;
					display_state = PRINT_NUM1;
				end
				else if(index == 2)
				begin
					i1 = n1;
					display_on = 1;
					display_state = PRINT_NUM2;				
				end
				else if(index == 3)
				begin
					i2 = n2;
					display_on = 1;
					display_state = PRINT_NUM3;				
				end
				else if(index == 4)
				begin
					i3 = n3;
					display_on = 1;
					display_state = PRINT_NUM4;				
				end
				else if(index == 5)
				begin	
					i4 = n4;
					display_on = 1;
					display_state = PRINT_NUM5;				
				end
				else if(index == 6)
				begin
					i5 = n5;
					display_on = 1;
					display_state = PRINT_NUM6;					
				end
				else
					display_on = 0;
			end
			SET_CHECK: begin
				buzzer_state = BUZZ_NULL;
				display_on = 0;
			end
			FAIL: begin
				buzzer_state = BUZZ_NULL;
				display_on = 0;
			end
			PIPO: begin
				buzzer_state = BUZZ_PIPOPIPO;
				display_on = 0;
			end 
			CLOSE: begin
				buzzer_state = BUZZ_ERR;
				display_on = 1;
				display_state = PRINT_CLOSE;
			end
			PRE_SET: begin
				buzzer_state = BUZZ_NULL;
				display_on = 0;
			end
			PASSWORD_CHECK: begin
				buzzer_state = BUZZ_NULL;
				if(index2 == 1)
				begin
					i0 = p0;
					display_on = 1;
					display_state = PRINT_NUM1;
				end
				else if(index2 == 2)
				begin
					i1 = p1;
					display_on = 1;
					display_state = PRINT_NUM2;				
				end
				else if(index2 == 3)
				begin
					i2 = p2;
					display_on = 1;
					display_state = PRINT_NUM3;				
				end
				else if(index2 == 4)
				begin
					i3 = p3;
					display_on = 1;
					display_state = PRINT_NUM4;				
				end
				else if(index2 == 5)
				begin	
					i4 = p4;
					display_on = 1;
					display_state = PRINT_NUM5;				
				end
				else if(index2 == 6)
				begin
					i5 = p5;
					display_on = 1;
					display_state = PRINT_NUM6;					
				end
				else
					display_on = 0;
			end		
			LOCK: begin
				buzzer_state = BUZZ_NULL;
				display_on = 0;
			end
			ONE_MINUTE_LOCK: begin
				buzzer_state = BUZZ_ONE_MINUTE_LOCK;
				display_on = 0;
			end
			OPEN: begin
				buzzer_state = BUZZ_OPEN;
				display_on = 1;
				display_state = PRINT_OPEN;
			end
		endcase
	end	
endmodule
	