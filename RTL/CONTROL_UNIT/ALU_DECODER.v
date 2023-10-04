module ALU_DECODER (
    input wire [5:0] funct,     
    input wire [2:0] alu_op,    
    output reg [3:0] ALUControl
);
    
    /*ALU Operation*/
    localparam      AND = 'b0000,
                    OR = 'b0001,
                    add = 'b0010,
                    XOR = 'b0011,
                    NOR= 'b0100,
                    Set_if_less_than_unsigned = 'b0101,
                    subtract = 'b0110,
                    Set_if_less_than = 'b0111,
                    Shift_left_logic = 'b1000,
                    Shift_left_logic_by_var = 'b1001,
                    Shift_right_logic = 'b1010,
                    Shift_right_logic_by_var = 'b1011,
                    Shift_right_arith = 'b1100,
                    Shift_right_arith_by_var = 'b1101;

    wire [8:0] sel;
    assign sel = {alu_op,funct};
always@(*)  begin
    
    casex (sel)
        /*Load word - Load byte - Load byte unsigned - Load half word */
        'b000_xxxxxx: begin
            ALUControl = add;
        end    
        'b001_xxxxxx: begin
            ALUControl = subtract;
        end    
        'b011_xxxxxx : begin
            ALUControl = Set_if_less_than;
        end
        'b100_xxxxxx : begin
            ALUControl = AND;
        end    
        'b101_xxxxxx : begin
            ALUControl = OR;
        end    
        'b110_xxxxxx : begin
            ALUControl = XOR;
        end              
        'b010_100000 : begin /*add*/
            ALUControl = add;
        end              
        'b010_100001 : begin /*add unsigned*/
            ALUControl = add;
        end                 
        'b010_100010 : begin /*subtract*/
            ALUControl = subtract;
        end                 
        'b010_100011 : begin /*subtract unsigned*/
            ALUControl = subtract;
        end                 
        'b010_100100 : begin /*Logical AND*/
            ALUControl = AND;
        end                  
        'b010_100101 : begin /*Logical OR*/
            ALUControl = OR;
        end                  
        'b010_100110 : begin /*Logical XOR*/
            ALUControl = XOR;
        end                  
        'b010_100111 : begin /*Logical NOR*/
            ALUControl = NOR;
        end                  
        'b010_000000 : begin /*Shift left logic*/
            ALUControl = Shift_left_logic;
        end                  
        'b010_000100 : begin /*Shift left logic by variable*/
            ALUControl = Shift_left_logic_by_var;
        end                  
        'b010_000010 : begin /*Shift right logic*/
            ALUControl = Shift_right_logic;
        end                  
        'b010_000110 : begin /*Shift right logic by variable */
            ALUControl = Shift_right_logic_by_var;
        end                 
        'b010_000011 : begin /*Shift right arithmetic*/
            ALUControl = Shift_right_arith;
        end                   
        'b010_000111 : begin /*Shift right arithmetic by variable*/
            ALUControl = Shift_right_arith_by_var;
        end                   
        'b010_101001 : begin /*Set-if-less-than unsigned*/
            ALUControl = Set_if_less_than_unsigned;
        end                   
        'b010_101010 : begin /*Set-if-less-than*/
            ALUControl = Set_if_less_than;
        end
        default: 
            ALUControl = 'b0;
    endcase
end

endmodule