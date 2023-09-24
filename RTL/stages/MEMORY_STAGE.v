module MEMORY_STAGE #(
    parameter DATA_WIDTH = 32,  
    parameter ADDRESS_WIDTH = 32, // Defines the number of bits for the memory address
    parameter RF_ADDR_WIDTH = 5
) (
    input  wire                        i_CLK,
    input  wire   [DATA_WIDTH-1:0]     i_ALUOutM,
    input  wire   [DATA_WIDTH-1:0]     i_WriteDataM, 
    input  wire                        i_MemWriteM,
    output wire   [DATA_WIDTH-1:0]     o_ReadDataM
);
    
    DATA_MEM #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) DM (
        .clk(i_CLK),
        .write_en(i_MemWriteM),
        .data_in(i_WriteDataM),
        .addr(i_ALUOutM),
        .data_out(o_ReadDataM)
    );


endmodule