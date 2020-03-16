
`timescale 1ns / 1ps
/*******************************************************************
*
* Module: RFMux.v
* Project: RISC-V CPU
* Author: Nada, Omar and Tarek
* Description: The RF control unit
* Change history:
* 2/7/19 - We edited the Module
**********************************************************************/
module RFControl(input [4:0] opcode,
input [31:0] dataIn, 
input [31:0] imm, 
input [31:0] PC, 
output [31:0] out);
assign out = (opcode[0]==0)?dataIn:
(opcode == 5'b11_001)?(PC+4):(opcode == 5'b11_011)?(PC+4):
(opcode == 5'b01_101)?imm:(opcode == 5'b00_101)?(PC+imm):0;
endmodule