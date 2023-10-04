module WRITE_BACK_STAGE #(
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 32
) (
    input wire   [DATA_WIDTH-1:0]     i_ALUOutW,
    input wire   [DATA_WIDTH-1:0]     i_ReadDataW,
    input wire   [1:0]                i_MemtoRegW,
    input wire   [2:0]                i_MemDataSelW,
    input wire   [ADDRESS_WIDTH-1:0]  i_PCPlus4W,
    output wire  [DATA_WIDTH-1:0]     o_ResultW
);
	localparam NC = 32'b0;
	
	wire [DATA_WIDTH-1:0] MemDataW;
    mux_4_to_1 #(
    .N(ADDRESS_WIDTH)
    ) WriteBackMUX (
        .sel(i_MemtoRegW),
        .in0(i_ALUOutW),
        .in1(MemDataW),
        .in2(i_PCPlus4W),
        .in3(NC),  // Not Connected
        .out(o_ResultW)
    );
	

/************ Half Word sign extend ***********/
    wire [DATA_WIDTH-1: 0] SEH0_Out;

    ZERO_EXT #(
        .INPUT_WIDTH(16),
        .OUTPUT_WIDTH(DATA_WIDTH)
    ) S_EXT_0_HALF_WORD (
        .in(i_ReadDataW[15:0]), 
        .out_extend(SEH0_Out)
        );

    wire [DATA_WIDTH-1: 0] SEH_Out;

    SIGN_EXT #(
        .INPUT_WIDTH(16),
        .OUTPUT_WIDTH(DATA_WIDTH)
    ) S_EX_HALF_WORD (
        .instr_part(i_ReadDataW[15:0]), 
        .data_out_signed(SEH_Out)
    );	
	
/************ Byte sign extend ***********/
    wire [DATA_WIDTH-1: 0] SEB0_Out;

    ZERO_EXT #(
        .INPUT_WIDTH(8),
        .OUTPUT_WIDTH(DATA_WIDTH)
    ) S_EXT_0_BYTE (
        .in(i_ReadDataW[7:0]), 
        .out_extend(SEB0_Out)
    );

    wire [DATA_WIDTH-1: 0] SEB_Out;

    SIGN_EXT #(
        .INPUT_WIDTH(8),
        .OUTPUT_WIDTH(DATA_WIDTH)
    ) S_EX_BYTE (
        .instr_part(i_ReadDataW[7:0]), 
        .data_out_signed(SEB_Out)
    );

/************ MUX ***********/
    mux_8_to_1 #(
        .WIDTH(DATA_WIDTH)
    ) MemDataWriteMUX (
        .sel(i_MemDataSelW), 
        .in0(i_ReadDataW), 
        .in1(SEH_Out), 
        .in2(SEH0_Out), 
        .in3(SEB_Out), 
        .in4(SEB0_Out), 
        .in5(NC),
        .in6(NC),	
        .in7(NC), 	
        .out(MemDataW)  
    );	
    
endmodule