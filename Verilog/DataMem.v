`timescale 1ns / 1ps
/*******************************************************************
*
* Module: PCControlUnit.v
* Project: RISC-V CPU
* Author: Nada, Omar and Tarek
* Description: The single byte addressable memory for both instructions and data
* Change history:
* 8/7/19 - We edited the Module
**********************************************************************/
`timescale 1ns/1ns
module SMem(
input clk,
input hclk,
input rst,
input [31:0] PC,
input MemRead, 
input MemWrite,
input [9:0] addr,
input [31:0] data_in, 
input [2:0] fun3,
output reg [31:0] data_out);
reg [7:0] mem [0:1023];
 reg temp;
 integer i;
 initial begin
 for(i =0; i<1024; i=i+1)
    mem[i] = 0;
 end
always @(negedge hclk) begin
temp=1;
end
    always @(posedge rst)
    begin
        //inst
        $readmemh("C:/Users/Tarekelsayed/Tests/j.hex", mem);
     /*  {mem[3],mem[2],mem[1],mem[0]}=32'b0_000000_00000_00000_000_1110_0_1100011; //beq x4, x3, 4
               {mem[7],mem[6],mem[5],mem[4]}=32'b00000000_11010100_10110010_00110011 ; //sltu x4,x9,x13
               {mem[11],mem[10],mem[9],mem[8]}=32'b00000111_10110100_10110010_00010011_ ; //sltiu x4,x9,123  
               {mem[15],mem[14],mem[13],mem[12]}=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
               {mem[19],mem[18],mem[17],mem[16]}=32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 4
               {mem[23],mem[22],mem[21],mem[20]}=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
               {mem[27],mem[26],mem[25],mem[24]}=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
               {mem[31],mem[30],mem[29],mem[28]}=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
               {mem[35],mem[34],mem[33],mem[32]}=32'b00000000_00000000_00000101_00110111; //lui x10, 0x87654
               {mem[39],mem[38],mem[37],mem[36]}=32'b00000000_00000000_00000101_00010111 ; //auipc x10, 0
               {mem[43],mem[42],mem[41],mem[40]}=32'b00000000_00100000_00000101_10010011; //addi x11,x0,2
               {mem[47],mem[46],mem[45],mem[44]}=32'b00000111_10110100_11110010_00010011 ; //andi x4,x9,123  
               {mem[51],mem[50],mem[49],mem[48]}=32'b00000000_11000010_11100001_00010011 ; //ori x2,x5,12  
               {mem[55],mem[54],mem[53],mem[52]}=32'b00000001_10110001_11000000_10010011 ; //xori x1,x3,27  
               {mem[59],mem[58],mem[57],mem[56]}=32'b00000000_11010100_11000010_00110011 ; //xor x4,x9,x13  
               {mem[63],mem[62],mem[61],mem[60]}=32'b00000000_01010101_00010010_00010011; //slli x4,x10,5
               {mem[67],mem[66],mem[65],mem[64]}=32'b00000000_11010100_10010010_00110011; //sll x4,x9,x13
               {mem[71],mem[70],mem[69],mem[68]}=32'b00000000_01010011_11010001_00010011; //srli x2,x7,5
               {mem[75],mem[74],mem[73],mem[72]}=32'b00000000_11010101_11010011_00110011; //srl x6,x11,x13
               {mem[79],mem[78],mem[77],mem[76]}=32'b01000000_01010010_11010001_00010011; //srai x2,x5,5  
               {mem[83],mem[82],mem[81],mem[80]}=32'b01000000_11010100_11010100_00110011; //sra x8,x9,x13
               {mem[87],mem[86],mem[85],mem[84]}=32'b00000000_10110100_10100010_00110011; //slt x4,x9,x11
               {mem[91],mem[90],mem[89],mem[88]}=32'b00010011_00000111_11000011_10100001; //slti x2,x7,124
               {mem[95],mem[94],mem[93],mem[92]}=32'b00000000_00000000_00100000_10000011 ; //lw x1,0(x0)
               {mem[99],mem[98],mem[97],mem[96]}=32'b000000010100_00000_100_00001_0000011 ; //lbu x1, 20(x0)
               {mem[103],mem[102],mem[101],mem[100]}=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
               {mem[107],mem[106],mem[105],mem[104]}=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
               {mem[111],mem[110],mem[109],mem[108]}=32'b00000000_01000000_00000110_00100011; //sb x4,12(x0)
               {mem[115],mem[114],mem[113],mem[112]}=32'b00000000_01100000_00010110_00100011; //sh x6,12(x0)
               {mem[119],mem[118],mem[117],mem[116]}=32'b00000000_10010010_00010100_01100011; //bne x4,x9,4  
               {mem[123],mem[122],mem[121],mem[120]}=32'b00000000_10110001_01000100_01100011; //blt x2,x11,4
               {mem[127],mem[126],mem[125],mem[124]}=32'b00000000_01110011_01010100_01100011; //bge x6,x7,4
               {mem[131],mem[130],mem[129],mem[128]}=32'b00000000_10010010_01100100_01100011; //bltu x4,x9,4  
               {mem[135],mem[134],mem[133],mem[132]}=32'b00000000_11010001_01110100_01100011; //bgeu x2,x13,4
               {mem[139],mem[138],mem[137],mem[136]}=32'b00000000_11000000_00000010_00000011; //lb x4,12(x0)            
               {mem[143],mem[142],mem[141],mem[140]}=32'b00000000_11000000_00010001_00000011; //lh x2,12(x0)  
               {mem[147],mem[146],mem[145],mem[144]}=32'b00000000_01000000_00000000_11101111; //jal x1,2
               {mem[151],mem[150],mem[149],mem[148]}=32'b00000000_01000000_00000000_11101111; //jal x1,2
               {mem[155],mem[154],mem[153],mem[152]}=32'b00000000_10000000_10000000_01100111; //jalr x0,x1,4
               {mem[159],mem[158],mem[157],mem[156]}=32'b00000000_10000000_10000000_01100111; //jalr x0,x1,4
               {mem[163],mem[162],mem[161],mem[160]}=32'b000000000001_00000_000_00000_1110011; //halt*/


    //data
      mem[512]=8'd1;
      mem[513]=8'd0 ;
      mem[514]=8'd0;
      mem[515]=8'd0;
      mem[516]=8'd2;
      mem[517]=8'd0;
      mem[518]=8'd0;
      mem[519]=8'd0;
      mem[520]=8'd25;
      mem[521]=8'd0;
      mem[522]=8'd0;
      mem[523]=8'd0;
      mem[524]=8'd5;
      mem[525]=8'd0;
      mem[526]=8'd0;
      mem[527]=8'd0;
      mem[528]=8'd255;
      mem[529]=8'd0;
      mem[530]=8'd0;
      mem[531]=8'd0;
      mem[532]=8'd15;
      mem[533]=8'd0;
      mem[534]=8'd0;
      mem[535]=8'd0;
      data_out = {mem[3],mem[2],mem[1],mem[0]};
      temp = 0;
  end
 always @(posedge clk)
 begin
     if (MemWrite)
     begin
         if(fun3==2)
         begin
         mem[addr] <= data_in[7:0];
         mem[addr+1] <= data_in[15:8];
         mem[addr+2] <= data_in[23:16];
         mem[addr+3] <= data_in[31:24];
         end
     if(fun3==1)
     begin
         mem[addr] <= data_in[7:0];
         mem[addr+1] <= data_in[15:8];
     end
      if(fun3==0)
        mem[addr] <= data_in[7:0];
     end
 end
 always @(*) begin
 if(temp==0)data_out = {mem[3],mem[2],mem[1],mem[0]};
 else if (hclk)
    data_out = {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};
 else if(!MemRead)
    data_out = 0; 
else  data_out = {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};
 end
endmodule
