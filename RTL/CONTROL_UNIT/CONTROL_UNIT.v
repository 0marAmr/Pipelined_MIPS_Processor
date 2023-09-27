module CONTROL_UNIT(
    input    wire [5:0]                 i_Op,
    input    wire [5:0]                 i_funct,
    output   wire                       o_RegWriteD,
    output   wire                       o_MemtoRegD,
    output   wire                       o_MemWriteD,
    output   wire [2:0]                 o_ALUControlD,
    output   wire                       o_ALUSrcD,
    output   wire                       o_RegDstD,
    output   wire                       o_BranchD,
    output   wire                       o_JumpD
);

    wire [2:0] alu_op;
    MAIN_DECODER MAIN_DEC(
        .op(i_Op),
        .regwrite(o_RegWriteD),
        .memtoreg(o_MemtoRegD),
        .memwrite(o_MemWriteD),
        .alusrc(o_ALUSrcD),
        .regdst(o_RegDstD),
        .branch(o_BranchD),
        .jump(o_JumpD),
        .alu_op(alu_op)
    );

    ALU_Controller (
        .funct(i_funct),
        .alu_op(alu_op),
        .ALUControl(o_ALUControlD)
    );
endmodule
