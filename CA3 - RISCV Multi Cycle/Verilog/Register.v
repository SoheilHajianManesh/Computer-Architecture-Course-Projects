module Register(clk,in,out);
	input clk;
	input[31:0] in;
	output reg[31:0] out=32'b0;
	always@(posedge clk)
		out<=in;
endmodule

