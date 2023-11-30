module Register_en (clk,en,in,out);
  input clk;
  input en;
  input [31:0] in;
  output reg [31:0] out = 32'b0;

  always @(posedge clk) begin
    if (en) 
      out <= in;
  end

endmodule