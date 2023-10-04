module ROM
    #(
        parameter ADDRESS_WIDTH = 32,
        parameter INSTR_WIDTH = 32,
        parameter PROGRAM = "simple.txt"
    )
    (
        input wire [ADDRESS_WIDTH-1:0] addr, // Input address wire
        output wire [INSTR_WIDTH-1:0] instr // Output instruction wire
    );

    localparam DEPTH = 2**10; // Set the depth of the instruction memory

    reg [INSTR_WIDTH-1:0] memory [DEPTH-1:0];

    // Initialize the instruction memory contents from the file specified by PROGRAM
    initial begin
        $readmemh(PROGRAM, memory);
    end

    assign instr = memory[addr[31:2]]; // word aligned

endmodule