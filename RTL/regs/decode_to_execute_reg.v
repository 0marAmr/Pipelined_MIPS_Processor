module decode_to_execute_reg #(
    parameter DATA_WIDTH = 32,  
    parameter ADDRESS_WIDTH = 32, // Defines the number of bits for the memory address
    parameter RF_ADDR_WIDTH = 5, 
    parameter INSTR_WIDTH = 32  // Defines the number of bits for the instruction
) (
    input   wire                       i_CLK,
    input   wire                       i_RST,
    input   wire                       i_CLR,
    // Data BUSES
    input   wire  [DATA_WIDTH-1:0]     i_SrcAD,
    input   wire  [DATA_WIDTH-1:0]     i_SrcBD,
    input   wire  [RF_ADDR_WIDTH-1:0]  i_RsD,
    input   wire  [RF_ADDR_WIDTH-1:0]  i_RtD,
    input   wire  [RF_ADDR_WIDTH-1:0]  i_RdD,
    input   wire  [ADDRESS_WIDTH-1:0]  i_SignImmD,
    output  reg   [DATA_WIDTH-1:0]     o_SrcAE,
    output  reg   [DATA_WIDTH-1:0]     o_SrcBE, 
    output  reg   [RF_ADDR_WIDTH-1:0]  o_RsE,
    output  reg   [RF_ADDR_WIDTH-1:0]  o_RtE,
    output  reg   [RF_ADDR_WIDTH-1:0]  o_RdE,
    output  reg   [ADDRESS_WIDTH-1:0]  o_SignImmE,
    // Control Signals
    input   wire                       i_RegWriteD,
    input   wire                       i_MemtoRegD,
    input   wire                       i_MemWriteD,
    input   wire  [2:0]                i_ALUControlD,
    input   wire                       i_ALUSrcD,
    input   wire                       i_RegDstD,
    output  reg                        o_RegWriteE,
    output  reg                        o_MemtoRegE,
    output  reg                        o_MemWriteE,
    output  reg   [2:0]                o_ALUControlE,
    output  reg                        o_ALUSrcE,
    output  reg                        o_RegDstE
    
);

    always @(posedge i_CLK or negedge i_RST) begin
        if (~i_RST) begin
            o_SrcAE <= 'b0;
            o_SrcBE <= 'b0;
            o_SignImmE <= 'b0;
            o_RsE <= 'b0;
            o_RtE <= 'b0;
            o_RdE <= 'b0;
            o_RegWriteE <= 'b0;
            o_MemtoRegE <= 'b0;
            o_MemWriteE <= 'b0;
            o_ALUControlE <= 'b0;
            o_ALUSrcE <= 'b0;
            o_RegDstE <= 'b0;
        end
        else if (i_CLR) begin
            o_SrcAE <= 'b0;
            o_SrcBE <= 'b0;
            o_SignImmE <= 'b0;
            o_RsE <= 'b0;
            o_RtE <= 'b0;
            o_RdE <= 'b0;
            o_RegWriteE <= 'b0;
            o_MemtoRegE <= 'b0;
            o_MemWriteE <= 'b0;
            o_ALUControlE <= 'b0;
            o_ALUSrcE <= 'b0;
            o_RegDstE <= 'b0;
        end
        else begin
            o_SrcAE <= i_SrcAD;
            o_SrcBE <= i_SrcBD;
            o_SignImmE <= i_SignImmD;
            o_RsE <= i_RsD;
            o_RtE <= i_RtD;
            o_RdE <= i_RdD;
            o_RegWriteE <= i_RegWriteD;
            o_MemtoRegE <= i_MemtoRegD;
            o_MemWriteE <= i_MemWriteD;
            o_ALUControlE <= i_ALUControlD;
            o_ALUSrcE <= i_ALUSrcD;
            o_RegDstE <= i_RegDstD;
        end
    end
endmodule