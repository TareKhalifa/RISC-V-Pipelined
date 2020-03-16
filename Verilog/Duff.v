`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2019 10:56:44 AM
// Design Name: 
// Module Name: DUFF
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
module DUFF(input clk, input rst, input D, output reg Q);
 always @ (posedge clk or posedge rst)
 if (rst)
 Q <= 1'b0;
 else begin
 Q <= D;
 end
endmodule
