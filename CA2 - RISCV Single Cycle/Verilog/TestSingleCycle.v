module TestSingleCycle();
	reg clk=0;
	RiscvSingleCyle	RVSC(clk);
	always #20 clk=~clk;
	initial begin 
	#5000
	$stop;
	end
endmodule
