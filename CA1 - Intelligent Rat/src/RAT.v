module intelligent_rat(input CLK,RST,Start,Run,Dout,output Fail,Done,Din,RD,WR,output[1:0] Move,output[3:0]X,Y);
	wire ldx,ldy,ld,en,push,pop,qpop,move,back,show,null,reset_direction,err,sel;
	wire [1:0]poped,direction;
	datapath	DP(CLK,RST,ldx,ldy,ld,en,push,pop,back,show,reset_direction,move,sel,qpop,Fail,Done,null,err,direction,poped,Move,X,Y);
	controller	CTRL(CLK,Start,Run,Dout,Done,err,RST,null,poped,direction,en,RD,ldx,ldy,WR,Din,ld,pop,push,back,show,reset_direction,move,sel,qpop);
endmodule

