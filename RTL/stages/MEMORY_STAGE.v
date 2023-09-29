module MEMORY_STAGE #(
    parameter DATA_WIDTH = 32,  
    parameter ADDRESS_WIDTH = 32, // Defines the number of bits for the memory address
    parameter RF_ADDR_WIDTH = 5
) (
    input  wire                        i_CLK,
    input  wire   [DATA_WIDTH-1:0]     i_ALUOutM,
    input  wire   [DATA_WIDTH-1:0]     i_WriteDataM, 
    input  wire                        i_MemWriteM,
    input  wire   [1:0]                i_RAM_selM,
    input wire    [DATA_WIDTH-1:0]     i_ReadDataW,	 //from write back stage
    input  wire                        i_MemDataSelM,   //from hazard unit

    output wire   [DATA_WIDTH-1:0]     o_ReadDataM
);

	localparam PROGRAM = "text.txt";
    wire [DATA_WIDTH-1:0] MemDataIn;
	RAM #(
		.PROGRAM(PROGRAM), .ADDRESS_WIDTH(ADDRESS_WIDTH), .DATA_WIDTH(DATA_WIDTH))
	) DATA_MEM(
		.CLK(i_CLK),
		.Data(MemDataIn),
		.Addr(i_ALUOutM),
		.W_EN(i_MemWriteM),
		.sel(i_RAM_selM),
		.Output_Data(o_ReadDataM)
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