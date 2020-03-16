`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2019 10:55:43 AM
// Design Name: 
// Module Name: Register32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module Register32(input [31:0] in,input clk,input rst,input load, output [31:0] Q);
wire [31:0] D;
genvar i;
generate
for(i = 0; i<32; i=i+1)
begin
Mux2 m(Q[i],in[i],load,D[i]);
DUFF d (clk,rst,D[i],Q[i]);
end
endgenerate
endmodule
