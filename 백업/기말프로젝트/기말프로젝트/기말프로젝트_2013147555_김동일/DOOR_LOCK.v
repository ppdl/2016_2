module DOOR_LOCK(reset,door,clk, key_col,key_row,seg_data,seg_pos,led,buzz);
	input reset,door,clk;	 
	output [3:0]key_col;		//key_matrix column
	input [3:0]key_row;		//key_matrix row
	
	output [7:0]seg_data;	//seven_segment data
	output [5:0]seg_pos;		//seven_segment position 		
	output [0:7]led;			//led 
	output buzz;				//buzzer
	
	//wires to connect between modules
	wire [3:0]key_value;
	wire key_number,key_star,key_sharp;
	wire led_end,led_on;
	wire [2:0]buzzer_state;
	wire [2:0]display_state;
	wire display_on;
	wire [3:0]i0,i1,i2,i3,i4,i5;
	wire buzz_key;
	
	//main FSM
	MAIN_FSM main_machin(reset,door,clk, key_value,key_number,key_star,key_sharp, led_end,led_on,buzzer_state,display_state,display_on,i0,i1,i2,i3,i4,i5);
	//keypad 
	KEYPAD_MODULE module_key(key_col,key_row,clk, key_value,key_number,key_star,key_sharp,buzz_key);
	//led control 
	LED_OUTPUT_CONTROLLER led_control(led_on,led_end,reset,clk,led);
	//7-segment
	SEVEN_SEGMENT_CONTROLLER sevenM(clk,display_state,display_on,i0,i1,i2,i3,i4,i5, seg_data,seg_pos);
	//buzzer control
	SOUND_GENERATOR_WITH_BUZZER buzzerM(clk,reset,buzzer_state,buzz_key, buzz);
	
endmodule 