module CONTROL_UNIT(
    input 				                i_CLK,
	input				                i_RST,
    input    wire [5:0]                 i_Op,                
    input    wire [5:0]                 i_funct,
    output   wire                       o_RegWriteD,
    output   wire                       o_MemtoRegD,
    output   wire                       o_MemWriteD,
    output   wire [2:0]                 o_ALUControlD,
    output   wire                       o_ALUSrcD,
    output   wire                       o_RegDstD,
    output   wire                       o_BranchD,
);

endmodule
