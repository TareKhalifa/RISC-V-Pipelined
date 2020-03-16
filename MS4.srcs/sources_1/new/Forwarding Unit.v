`timescale 1ns / 1ps
/*******************************************************************
*
* Module: ForwardingUnit.v
* Project: RISC-V CPU
* Author: Nada, Omar and Tarek
* Description: The forwarding unit that forwards the operands to the ALU when needed
* Change history:
* 8/7/19 - We edited the Module
**********************************************************************/
module ForwardingUnit(
input [4:0]ID_EX_Rs1, 
input [4:0]ID_EX_Rs2, 
input [4:0]EX_MEM_Rd, 
input [4:0]MEM_WB_Rd,
input EX_MEM_RegWrite, 
input MEM_WB_RegWrite,
output reg [1:0] forwardA,
output reg [1:0] forwardB
    );
wire w1;
assign w1 = (EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs1));
wire w2;
assign w2 = (EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs2));
always @(*) begin
if(EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs1))
    forwardA <= 2'b10;
else if (MEM_WB_RegWrite && (MEM_WB_Rd!=0) && (MEM_WB_Rd == ID_EX_Rs1) && (!w1))
        forwardA <= 2'b01;
else  forwardA <= 2'b00;
if(EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs2))
    forwardB <= 2'b10;    
else if (MEM_WB_RegWrite && (MEM_WB_Rd!=0) && (MEM_WB_Rd == ID_EX_Rs2) && (!w2))
    forwardB <= 2'b01;
else  forwardB <= 2'b00;
end
endmodule
