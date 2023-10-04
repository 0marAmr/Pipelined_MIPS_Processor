module SIGN_EXT #(
    parameter   INPUT_WIDTH=8,
                OUTPUT_WIDTH=32
)(
    input  wire [INPUT_WIDTH-1:0]  instr_part,                   // Input instruction part with most significant bits unused
    output wire [OUTPUT_WIDTH-1:0] data_out_signed               // Output signed data with the specified immediate value
    );

    localparam width = OUTPUT_WIDTH - INPUT_WIDTH;

    assign data_out_signed = {{width{instr_part[INPUT_WIDTH-1]}}, instr_part};

endmodule


