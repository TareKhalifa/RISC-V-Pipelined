`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Mux2_1.v
* Project: RISC-V CPU
* Author: Nada, Omar and Tarek
* Description: 2x1 mux
* Change history:
* 8/7/19 - We edited the Module
**********************************************************************/
`timescale 1ns/1ns

module Mux2_1 (
    sel,
    in1,
    in2,
    out
);
    parameter N=1;
    output [N-1:0] out;
    input [N-1:0] in1, in2;
    input sel;
    
    assign out = (sel)?in2:in1;
endmodule

