module Controller(
	 input clk,
	 input rst,
	 input [4:0] opcode,
	 input [2:0] fun_3,
	 input fun_7,
	 input [4:0] fun_5,//
	 input alu_out,
	 input [4:0]rd,
	 input [4:0]rs1,
	 input [4:0]rs2,
	 input predict,//
	 input mulbit,
	 output reg E_mulbit,
	 output reg [3:0] F_im_w_en,
	 output reg D_rs1_data_sel,
     output reg D_rs2_data_sel,
	 output reg [1:0] E_rs1_data_sel,
     output reg [1:0] E_rs2_data_sel,
 	 output reg E_jb_op1_sel,
	 output reg E_alu_op1_sel,
	 output reg E_alu_op2_sel,
	 output reg [4:0]E_opcode,
	 output reg [2:0] E_fun_3,
	 output reg E_fun_7,
	 output reg [3:0] M_dm_w_en,
	 output reg W_wb_sel,
	 output reg W_wb_en,
	output reg W_fwb_en,
	 output reg [4:0] W_rd_index, 
	 output reg [2:0]W_fun_3,
	 output reg next_pc_sel,
	 output reg stall,
	 output reg P_Mux_sel,
	 output reg [4:0] E_fun_5,//
	 output reg E_alu_falu_sel,//
	output reg D_rs1_sel,
	output reg D_rs2_sel,
	output reg [4:0] E_rs2
	//output reg b_check
);
//predict
reg D_predict;
reg E_predict;

reg [4:0] E_op;
reg [2:0] E_f3;
reg [4:0] E_rd;
reg [4:0] E_rs1;
reg  E_f7;
reg [4:0] M_op;
reg [2:0] M_f3;
reg [4:0] M_rd;
reg [4:0] W_op;
reg [2:0] W_f3;
reg [4:0] W_rd;
reg is_D_use_rs1;
reg is_D_use_rs2;
reg is_W_use_rd;
reg is_DE_overlap;
reg is_E_use_rs1;
reg is_E_use_rs2;
reg is_M_use_rd;
reg is_D_rs1_E_rd_overlap;
reg is_D_rs1_W_rd_overlap;
reg is_D_rs2_E_rd_overlap;
reg is_D_rs2_W_rd_overlap;
reg is_E_rs1_M_rd_overlap;
reg is_E_rs1_W_rd_overlap;
reg is_E_rs2_M_rd_overlap;
reg is_E_rs2_W_rd_overlap;


always@(posedge clk or posedge rst)
begin
if (rst) begin
		W_op <=5'b0;
		W_f3 <=3'b0;
		W_rd <=5'b0;
		M_op <=5'b0;
		M_f3 <=3'b0;
		M_rd <=5'b0;
		E_op <=5'b0;
		E_f3 <=3'b0;
		E_f7 <=1'b0;
		E_rs1 <=5'b0;
		E_rs2 <=5'b0;
		E_rd <=5'b0;
		D_predict <=1'b0;
		E_predict <=1'b0;
		E_mulbit<=1'b0;
		E_fun_5 <=5'b0;
