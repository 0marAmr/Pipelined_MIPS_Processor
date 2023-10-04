module EXECUTE_STAGE #(
    parameter DATA_WIDTH = 32,  
    parameter ADDRESS_WIDTH = 32, // Defines the number of bits for the memory address
    parameter RF_ADDR_WIDTH = 5

) (
    input  wire  [DATA_WIDTH-1:0]       i_SrcAE,
    input  wire  [DATA_WIDTH-1:0]       i_SrcBE,
    input  wire  [DATA_WIDTH-1:0]       i_ResultW,
    input  wire  [DATA_WIDTH-1:0]       i_ALUOutM,
    input  wire  [ADDRESS_WIDTH-1:0]    i_SignImmE,
    input  wire  [3:0]                  i_ALUControlE,
    input  wire  [1:0]                  i_ForwardAE,
    input  wire  [1:0]                  i_ForwardBE,
    input  wire                         i_ALUSrcE,
    input  wire  [1:0]                  i_RegDstE,
    input  wire  [RF_ADDR_WIDTH-1:0]    i_RtE,
    input  wire  [RF_ADDR_WIDTH-1:0]    i_RdE,
    input  wire  [RF_ADDR_WIDTH-1:0]    i_RsE,
    input  wire  [4:0]                  i_ShamtE,
    output wire  [RF_ADDR_WIDTH-1:0]    o_WriteRegE,
    output wire  [DATA_WIDTH-1:0]       o_WriteDataE,
    output wire  [DATA_WIDTH-1:0]       o_ALUOutE
);
        

    wire  [DATA_WIDTH-1:0] OperAE;
    wire  [DATA_WIDTH-1:0] OperBE;
    ALU #(
        .DATA_WIDTH(DATA_WIDTH) 
    ) alu_inst (

        .Operand1(OperAE),
        .Operand2(OperBE),
        .Cntrl(i_ALUControlE),
        .Shamt(i_ShamtE),
        .ALU_OUT(o_ALUOutE)
    );

    mux_4_to_1 #(
        .N(DATA_WIDTH)
    ) ALU_OPERA_MUX (
        .sel(i_ForwardAE),
        .in0(i_SrcAE),
        .in1(i_ResultW),
        .in2(i_ALUOutM),
        .in3(32'b0),  // Not Connected
        .out(OperAE)
    );

    mux_4_to_1 #(
        .N(DATA_WIDTH)
    ) Write_Data_MUX (
        .sel(i_ForwardBE),
        .in0(i_SrcBE),
        .in1(i_ResultW),
        .in2(i_ALUOutM),
        .in3(32'b0),  // Not Connected
        .out(o_WriteDataE)
    );

    mux_2_to_1 #(
        .N(DATA_WIDTH)
    ) ALU_SRC_B_MUX (
        .data_true(i_SignImmE),
        .data_false(o_WriteDataE),
        .sel(i_ALUSrcE),
        .data_out(OperBE)
    );

     mux_4_to_1 #(
        .N(DATA_WIDTH)
    ) WriteRegMux (
        .sel(i_RegDstE),
        .in0(i_RtE),
        .in1(i_RdE),
        .in2(32'd31),
        .in3(32'b0),  // Not Connected
        .out(o_WriteRegE)
    );

endmodule