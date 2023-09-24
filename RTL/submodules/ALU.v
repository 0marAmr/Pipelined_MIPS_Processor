module ALU
#(
        parameter WIDTH = 32
    )(
        input wire [2:0] sel,
        input wire [WIDTH-1: 0] A,
        input wire [WIDTH-1: 0] B,
        output reg [WIDTH-1: 0] alu_result
    );
    
    localparam  [2:0]   ADD     = 3'b000,
                        SHL     = 3'b001,
                        SUB     = 3'b010,
                        NOTUSED = 3'b011, 
                        XOR     = 3'b100,
                        SHR     = 3'b101,
                        OR      = 3'b110,
                        AND     = 3'b111;

    always @ (*) 
    begin
        alu_result = {WIDTH{1'b0}};
        case(sel)
            ADD: alu_result = A + B;
            SHL: alu_result = A << B;
            SUB: alu_result = A - B;
            XOR: alu_result = A ^ B;
            SHR: alu_result = A >> B;
            OR:  alu_result = A | B;
            AND: alu_result = A & B;
            default: alu_result = {WIDTH{1'b0}};
        endcase
    end
    
endmodule