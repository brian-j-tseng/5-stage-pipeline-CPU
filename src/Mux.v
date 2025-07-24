module Mux(
	input next_pc_sel,
	input E_jb_op1_sel,
	input E_alu_op1_sel,
	input E_alu_op2_sel,
	input W_wb_sel,
	input [31:0]F_pc,
	input [31:0]E_pc,
	input [31:0]rs1_data,
	input [31:0]rs2_data,
	input [31:0]rs1_data_out_to_mux,
	input [31:0]rs2_data_out_to_mux,
	input [31:0]imme,
	input [31:0]jb_pc,
	input [31:0]ld_data_f,
	//input [31:0]alu_out,
	input [31:0]alu_out_to_wbmux,
	input D_rs1_data_sel,
	input D_rs2_data_sel,
	input [1:0]E_rs1_data_sel,
	input [1:0]E_rs2_data_sel,
 	input E_alu_falu_sel,//new from controller//0 for alu result ,1 for falu result.
        input [31:0]f_rs1_data,//new
        input [31:0]f_rs2_data,//new
	input [31:0] M_alu_out,//change alu_out to M_alu_out
        input [31:0] E_alu_out,//new from alu result
        input [31:0] E_falu_out,//new from falu result
	output reg[31:0]rs1_data_out,
	output reg[31:0]rs2_data_out,
	output reg[31:0]newest_rs1_data,
	output reg[31:0]newest_rs2_data,
	output reg[31:0]operand1,
	output reg[31:0]operand2,
	output reg[31:0]jb_operand1,
	output reg[31:0]next_pc,
	output reg[31:0]wb_data,
	output reg[31:0]f_rs1_data_out,//new
	output reg[31:0]f_rs2_data_out,//new
	output reg[31:0]E_alu_falu_out//new
	
);

always@(*)
begin

	//wb mux
	if (W_wb_sel)
		wb_data = ld_data_f;
	else
		wb_data = alu_out_to_wbmux;

	//D_rs1_data mux
	if(D_rs1_data_sel)begin
	rs1_data_out = wb_data;
	f_rs1_data_out = wb_data;//new
	end
	else begin
	rs1_data_out = rs1_data;
	f_rs1_data_out = f_rs1_data;//new
	end

	//D_rs2_data mux
	if(D_rs2_data_sel)begin
	rs2_data_out = wb_data;
	f_rs2_data_out = wb_data;//new
	end
	else begin
	rs2_data_out = rs2_data;
	f_rs2_data_out = f_rs2_data;//new
	end

	//E_rs1_data mux
	case(E_rs1_data_sel)
	2'b00:
	newest_rs1_data = wb_data;	//wb forward
	2'b01:
	newest_rs1_data = M_alu_out; //mem forward
	default:
	newest_rs1_data = rs1_data_out_to_mux; 
	endcase

	//E_rs2_data mux
	case(E_rs2_data_sel)
	2'b00:
	newest_rs2_data = wb_data; //wb forward
	2'b01:
	newest_rs2_data = M_alu_out;	//mem forward
	default:
	newest_rs2_data = rs2_data_out_to_mux;
	endcase


	// pc mux
	if (next_pc_sel)
		next_pc = jb_pc;
	else
		next_pc = F_pc ;

	//alu mux1
	if (E_alu_op1_sel)
		operand1 = newest_rs1_data;
	else
		operand1 = E_pc;
	//alu mux2
	if (E_alu_op2_sel)
		operand2 = newest_rs2_data;
	else
		operand2 = imme;
	//jb mux
	if (E_jb_op1_sel)
		jb_operand1 = newest_rs1_data;
	else
		jb_operand1 = E_pc;
	//new 
	//E_alu_falu_out
	if(E_alu_falu_sel) 
                        E_alu_falu_out = E_falu_out;
	else
                        E_alu_falu_out = E_alu_out;
	//
	

end
endmodule
