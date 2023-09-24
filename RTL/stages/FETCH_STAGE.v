module FETCH_STAGE #(
    parameter ADDRESS_WIDTH = 32, // Defines the number of bits for the memory address
    parameter INSTR_WIDTH = 32, // Defines the number of bits for the instruction
    parameter PROGRAM = "factorial.txt"
)(
    input   wire                      i_CLK,
    input   wire                      i_RST,
    input   wire [ADDRESS_WIDTH-1:0]  i_PCBranchD,
    input   wire                      i_StallF,
    input   wire                      i_PCSrcD,
    output  wire [INSTR_WIDTH-1:0]    o_InstrF,
    output  wire [ADDRESS_WIDTH-1: 0] o_PCPlus4F
);
    wire [ADDRESS_WIDTH-1: 0]  PCF;
    wire [ADDRESS_WIDTH-1: 0]  PC_Next;
    wire [ADDRESS_WIDTH-1: 0]  imm_ext_internal;


    PRG_CNTR #(
        .N(ADDRESS_WIDTH)
    ) program_counter (
        .CLK(i_CLK),        // Clock input
        .RST(i_RST),  // Reset input
        .n_EN(i_StallF),      // Load input
        .pc_next(PC_Next),  // Next PC output
        .pc(PCF)           // Current PC output
    );

    // Select the next PC value based on the instruction type
    mux_2_to_1 pc_next_mux (
        .data_true(i_PCBranchD),  // Target PC
        .data_false(o_PCPlus4F),  // PC+4
        .sel(i_PCSrcD),  // Source of the next PC value
        .data_out(PC_Next)  // Next PC output
    );
    // Calculate the PC+4 value
    ADDER #(
        .N(ADDRESS_WIDTH)
    ) PC_PLUS_4_ADDER (
        .X(PCF),
        .Y(32'd4),
        .Z(o_PCPlus4F)
    );

    instr_mem #(
        .PROGRAM(PROGRAM)
    ) INSTRUCTION_MEMORY (
        .addr(PCF), // Input address wire
        .instr(o_InstrF) // Output instruction wire
    ); 
endmodule