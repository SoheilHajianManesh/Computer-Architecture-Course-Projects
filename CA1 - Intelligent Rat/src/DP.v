`define UP	2'b00
`define RIGHT 	2'b01
`define DOWN 	2'b10
`define LEFT 	2'b11
	


module Stack(input reg clk, rst , push , pop, qpop , input reg [1:0] value_in , output reg err,output reg [1:0] value_out);
	parameter WIDTH = 1;
	parameter DEPTH = 255;

	reg [WIDTH:0] stack [0:DEPTH];
	reg [7:0] size;
	reg [7:0] qpop_num;

	always @(posedge clk) begin
		if(rst)begin
			size <= 0;
			err<=0;
			qpop_num<=0;

		end
		
		else if (push) begin
			err=0;
			if(size == DEPTH+1)
				err<=1;
			else begin
				size<= size+1;
				stack[size]<= value_in;
			end
		end
		else if (pop)begin
			if(size==0)
				err<=1;
			else begin
				err=0;
				value_out = stack[qpop_num + size-1];
				stack[qpop_num + size-1]=2'bz ;
				size= size-1;
			end
		end
		else if (qpop)begin
			if(size==0)
				err<=1;
			else begin
				err=0;
				value_out = stack[qpop_num];
				stack[qpop_num]=2'bz ;
				size = size-1;
				qpop_num = qpop_num+1;
			end
		end
	end
endmodule

module counter(input clk,rst,ld,en,reset_direction,input[1:0] Pi,output[1:0] count);
	reg[1:0] upCounter;
	always@(posedge clk,posedge rst)begin 
		if(rst||reset_direction)
			upCounter<=2'b11;
		if(ld)
			upCounter<=Pi;
		if(en)
			upCounter<=upCounter+1;	
	end
	assign count=upCounter;
endmodule
module add_sub(input move,input [3:0]x,y,input[1:0]direction,output reg null,output reg[3:0] newx,newy);
	reg [3:0] newx_,newy_;
	always@(x,y,direction,move) begin
			case(direction)
				`UP:begin 
					if(y==0)begin
						null=1;
						newx_=x;
						newy_=y;
					end
					else begin
						null=0;
						newy_=y-1;
						newx_=x;
					end
				 end
				`RIGHT:begin 
					if(x==15)begin
						null=1;
						newx_=x;
						newy_=y;
					end
					else begin
						null=0;
						newy_=y;
						newx_=x+1;
					end
				 end
				`DOWN:begin 
					if(y==15)begin
						null=1;
						newx_=x;
						newy_=y;
					end
					else begin
						null=0;
						newy_=y+1;
						newx_=x;
					end
				 end
				`LEFT:begin 
					if(x==0)begin
						null=1;
						newx_=x;
						newy_=y;
					end
					else begin
						null=0;
						newy_=y;
						newx_=x-1;
					end	
				 end
			endcase
	end
	assign newx=move?newx_:newx;
	assign newy=move?newy_:newy;
endmodule 

module backTracker(input back,input[1:0] poped,input[3:0] x,y,output reg[3:0] newx,newy);
	always@(back) begin
			case(poped)
				`UP:begin 
						newy=y+1;
						newx=x;
				end
				`RIGHT:begin
						newy=y;
						newx=x-1;
				 end
				`DOWN:begin 
						newy=y-1;
						newx=x;
				 end
				`LEFT:begin 
						newy=y;
						newx=x+1;
				 end
			endcase
	end
endmodule

module Xreg(input clk,rst,ldx,input[3:0]Pi,output fullx,output [3:0] Po);
	reg[3:0]	current_x=0;
	always@(posedge clk,posedge rst)begin
		if(rst)
			current_x<=4'b0000;
		else
			current_x<=ldx?Pi:current_x;
	end
	assign Po=current_x;
	assign fullx=&Po;
endmodule

module Yreg(input clk,rst,ldy,input[3:0]Pi,output fully,output reg[3:0] Po);
	reg[3:0] 	current_y=0;
	always@(posedge clk,posedge rst)begin
		if(rst)
			current_y<=4'b0000;
		else
			current_y<=ldy?Pi:current_y;
	end
	assign Po=current_y;
	assign fully=&Po;
	
endmodule

module show(input show,input [1:0]direction_to_show,output reg [1:0]Move);
	assign Move=show?direction_to_show:2'bz;
endmodule

module MUX2to1(input [3:0] bt,as,input sel,output [3:0]new);
	assign new = sel ? bt : as;
endmodule
module datapath(input clk,rst,ldx,ldy,ld,en,push,pop,back,show,reset_direction,move,sel,qpop,output fail,done,null,err,output [1:0]direction,poped,Move,output [3:0]newx,newy);
	wire[3:0] x,y;
	wire fullx,fully;
	wire[3:0]xas,xbt,yas,ybt;
	Xreg X(clk,rst,ldx,newx,fullx,x);
	Yreg Y(clk,rst,ldy,newy,fully,y);
	assign done=fullx&fully;
	assign fail=err&&~done;
	MUX2to1 MUX2to1x(xbt,xas,sel,newx);
	MUX2to1 MUX2to1y(ybt,yas,sel,newy);
	counter C(clk,rst,ld,en,reset_direction,poped,direction);
	Stack	S1(clk,rst,push,pop,qpop,direction,err,poped);
	add_sub	A(move,x,y,direction,null,xas,yas);
	backTracker B(back,poped,x,y,xbt,ybt);	
	show	SH(show,poped,Move);
	
endmodule






















