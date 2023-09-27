module Hazard_unit #(
parameter RF_ADDR_WIDTH = 5
)(
//control unit outputs
input	wire						BranchD,   //in case a branch instr is being decoded
//pipeline registers
input	wire	[RF_ADDR_WIDTH-1:0]	RsD,RtD,
input	wire	[RF_ADDR_WIDTH-1:0]	RsE,RtE,
input	wire	[RF_ADDR_WIDTH-1:0]	WriteRegE, WriteRegM, WriteRegW,
//pipeline control signals
input	wire						RegWriteE, RegWriteM, RegWriteW,
input	wire						MemtoRegE, MemtoRegM,
//hazard control outputs
output	wire						StallF,StallD,
output	reg							ForwardAD,ForwardBD,   //mux selectors for sources to be compared, i case it is a branch instr
output	wire						FlushE,
output	reg	[1:0]					ForwardAE,ForwardBE,   //mux selectors for ALU sources
input	wire						JrD
);

//internal control signals
wire lwstall, branchstall, jrstall;
wire lwstall_cond, branchstall_cond1, branchstall_cond2, forward_cond_Rs_M, forward_cond_Rs_W, forward_cond_Rt_M, forward_cond_Rt_W, branch_forward_cond_Rs, branch_forward_cond_Rt, jrstall_cond1, jrstall_cond2;
wire [1:0] forward_cond_Rs, forward_cond_Rt;


//forwarding logic -- >> no branch
always @(*)begin
//Rs
	case(forward_cond_Rs)
		'b01:	begin
					ForwardAE = 'd1;  //ResultW
				end
				
		'b10:	begin
					ForwardAE = 'd2;  //ALUOutM
				end
				
		'b11:	begin
					ForwardAE = 'd2; /////////////////////////////////////////review
				end				

		default:begin
					ForwardAE = 'd0;
				end							
	endcase
	
//Rt
	case(forward_cond_Rt)
		'b01:	begin
					ForwardBE = 'd1;  //ResultW
				end
				
		'b10:	begin
					ForwardBE = 'd2;  //ALUOutM
				end
				
		'b11:	begin
					ForwardBE = 'd2; /////////////////////////////////////////review
				end				

		default:begin
					ForwardBE = 'd0;
				end							
	endcase	
	
end



//forwardig logic in case it is a branch instruction
always @(*)begin
//Rs
	if(branch_forward_cond_Rs)begin
		ForwardAD = 'd1;
	end
	else begin
		ForwardAD = 'd0;
	end
	
//Rt
	if(branch_forward_cond_Rs)begin
		ForwardBD = 'd1;
	end
	else begin
		ForwardBD = 'd0;
	end	
end


//stall consitions
assign lwstall_cond  = MemtoRegE && (((RsD != 'd0) && (RsD == RtE)) || ((RtD != 'd0) && (RtD == RtE)));
assign branchstall_cond1  = BranchD && RegWriteE (((RsD != 'd0) && (RsD == WriteRegE)) || ((RtD != 'd0) && (RtD == WriteRegE)));
assign branchstall_cond2  = BranchD && MemtoRegM (((RsD != 'd0) && (RsD == WriteRegM)) || ((RtD != 'd0) && (RtD == WriteRegM)));
assign jrstall_cond1 = JrD && RegWriteE ((RsD != 'd0) && (RsD == WriteRegE)) ;
assign jrstall_cond2 = JrD && MemtoRegM ((RsD != 'd0) && (RsD == WriteRegM));


//forwarding conditions
assign forward_cond_Rs = {forward_cond_Rs_M,forward_cond_Rs_W};
assign forward_cond_Rt = {forward_cond_Rt_M,forward_cond_Rt_W};
assign forward_cond_Rs_M = RegWriteM && ((RsE != 'd0) && (RsE == WriteRegM))  ;
assign forward_cond_Rt_M = RegWriteM && ((RtE != 'd0) && (RtE == WriteRegM)));
assign forward_cond_Rs_W = RegWriteW && ((RsE != 'd0) && (RsE == WriteRegW)) ;
assign forward_cond_Rt_W = RegWriteW && ((RtE != 'd0) && (RtE == WriteRegW));
assign branch_forward_cond_Rs = RegWriteM && ((RsD != 'd0) && (RsD == WriteRegM));
assign branch_forward_cond_Rt = RegWriteM && ((RtD != 'd0) && (RtD == WriteRegM));


//load stall logic
assign lwstall = lwstall_cond;


//branch stall logic
assign branchstall = branchstall_cond1 || branchstall_cond2;


// Jump register stall logic
assign jrstall = jrstall_cond1 || jrstall_cond2;


//stalling assignment
assign StallF = lwstall || branchstall || jrstall;
assign StallD = StallF;
assign FlushE = StallD;

endmodule