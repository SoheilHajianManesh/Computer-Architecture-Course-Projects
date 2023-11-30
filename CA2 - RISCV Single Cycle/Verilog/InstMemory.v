module InstMemory (input[31:0] A,output[31:0] RD); 

    reg [31:0] instMem [0:16383];

    wire [31:0] adr;
    assign adr = {2'b00,A[31:2]}; 

    initial $readmemh("inst_memory.txt", instMem);
    assign RD=instMem[adr];
endmodule
