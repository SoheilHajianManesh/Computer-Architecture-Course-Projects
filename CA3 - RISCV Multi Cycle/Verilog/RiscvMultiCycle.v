module RiscvMultiCycle(input clk);
	wire 		MemWrite,ALUSrc,RegWrite,PCWrite,AdrSrc,IRWrite,zero,branchLEG;
	wire[1:0]	ResultSrc,ALUSrcB,ALUSrcA;
	wire[2:0]	ALUControl,ImmSrc,func3;
	wire[6:0]	func7,op;
	DataPath	DP(clk,MemWrite,ALUSrc,RegWrite,PCWrite,AdrSrc,IRWrite,ResultSrc,ALUSrcB,ALUSrcA,ALUControl,ImmSrc,zero,branchLEG,func3,func7,op);
	Controller	CTRL(clk,zero,branchLEG,op,func7,func3,PCWrite,AdrSrc,MemWrite,IRWrite,RegWrite,ResultSrc,ALUSrcA,ALUSrcB,ALUControl,ImmSrc);
endmodule
