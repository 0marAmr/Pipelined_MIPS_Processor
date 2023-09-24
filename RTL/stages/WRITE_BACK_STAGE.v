module WRITE_BACK_STAGE #(
    parameter DATA_WIDTH = 32
) (
    input wire   [DATA_WIDTH-1:0]     i_ALUOutW,
    input wire   [DATA_WIDTH-1:0]     i_ReadDataW,
    input wire                        i_MemtoRegW,
    output wire   [DATA_WIDTH-1:0]    o_ResultW
);

    mux_2_to_1 #(
        .N(DATA_WIDTH)
    ) ForwardAMUX (
        .data_true(i_ReadDataW),
        .data_false(i_ALUOutW),
        .sel(i_MemtoRegW),
        .data_out(o_ResultW)
    );
    
endmodule