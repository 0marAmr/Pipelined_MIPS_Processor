module MAIN_DECODER(
    input wire [6:0]    op, // 7-bit input signal op
    input wire [5:0]    funct,     
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
    output reg          load

);


    localparam [6:0]    R_TYPE  = 6'b00_0000,
                        LW      = 6'b100011,
                        SW      = 6'b101011,
                        BEQ     = 6'b000100,
                        ADDI    = 6'b001000,
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
        case (op)
            R_TYPE: begin
                case (funct)
                    6'b001001: begin  // jump and link register (JALR)
                        memtoreg = 'b10;    // PC + 4
                        regdst   = 'b10;    // return address reg  (31)
                        jumpr = 'b1;
                        pcsel = 'b01;       // PC next values is Rs
                    end 
                    6'b001000: begin  // jump (JR)
                        jumpr = 'b1;
                        pcsel = 'b01;       // PC next values is Rs
                    end 
                    default: begin
                        regdst   =  'b01;
                    end
                endcase
                regwrite =  'b1;
                alu_op   =  'b010;
            end
            LW: begin
                regwrite = 'b1;
                memtoreg = 'b01;
                alusrc   = 'b1; // signed imm value
            end
            SW: begin
                memwrite = 'b1;
                alusrc   = 'b1; // signed imm value
            end
            BEQ: begin
                alu_op   =  'b001;
                branch   = 'b1;
            end
            ADDI: begin
                regwrite =  'b1;
                alusrc   = 'b1;
            end
            JMP: begin
                jump = 'b1;
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
