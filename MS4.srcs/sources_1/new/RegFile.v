// file: RegFile.v
// author: @cherifsalama

`timescale 1ns/1ns
module RegFile(input clk,
input rst,
input [31:0] writeData,
input writeFlag1,
input [4:0] rs1,
input [4:0] rs2,
input [4:0] writeRegister,
output [31:0] out1,
output [31:0] out2);
wire [31:0] Register [0:31];
wire [31:0] load;
wire writeFlag;
assign writeFlag = (writeRegister==0)?0:writeFlag1;
assign load =writeFlag? 1<<writeRegister:0;
genvar i;
generate 
for(i = 0; i<32; i=i+1)
begin
Register32 LLL(writeData,clk,rst,load[i], Register[i]);
end
endgenerate
assign out1 = Register[rs1];
assign out2 = Register[rs2];
endmodule

