module memory_to_write_back_reg #(
    parameter DATA_WIDTH = 32,  
    parameter ADDRESS_WIDTH = 32, // Defines the number of bits for the memory address
    parameter RF_ADDR_WIDTH = 5, 
    parameter INSTR_WIDTH = 32  // Defines the number of bits for the instruction
) (
    input   wire                       i_CLK,
    input   wire                       i_RST,
    input   wire  [DATA_WIDTH-1:0]     i_ALUOutM,
    input   wire  [RF_ADDR_WIDTH-1:0]  i_WriteRegM,
    input   wire  [DATA_WIDTH-1:0]     i_ReadDataM,
    output  reg   [DATA_WIDTH-1:0]     o_ALUOutW,
    output  reg   [RF_ADDR_WIDTH-1:0]  o_WriteRegW,
    output  reg   [DATA_WIDTH-1:0]     o_ReadDataW,
    // Control Signals
    input   wire                       i_RegWriteM,
    input   wire                       i_MemtoRegM,
    output  reg                        o_RegWriteW,
    output  reg                        o_MemtoRegW
);

    always @(posedge i_CLK or negedge i_RST) begin
        if (~i_RST) begin
            o_ALUOutW <= 'b0;
            o_WriteRegW <= 'b0;
            o_ReadDataW <= 'b0;
            o_RegWriteW <= 'b0;
            o_MemtoRegW <= 'b0;
        end
        else begin
            o_ALUOutW <= i_ALUOutM;
            o_WriteRegW <= i_WriteRegM;
            o_ReadDataW <= i_ReadDataM;
            o_RegWriteW <= i_RegWriteM;
            o_MemtoRegW <= i_MemtoRegM;
        end
    end
endmodule