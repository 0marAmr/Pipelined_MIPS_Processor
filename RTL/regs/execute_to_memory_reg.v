module execute_to_memory_reg #(
    parameter DATA_WIDTH = 32,  
    parameter ADDRESS_WIDTH = 32, // Defines the number of bits for the memory address
    parameter RF_ADDR_WIDTH = 5, 
    parameter INSTR_WIDTH = 32  // Defines the number of bits for the instruction
) (
    input   wire                       i_CLK,
    input   wire                       i_RST,
    input   wire  [DATA_WIDTH-1:0]     i_ALUOutE,
    input   wire  [DATA_WIDTH-1:0]     i_WriteDataE, 
    input   wire  [RF_ADDR_WIDTH-1:0]  i_WriteRegE,
    output  reg   [DATA_WIDTH-1:0]     o_ALUOutM,
    output  reg   [DATA_WIDTH-1:0]     o_WriteDataM, 
    output  reg   [RF_ADDR_WIDTH-1:0]  o_WriteRegM,
    // Control Signals
    input   wire                       i_RegWriteE,
    input   wire                       i_MemtoRegE,
    input   wire                       i_MemWriteE,
    output  reg                        o_RegWriteM,
    output  reg                        o_MemtoRegM,
    output  reg                        o_MemWriteM
);

    always @(posedge i_CLK or negedge i_RST) begin
        if (~i_RST) begin
            o_ALUOutM <= 'b0;
            o_WriteDataM <= 'b0;
            o_WriteRegM <= 'b0;
            o_RegWriteM <= 'b0;
            o_MemtoRegM <= 'b0;
            o_MemWriteM <= 'b0;
        end
        else begin
            o_ALUOutM  <= i_ALUOutE;
            o_WriteDataM <= i_WriteDataE;
            o_WriteRegM <= i_WriteRegE;
            o_RegWriteM <= i_RegWriteE;
            o_MemtoRegM <= i_MemtoRegE;
            o_MemWriteM <= i_MemWriteE;
        end
    end
endmodule