`timescale 1ns / 1ps
/*******************************************************************
*
* Module: ALU.v
* Project: RISC-V CPU
* Author: Nada, Omar and Tarek
* Description: The ALU 
* Change history:
* 2/7/19 - We edited the Module
**********************************************************************/
module ALU(
	input   wire [31:0] a, b,
	input   wire [4:0]  shamt,
	input   wire [3:0]  alufn,
		output  reg  [31:0] r,
    output  wire cf, zf, vf, sf
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
    wire[31:0] sh;
    Shift1 shifter60(.a(a), .shamt(shamt),  .r(sh),.type(alufn[1:0]));
    
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            //arithmetic
            4'b00_00 : r = add;
            4'b00_01 : r = add;
            4'b00_10 : r = add;
            4'b00_11 : r = b;
            // logic
            4'b01_00:  r = a | b;
            4'b01_01:  r = a & b;
            4'b01_11:  r = a ^ b;
            // shift
            4'b10_00:  r=sh;
            4'b10_01:  r=sh;
            4'b10_10:  r=sh;
            // slt & sltu
            4'b11_01:  r = {31'b0,(sf != vf)}; 
            4'b11_11:  r = {31'b0,(~cf)};            	
        endcase
    end
endmodule
