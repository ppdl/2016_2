module SOUND_GENERATOR_WITH_BUZZER(clk,reset,buzzer_state,buzz_key, buzz);
	input clk,reset,buzz_key;
	input [2:0]buzzer_state;
	localparam BUZZ_NULL=0,BUZZ_ERR=1,BUZZ_OPEN=2,BUZZ_ONE_MINUTE_LOCK=3,BUZZ_PIPOPIPO=4;
	
	reg [3:0]sound;
	//0:no sound, 1:C, 2:E, 3:F#, 4:G, 5:G#, 6:high A#, 7:high B, 8:high C, 9: high E, 10: high G;
	reg [31:0]count_for_sound;
	
	output buzz;	
	reg buzz;
	
	//inner state
	reg [3:0]internal_state;
	localparam S0=0,STATE_KEY=1,STATE_OPEN=2,STATE_ERR=3,STATE_LOCK=4,STATE_PIPOPIPO=5;

	reg err_on, open_on, key_on;
	reg [2:0]previous_buzzer_state;
	reg previous_buzz_key;
	
	reg [1:0]open_internal_state;
	reg [1:0]err_internal_state;
	reg [1:0]lock_internal_state;
	reg [1:0]pipo_internal_state;
	
	wire short_time;
	reg reset_short_time;
	wire fiften_sec;
	reg reset_fiften_sec;
	
	COUNTER_FOR_SHORT_TIME cfst(clk,reset_short_time,short_time);
	COUNTER_FOR_FIFTEN_SEC cffs(clk,reset_fiften_sec,fiften_sec);
	
	initial 
	begin
		internal_state =S0;
		buzz = 0;
		err_on = 0;
		open_on = 0;
		key_on = 0;
		open_internal_state = 0;
		err_internal_state = 0;
		lock_internal_state = 0;
		pipo_internal_state = 0;
	end
	
	always @(posedge clk)
	begin
		if(reset)
		begin
			internal_state = S0;
			err_on = 0;
			open_on = 0;
			key_on = 0;
			open_internal_state = 0;
			err_internal_state = 0;
			lock_internal_state = 0;
			pipo_internal_state = 0;
		end
		case(internal_state)
	//=====================================================
		S0: begin
			sound = 0;
			reset_short_time = 1;
			if(key_on)
			begin
				internal_state = STATE_KEY;
				key_on = 0;
			end
			else if(open_on)
			begin
				internal_state = STATE_OPEN;
				open_on = 0;
			end
			else if(err_on)
			begin
				internal_state = STATE_ERR;
				err_on = 0;
			end
			else if(buzzer_state == BUZZ_ONE_MINUTE_LOCK)
			begin
				internal_state = STATE_LOCK;
			end
			else if(buzzer_state == BUZZ_PIPOPIPO)
			begin
				internal_state = STATE_PIPOPIPO;
			end
		end
	//=====================================================
		STATE_KEY: begin
			reset_short_time = 0;
			sound = 1;
			if(short_time)
			begin
				reset_short_time = 1;
				internal_state = S0;
			end
		end
	//=====================================================
		STATE_OPEN: begin
			case(open_internal_state)
			0:	begin
				reset_short_time = 0;
				sound = 2;
				if(short_time)
				begin
					open_internal_state = 1;
					reset_short_time = 1;
				end
			end
			1:	begin
				reset_short_time = 0;
				sound = 4;
				if(short_time)
				begin
					open_internal_state = 2;
					reset_short_time = 1;
				end
			end
			2:	begin
				reset_short_time = 0;
				sound = 8;
				if(short_time)
				begin
					internal_state = S0;
					open_internal_state = 0;
					reset_short_time = 1;
				end
			end
			endcase
		end
	//=====================================================
		STATE_ERR: begin
			case(err_internal_state)
			0:	begin
				reset_short_time = 0;
				sound = 7;
				if(short_time)
				begin
					err_internal_state = 1;
					reset_short_time = 1;
				end
			end
			1:	begin
				reset_short_time = 0;
				sound = 6;
				if(short_time)
				begin
					err_internal_state = 2;
					reset_short_time = 1;
				end
			end
			2:	begin
				reset_short_time = 0;
				sound = 4;
				if(short_time)
				begin
					internal_state = S0;
					err_internal_state = 0;
					reset_short_time = 1;
				end
			end
			endcase
		end
	//=====================================================
		STATE_LOCK: begin
			if(buzzer_state != BUZZ_ONE_MINUTE_LOCK)
				internal_state = S0;
			else
			begin
				case(lock_internal_state)
				0: begin
					reset_short_time = 0;
					sound = 5;
					if(short_time)
					begin
						lock_internal_state = 1;
						reset_short_time = 1;
					end	
				end
				1: begin
					reset_short_time = 0;
					sound = 4;
					if(short_time)
					begin
						lock_internal_state = 2;
						reset_short_time = 1;
					end
				end
				2: begin
					reset_short_time = 0;
					sound = 3;
					if(short_time)
					begin
						lock_internal_state = 3;
						reset_short_time = 1;
					end
				end
				3: begin
					reset_short_time = 0;
					sound = 4;
					if(short_time)
					begin
						lock_internal_state = 0;
						reset_short_time = 1;
					end	
				end
				endcase
			end		
		end
	//=====================================================
		STATE_PIPOPIPO: begin
			if(buzzer_state != BUZZ_PIPOPIPO)
				internal_state = S0;
			else
			begin
				case(pipo_internal_state)
				0: begin
					reset_short_time = 0;
					sound = 9;
					if(short_time)
					begin
						pipo_internal_state = 1;
						reset_short_time = 1;
					end	
				end
				1: begin
					reset_short_time = 0;
					sound = 9;
					if(short_time)
					begin
						pipo_internal_state = 2;
						reset_short_time = 1;
					end						
				end
				2: begin
					reset_short_time = 0;
					sound = 10;
					if(short_time)
					begin
						pipo_internal_state = 3;
						reset_short_time = 1;
					end	
				end
				3: begin
					reset_short_time = 0;
					sound = 10;
					if(short_time)
					begin
						pipo_internal_state = 0;
						reset_short_time = 1;
					end						
				end
				endcase
			end		
		end		
		endcase
		
		if(buzzer_state == BUZZ_ERR && previous_buzzer_state != BUZZ_ERR)
			err_on = 1;
		if(buzzer_state == BUZZ_OPEN && previous_buzzer_state != BUZZ_OPEN)
			open_on = 1;
		if(buzz_key && ~previous_buzz_key)
			key_on = 1;		
		if(~buzz_key)
			key_on = 0;
		previous_buzz_key = buzz_key;
		previous_buzzer_state = buzzer_state;
	end
	
	//make sound
	always @(posedge clk)
	begin
		if(sound == 0)
		begin
			buzz = 0;
			count_for_sound = 0;
		end
	//------about 523hz sound--------
		else if(sound == 1)
		begin
			if(count_for_sound == 31295)	
			begin
				buzz = ~buzz;
				count_for_sound = 0;
			end
			else
				count_for_sound = count_for_sound + 1;			
		end
	//------about 659hz sound--------
		else if(sound == 2)
		begin
			if(count_for_sound == 24838)	
			begin
				buzz = ~buzz;
				count_for_sound = 0;
			end
			else
				count_for_sound = count_for_sound + 1;			
		end
	//------about 740hz sound--------
		else if(sound == 3)
		begin
			if(count_for_sound == 22128)	
			begin
				buzz = ~buzz;
				count_for_sound = 0;
			end
			else
				count_for_sound = count_for_sound + 1;			
		end
	//------about 784hz sound--------
		else if(sound == 4)
		begin
			if(count_for_sound == 20886)	
			begin
				buzz = ~buzz;
				count_for_sound = 0;
			end
			else
				count_for_sound = count_for_sound + 1;			
		end
	//------about 831hz sound--------
		else if(sound == 5)
		begin
			if(count_for_sound == 19705)	
			begin
				buzz = ~buzz;
				count_for_sound = 0;
			end
			else
				count_for_sound = count_for_sound + 1;			
		end
	//------about 932hz sound--------
		else if(sound == 6)
		begin
			if(count_for_sound == 17570)	
			begin
				buzz = ~buzz;
				count_for_sound = 0;
			end
			else
				count_for_sound = count_for_sound + 1;			
		end
	//------about 988hz sound--------
		else if(sound == 7)
		begin
			if(count_for_sound == 16573)	
			begin
				buzz = ~buzz;
				count_for_sound = 0;
			end
			else
				count_for_sound = count_for_sound + 1;			
		end
	//------about 1046hz sound--------
		else if(sound == 8)
		begin
			if(count_for_sound == 15654)	
			begin
				buzz = ~buzz;
				count_for_sound = 0;
			end
			else
				count_for_sound = count_for_sound + 1;			
		end
	//------about 1318hz sound--------
		else if(sound == 9)
		begin
			if(count_for_sound == 12424)	
			begin
				buzz = ~buzz;
				count_for_sound = 0;
			end
			else
				count_for_sound = count_for_sound + 1;			
		end
	//------about 1568hz sound--------
		else if(sound == 10)
		begin
			if(count_for_sound == 10443)	
			begin
				buzz = ~buzz;
				count_for_sound = 0;
			end
			else
				count_for_sound = count_for_sound + 1;			
		end
	end
endmodule

