module RiscvSingleCyle(input clk);
	wire		MemWrite,ALUSrc,RegWrite,zero,branchLEG;
	wire[1:0]	pcSrc,ResultSrc;
	wire[2:0]	ALUControl,ImmSrc,func3;
	wire[6:0]	func7,op;
	DataPath	DP(clk,MemWrite,ALUSrc,RegWrite,pcSrc,ResultSrc,ALUControl,ImmSrc,zero,branchLEG,func3,func7,op);
	Controller	CTRL(zero,branchLEG,func3,func7,op,MemWrite,ALUSrc,RegWrite,pcSrc,ResultSrc,ALUControl,ImmSrc);
endmodule
