`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2019 07:20:40 PM
// Design Name: 
// Module Name: Dic
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

module Dic(input [15:0] comp_Inst /*input [1:0] OP, C_Fun2,C_Fun2_R_Form,input [2:0] C_Fun3,input [4:0] C_Fun4, C_Fun5*/,output reg [31:0] Inst);

always @ (*) begin
case (comp_Inst[`OP]) 

2'b00: 
    case (comp_Inst[`C_Fun3])
        3'b010: Inst = {5'b00000,comp_Inst[5],comp_Inst[12:10],comp_Inst[6],2'b00,2'b00,comp_Inst[9:7],3'b010,2'b00,comp_Inst[4:2],`OPCODE_Load,2'b11}; //lw
        3'b110: Inst = {5'b00000,comp_Inst[5],comp_Inst[12],2'b00,comp_Inst[4:2],2'b00,comp_Inst[9:7],3'b010,comp_Inst[11:10],comp_Inst[6],2'b00,`OPCODE_Store,2'b11};//Sw
            endcase

2'b01:
 case (comp_Inst[`C_Fun3])
       3'b000: Inst = {6'b000000,comp_Inst[12],comp_Inst[6:2],comp_Inst[11:7],3'b000,comp_Inst[11:7],`OPCODE_Arith_I,2'b11}; //Addi
       3'b001: Inst = {comp_Inst[12],comp_Inst[8],comp_Inst[10:9],comp_Inst[6],comp_Inst[7],comp_Inst[2],comp_Inst[11],comp_Inst[5:3],comp_Inst[12],8'b00000000,5'b00001,`OPCODE_JAL,2'b11};//Jal
       3'b011: Inst = {14'b00000000000000,comp_Inst[12],comp_Inst[6:2],comp_Inst[11:7],`OPCODE_LUI,2'b11};//Lui
      
        3'b100:
            case (comp_Inst[`C_Fun2])
              2'b00: Inst = {7'b0000000,comp_Inst[6:2],2'b00,comp_Inst[9:7],3'b101,2'b00,comp_Inst[9:7],`OPCODE_Arith_I,2'b11};//Srli
              2'b01: Inst = {7'b0100000,comp_Inst[6:2],2'b00,comp_Inst[9:7],3'b101,2'b00,comp_Inst[9:7],`OPCODE_Arith_I,2'b11};//Srai
              2'b10: Inst = {7'b0000000,comp_Inst[12],comp_Inst[6:2],2'b00,comp_Inst[9:7],3'b111,2'b00,comp_Inst[9:7],`OPCODE_Arith_I,2'b11};//Andi

        2'b11:
            case (comp_Inst[`C_Fun2_R_Form])
               2'b00: Inst = {7'b0100000,2'b00,comp_Inst[4:2],2'b00,comp_Inst[9:7],3'b000,2'b00,comp_Inst[9:7],`OPCODE_Arith_R,2'b11}; //Sub
               2'b01: Inst = {7'b0000000,2'b00,comp_Inst[4:2],2'b00,comp_Inst[9:7],3'b100,2'b00,comp_Inst[9:7],`OPCODE_Arith_R,2'b11};//Xor
               2'b10: Inst = {7'b0000000,2'b00,comp_Inst[4:2],2'b00,comp_Inst[9:7],3'b110,2'b00,comp_Inst[9:7],`OPCODE_Arith_R,2'b11};//Or
               2'b11: Inst = {7'b0000000,2'b00,comp_Inst[4:2],2'b00,comp_Inst[9:7],3'b111,2'b00,comp_Inst[9:7],`OPCODE_Arith_R,2'b11};//And
endcase
endcase
endcase
2'b10: case (comp_Inst[`C_Fun3])
       3'b000: Inst = {7'b0000000, comp_Inst[12], comp_Inst[6:2],comp_Inst[11:7],3'b001, comp_Inst[11:7],`OPCODE_Arith_I,2'b11};//Slli
      
3'b100: case (comp_Inst[6:2])
       0: case (comp_Inst[11:7])
          
          0 : Inst= {{11{0}},1'b1,{13{0}},`OPCODE_SYSTEM,2'b11};  //Ebreak
          
          default:
             Inst = {{12{0}},comp_Inst[11:7],3'b000,5'b00001,`OPCODE_JALR, 2'b11}; //Jalr
          endcase
       
       default: 
       Inst ={7'b0000000,2'b00,comp_Inst[4:2],2'b00,comp_Inst[9:7],3'b000,2'b00,comp_Inst[9:7],`OPCODE_Arith_R,2'b11}; //Add  
       endcase


endcase
endcase

end

endmodule

