	
	`define UP		2'd0
	`define RIGHT 		2'd1
	`define LEFT		2'd2
	`define DOWN		2'd3


	`define BEGIN		4'b0000 
	`define COUNTING	4'b0001
	`define MOVE 		4'b0010
	`define CHECKING_NULL	4'b0011
	`define CHECKING_WALL 	4'b0100
	`define ACCEPT_MOVE	4'b0101
	`define POPPING	        4'b0110
	`define BACK_TRACK	4'b0111
	`define LOAD_COUNTER	4'b1000
	`define LOADING		4'b1001
	`define WAITING		4'b1010
	`define	SHOW		4'b1011

		
	
module controller(input clk,start,run,Dout,done,err,rst,null,input[1:0]poped,direction,output reg en,RD,ldx,ldy,WR,Din,ld,pop,push,back,show,reset_direction,move,sel,qpop);
	reg [3:0] ps,ns;
	always @(posedge clk) begin
		if(rst)
		ps <= 4'b0000;
		else
		ps <= ns;
	end
	always @(ps,start,run,Dout,done,err,rst,null) begin
		{en,RD,ldx,ldy,WR,Din,ld,pop,push,back,show,reset_direction,move,sel,qpop}=15'b000_0000_0000_0000;
		case(ps)
		`BEGIN:		;
		`COUNTING:begin
				{ld,push,WR,Din,RD,reset_direction}=7'b_000_0000;
				en=done?0:1;
			end
		`MOVE:begin 
				move=1;
				en=0;
			end
		`CHECKING_NULL:	move=0;
		`CHECKING_WALL:		RD=1;
		`ACCEPT_MOVE:begin
				RD=0;				
				{ldx,ldy,push,WR,Din}=5'b11111;
				reset_direction=1;
			end
		`POPPING:begin
				RD=0;
				pop=1;
			end
		`BACK_TRACK:begin
				pop=0;
				back=1;
				sel=1;
			end
		`LOADING:begin
				sel=1;
				{ldx,ldy}=2'b11;
			end
		`LOAD_COUNTER:begin 
				back=0;
				{ldx,ldy}=2'b00;
				ld=1;
			end
		`WAITING:	;
		`SHOW:		{qpop,show}=2'b11;
		endcase
	end
	always @(ps,start,run,Dout,done,rst,null) begin
		case(ps)
		`BEGIN:		ns=start?`COUNTING:`BEGIN;
		`COUNTING:	ns=rst?`BEGIN:done?`WAITING:`MOVE;
		`MOVE:		ns=rst?`BEGIN:`CHECKING_NULL;
		`CHECKING_NULL:	ns=rst?`BEGIN:(null&&direction==`DOWN)?`POPPING:null?`COUNTING:`CHECKING_WALL;
		`CHECKING_WALL:	ns=rst?`BEGIN:(Dout==0)?`ACCEPT_MOVE:(Dout==1&&direction==`DOWN)?`POPPING:`COUNTING;
		`ACCEPT_MOVE:	ns=rst?`BEGIN:`COUNTING;		
		`POPPING:	ns=rst?`BEGIN:`BACK_TRACK;
		`BACK_TRACK:	ns=rst?`BEGIN:`LOADING;
		`LOADING:	ns=rst?`BEGIN:`LOAD_COUNTER;
		`LOAD_COUNTER:	ns=rst?`BEGIN:(poped==`DOWN)?`POPPING:`COUNTING;	
		`WAITING:	ns=rst?`BEGIN:run?`SHOW:`WAITING;
		`SHOW:		ns=(rst || err)? `BEGIN :`SHOW;
		endcase
	end
endmodule

