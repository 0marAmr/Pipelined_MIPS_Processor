module MAIN_DECODER(
    input wire [5:0]    op, // 7-bit input signal op
    input wire [5:0]    funct,
    input wire          i_EqualD, i_GTZD, i_LTZD, i_LTEZD,	
    output reg          regwrite,
    output reg [1:0]    memtoreg,
    output reg          memwrite,
    output reg          alusrc,
    output reg [1:0]    regdst,
    output reg [1:0]    pcsel,
    output reg          branch,
    output reg          jump,
    output reg          jumpr,
    output reg [2:0]    alu_op,
    output reg 		    PCSrcD,
    output reg 		    sign_selD,
    output reg          load,
	output reg [2:0]    MemDataSelD,
	output reg [1:0]	RAM_sel



);


    localparam [6:0]    R_TYPE  = 6'b00_0000,
                        LW      = 6'b100011,
						LH      = 6'b100001,
						LB      = 6'b100000,
						LHu     = 6'b100101,
						LBU     = 6'b100100,
                        SW      = 6'b101011,
						SH      = 6'b101001,
						SB      = 6'b101000,
                        BEQ     = 6'b000100,
                        BNE     = 6'b000101,
                        BLEZ    = 6'b000110,
                        BGTZ    = 6'b000111,
                        BLTZ    = 6'b000001,
                        ADDI    = 6'b001000,
						ANDi    = 6'b001100,
						ORi     = 6'b001101,
						XORI    = 6'b001110,
						SLTi    = 6'b001010,
						SLTiu   = 6'b001011,
						ADDiu   = 6'b001001,
                        JMP     = 6'b000010,
                        JAL     = 6'b000011,
                        HALT    = 6'b111111;
											

    always @(*) begin 
        regwrite = 'b0;
        memtoreg = 'b0;
        memwrite = 'b0;
        alusrc = 'b0;
        regdst = 'b0;
        branch = 'b0;
        jump = 'b0;
        jumpr = 'b0;
        alu_op = 'b0;
        pcsel = 'b0;
        load = 'b1;
		PCSrcD = 'b0;
		sign_selD = 'b0;
		MemDataSelD = 'b0;
		RAM_sel = 'b0;
        case (op)
            R_TYPE: begin
                case (funct)
                    6'b001001: begin  // jump and link register (JALR)
                        memtoreg = 'b10;    // PC + 4
						regwrite = 'd1;
                        regdst   = 'b10;    // return address reg  (31)
                        jumpr = 'b1;
                        pcsel = 'b01;       // PC next values is Rs
                    end 
                    6'b001000: begin  // jump (JR)
                        jumpr = 'b1;
                        pcsel = 'b01;       // PC next values is Rs
                    end 
                    default: begin  //other R-Type
                        regdst   =  'b01;
						regwrite =  'b1;
						alu_op   =  'b010;
                    end
                endcase
            end
            LW: begin
                regwrite = 'b1;
                memtoreg = 'b01;
                alusrc   = 'b1; // signed imm value				
            end
            LH: begin
                regwrite = 'b1;
                memtoreg = 'b01;
                alusrc   = 'b1; // signed imm value
				MemDataSelD = 'b1;
            end	
            LHu: begin
                regwrite = 'b1;
                memtoreg = 'b01;
                alusrc   = 'b1; // signed imm value
				MemDataSelD = 'b010;
            end	
            LB: begin
                regwrite = 'b1;
                memtoreg = 'b01;
                alusrc   = 'b1; // signed imm value
				MemDataSelD = 'b11;
            end	
            LBU: begin
                regwrite = 'b1;
                memtoreg = 'b01;
                alusrc   = 'b1; // signed imm value
				MemDataSelD = 'b100;
            end				
            SW: begin
                memwrite = 'b1;
                alusrc   = 'b1; // signed imm value
            end
            SH: begin
                memwrite = 'b1;
                alusrc   = 'b1; // signed imm value
				RAM_sel = 'b1;
            end
            SB: begin
                memwrite = 'b1;
                alusrc   = 'b1; // signed imm value
				RAM_sel = 'b10;
            end			
            BEQ: begin
                branch   = 'b1;
				PCSrcD = i_EqualD;
            end
            BNE: begin
                branch   = 'b1;
				PCSrcD = ~i_EqualD;
            end
            BLEZ: begin
                branch   = 'b1;
				PCSrcD = i_LTEZD;
            end
            BGTZ: begin
                branch   = 'b1;
				PCSrcD = i_GTZD;
            end
            BLTZ: begin
                branch   = 'b1;
				PCSrcD = i_EqualD;
				PCSrcD = i_LTZD;
            end			
            ADDI: begin
                regwrite =  'b1;
                alusrc   = 'b1;
            end
            ANDi: begin
				alu_op  = 'b100;  //review
                regwrite =  'b1;
                alusrc   = 'b1;
            end
            ORi: begin
				alu_op  = 'b101;  //review
                regwrite =  'b1;
                alusrc   = 'b1;
            end	
            XORI: begin
				alu_op  = 'b110;  //review
                regwrite =  'b1;
                alusrc   = 'b1;
            end	
            SLTi: begin
				alu_op  = 'b11;  //review
                regwrite =  'b1;
                alusrc   = 'b1;
            end	
            SLTiu: begin
				alu_op  = 'b11;  //review
                regwrite =  'b1;
                alusrc   = 'b1;
				sign_selD = 'b1;  //sign extend with 0
            end	
            ADDiu: begin
                regwrite =  'b1;
                alusrc   = 'b1;
				sign_selD = 'b1;  //sign extend with 0
            end				
            JMP: begin
                jump = 'b1;
				pcsel = 'b10; 
            end
            JAL: begin
                jump = 'b1;
                memtoreg = 'b10;    // PC + 4
                regdst   = 'b10;    // return address reg  (31)
                pcsel = 'b10;       // PC next values is PC[31:28] || Inst[25:0] || 00
                regwrite =  'b1;
            end
            HALT: begin
                load = 'b0;
            end
        endcase
    end
endmodule
