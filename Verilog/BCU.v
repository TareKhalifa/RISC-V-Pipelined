`timescale 1ns / 1ps
/*******************************************************************
*
* Module: BCU.v
* Project: RISC-V CPU
* Author: Nada, Omar and Tarek
* Description: The branch control unit
* Change history:
* 2/7/19 - We edited the Module
**********************************************************************/

module BCU(
input [2:0] f3,
input [31:0] a,
input [31:0] b,
output out
);
wire cf,zf,sf,vf;
wire [31:0] add,op_b;
assign op_b = (~b);
assign {cf, add} =(a + op_b + 1'b1);

assign zf = (add == 0);
assign sf = add[31];
assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
wire Beq,Bne,Blt,Bge,Bltu,Bgeu;
assign Beq = (zf==1);
assign Bne = (zf==0);
assign Bltu = (cf==0);
assign Bgeu = (cf==1);
assign Blt = (sf!=vf);
assign Bgt = (sf==vf);
assign out = (f3==0)?Beq:(f3==1)?Bne:(f3==4)?Blt:(f3==5)?Bge:(f3==6)?Bltu:(f3==7)?Bgeu:0;
endmodule

