module ADDER
#(  parameter N = 32  // N is the number of bits in the adder
)(
    input [N-1:0] X, Y,  // the two input vectors
    output [N-1:0] Z    // the sum output vector
    );
    
    assign Z = X + Y;
endmodule

