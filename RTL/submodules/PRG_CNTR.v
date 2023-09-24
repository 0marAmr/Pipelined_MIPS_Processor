module PRG_CNTR
#(  parameter N = 32   // Parameter defining the number of bits for the PC counter
)(
    input wire CLK,
    input wire RST,  
    input n_EN,  // Load input for setting a new PC value
    input [N-1: 0] pc_next,  // Input for the next PC value to be loaded
    output wire [N-1: 0] pc  // Output for the current PC value
    );

    reg [N-1: 0] current_pc;   // Register to hold the current PC value

    always @(posedge CLK or negedge RST) begin   // On every positive edge of the clock, or on a negative edge of reset
        if (~RST) begin   // If reset is active (low)
            current_pc <= 0;   // Reset the current PC value to zero
        end
        else if(~n_EN) begin   // If n_EN is active (high)
            current_pc <= pc_next;   // Set the current PC value to the new PC value (pc_next)
        end
    end
    assign pc = current_pc;
endmodule
