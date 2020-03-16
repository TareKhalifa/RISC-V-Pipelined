`timescale 1ns / 1ps
/*******************************************************************
*
* Module: PCControlUnit.v
* Project: RISC-V CPU
* Author: Nada, Omar and Tarek
* Description: The PC control unit
* Change history:
* 2/7/19 - We edited the Module
**********************************************************************/
module PCControlUnit(input [31:0] instruction,
input [4:0] opcode,
input branch,
input [31:0]PC,
input [31:0] PCB, 
input [31:0] rs1, 
input[31:0] imm, 
output yesbranch,
output reg[31:0]  out,
input compflag
);
always @* begin
if(branch)
    out <= PCB+imm;
else if(opcode[0]==0)
begin
    if(compflag)
    out<=PC+4;
    else  out<=PC+2;
    end
else begin
    if(opcode == 7'b11_001)
        out<=imm+rs1;
    else if (opcode == 5'b11_011)
        out<= PCB+imm;
    else 
    begin
    if(compflag)
    out<=PC+4;
    else  out<=PC+2;
    end
end
end
assign yesbranch = (branch | (opcode == 5'b11_001) | (opcode == 5'b11_011));
endmodule