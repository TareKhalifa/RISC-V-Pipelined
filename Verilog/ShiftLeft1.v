`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2019 10:57:55 AM
// Design Name: 
// Module Name: Shift1
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
module Shift1(input [31:0] a,input [4:0]  shamt,input [1:0]type,output reg  [31:0] r);
   always @ * begin
        case (type)
            2'b00: r <= (a>>shamt);
            2'b01: r <= (a<<shamt);
            2'b10: r<= ($signed(a)>>>shamt);
        endcase
    end
endmodule

