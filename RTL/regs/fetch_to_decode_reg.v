module fetch_to_decode_reg #(
    parameter ADDRESS_WIDTH = 32, // Defines the number of bits for the memory address
    parameter INSTR_WIDTH = 32 // Defines the number of bits for the instruction
) (
    input   wire                      i_CLK,
    input   wire                      i_RST,
    input   wire                      i_n_EN,
    input   wire                      i_CLR,
    input   wire [INSTR_WIDTH-1:0]    i_InstrF,
    input   wire [ADDRESS_WIDTH-1: 0] i_PCPlus4F,
    output  reg  [INSTR_WIDTH-1:0]    o_InstrD,
    output  reg  [ADDRESS_WIDTH-1: 0] o_PCPlus4D
);

    always @(posedge i_CLK or negedge i_RST) begin
        if (~i_RST) begin
            o_InstrD <= 'b0;
            o_PCPlus4D <= 'b0;
        end
        else if (i_CLR) begin
            o_InstrD <= 'b0;
            o_PCPlus4D <= 'b0;
        end
        else if (~i_n_EN) begin
            o_InstrD <= i_InstrF;
            o_PCPlus4D <= i_PCPlus4F;

        end
    end
endmodule