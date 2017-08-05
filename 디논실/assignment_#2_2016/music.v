module music(clk, num, speaker);
	input clk;
	input [3:0] num;
	output speaker;

	parameter			SN=0, SA=1, SS=2;
	parameter			S0=3, S1=4, S2=5, S3=6, S4=7, S5=8, S6=9, S7=10, S8=11, S9=12;	
	
	reg [27:0] tone;
	always @(posedge clk) tone <= tone+1;

	wire [5:0] fullnote = tone[27:22];

	wire [2:0] octave;
	wire [3:0] note;
	
	divide_by12 divby12(.numer(fullnote[5:0]), .quotient(octave), .remain(note));

	reg [8:0] clkdivider;
	
	always @(note)
	case(note)
	  0: clkdivider = 512-1; // A 
	  1: clkdivider = 483-1; // A#/Bb
	  2: clkdivider = 456-1; // B 
	  3: clkdivider = 431-1; // C 
	  4: clkdivider = 406-1; // C#/Db
	  5: clkdivider = 384-1; // D 
	  6: clkdivider = 362-1; // D#/Eb
	  7: clkdivider = 342-1; // E 
	  8: clkdivider = 323-1; // F 
	  9: clkdivider = 304-1; // F#/Gb
	  10: clkdivider = 287-1; // G 
	  11: clkdivider = 271-1; // G#/Ab
	  12: clkdivider = 0; // should never happen
	  13: clkdivider = 0; // should never happen
	  14: clkdivider = 0; // should never happen
	  15: clkdivider = 0; // should never happen
	endcase

	reg [8:0] counter_note;
	
	always @(posedge clk) 
		begin
			case(num)
				S0 : if(counter_note==0) counter_note <= 512-1; else counter_note <= counter_note-1;
				S1 : if(counter_note==0) counter_note <= 483-1; else counter_note <= counter_note-1;
				S2 : if(counter_note==0) counter_note <= 456-1; else counter_note <= counter_note-1;
				S3 : if(counter_note==0) counter_note <= 431-1; else counter_note <= counter_note-1; 
				S4 : if(counter_note==0) counter_note <= 406-1; else counter_note <= counter_note-1;
				S5 : if(counter_note==0) counter_note <= 384-1; else counter_note <= counter_note-1;
				S6 : if(counter_note==0) counter_note <= 362-1; else counter_note <= counter_note-1;
				S7 : if(counter_note==0) counter_note <= 342-1; else counter_note <= counter_note-1;
				S8 : if(counter_note==0) counter_note <= 323-1; else counter_note <= counter_note-1;
				S9 : if(counter_note==0) counter_note <= 287-1; else counter_note <= counter_note-1;
				SA : if(counter_note==0) counter_note <= 271-1; else counter_note <= counter_note-1;
				SS : if(counter_note==0) counter_note <= 271-1; else counter_note <= counter_note-1;
			endcase
		end
		
	reg [7:0] counter_octave;
	always @(posedge clk)
		if(counter_note==0)
		begin
		 if(counter_octave==0)
		  counter_octave <= 127;
		 else
		  counter_octave <= counter_octave-1;
		end

	reg speaker;
	always @(posedge clk) 
		begin
			if(counter_note==0 && counter_octave==0) speaker <= ~speaker;
		end
endmodule