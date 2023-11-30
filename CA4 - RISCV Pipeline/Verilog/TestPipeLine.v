module	TestPipeLine();
	reg clk=0;
	RiscvPipeLine	RVPL(clk);
	always #20 clk=~clk;
	initial begin 
	#10000
	$stop;
	end
endmodule

