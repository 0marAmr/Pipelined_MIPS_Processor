module WRITE_BACK_STAGE #(
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 32
) (
    input wire   [DATA_WIDTH-1:0]     i_ALUOutW,
    input wire   [DATA_WIDTH-1:0]     i_ReadDataW,
    input wire   [1:0]                i_MemtoRegW,
    input wire   [ADDRESS_WIDTH-1:0]  i_PCPlus4W,
    output wire  [DATA_WIDTH-1:0]     o_ResultW
);

    mux_4_to_1 #(
    .N(ADDRESS_WIDTH)
    ) WriteBackMUX (
        .sel(i_MemtoRegW),
        .in0(i_ALUOutW),
        .in1(i_ReadDataW),
        .in2(i_PCPlus4W),
        .in3(32'b0),  // Not Connected
        .out(o_ResultW)
    );
    
endmodule