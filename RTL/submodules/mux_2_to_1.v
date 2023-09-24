module mux_2_to_1
#(
    parameter N = 32
)
(
    input wire [N-1: 0]  data_true,
    input wire [N-1: 0]  data_false,
    input wire           sel,
    output wire [N-1: 0] data_out
);

    assign data_out = (sel) ? data_true : data_false;

endmodule
