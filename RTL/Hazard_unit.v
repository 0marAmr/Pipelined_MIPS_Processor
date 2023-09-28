module Hazard_unit #(
parameter RF_ADDR_WIDTH = 5
)(
//control unit outputs
input	wire						i_BranchD,   //from control unit : BranchD = 1 in case of a bltz,beq,bne,blez or bgtz instr
//pipeline registers
input	wire	[RF_ADDR_WIDTH-1:0]	i_RsD,
input	wire	[RF_ADDR_WIDTH-1:0]	i_RtD,
input	wire	[RF_ADDR_WIDTH-1:0]	i_RsE,
input	wire	[RF_ADDR_WIDTH-1:0]	i_RtE,
input	wire	[RF_ADDR_WIDTH-1:0]	i_WriteRegE,
input	wire	[RF_ADDR_WIDTH-1:0]	i_WriteRegM, 
input	wire	[RF_ADDR_WIDTH-1:0]	i_WriteRegW,
//pipeline control signals
input	wire						i_RegWriteE, 
input	wire						i_RegWriteM, 
input	wire						i_RegWriteW,
input	wire						i_MemtoRegE, 
input	wire						i_MemtoRegM,
input	wire						i_MemtoRegW,
//hazard control outputs
output	wire						o_MemDataSelM,  //to memory stage
output	wire						o_StallF,
output	wire						o_StallD,
output	reg							o_ForwardAD,   //mux selectors for sources to be compared, i case it is a branch instr
output	reg							o_ForwardBD,   //mux selectors for sources to be compared, i case it is a branch instr
output	wire						o_FlushE,
output	reg		[1:0]				o_ForwardAE,   //mux selectors for ALU sources
output	reg		[1:0]				o_ForwardBE,   //mux selectors for ALU sources
input	wire						i_JrD,                  //from control unit : i_JrD = 1 in case of a JR OR a JALR
input	wire						i_JD,				      //from control unit : i_JD = 1 in case of a J OR a JAL
input	wire						i_ALUSrcD
);

//internal control signals
wire lwstall, branchstall, jrstall;
wire lwstall_cond, branchstall_cond1, branchstall_cond2, forward_cond_Rs_M, forward_cond_Rs_W, forward_cond_Rt_M, forward_cond_Rt_W, branch_forward_cond_Rs, branch_forward_cond_Rt, jrstall_cond1, jrstall_cond2, lw_forward_cond;
wire [1:0] forward_cond_Rs, forward_cond_Rt;


//forwarding logic -- >> no branch
always @(*)begin
//Rs
	case(forward_cond_Rs)
		'b01:	begin
					o_ForwardAE = 'd1;  //ResultW
				end
				
		'b10:	begin
					o_ForwardAE = 'd2;  //ALUOutM
				end
				
		'b11:	begin
					o_ForwardAE = 'd2; /////////////////////////////////////////review
				end				

		default:begin
					o_ForwardAE = 'd0;
				end							
	endcase
	
//Rt
	case(forward_cond_Rt)
		'b01:	begin
					o_ForwardBE = 'd1;  //ResultW
				end
				
		'b10:	begin
					o_ForwardBE = 'd2;  //ALUOutM
				end
				
		'b11:	begin
					o_ForwardBE = 'd2; /////////////////////////////////////////review
				end				

		default:begin
					o_ForwardBE = 'd0;
				end							
	endcase	
	
end



//forwardig logic in case it is a branch instruction
always @(*)begin
//Rs
	if(branch_forward_cond_Rs)begin
		o_ForwardAD = 'd1;
	end
	else begin
		o_ForwardAD = 'd0;
	end
	
//Rt
	if(branch_forward_cond_Rt)begin
		o_ForwardBD = 'd1;
	end
	else begin
		o_ForwardBD = 'd0;
	end	
end


//stall consitions
assign lwstall_cond  = (i_MemtoRegE && (((i_RsD != 'd0) && (i_RsD == i_RtE)) || ((i_RtD != 'd0) && (i_RtD == i_RtE) && !i_ALUSrcD && !(i_JrD))) ) && !(i_JD);
assign branchstall_cond1  = BranchD && i_RegWriteE && (((i_RsD != 'd0) && (i_RsD == i_WriteRegE)) || ((i_RtD != 'd0) && (i_RtD == i_WriteRegE)));
assign branchstall_cond2  = BranchD && i_MemtoRegM && (((i_RsD != 'd0) && (i_RsD == i_WriteRegM)) || ((i_RtD != 'd0) && (i_RtD == i_WriteRegM)));
assign jrstall_cond1 = (i_JrD) && i_RegWriteE && ((i_RsD != 'd0) && (i_RsD == i_WriteRegE)) ;
assign jrstall_cond2 = (i_JrD) && i_MemtoRegM && ((i_RsD != 'd0) && (i_RsD == i_WriteRegM));

 
//forwarding conditions
assign forward_cond_Rs = {forward_cond_Rs_M,forward_cond_Rs_W};
assign forward_cond_Rt = {forward_cond_Rt_M,forward_cond_Rt_W};
assign forward_cond_Rs_M = i_RegWriteM && ((i_RsE != 'd0) && (i_RsE == i_WriteRegM))  ;
assign forward_cond_Rt_M = i_RegWriteM && ((i_RtE != 'd0) && (i_RtE == i_WriteRegM));
assign forward_cond_Rs_W = i_RegWriteW && ((i_RsE != 'd0) && (i_RsE == i_WriteRegW)) ;
assign forward_cond_Rt_W = i_RegWriteW && ((i_RtE != 'd0) && (i_RtE == i_WriteRegW));
assign branch_forward_cond_Rs = i_RegWriteM && ((i_RsD != 'd0) && (i_RsD == i_WriteRegM));
assign branch_forward_cond_Rt = i_RegWriteM && ((i_RtD != 'd0) && (i_RtD == i_WriteRegM));
assign lw_forward_cond = (i_WriteRegM == i_WriteRegW) && i_MemtoRegW;   // a load followed by a store


//memory data source selector
assign o_MemDataSelM = lw_forward_cond;


//load stall logic
assign lwstall = lwstall_cond;


//branch stall logic
assign branchstall = branchstall_cond1 || branchstall_cond2;


// Jump register stall logic
assign jrstall = jrstall_cond1 || jrstall_cond2;


//stalling assignment
assign o_StallF = lwstall || branchstall || jrstall;
assign o_StallD = o_StallF;
assign o_FlushE = o_StallD;

endmodule