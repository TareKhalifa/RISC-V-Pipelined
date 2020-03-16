`timescale 1ns / 1ps
/*******************************************************************
*
* Module: RISCV.v
* Project: RISC-V CPU
* Author: Nada, Omar and Tarek
* Description: The top level module containing all the modules
* Change history:
* 8/7/19 - We edited the Module to add forwarding
* 7/7/19 - We edited the Module to add the hazard detection unit
* 6/7/19 - We edited the Module to add the rest of the modules and wiring
**********************************************************************/
`timescale 1ns/1ns

module RISCV(
    input clk, 
    input rst, 
    input [1:0] ledSel, 
    input [3:0] ssdSel,
    output reg [15:0] leds, 
    output reg [12:0] ssd
);
    wire [31:0] PC_out, PCAdder_out, PC_in, 
        RegR1, RegR2, RegW, ImmGen_out, ALUSrcMux_out, 
        ALU_out,ALU1in,ALU2in,RFin;
    wire Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite,
    zf,cf,vf,sf,zeroFlag,halt;
    wire [1:0] ALUOp,forwardA,forwardB;
    wire [3:0] ALUSel;
    wire PCSrc,BranchYES;
    
    wire [31:0] IF_ID_PC, IF_ID_Inst, 
        ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, 
        EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, 
        MEM_WB_Mem_out, MEM_WB_ALU_out,MemoryInputt,
        inst_data,EX_MEM_IMM,MEM_WB_IMM,EX_MEM_PC,MEM_WB_PC,
        ID_EX_Inst,EX_MEM_Inst,EX_MEM_RegR1,RF_FINAL_INPUT,MEM_WB_Inst,
        MEM_WB_RegR1,MEM_WB_RegR2,CompressedInstOut,FinalInst,rfilea,rfileb;
        reg [31:0] BAAAA;
    wire [7:0] ID_EX_Ctrl,zerosControl;
    wire [4:0] EX_MEM_Ctrl,ID_EX_OP,IF_ID_OP,EX_MEM_OP;
    wire [1:0] MEM_WB_Ctrl;
    wire [3:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd, EX_MEM_Rd, MEM_WB_Rd,EXmemZeros,MEM_WB_OP;
    wire EX_MEM_Zero,B,compressedFlag,compressedFlagIDEX,compressedFlagEXMEM;
    reg hclk,stall;
    reg xyz;
    always @(posedge clk)
    begin
    hclk = xyz;
    xyz  = !hclk;
    end
    initial begin
    xyz = 1;
    stall = 0;
    end
    assign halt = (IF_ID_Inst[6:2] == 5'b11_100);

    RegWLoad PC(hclk,rst,!halt & !stall,PC_in,PC_out);
    RegWLoad #(65) IF_ID (clk,rst,!halt,
                            {PC_out,hclk?FinalInst:0,(inst_data[1:0]==2'b11)},
                            {IF_ID_PC,IF_ID_Inst,compressedFlag}
                            );
    RegWLoad #(195) ID_EX (clk,rst,!halt,
                            {zerosControl,
                                IF_ID_PC,RegR1,RegR2,ImmGen_out,
                                IF_ID_Inst[30],IF_ID_Inst[14:12],
                                IF_ID_Inst[19:15],IF_ID_Inst[24:20],IF_ID_Inst[11:7],IF_ID_Inst[6:2],
                                IF_ID_Inst,compressedFlag},
                            {ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,ID_EX_Imm,
                                ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd,ID_EX_OP,ID_EX_Inst,compressedFlagIDEX}
                            );
    RegWLoad #(221) EX_MEM (clk,rst,1'b1,
                            {ID_EX_Ctrl[7:3],zeroFlag,ALU_out,
                                ALU2in,ID_EX_Rd,ID_EX_OP,ID_EX_Imm,ID_EX_PC,ID_EX_Inst,
                               B?RF_FINAL_INPUT:ID_EX_RegR1,compressedFlagIDEX},
                            {EX_MEM_Ctrl,EX_MEM_Zero,EX_MEM_ALU_out,
                                EX_MEM_RegR2, EX_MEM_Rd,EX_MEM_OP,EX_MEM_IMM,EX_MEM_PC,EX_MEM_Inst,
                                EX_MEM_RegR1,compressedFlagEXMEM}
                            );
    RegWLoad #(239) MEM_WB (clk,rst,1'b1,
                            {EX_MEM_Ctrl[4:3],
                                !hclk?inst_data:0,EX_MEM_ALU_out,EX_MEM_Rd,EX_MEM_OP,EX_MEM_IMM,EX_MEM_PC,
                                EX_MEM_Inst,EX_MEM_RegR1,EX_MEM_RegR2},
                            {MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd,MEM_WB_OP,MEM_WB_IMM,MEM_WB_PC,MEM_WB_Inst,
                            MEM_WB_RegR1,MEM_WB_RegR2}
                            );
    ForwardingUnit F1(ID_EX_Rs1,ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd,EX_MEM_Ctrl[4],MEM_WB_Ctrl[1] ,forwardA,forwardB);
    Mux4_1 FWA (forwardA,ID_EX_RegR1,RF_FINAL_INPUT,EX_MEM_ALU_out,0,ALU1in); //forwarding mux
    Mux4_1 FWB (forwardB,ID_EX_RegR2,RF_FINAL_INPUT,EX_MEM_ALU_out,0,ALU2in); //forwarding mux for 2nd in
    RippleAdder IncPC(PC_out,4,1'b0,PCAdder_out,);  
    RegFile rf(clk,rst,RF_FINAL_INPUT,MEM_WB_Ctrl[1],IF_ID_Inst[19:15],IF_ID_Inst[24:20],MEM_WB_Rd,RegR1,RegR2);
    Mux2_1 #(8)  IDEXZEROS(PCSrc,{RegWrite,MemToReg,Branch,MemRead,MemWrite,ALUOp,ALUSrc},8'd0,zerosControl);
    Mux2_1 #(32) MemoryMuxout(hclk,(EX_MEM_ALU_out[9:0]+512),PC_out,MemoryInputt);
    Mux2_1 #(32) aluSrcBMux(ID_EX_Ctrl[0],ALU2in,ID_EX_Imm,ALUSrcMux_out);
    ALU ALUU(ALU1in,ALUSrcMux_out,ID_EX_Inst[5]?ID_EX_RegR2:ID_EX_Inst[24:20],ALUSel,ALU_out,cf,zf,vf,sf);
    SMem Smem1 (clk,hclk,rst,PC_out,EX_MEM_Ctrl[1],EX_MEM_Ctrl[0],MemoryInputt,
    EX_MEM_RegR2,inst_data[14:12],inst_data);
    Mux2_1 #(32) regWSrcMux(MEM_WB_Ctrl[0],MEM_WB_ALU_out,MEM_WB_Mem_out,RegW);
    Mux4_1 InstType (inst_data[1:0],CompressedInstOut,CompressedInstOut,
    CompressedInstOut,inst_data,FinalInst);
    Dic CompressPlease(inst_data,CompressedInstOut);
    ControlUnit cu(IF_ID_Inst[7:2],Branch,MemRead,MemToReg,ALUOp,MemWrite,ALUSrc,RegWrite);
    ALUControl acu(ID_EX_Ctrl[2:1],ID_EX_Func[2:0],ID_EX_Func[3],ALUSel);
    assign rfilea = ((EX_MEM_Ctrl[4]) & (EX_MEM_Inst[19:15]==IF_ID_Inst[19:15])&(IF_ID_Inst[19:15]!=0))?
    EX_MEM_RegR1:RegR1;
    assign rfileb = ((EX_MEM_Ctrl[4]) & (EX_MEM_Inst[24:20]==IF_ID_Inst[24:20])&(IF_ID_Inst[24:20]!=0))?
    EX_MEM_RegR2:RegR2;
    BCU branch1(IF_ID_Inst[14:12],rfilea,rfileb,zeroFlag); 
    RFControl RRFF(MEM_WB_OP,RegW,MEM_WB_IMM,MEM_WB_PC,RFin);
    PCControlUnit dsa(IF_ID_Inst,IF_ID_Inst[6:0],(Branch & zeroFlag),PC_out,IF_ID_PC,
    RegR1,ImmGen_out,PCSrc,PC_in,compressedFlag);
    RF_Input_MUX RFINPUTTTT(RF_FINAL_INPUT,MEM_WB_Inst[14:12],
    MEM_WB_Inst[2],MEM_WB_Inst[6:2],RFin);
    Gen ig(IF_ID_Inst,ImmGen_out);
    assign B =((EX_MEM_Ctrl[4]) && (EX_MEM_Rd == IF_ID_Inst[19:15]));
    always @(*)
    begin
    if((EX_MEM_Inst[6:2] == 0 && EX_MEM_Ctrl[1]) &
    ((EX_MEM_Inst[11:7] == IF_ID_Inst[19:15])||(EX_MEM_Inst[11:7] == IF_ID_Inst[24:20])) && Branch && clk)
    stall = 1;
    else if(hclk && stall)
    stall = 0;
    end
    always @(*) begin
        case(ledSel) 
            0: leds <= inst_data[15:0];
            1: leds <= inst_data[31:16];
            2: leds <= {forwardB, Branch, MemRead, MemToReg, ALUOp, MemWrite, 
                        ALUSrc, RegWrite,zeroFlag, PCSrc, ALUSel};
            default: leds <= 0;            
        endcase
        case(ssdSel)
            0: ssd <= PC_out[12:0];
            1: ssd <= PCAdder_out[12:0]; 
         // 2: ssd <= BranchAdder_out[12:0]; 
            3: ssd <= PC_in[12:0];
            4: ssd <= RegR1[12:0]; 
            5: ssd <= RegR2[12:0]; 
            6: ssd <= RegW[12:0]; 
            7: ssd <= ImmGen_out[12:0]; 
   //       8: ssd <= Shift_out[12:0];
            9: ssd <= ALUSrcMux_out[12:0]; 
            10: ssd <= ALU_out[12:0]; 
            //11: ssd <= Mem_out[12:0];
            default: ssd <= 0;
        endcase
    end
endmodule