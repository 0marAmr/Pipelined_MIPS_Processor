module MEMORY_STAGE #(
    parameter DATA_WIDTH = 32,  
    parameter ADDRESS_WIDTH = 32, // Defines the number of bits for the memory address
    parameter RF_ADDR_WIDTH = 5
) (
    input  wire                        i_CLK,
    input  wire   [DATA_WIDTH-1:0]     i_ALUOutM,
    input  wire   [DATA_WIDTH-1:0]     i_WriteDataM, 
    input  wire                        i_MemWriteM,
    input wire    [DATA_WIDTH-1:0]     i_ReadDataW,	 //from write back stage
    input  wire                        i_MemDataSelM,   //from hazard unit
    output wire   [DATA_WIDTH-1:0]     o_ReadDataM
);
    wire [DATA_WIDTH-1:0] MemDataIn;
    DATA_MEM #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) DM (
        .clk(i_CLK),
        .write_en(i_MemWriteM),
        .data_in(MemDataIn),
        .addr(i_ALUOutM),
        .data_out(o_ReadDataM)
    );
	
	mux_2_to_1 #(
        .N(DATA_WIDTH)
    ) WriteDataMux (
        .data_true(i_ReadDataW),
        .data_false(i_WriteDataM),
        .sel(i_MemDataSelM),
        .data_out(MemDataIn)
    );


endmodule