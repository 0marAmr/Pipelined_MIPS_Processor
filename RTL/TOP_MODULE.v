module TOP_MODULE #(
    parameter DATA_WIDTH = 32,  
    parameter ADDRESS_WIDTH = 32, // Defines the number of bits for the memory address
    parameter INSTR_WIDTH = 32, // Defines the number of bits for the instruction
    parameter RF_ADDR_WIDTH = 5

)(
    input wire CLK,
    input wire RST
);


    wire [ADDRESS_WIDTH-1:0]    PCBranchD;
    wire [INSTR_WIDTH-1:0]      InstrF;
    wire [ADDRESS_WIDTH-1:0]    PCPlus4F;
    wire StallF;
    wire PCSrcD;
    wire JumpD;
    wire JumpRD;
    wire LoadD;
	wire BranchD;


    FETCH_STAGE U0_FET_ST(
        .i_CLK(CLK),
        .i_RST(RST),
        .i_PCNextD(PCNextD),
        .i_StallF(StallF),
        .i_PCSrcD(PCSrcD),
        .i_LoadD(LoadD),
        .o_InstrF(InstrF),
        .o_PCPlus4F(PCPlus4F)
    );
	

    wire StallD;
    wire [ADDRESS_WIDTH-1:0]    PCPlus4D;
    wire [INSTR_WIDTH-1:0]      InstrD;
    fetch_to_decode_reg U1_FET_TO_DEC(
        .i_CLK(CLK),
        .i_RST(RST),
        .i_n_EN(StallD),
        .i_CLR(PCSrcD),
        .i_PCPlus4F(PCPlus4F),
        .i_InstrF(InstrF),
        .o_PCPlus4D(PCPlus4D),
        .o_InstrD(InstrD),
    );
	
	
    wire [RF_ADDR_WIDTH-1:0] WriteRegW;
    wire RegWriteW;
    wire ForwardAD;
    wire ForwardBD;
    wire [DATA_WIDTH-1:0]       ALUOutM;
    wire [DATA_WIDTH-1:0]       ResultW;
    wire [DATA_WIDTH-1:0]       SrcAD;
    wire [DATA_WIDTH-1:0]       SrcBD;
    wire [DATA_WIDTH-1:0]       SignImmD;
    wire EqualD;
    wire GTZD;
    wire LTZD;
    wire LTEZD;
    wire [1:0] PC_SelD;
    wire [4:0]                  ShamtD;

    DECODE_STAGE U2_DEC_ST (
        .i_CLK(CLK),
        .i_RST(RST),
        .i_WriteRegW(WriteRegW),
        .i_RegWriteW(RegWriteW),
        .i_ForwardAD(ForwardAD),
        .i_ForwardBD(ForwardBD),
        .i_PC_SelD(PC_SelD),
        .i_InstrD(InstrD),
        .i_ALUOutM(ALUOutM),
        .i_ResultW(ResultW),
        .i_PCPlus4D(PCPlus4D),
        .o_SrcAD(SrcAD),
        .o_SrcBD(SrcBD),
        .o_SignImmD(SignImmD),
        .o_PCNextD(PCNextD),
        .o_EqualD(EqualD),
        .o_GTZD(GTZD),
        .o_LTZD(LTZD),
        .o_LTEZD(LTEZD),
        .o_ShamtD(ShamtD)
    );

    wire FlushE;
    wire [DATA_WIDTH-1:0]       SrcAE;
    wire [DATA_WIDTH-1:0]       SrcBE;
    wire [RF_ADDR_WIDTH-1:0]    RsE;
    wire [RF_ADDR_WIDTH-1:0]    RtE;
    wire [RF_ADDR_WIDTH-1:0]    RdE;
    wire [DATA_WIDTH-1:0]       SignImmE;
    wire [ADDRESS_WIDTH-1:0]    PCPlus4E;	
    wire RegWriteD;
    wire RegWriteE;
    wire [1:0] MemtoRegD;
    wire [1:0] MemtoRegE;
    wire MemWriteD;
    wire MemWriteE;
    wire ALUControlD;
    wire ALUControlE;
    wire ALUSrcD;
    wire ALUSrcE;
    wire [1:0] RegDstD;
    wire [1:0] RegDstE;
	wire [4:0]  ShamtE;
	

    decode_to_execute_reg U3_DEC_TO_EXC(
        .i_CLK(CLK),
        .i_RST(RST),
        .i_CLR(FlushE),
        // Data BUSES,
        .i_SrcAD(SrcAD),
        .i_SrcBD(SrcBD),
        .i_RsD(InstrD[25:21]),
        .i_RtD(InstrD[20:16]),
        .i_RdD(InstrD[15:11]),
        .i_SignImmD(SignImmD),
        .i_PCPlus4D(PCPlus4D),
        .i_ShamtD(ShamtD)
        .o_SrcAE(SrcAE),
        .o_SrcBE(SrcBE),
        .o_RsE(RsE),
        .o_RtE(RtE),
        .o_RdE(RdE),
        .o_SignImmE(SignImmE),
        .o_PCPlus4E(PCPlus4E),
        .o_ShamtE(ShamtE),
        // Control Signals,
        .i_RegWriteD(RegWriteD),
        .i_MemtoRegD(MemtoRegD),
        .i_MemWriteD(MemWriteD),
        .i_ALUControlD(ALUControlD),
        .i_ALUSrcD(ALUSrcD),
        .i_RegDstD(RegDstD),
        .o_RegWriteE(RegWriteE),
        .o_MemtoRegE(MemtoRegE),
        .o_MemWriteE(MemWriteE),
        .o_ALUControlE(ALUControlE),
        .o_ALUSrcE(ALUSrcE),
        .o_RegDstE(RegDstE)
    );


    wire ForwardAE;
    wire ForwardBE;
    wire [RF_ADDR_WIDTH-1:0]    WriteRegE;
    wire [DATA_WIDTH-1:0]       WriteDataE;
    wire [DATA_WIDTH-1:0]       ALUOutE;
    EXECUTE_STAGE U4_EXC_ST(
        .i_SrcAE(SrcAE),
        .i_SrcBE(SrcBE),
        .i_ResultW(ResultW),
        .i_ALUOutM(ALUOutM),
        .i_SignImmE(SignImmE),
        .i_ALUControlE(ALUControlE),
        .i_ForwardAE(ForwardAE),
        .i_ForwardBE(ForwardBE),
        .i_ALUSrcE(ALUSrcE),
        .i_RegDstE(RegDstE),
        .i_RsE(RsE),
        .i_RtE(RtE),
        .i_RdE(RdE),
        .i_ShamtE(ShamtE),
        .o_WriteRegE(WriteRegE),
        .o_WriteDataE(WriteDataE),
        .o_ALUOutE(ALUOutE)
    );

    wire RegWriteM;
    wire [1:0] MemtoRegM;
    wire MemWriteM;
    wire [DATA_WIDTH-1:0]    WriteDataM;
    wire [RF_ADDR_WIDTH-1:0] WriteRegM;
    wire [ADDRESS_WIDTH-1:0] PCPlus4M;	
    execute_to_memory_reg U5_EXC_TO_MEM (
        .i_CLK(CLK),
        .i_RST(RST),
        .i_ALUOutE(ALUOutE),
        .i_WriteDataE(WriteDataE),
        .i_WriteRegE(WriteRegE),
        .i_PCPlus4E(PCPlus4E),
        .o_ALUOutM(ALUOutM),
        .o_WriteDataM(WriteDataM),
        .o_WriteRegM(WriteRegM),
        .o_PCPlus4M(PCPlus4M),
        // Control Signals
        .i_RegWriteE(RegWriteE),
        .i_MemtoRegE(MemtoRegE),
        .i_MemWriteE(MemWriteE),
        .o_RegWriteM(RegWriteM),
        .o_MemtoRegM(MemtoRegM),
        .o_MemWriteM(MemWriteM)
    );

    wire [DATA_WIDTH-1:0] ReadDataM, ReadDataW ;
	wire MemDataSelM;
    MEMORY_STAGE U6_MEM_ST(
        .i_CLK(CLK),
        .i_ALUOutM(ALUOutM),
        .i_WriteDataM(WriteDataM),
        .i_MemWriteM(MemWriteM),
        .o_ReadDataM(ReadDataM),
		.i_ReadDataW(ReadDataW),
		.i_MemDataSelM(MemDataSelM)
		
    );
	
	
    wire [DATA_WIDTH-1:0] ALUOutW;
    wire [ADDRESS_WIDTH-1:0] PCPlus4W;
    wire [1:0] MemtoRegW;
    memory_to_write_back_reg U7_MEM_ST(
        .i_CLK(CLK),
        .i_RST(RST),
        .i_ALUOutM(ALUOutM),
        .i_WriteRegM(WriteRegM),
        .i_ReadDataM(ReadDataM),
        .i_PCPlus4M(PCPlus4M),
        .o_ALUOutW(ALUOutW),
        .o_WriteRegW(WriteRegW),
        .o_ReadDataW(ReadDataW),
        .o_PCPlus4W(PCPlus4W),
        // Control Signals
        .i_RegWriteM(RegWriteM),
        .i_MemtoRegM(MemtoRegM),
        .o_RegWriteW(RegWriteW),
        .o_MemtoRegW(MemtoRegW)
    );

    WRITE_BACK_STAGE U8_WB_ST (
        .i_ALUOutW(ALUOutW),
        .i_ReadDataW(ReadDataW),
        .i_MemtoRegW(MemtoRegW),
        .i_PCPlus4W(PCPlus4W),
        .o_ResultW(ResultW)
    );

	
	
	    CONTROL_UNIT U9_CTRL_UNIT(
        .i_Op(InstrD[31:26]),
        .i_funct(InstrD[5:0]),		
        .i_EqualD(EqualD), 
		.i_GTZD(GTZD), 
		.i_LTZD(LTZD), 
		.i_LTEZD(LTEZD),
        .o_RegWriteD(RegWriteD),
        .o_MemtoRegD(MemtoRegD),
        .o_MemWriteD(MemWriteD),
        .o_ALUControlD(ALUControlD),
        .o_ALUSrcD(ALUSrcD),
        .o_RegDstD(RegDstD),
        .o_BranchD(BranchD),
        .o_PCSrcD(PCSrcD),
        .o_JumpD(Jump),
        .o_JumpRD(JumpR),
        .o_LoadD(LoadD),
        .o_PC_SelD(PC_SelD)
    );
	
    Hazard_unit (
        .i_BranchD(BranchD),   //from control unit : BranchD = 1 in case of a bltz,beq,bne,blez or bgtz instr
        //pipeline registers
        .i_RsD(RsD),
        .i_RtD(RtD),
        .i_RsE(RsE),
        .i_RtE(RtE),
        .i_WriteRegE(WriteRegE),
        .i_WriteRegM(WriteRegM), 
        .i_WriteRegW(WriteRegW),
        //pipeline control signals
        .i_RegWriteE(RegWriteE), 
        .i_RegWriteM(RegWriteM), 
        .i_RegWriteW(RegWriteW),
        .i_MemtoRegE(MemtoRegE[0]), 
        .i_MemtoRegM(MemtoRegM[0]),
		.i_MemtoRegW(MemtoRegW[0]),
        //hazard control outputs
		.o_MemDataSelM(MemDataSelM),
        .o_StallF(StallF),
        .o_StallD(StallD),
        .o_ForwardAD(ForwardAD),   //mux selectors for sources to be compared, i case it is a branch instr
        .o_ForwardBD(ForwardBD),   //mux selectors for sources to be compared, i case it is a branch instr
        .o_FlushE(FlushE),
        .o_ForwardAE(ForwardAE),   //mux selectors for ALU sources
        .o_ForwardBE(ForwardBE),   //mux selectors for ALU sources
        .i_JrD(JumpRD),                  //from control unit : JrD = 1 in case of a JR OR a JALR
        .i_JD(Jump),				      //from control unit : JD = 1 in case of a J OR a JAL
        .i_ALUSrcD(ALUSrcD)
);
	
	
	
endmodule