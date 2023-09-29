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
    input   wire  [ADDRESS_WIDTH-1:0]  i_PCPlus4E,
    output  reg   [DATA_WIDTH-1:0]     o_ALUOutM,
    output  reg   [DATA_WIDTH-1:0]     o_WriteDataM, 
    output  reg   [RF_ADDR_WIDTH-1:0]  o_WriteRegM,
    output  reg   [ADDRESS_WIDTH-1:0]  o_PCPlus4M,
    // Control Signals
    input   wire                       i_RegWriteE,
    input   wire  [1:0]                i_MemtoRegE,
    input   wire                       i_MemWriteE,
    output  reg                        o_RegWriteM,
    output  reg   [1:0]                o_MemtoRegM,
    output  reg                        o_MemWriteM,
    output 	reg   [2:0]                i_MemDataSelE,	
    output 	reg   [2:0]                o_MemDataSelM,
	output  reg   [1:0]	               i_RAM_selE,	
	output  reg   [1:0]	               O_RAM_selM	
);

    always @(posedge i_CLK or negedge i_RST) begin
        if (~i_RST) begin
            o_ALUOutM <= 'b0;
            o_WriteDataM <= 'b0;
            o_WriteRegM <= 'b0;
            o_RegWriteM <= 'b0;
            o_MemtoRegM <= 'b0;
            o_MemWriteM <= 'b0;
            o_PCPlus4M <= 'b0 ;
			o_MemDataSelM <= 'b0;
			O_RAM_selM <= 'b0;
        end
        else begin
            o_ALUOutM  <= i_ALUOutE;
            o_WriteDataM <= i_WriteDataE;
            o_WriteRegM <= i_WriteRegE;
            o_RegWriteM <= i_RegWriteE;
            o_MemtoRegM <= i_MemtoRegE;
            o_MemWriteM <= i_MemWriteE;
            o_PCPlus4M <= i_PCPlus4E;
			o_MemDataSelM <= i_MemDataSelE;
			O_RAM_selM <= i_RAM_selE;
        end
    end
endmodule