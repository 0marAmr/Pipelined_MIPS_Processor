module mux_4_to_1 #(
    parameter N = 32
) (
    input   wire [1:0]      sel,
    input   wire [N-1: 0]   in0,
    input   wire [N-1: 0]   in1,
    input   wire [N-1: 0]   in2,
    input   wire [N-1: 0]   in3,
    output  reg  [N-1: 0 ]  out
);
    
    always @(*) begin
        case (sel)
            2'b00: out = in0; 
            2'b01: out = in1; 
            2'b10: out = in2; 
            2'b11: out = in3; 
        endcase
    end
endmodule