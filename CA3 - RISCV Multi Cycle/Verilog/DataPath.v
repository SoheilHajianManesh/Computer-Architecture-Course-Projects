module DataPath(input clk,MemWrite,ALUSrc,RegWrite,PCWrite,AdrSrc,IRWrite,input [1:0] ResultSrc,ALUSrcB,ALUSrcA,input [2:0] ALUControl,ImmSrc,output zero,branchLEG,output[2:0] func3,output[6:0] func7,op);
	wire [31:0] Result,PCPlus4,OldPC,WriteData,ReadData,ADR,ImmExt,MDROut,PCTarget,ALUResult,ALUOut,Instr,AOut,SrcA,SrcB,RD1,RD2;
	Register_en 	pc_n(clk,PCWrite,Result,PCPlus4);
    	Mux2to1  	PC_MUX(AdrSrc,PCPlus4,Result,ADR);
	Register_en oldpc_register(clk,IRWrite,PCPlus4,OldPC);
	Register_en mem_register(clk,IRWrite,ReadData,Instr); 
    	Memory		DataMemory(clk,MemWrite,ADR,WriteData,ReadData);
	Register	MDR(clk,ReadData,MDROut);
	RegisterFile	registerFile(clk,RegWrite,Instr[19:15],Instr[24:20],Instr[11:7],Result,RD1,RD2);
	Register	RFregA(clk,RD1,AOut);
	Register	RFregB(clk,RD2,WriteData);
	ImmExtend	Extend(ImmSrc,Instr[31:7] ,ImmExt);
	Mux3to1  	MuxSrcA(ALUSrcA,PCPlus4,OldPC,AOut,SrcA);
	Mux3to1  	MuxSrcB(ALUSrcB,WriteData,ImmExt,4,SrcB);
	ALU 		ALUfinal(SrcA,SrcB,ALUControl,ALUResult,zero);
	Register	ResultReg(clk,ALUResult,ALUOut);
	Mux4to1    	FinalMux(ResultSrc,ALUOut,MDROut,ALUResult,ImmExt,Result);


	assign	branchLEG=	ALUResult[0];
	assign 	func3	=	Instr[14:12];
	assign	func7	=	Instr[31:25];
	assign  op   	=	Instr[6:0];

endmodule
