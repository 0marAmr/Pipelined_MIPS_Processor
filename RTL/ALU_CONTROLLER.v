module ALU_Controller (
    input wire [5:0] i_FunctE,     /*Connected to the function field of an R-type instruction (bits [5:0])*/
    input wire [2:0] i_ALUControlE,       /*Derived by ALU_OP from the sequence controller*/
    output reg [3:0] o_ALUCtrl
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
                    Shift_right_arith_by_var = 'b1101,
					MULT = 'b1110,
					DIV = 'b1111;

    wire [8:0] sel;
    assign sel = {i_ALUControlE, i_FunctE};
    always@(*)  begin    
        casex (sel)
            /*Load word - Load byte - Load byte unsigned - Load half word */
            'b000_xxxxxx: begin
                o_ALUCtrl = add;
            end    
            'b001_xxxxxx: begin
                o_ALUCtrl = subtract;
            end    
            'b011_xxxxxx : begin
                o_ALUCtrl = Set_if_less_than;
            end
            'b100_xxxxxx : begin
                o_ALUCtrl = AND;
            end    
            'b101_xxxxxx : begin
                o_ALUCtrl = OR;
            end    
            'b110_xxxxxx : begin
                o_ALUCtrl = XOR;
            end  
            'b111_xxxxxx : begin
                o_ALUCtrl = MULT;
            end  		
            'b010_001000 : begin /*Jump register*/
                o_ALUCtrl = 4'bxxxx;
            end           
            'b010_001001 : begin /*Jump and link reg*/
                o_ALUCtrl = add;
            end              
            'b010_100000 : begin /*add*/
                o_ALUCtrl = add;
            end              
            'b010_100001 : begin /*add unsigned*/
                o_ALUCtrl = add;
            end                 
            'b010_100010 : begin /*subtract*/
                o_ALUCtrl = subtract;
            end                 
            'b010_100011 : begin /*subtract unsigned*/
                o_ALUCtrl = subtract;
            end                 
            'b010_100100 : begin /*Logical AND*/
                o_ALUCtrl = AND;
            end                  
            'b010_100101 : begin /*Logical OR*/
                o_ALUCtrl = OR;
            end                  
            'b010_100110 : begin /*Logical XOR*/
                o_ALUCtrl = XOR;
            end                  
            'b010_100111 : begin /*Logical NOR*/
                o_ALUCtrl = NOR;
            end                  
            'b010_000000 : begin /*Shift left logic*/
                o_ALUCtrl = Shift_left_logic;
            end                  
            'b010_000100 : begin /*Shift left logic by variable*/
                o_ALUCtrl = Shift_left_logic_by_var;
            end                  
            'b010_000010 : begin /*Shift right logic*/
                o_ALUCtrl = Shift_right_logic;
            end                  
            'b010_000110 : begin /*Shift right logic by variable */
                o_ALUCtrl = Shift_right_logic_by_var;
            end                 
            'b010_000011 : begin /*Shift right arithmetic*/
                o_ALUCtrl = Shift_right_arith;
            end                   
            'b010_000111 : begin /*Shift right arithmetic by variable*/
                o_ALUCtrl = Shift_right_arith_by_var;
            end                   
            'b010_101001 : begin /*Set-if-less-than unsigned*/
                o_ALUCtrl = Set_if_less_than_unsigned;
            end                   
            'b010_101010 : begin /*Set-if-less-than*/
                o_ALUCtrl = Set_if_less_than;
            end
            'b010_011000 : begin 
                o_ALUCtrl = MULT;
            end
            'b010_011010 : begin 
                o_ALUCtrl = DIV;
            end		
            default: 
                o_ALUCtrl = 'bxxxx;
        endcase
    end
endmodule
