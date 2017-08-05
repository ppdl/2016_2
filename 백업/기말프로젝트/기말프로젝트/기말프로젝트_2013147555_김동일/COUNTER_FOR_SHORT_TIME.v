module COUNTER_FOR_SHORT_TIME(clk,reset,t);
	input reset,clk;
	output t;
	reg t;
	
	reg [32:0]count;
	
	always @(posedge clk or posedge reset)
	begin
		if(reset)
		begin
			count=0;
			t=0;
		end
		else if(t == 0)
		begin
			if(count == 32750000/5)
			begin
				count = 0;
				t = 1;
			end
			else
				count = count+1;
		end
	end
endmodule
	