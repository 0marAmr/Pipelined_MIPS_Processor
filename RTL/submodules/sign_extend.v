`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2023 08:06:15 AM
// Design Name: 
// Module Name: sign_extend
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SIGN_EXT(
    input  wire [15:0] instr_part,                        // Input instruction part with most significant bits unused
    output wire [31:0] data_out_signed               // Output signed data with the specified immediate value
    );

    assign data_out_signed = {{16{instr_part[15]}}, instr_part};

endmodule


