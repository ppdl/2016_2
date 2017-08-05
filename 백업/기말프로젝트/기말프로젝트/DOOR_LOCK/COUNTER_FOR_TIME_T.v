module COUNTER_FOR_TIME_T(time_t,reset,clk);
	input reset,clk;
	output time_t;
	reg time_t;
	
	reg [31:0]count;
	
	always @(posedge clk or posedge reset)
	begin
		if(reset)
		begin
			count=0;
			time_t=0;
		end
		else if(time_t == 0)
		begin
			if(count == 32750001/3)	//about 1/2sec
			begin
				count = 0;
				time_t = 1;
			end
			else
				count = count+1;
		end
	end
endmodule 