`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2019 10:11:10 PM
// Design Name: 
// Module Name: RF_Input_MUX
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


module RF_Input_MUX(
output [31:0] RF_FINAL_INPUT,
input [2:0] MEM_WB_Inst1412,
input MEM_WB_Inst2,
input MEM_WB_Inst62,
input [31:0] RFin
    );
    
 assign RF_FINAL_INPUT = (MEM_WB_Inst1412==0 && MEM_WB_Inst2==0)?{{24{RFin[7]}},RFin[7:0]}:
(MEM_WB_Inst1412==1 && MEM_WB_Inst2==0)?{{16{RFin[15]}},RFin[15:0]}:(MEM_WB_Inst1412==2 && MEM_WB_Inst2==0)?RFin:
(MEM_WB_Inst1412==4 && MEM_WB_Inst2==0)?{{24{1'b0}},RFin[7:0]}:(MEM_WB_Inst1412==5 && MEM_WB_Inst2==0)?{{16{1'b0}},RFin[15:0]}:
(( MEM_WB_Inst2 == 1) || MEM_WB_Inst62 == 12)?RFin:RFin;
endmodule
