`timescale 1ns / 1ps
/*******************************************************************
*
* Module: ControlUnit.v
* Project: RISC-V CPU
* Author: Nada, Omar and Tarek
* Description: The control unit
* Change history:
* 2/7/19 - We edited the Module
**********************************************************************/
module ControlUnit(input [4:0] inst, output Branch,output MemRead, output MemReg, output [1:0] ALUOp,output MemWrite,output ALUSrc,output RegWrite);
assign Branch = (inst==12)? 0:(inst==0)?0:(inst==8)?0:(inst==24)?1:0;
assign MemRead = (inst==12)? 0:(inst==0)?1:(inst==8)?0:0;
assign MemReg = (inst==12)? 0:(inst==0)?1:(inst==8)?0:0;
assign ALUOp = (inst==12 | inst==4)? 2:(inst==0)?0:(inst==8)?0:(inst==24)?1:0;
assign MemWrite = (inst==12)? 0:(inst==0)?0:(inst==8)?1:0;
assign ALUSrc = (inst==12)? 0:(inst==0)?1:(inst==8)?1:(inst==4)?1:(inst[0]==1)?1:0;
assign RegWrite = (inst==24)?0:(inst==8)?0:1;
endmodule