module timer(clk, slow_clk);
	input				clk;
	output			slow_clk;
	
	reg				slow_clk;
	
	reg[9:0]			cycle_cnt;
	
	always @(posedge clk)
	begin
		if (cycle_cnt == 0)			slow_clk = 1;
		else if(cycle_cnt == 32)	slow_clk = 0;
		cycle_cnt = cycle_cnt + 1;
	end
	
endmodule
