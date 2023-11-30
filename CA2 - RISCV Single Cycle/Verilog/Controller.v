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



module Controller(input zero,branchLEG,input[2:0] func3,input[6:0] func7,op,output reg MemWrite,ALUSrc,RegWrite,output reg [1:0] pcSrc,ResultSrc,output reg [2:0] ALUControl,ImmSrc);
	wire[9:0] func;
	assign func={func7,func3};
	always@(func3,func7,op) begin
		{MemWrite,ALUSrc,RegWrite,pcSrc,ResultSrc,ALUControl,ImmSrc}=13'b0000_0000_0000_0;
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
			`Lw:begin	
					ALUSrc = 1'b1;
					ResultSrc=1'b1;
					RegWrite=1'b1;
			end
			`I_Type:begin
				ALUSrc=1'b1;
				case(func3)					
					`addi:;
					`xori:ALUControl=3'b100;
					`ori :ALUControl=3'b011;
					`slti:ALUControl=3'b101;
				endcase
				RegWrite=1'b1;
				end
			`Jalr:begin 
				pcSrc=2'b10;
				ALUSrc=1'b1;
				ResultSrc=2'b10;
				RegWrite=1'b1;

			end
			`S_Type:begin
					ResultSrc=2'bxx;
					ImmSrc=3'b001;
					ALUSrc=1'b1;
					MemWrite=1'b1;
				end
			`J_Type:begin
					pcSrc=2'b01;
					ResultSrc=2'b10;
					ALUControl=3'bxxx;
					ALUSrc=1'bx;
					ImmSrc=3'b010;
					RegWrite=1'b1;
				end
			`B_Type:begin 
					ResultSrc=2'bxx;
					ImmSrc=3'b011;
				case(func3)
					`beq:begin
						ALUControl=3'b001;
						pcSrc= zero ? 01 : 00;
					end
					`bne:begin
						ALUControl=3'b001;
						pcSrc= zero ? 00 : 01;
					end
					`blt:begin
						ALUControl=3'b101;
						pcSrc= branchLEG ? 01 : 00;
					end
					`bge:begin
						ALUControl=3'b101;
						pcSrc= branchLEG ? 00 : 01;
					end
				endcase
				end
			`U_Type:begin
					ResultSrc=2'b11;
					ALUControl=3'bxxx;
					ALUSrc=1'bx;
					ImmSrc=3'b100;
					RegWrite=1'b1;
				end
			default:;
		endcase
	end
endmodule
