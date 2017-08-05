module LED_OUTPUT_CONTROLLER(led_on,led_end,reset,clk,led);
	input led_on,reset,clk;
	output led_end;
	output [0:7]led;
	reg led_end;
	reg [0:7]led;
	
	reg previous_led_on;
	reg [4:0]internal_state;
	
	wire time_t1;
	reg reset_time_t1;
	wire time_t2;
	reg reset_time_t2;

	COUNTER_FOR_TIME_T cftt1(time_t1,reset_time_t1,clk);
	COUNTER_FOR_TIME_T cftt2(time_t2,reset_time_t2,clk);
	
	initial
	begin
		led_end = 0;
		internal_state = 0;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if(reset)	//reset.
		begin
			internal_state = 0;
			previous_led_on = 0;
		end
		//--------state별---------
		case(internal_state)
		//------------------------------
		0: begin
			led_end = 0;
			led = 0;
			reset_time_t1 = 1;
			reset_time_t2 = 1;
			if(led_on&~previous_led_on)
			begin
				internal_state = 1;
			end
		end
		//------------------------------
		1: begin
			if(time_t1)
			begin
				internal_state = 2;
			end
			else
			begin
				reset_time_t1 = 0;
				reset_time_t2 = 1;
				led = 8'b10000000;
			end		
		end
		//------------------------------
		2: begin
			if(time_t2)
			begin
				internal_state = 3;
			end
			else
			begin
				reset_time_t1 = 1;
				reset_time_t2 = 0;
				led = 8'b01000000;
			end
		end
		//------------------------------
		3: begin
			if(time_t1)
			begin
				internal_state = 4;		////adadadadadadd///
			end
			else
			begin
				reset_time_t1 = 0;
				reset_time_t2 = 1;
				led = 8'b00100000;
			end		
		end
		//------------------------------
		4: begin
			if(time_t2)
			begin
				internal_state = 5;
			end
			else
			begin
				reset_time_t1 = 1;
				reset_time_t2 = 0;
				led = 8'b00010000;
			end
		
		end
		//------------------------------
		5: begin
			if(time_t1)
			begin
				internal_state = 6;
			end
			else
			begin
				reset_time_t1 = 0;
				reset_time_t2 = 1;
				led = 8'b00001000;
			end
		
		end
		//------------------------------
		6: begin
			if(time_t2)
			begin
				internal_state = 7;
			end
			else
			begin
				reset_time_t1 = 1;
				reset_time_t2 = 0;
				led = 8'b00000100;
			end
		
		end
		//------------------------------
		7: begin
			if(time_t1)
			begin
				internal_state = 8;
			end
			else
			begin
				reset_time_t1 = 0;
				reset_time_t2 = 1;
				led = 8'b00000010;
			end
		end
		//------------------------------
		8: begin
			if(time_t2)
			begin
				internal_state = 9;
			end
			else
			begin
				reset_time_t1 = 1;
				reset_time_t2 = 0;
				led = 8'b00000001;
			end
		end
		//------------------------------
		9: begin
			if(time_t1)
			begin
				internal_state = 10;
			end
			else
			begin
				reset_time_t1 = 0;
				reset_time_t2 = 1;
				led = 8'b00000010;
			end
		end
		//------------------------------
		10: begin
			if(time_t2)
			begin
				internal_state = 11;
			end
			else
			begin
				reset_time_t1 = 1;
				reset_time_t2 = 0;
				led = 8'b00000100;
			end
		end
		//------------------------------
		11: begin
			if(time_t1)
			begin
				internal_state = 12;
			end
			else
			begin
				reset_time_t1 = 0;
				reset_time_t2 = 1;
				led = 8'b00001000;
			end
		
		end
		//------------------------------
		12: begin
			if(time_t2)
			begin
				internal_state = 13;
			end
			else
			begin
				reset_time_t1 = 1;
				reset_time_t2 = 0;
				led = 8'b00010000;
			end
		end
		//------------------------------
		13: begin
			if(time_t1)
			begin
				internal_state = 14;
			end
			else
			begin
				reset_time_t1 = 0;
				reset_time_t2 = 1;
				led = 8'b00100000;
			end
		end
		//------------------------------
		14: begin
			if(time_t2)
			begin
				internal_state = 15;
			end
			else
			begin
				reset_time_t1 = 1;
				reset_time_t2 = 0;
				led = 8'b01000000;
			end		
		end
		//------------------------------
		15: begin
			if(time_t1)
			begin
				internal_state = 16;
			end
			else
			begin
				reset_time_t1 = 0;
				reset_time_t2 = 1;
				led = 8'b10000000;
			end		
		end
		//------------------------------
		16: begin
			if(time_t2)
			begin
				internal_state = 17;
			end
			else
			begin
				reset_time_t1 = 1;
				reset_time_t2 = 0;
				led = 8'b00000000;
			end		
		end
		//------------------------------
		17: begin
			if(time_t1)
			begin
				internal_state = 18;
			end
			else
			begin
				reset_time_t1 = 0;
				reset_time_t2 = 1;
				led = 8'b11111111;
			end
		end
		//------------------------------
		18: begin
			if(time_t2)
			begin
				led_end = 1;
				internal_state = 0;
			end
			else
			begin
				reset_time_t1 = 1;
				reset_time_t2 = 0;
				led = 8'b00000000;
			end		
		end
		endcase
		//------------------------------
		previous_led_on = led_on;
	end
endmodule
