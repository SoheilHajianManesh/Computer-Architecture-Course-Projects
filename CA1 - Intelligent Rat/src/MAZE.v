
module MazeMemory(input clk,rst,Din,RD,WR,input [3:0]X,Y,output reg Dout);
	reg [0:15] Maze[0:15];
	reg[0:15] row;
	initial $readmemh("map.txt",Maze);
	reg[0:15] first_row;
	assign first_row=Maze[0];
	assign first_row[0]=1;
	assign Maze[0]=first_row;
	
	always @(posedge rst or posedge clk) begin
		if(rst)
				$readmemh("map.txt",Maze);
		else if(WR) begin
		row = Maze[Y];
		row[X] = Din;
		Maze[Y] = row;
		end
	end
	always@(RD,X,Y)begin
		if(RD)begin
			if(X==4'bx || Y==4'bx)
				Dout=1;
			else begin 
				row = Maze[Y];
				Dout = row[X];
			end
		end
		else Dout=1'bz;
	end	
endmodule