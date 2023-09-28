module CONTROL_UNIT(
    input    wire [5:0]                 i_Op,
    input    wire [5:0]                 i_funct,
    input    wire                       i_EqualD,
    output   wire                       o_RegWriteD,
    output   wire [1:0]                 o_MemtoRegD,
    output   wire                       o_MemWriteD,
    output   wire [2:0]                 o_ALUControlD,
    output   wire                       o_ALUSrcD,
    output   wire [1:0]                 o_RegDstD,
    output   wire                       o_JumpD,
    output   wire                       o_JumpRD,
    output   wire                       o_LoadD,
    output   wire                       o_PCSrcD,
    output   wire                       o_BranchD,
    output   wire [1:0]                 o_PC_SelD
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
        .jumpr(o_JumpRD),
        .alu_op(alu_op),
        .load(o_LoadD),
        .pcsel(o_PC_SelD)
    );

    ALU_Controller (
        .funct(i_funct),
        .alu_op(alu_op),
        .ALUControl(o_ALUControlD)
    );

    assign o_PCSrcD =  (o_JumpD) || (o_JumpRD) || (BranchD && (i_EqualD));
endmodule
