module ALU #(
	parameter DATA_WIDTH=32 
)(
input 	wire	[DATA_WIDTH-1:0] Operand1,
input 	wire	[DATA_WIDTH-1:0] Operand2,
//control signals
input	wire	[3:0]			 Cntrl,
input 	wire	[4:0]			 Shamt,
//data out
output	reg  	[DATA_WIDTH-1:0] ALU_OUT,
//flags
output	reg						 BF_OUT,
output	reg						 OF_OUT,
output	reg						 ZF_OUT,
output	reg						 NF_OUT
);

	localparam 	[3:0]	AND							= 'b0000,
						OR							= 'b0001,
						ADD							= 'b0010,
						XOR							= 'b0011,
						NOR							= 'b0100,
						Set_if_less_than_unsigned	= 'b0101,
						SUB							= 'b0110,
						Set_if_less_than			= 'b0111,
						Shift_left_logic     		= 'b1000,
						Shift_left_logic_by_var    	= 'b1001,
						Shift_right_logic     		= 'b1010,
						Shift_right_logic_by_var    = 'b1011,
						Shift_right_arith     		= 'b1100,
						Shift_right_arith_by_var   	= 'b1101;

	wire 	[DATA_WIDTH-1:0]  OP1_U,OP2_U,OP2_TEMP;

	assign	OP1_U = Operand1;
	assign	OP2_U = Operand2;
	assign 	OP2_TEMP = (~Operand2)+'d1; //2's complement										

	always @(*)begin
		OF_OUT = 'd0;
		BF_OUT = 'd0;
		case(Cntrl)
			AND 	:begin
					ALU_OUT = Operand1 & Operand2;
			end
			OR  	:begin
					ALU_OUT = Operand1 | Operand2;
			end	
			XOR 	:begin
					ALU_OUT = Operand1 ^ Operand2;
					end	
			NOR 	:begin
					ALU_OUT = ~(Operand1 | Operand2);
					end
			ADD 	:begin
					ALU_OUT = Operand1 + Operand2;
					if((Operand1[DATA_WIDTH-1] && Operand2[DATA_WIDTH-1] && !ALU_OUT[DATA_WIDTH-1]) || (!Operand1[DATA_WIDTH-1] && !Operand2[DATA_WIDTH-1] && ALU_OUT[DATA_WIDTH-1]))begin
						OF_OUT = 'd1;
					end
					else begin
						OF_OUT = 'd0;
					end
					end	
			Set_if_less_than_unsigned 	:begin
					if(OP1_U<OP2_U)begin
						ALU_OUT ='d1;
					end
					else begin
						ALU_OUT ='d0;
					end
					end	
			Set_if_less_than 	:begin
					if(Operand1<Operand2)begin
						ALU_OUT ='d1;
					end
					else begin
						ALU_OUT ='d0;
					end
					end	
			SUB 	:begin
					ALU_OUT = Operand1 + OP2_TEMP; //Operand1-Operand2
					if((Operand1[DATA_WIDTH-1] && Operand2[DATA_WIDTH-1] && !ALU_OUT[DATA_WIDTH-1]) || (!Operand1[DATA_WIDTH-1] && !Operand2[DATA_WIDTH-1] && ALU_OUT[DATA_WIDTH-1])) begin
						OF_OUT = 'd1;
					end
					else begin
						OF_OUT = 'd0;
					end
					end	
			Shift_left_logic 	:begin
						ALU_OUT = Operand2 << Shamt;
					end	
			Shift_left_logic_by_var 	:begin
						ALU_OUT = Operand2 << Operand1;
					end	
			Shift_right_logic 	:begin
						ALU_OUT = Operand2 >> Shamt;
					end	
			Shift_right_logic_by_var 	:begin
						ALU_OUT = Operand2 >> Operand1;
					end	
			Shift_right_arith 	:begin
						ALU_OUT = Operand2 >>> Shamt;
					end	
			Shift_right_arith_by_var 	:begin
						ALU_OUT = Operand2 >>> Operand1;
					end	
			default :begin
						ALU_OUT = 'd0;
						BF_OUT = 'b1;
					end	

		endcase
	end

	always @(*)begin
		NF_OUT = ALU_OUT[DATA_WIDTH-1];
		ZF_OUT = (ALU_OUT=='d0);
	end

endmodule
