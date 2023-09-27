module MAIN_DECODER(
    input [6:0]op, // 7-bit input signal op
    output reg regwrite,
    output reg memtoreg,
    output reg memwrite,
    output reg alusrc,
    output reg regdst,
    output reg branch,
    output reg jump,
    output reg [2:0] alu_op,
    output reg load

);


    localparam [6:0]    R_TYPE  = 6'b00_0000,
                        LW      = 6'b100011,
                        SW      = 6'b101011,
                        BEQ     = 6'b000100,
                        ADDI    = 6'b001000,
                        JMP     = 6'b000010,
                        HALT    = 6'b111111;

    always @(*) begin 
        regwrite = 'b0;
        memtoreg = 'b0;
        memwrite = 'b0;
        alusrc = 'b0;
        regdst = 'b0;
        branch = 'b0;
        jump = 'b0;
        alu_op = 'b0;
        load = 'b1;
        case (op)
            R_TYPE: begin
                regwrite =  'b1;
                alu_op   =  'b010;
                regdst   =  'b1;
            end
            LW: begin
                regwrite = 'b1;
                memtoreg = 'b1;
                alusrc = 'b1; // signed imm value
            end
            SW: begin
                memwrite = 'b1;
                alusrc = 'b1; // signed imm value
            end
            BEQ: begin
                alu_op   =  'b001;
                branch = 'b1;
            end
            ADDI: begin
                regwrite =  'b1;
                alusrc = 'b1;
            end
            JMP: begin
                jump = 'b1;
            end
            HALT: begin
                load = 'b0;
            end
        endcase
    end
endmodule
