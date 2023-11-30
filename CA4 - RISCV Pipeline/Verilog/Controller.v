`define 	R_Type	7'b0110011
`define 	I_Type	7'b0010011
`define		Lw	7'b0000011
`define 	Jalr	7'b1100111
`define		S_Type	7'b0100011
`define		J_Type	7'b1101111
`define 	B_Type	7'b1100011
`define		U_Type	7'b0110111


`define		Add	10'b0000_0000_00
`define 	Sub	10'b0100_0000_00
`define		And	10'b0000_0001_11
`define 	Or	10'b0000_0001_10
`define		Slt	10'b0000_0000_10


`define		lw	3'b010
`define 	addi	3'b000
`define		xori	3'b100
`define 	ori	3'b110
`define		slti	3'b010
`define		jalr	3'b000


`define		beq	3'b000
`define 	bne	3'b001
`define		blt	3'b100
`define 	bge	3'b101



module Controller(input[2:0] func3,input[6:0] func7,op,output reg MemWrite,ALUSrc,RegWrite,Jump,Branch,Jalr,output reg [1:0] ResultSrc,output reg [2:0] ALUControl,ImmSrc);
	wire[9:0] func;
	assign func={func7,func3};
	always@(func3,func7,op) begin
		{MemWrite,ALUSrc,RegWrite,Jump,Branch,Jalr,ResultSrc,ALUControl,ImmSrc}=14'b0000_0000_0000_00;
		case(op)
			`R_Type:begin
				RegWrite=1'b1;
				case(func)
					`Add:;
					`Sub:ALUControl=3'b001;
					`And:ALUControl=3'b010;
					`Or :ALUControl=3'b011;
					`Slt:ALUControl=3'b101;
				endcase
				end
			`Lw:	{RegWrite,ResultSrc,ALUSrc}=4'b1011;
			`I_Type:begin
				{ALUSrc,RegWrite}=2'b11;
				case(func3)					
					`addi:;
					`xori:ALUControl=3'b100;
					`ori :ALUControl=3'b011;
					`slti:ALUControl=3'b101;
				endcase
				end
			`Jalr:	{Jalr,ALUSrc,ResultSrc,RegWrite}=5'b11101;
			`S_Type:	{ImmSrc,ALUSrc,MemWrite}=5'b00111;
			`J_Type:	{ResultSrc,ImmSrc,RegWrite,Jump}=7'b1001011;
			`B_Type:begin 
				{Branch,ImmSrc}=4'b1011;
				case(func3)
					`beq:	ALUControl=3'b001;
					`bne:	ALUControl=3'b001;
					`blt:	ALUControl=3'b101;
					`bge:	ALUControl=3'b101;
				endcase
				end
			`U_Type:	{ResultSrc,ImmSrc,RegWrite}=6'b111001;
		endcase
	end
endmodule