end
else begin
		
		W_op <= M_op;
		W_f3 <= M_f3;
		W_rd <= M_rd;
		M_op <= E_op;
		M_f3 <= E_f3;
		M_rd <= E_rd;
		//predict
		
		D_predict <=predict;
		E_predict <=D_predict;

		E_mulbit <= mulbit;
		
		E_fun_5 <= fun_5;
		
	if(stall == 1'b0 && next_pc_sel == 1'b0)
		begin
		E_op <= opcode;
		E_f3 <= fun_3;
		E_f7 <= fun_7;
		E_rs1 <= rs1;
		E_rs2 <= rs2;
		E_rd <= rd;
		end
	else
		begin
		E_op <=5'b00100 ;
		E_f3 <= 3'b000;
		E_f7 <= {1'b0};
		E_rs1 <= 5'b0;
		E_rs2 <= {5{1'b0}};
		E_rd <= 5'b0;
		end

end
end
always@(*)
begin
	W_rd_index = W_rd;
	E_opcode = E_op;
	E_fun_3 = E_f3;
	E_fun_7 = E_f7;
	W_fun_3 = W_f3;

	//wb_en
	case(W_op)
	5'b00100:
		W_wb_en = 1'b1;
	5'b01100:
		W_wb_en = 1'b1;	
	5'b11011:
		W_wb_en = 1'b1;	
	5'b11001:
		W_wb_en = 1'b1;
	5'b01101:
		W_wb_en = 1'b1;
	5'b00101:
		W_wb_en = 1'b1;
	5'b00000:
		W_wb_en = 1'b1;
	
	default:
	W_wb_en = 1'b0;
	
	endcase

	//wb_en for float
	case(W_op)
	5'b00001:
		W_fwb_en = 1'b1;
	5'b10100:
		W_fwb_en = 1'b1;
	default:
	W_fwb_en = 1'b0;
	endcase
	
	//F_im_w_en
	F_im_w_en=4'b0000;

	//M_dm_w_en

	if (M_op == 5'b01000||M_op == 5'b01001)
	begin
	case(M_f3)
		3'b000: 
		M_dm_w_en =4'b0001;//sb
		3'b001:
		M_dm_w_en =4'b0011;//sh
		default:
		M_dm_w_en =4'b1111;//sw	
		endcase
	end
	else
	M_dm_w_en = 4'b0000;
	
	
        //P_Mux_sel
	if(E_predict==1'b1 && alu_out==1'b0 && E_op == 5'b11000)begin
		P_Mux_sel=1'b0;//pc
	end
	else begin
		P_Mux_sel=1'b1;//jb_out
	end

	//next_pc_sel
	if((E_op == 5'b11011 ) || (E_op == 5'b11001))//jal jalr
		next_pc_sel = 1'b1;
		
	else if(E_op == 5'b11000) //branch
	begin
		if(alu_out != E_predict)
		next_pc_sel = 1'b1;
		else
		next_pc_sel = 1'b0;
	end

	else
		next_pc_sel = 1'b0;
	
	// E_jb_op1_sel
	if(E_op == 5'b11001)
		E_jb_op1_sel = 1'b1; //jalr mux choose rs1
	else
		E_jb_op1_sel = 1'b0;

	// E_alu_op1_sel
	case(E_op)
		5'b00101: 
			E_alu_op1_sel = 1'b0; //auipc
		5'b11011:
			E_alu_op1_sel = 1'b0; //jal
		5'b11001:
			E_alu_op1_sel = 1'b0; //jalr
	default:
		E_alu_op1_sel = 1'b1;
	endcase

	//E_alu_op2_sel
	case(E_op)

		5'b01100:
			E_alu_op2_sel = 1'b1; //R type
		5'b11000:
			E_alu_op2_sel = 1'b1; //B type
		5'b10100:
			E_alu_op2_sel = 1'b1; //float
		default:
			E_alu_op2_sel = 1'b0;
		endcase
	//W_wb_sel
	if(W_op == 5'b00000||W_op == 5'b00001)
	W_wb_sel = 1'b1;
	else
	W_wb_sel = 1'b0;
	
	//D_rs1_data_sel
	case(opcode)
		5'b01101:
		is_D_use_rs1 = 1'b0;
		5'b00101:
		is_D_use_rs1 = 1'b0;
		5'b11011:
		is_D_use_rs1 = 1'b0;
		default:
		is_D_use_rs1 = 1'b1;
	endcase
	case(W_op)
		5'b11000:
		is_W_use_rd = 1'b0;
		5'b01000:
		is_W_use_rd = 1'b0;
		5'b01001:
		is_W_use_rd = 1'b0;	//FSW
		default:
		is_W_use_rd = 1'b1;	
	endcase
	is_D_rs1_W_rd_overlap = is_D_use_rs1 & is_W_use_rd & (rs1 == W_rd) & (W_rd != 5'b0);
	D_rs1_data_sel = is_D_rs1_W_rd_overlap ? 1'b1: 1'b0;
	


	//D_rs2_data_sel
case(opcode)
		5'b11000:
		is_D_use_rs2 = 1'b1; //B 
		5'b01000:
		is_D_use_rs2 = 1'b1; //S
		5'b01100:
		is_D_use_rs2 = 1'b1; //R
		5'b01001:
		is_D_use_rs2 = 1'b1; //FSW	
		5'b10100:
			if(fun_5 == 5'b00000||fun_5 == 5'b00001 || fun_5 == 5'b00010 || fun_5 == 5'b00101 || fun_5 == 5'b10100)
				is_D_use_rs2 = 1'b1; //float
		default:
		is_D_use_rs2 = 1'b0;
	endcase
	
	is_D_rs2_W_rd_overlap = is_D_use_rs2 & is_W_use_rd & (rs2 == W_rd) & (W_rd != 5'b0);
	D_rs2_data_sel = is_D_rs2_W_rd_overlap ? 1'b1: 1'b0;
	
	//E_rs1_data_sel
		case(E_op)
		5'b01101:
		is_E_use_rs1 = 1'b0;
		5'b00101:
		is_E_use_rs1 = 1'b0;
		5'b11011:
		is_E_use_rs1 = 1'b0;
		default:
		is_E_use_rs1 = 1'b1;
		endcase
	
	case(M_op)
		5'b11000:
		is_M_use_rd = 1'b0;
		5'b01000:
		is_M_use_rd = 1'b0;
		default:
		is_M_use_rd = 1'b1;	
	endcase
	is_E_rs1_W_rd_overlap = is_E_use_rs1 & is_W_use_rd & (E_rs1 == W_rd) & (W_rd != 5'b0);
	is_E_rs1_M_rd_overlap = is_E_use_rs1 & is_M_use_rd & (E_rs1 == M_rd) & (M_rd != 5'b0);
	
	if(is_E_rs1_M_rd_overlap)
	E_rs1_data_sel = 2'b01;
	else if(is_E_rs1_W_rd_overlap)
	E_rs1_data_sel = 2'b00;
	else
	E_rs1_data_sel = 2'b10;
	

					 
	//E_rs2_data_sel
	case(E_op)
		5'b11000:
		is_E_use_rs2 = 1'b1; //B 
		5'b01000:
		is_E_use_rs2 = 1'b1; //S
		5'b01100:
		is_E_use_rs2 = 1'b1; //R
		5'b01001:
		is_E_use_rs2 = 1'b1; //FSW	
		5'b10100:
			if(E_fun_5 == 5'b00000||E_fun_5 == 5'b00001 || E_fun_5 == 5'b00010 || E_fun_5 == 5'b00101 || E_fun_5 == 5'b10100)
				is_E_use_rs2 = 1'b1; //float	
		
		default:
		is_E_use_rs2 = 1'b0;
	endcase


	case(M_op)
		5'b11000:
		is_M_use_rd = 1'b0;
		5'b01000:
		is_M_use_rd = 1'b0;
		5'b01001:
		is_M_use_rd = 1'b0;	//FSW
		default:
		is_M_use_rd = 1'b1;	
	endcase
	is_E_rs2_W_rd_overlap = is_E_use_rs2 & is_W_use_rd & (E_rs2 == W_rd) & (W_rd != 5'b0);
	is_E_rs2_M_rd_overlap = is_E_use_rs2 & is_M_use_rd & (E_rs2 == M_rd) & (M_rd != 5'b0);

	if(is_E_rs2_M_rd_overlap)
	E_rs2_data_sel = 2'b01;
	else if(is_E_rs2_W_rd_overlap)
	E_rs2_data_sel = 2'b00;
	else
	E_rs2_data_sel = 2'b10;
	 
					 
	//stall
	is_D_rs1_E_rd_overlap = is_D_use_rs1 & (rs1 == E_rd) & (E_rd!=5'b0);
	is_D_rs2_E_rd_overlap = is_D_use_rs2 & (rs2 == E_rd) & (E_rd!=5'b0);
	is_DE_overlap = (is_D_rs1_E_rd_overlap || is_D_rs2_E_rd_overlap);
	stall = (E_op == 5'b00000||E_op == 5'b00001) & is_DE_overlap;
	// ALU/FALU
	if (E_op==5'b10100)
		E_alu_falu_sel = 1'b1;
	else 
		E_alu_falu_sel = 1'b0;


	if (opcode==5'b10100) begin
		if(fun_5 == 5'b11010 || fun_5 == 5'b11110)begin
			D_rs1_sel = 1'b0;
			D_rs2_sel = 1'b0;
		end
		else begin
			D_rs1_sel = 1'b1;
			D_rs2_sel = 1'b1;
		end
	end
	else begin
		D_rs1_sel = 1'b0;
		D_rs2_sel = 1'b0;
	end
	
		
	
end
endmodule
