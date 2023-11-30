`define		beq	3'b000
`define 	bne	3'b001
`define		blt	3'b100
`define 	bge	3'b101

module Decoder(input JalrE,JumpE,BranchE,ZeroE,ALUResult0,input[2:0] func3,output[1:0] PCSrc);
	assign PCSrc=(JalrE) ? 2'b10:
		((JumpE)||
		(BranchE && func3==`beq && ZeroE)||
		(BranchE && func3==`bne && ~ZeroE)||
		(BranchE && func3==`blt && ALUResult0)||
		(BranchE && func3==`bge && ~ALUResult0))?2'b01:
		2'b00;
endmodule
