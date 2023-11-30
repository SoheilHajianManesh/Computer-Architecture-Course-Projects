`timescale 1ns/1ns
module RAT();
	reg CLK=0,RST=0,Start=0,Run=0;
	wire [1:0] Move;
	wire Fail,Done,Din,RD,WR,Dout;
	wire [3:0] X,Y;
	always #1 CLK=~CLK;
	intelligent_rat		RAT1(CLK,RST,Start,Run,Dout,Fail,Done,Din,RD,WR,Move,X,Y);
	MazeMemory 	MEMORY(CLK,RST,Din,RD,WR,X,Y,Dout);
	initial begin
		
		#5 RST=1;
		#5 RST=0;
		#5 Start=1;
		#100000;
		Run=1;
		#100000;
		$stop;
	end
endmodule