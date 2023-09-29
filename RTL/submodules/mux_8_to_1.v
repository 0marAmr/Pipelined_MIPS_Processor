module mux_8_to_1 #(
    parameter WIDTH = 32
) (
    input   wire [2:0]          sel,
    input   wire [WIDTH-1: 0]   in0,
    input   wire [WIDTH-1: 0]   in1,
    input   wire [WIDTH-1: 0]   in2,
    input   wire [WIDTH-1: 0]   in3,
    input   wire [WIDTH-1: 0]   in4,
    input   wire [WIDTH-1: 0]   in5,
    input   wire [WIDTH-1: 0]   in6,
    input   wire [WIDTH-1: 0]   in7,
    output  reg  [WIDTH-1: 0 ]  out
);
    
    always @(*) begin
        case (sel)
            3'b000: out = in0; 
            3'b001: out = in1; 
            3'b010: out = in2; 
            3'b011: out = in3; 
            3'b100: out = in4; 
            3'b101: out = in5; 
            3'b110: out = in6; 
            3'b111: out = in7; 
        endcase
    end
endmodule