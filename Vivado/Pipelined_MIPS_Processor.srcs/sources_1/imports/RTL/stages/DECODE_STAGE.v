module DECODE_STAGE #(
    parameter DATA_WIDTH = 32,  
    parameter ADDRESS_WIDTH = 32, // Defines the number of bits for the memory address
    parameter INSTR_WIDTH = 32, // Defines the number of bits for the instruction
    parameter RF_ADDR_WIDTH = 5
) (
    input   wire                      i_CLK,
    input   wire                      i_RST,
    input   wire [4:0]                i_WriteRegW,
    input   wire                      i_RegWriteW,
    input   wire                      i_ForwardAD,
    input   wire                      i_ForwardBD,
    input   wire                      i_sign_selD,
    input   wire [1:0]                i_PC_SelD,  //from control unit
    input   wire [INSTR_WIDTH-1:0]    i_InstrD,
    input   wire [DATA_WIDTH-1:0]     i_ALUOutM,
    input   wire [DATA_WIDTH-1:0]     i_ResultW,
    input   wire [ADDRESS_WIDTH-1:0]  i_PCPlus4D,
    output  wire [DATA_WIDTH-1:0]     o_SrcAD,
    output  wire [DATA_WIDTH-1:0]     o_SrcBD,
    output  wire [ADDRESS_WIDTH-1:0]  o_SignImmD,
    output  wire [ADDRESS_WIDTH-1:0]  o_PCNextD,
    output  wire                      o_EqualD,
    output  wire                      o_GTZD,
    output  wire                      o_LTZD, 
    output  wire                      o_LTEZD,
	output  wire [4:0]                o_ShamtD

);
    
    REG_FILE  #(
        .RF_ADDR_WIDTH(RF_ADDR_WIDTH),
        .RF_DATA_WIDTH(DATA_WIDTH)
    ) register_file (
        // input ports
        .clk(i_CLK),                  // clock input
        .n_reset(i_RST),              // reset input
        .r_addr_1(i_InstrD[25:21]),   // read address A input
        .r_addr_2(i_InstrD[20:16]),   // read address B input
        .w_addr(i_WriteRegW),         // write address input
        .wr_en(i_RegWriteW),          // write enable input
        .w_data(i_ResultW),           // write data input
        // outpuo_t ports
        .r_data_1(o_SrcAD),   // read data A output
        .r_data_2(o_SrcBD)    // read data B output
    );

	wire [DATA_WIDTH-1:0] SignImmD;
    SIGN_EXT sign_extend (
        .instr_part(i_InstrD[15:0]),
        .data_out_signed(SignImmD)
    ); 
	
	
	wire [DATA_WIDTH-1:0] SignImm0;
    zero_extend #(
        .INPUT_WIDTH(16),
        .OUTPUT_WIDTH(DATA_WIDTH)
    ) EXT_0_WORD (
        .in(i_InstrD[15:0]), 
        .out_extend(SignImm0)
    );
	
    mux_2_to_1 #(
        .N(DATA_WIDTH)
    ) SignExtendMux (
        .data_true(SignImm0),
        .data_false(SignImmD),
        .sel(i_sign_selD),
        .data_out(o_SignImmD)
    );		
    
	wire [ADDRESS_WIDTH-1:0] PCBranchD;
    ADDER #(
        .N(ADDRESS_WIDTH)
    ) PC_BRANCH_ADDER (
        .X((SignImmD<<2'd2)),
        .Y(i_PCPlus4D),
        .Z(PCBranchD)
    );

    wire [DATA_WIDTH-1:0] CmpValAD;
    mux_2_to_1 #(
        .N(DATA_WIDTH)
    ) ForwardAMUX (
        .data_true(i_ALUOutM),
        .data_false(SrcAD),
        .sel(i_ForwardAD),
        .data_out(CmpValAD)
    );

    wire [DATA_WIDTH-1:0] CmpValBD;
    mux_2_to_1 #(
        .N(DATA_WIDTH)
    ) ForwardBMUX (
        .data_true(i_ALUOutM),
        .data_false(o_SrcBD),
        .sel(i_ForwardBD),
        .data_out(CmpValBD)
    );
	
	 mux_4_to_1 #(
        .N(ADDRESS_WIDTH)
    ) PC_MUX (
        .sel(i_PC_SelD),
        .in0(PCBranchD),
        .in1(CmpValAD),
        .in2({i_PCPlus4D[31:28], i_InstrD[25:0], 2'b00}),
        .in3(32'b0),  // Not Connected
        .out(o_PCNextD)
    );

	assign o_ShamtD = i_InstrD[10:6];
    assign o_EqualD = (CmpValAD == CmpValBD);
    assign o_GTZD = (CmpValAD > 'd0);
    assign o_LTZD = (CmpValAD < 'd0);
    assign o_LTEZD = (CmpValAD <= 'd0);	
endmodule
