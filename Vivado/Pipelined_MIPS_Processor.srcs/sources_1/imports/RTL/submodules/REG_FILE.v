module REG_FILE
    #(parameter RF_ADDR_WIDTH = 5,           // address bits
                RF_DATA_WIDTH = 32           // bits per word 
     )
    (       
        input wire clk,
        input wire n_reset,
        input wire wr_en,
        input wire [RF_ADDR_WIDTH-1 : 0] r_addr_1,
        input wire [RF_ADDR_WIDTH-1 : 0] r_addr_2,
        input wire [RF_ADDR_WIDTH-1 : 0] w_addr,
        input wire [RF_DATA_WIDTH-1 : 0] w_data,
        output wire [RF_DATA_WIDTH-1 : 0] r_data_1,
        output wire [RF_DATA_WIDTH-1 : 0] r_data_2
    );

    // storage elements
    reg [RF_DATA_WIDTH-1 : 0] array_reg [2**RF_ADDR_WIDTH-1 : 0];
    integer i;
    always @(posedge clk or negedge n_reset)  begin
        if(~n_reset)
            for (i = 0; i < 2**RF_ADDR_WIDTH; i = i + 1) begin
                array_reg[i] <= 0;
            end
        else if(wr_en) 
            array_reg[w_addr] <= w_data;
    end
    
    assign r_data_1 = array_reg[r_addr_1];
    assign r_data_2 = array_reg[r_addr_2];

endmodule
