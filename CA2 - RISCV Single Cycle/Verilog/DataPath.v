module DataPath(input clk,MemWrite,ALUSrc,RegWrite,input [1:0] pcSrc,ResultSrc,input [2:0] ALUControl,ImmSrc,output zero,branchLEG,output[2:0] func3,output[6:0] func7,op);
	wire [31:0] PCPlus4,PCTarget,ALUResult,PCNext,PC,Instr,ImmExt,Result,RD1,RD2,SrcB,ReadData;
	Mux3to1		M31(pcSrc,PCPlus4,PCTarget,ALUResult,PCNext);
	Register	PCReg(clk,PCNext,PC);
	InstMemory	InstructionMemory(PC,Instr); 
	Adder		PC4Adder(PC,4,PCPlus4);/// 4 OK?
	ImmExtend	Extend(ImmSrc,Instr[31:7] ,ImmExt);
	RegisterFile	RegisterFile(clk,RegWrite,Instr[19:15],Instr[24:20],Instr[11:7],Result,RD1,RD2);
	Mux2to1		M21(ALUSrc,RD2,ImmExt,SrcB);
	ALU 		ALU(RD1, SrcB,ALUControl,ALUResult,zero);
	Adder		PCImmAdder(PC,ImmExt,PCTarget);
    	DataMem		DataMemory(clk ,MemWrite,ALUResult,RD2,ReadData);
	Mux4to1		M41(ResultSrc,ALUResult,ReadData,PCPlus4,ImmExt,Result);
	assign	brachLEG=	ALUResult[0];
	assign 	func3	=	Instr[14:12];
	assign	func7	=	Instr[31:25];
	assign  op   	=	Instr[6:0];

endmodule
