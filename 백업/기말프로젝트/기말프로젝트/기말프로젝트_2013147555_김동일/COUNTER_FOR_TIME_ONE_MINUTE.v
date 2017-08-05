module COUNTER_FOR_TIME_ONE_MINUTE(clk,reset,t);
	input reset,clk;
	output t;
	reg t;
	
	reg [41:0]count;
	
	always @(posedge clk or posedge reset)
	begin
		if(reset)
		begin
			count=0;
			t=0;
		end
		else if(t == 0)
		begin
			if(count == 32750000*60) //about 1minute
			begin
				count = 0;
				t = 1;
			end
			else
				count = count+1;
		end
	end
endmodule 