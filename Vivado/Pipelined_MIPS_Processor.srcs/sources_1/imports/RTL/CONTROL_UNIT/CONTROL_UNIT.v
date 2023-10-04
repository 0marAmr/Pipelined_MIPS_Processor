module CONTROL_UNIT(
    input    wire [5:0]                 i_Op,
    input    wire [5:0]                 i_funct,
    input    wire                       i_EqualD, i_GTZD, i_LTZD, i_LTEZD,
    output   wire                       o_RegWriteD,
    output   wire [1:0]                 o_MemtoRegD,
    output   wire                       o_MemWriteD,
    output   wire [3:0]                 o_ALUControlD,
    output   wire                       o_ALUSrcD,
    output   wire [1:0]                 o_RegDstD,
    output   wire                       o_JumpD,
    output   wire                       o_JumpRD,
    output   wire                       o_LoadD,
    output   wire                       o_PCSrcD,
    output   wire                       o_BranchD,
    output 	 wire 		    			o_sign_selD,	
    output 	 wire [2:0]                 o_MemDataSelD,
	output   wire [1:0]	                o_RAM_selD,
    output   wire [1:0]                 o_PC_SelD
);

    wire [2:0] alu_op;
	wire PCSrcD;
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
        .pcsel(o_PC_SelD),
        .PCSrcD(PCSrcD),
		.i_EqualD(i_EqualD), 
		.i_GTZD(i_GTZD), 
		.i_LTZD(i_LTZD), 
		.i_LTEZD(i_LTEZD),
		.sign_selD(o_sign_selD),
		.MemDataSelD(o_MemDataSelD),
		.RAM_sel(o_RAM_selD)
    );

    ALU_DECODER ALU_DEC(
        .funct(i_funct),
        .alu_op(alu_op),
        .ALUControl(o_ALUControlD)
    );

    assign o_PCSrcD =  (o_JumpD) || (o_JumpRD) || (PCSrcD);
endmodule
