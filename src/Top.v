//`include "./src/SRAM.v"
`include "ALU.v"
`include "Decorder.v"
`include "Imm_Ext.v"
`include "JB_Unit.v"
`include "LD_Filter.v"
`include "RegFile.v"
`include "Reg_PC.v"
`include "Mux.v"
`include "Controller.v"
`include "Reg_D.v"
`include "Reg_E.v"
`include "Reg_M.v"
`include "Reg_W.v"

//new function
`include "FALU.v"
`include "MUL_Booth.v"//?
`include "MUL_Hierarchy.v"//?
`include "Branch_Predictor.v"
`include "FRegFile.v"
`include "sMUX.v"
//

module Top(
  input clk,
  input rst,
  output im_w_en,
  output F_pc[15:0],
  output F_inst,
  output dm_w_en,
  output M_alu_out,
  output M_rs2_data,
  output M_ld_data
);


  wire [31:0] next_pc; 
  wire[31:0] F_pc;
  wire[31:0] E_pc;
  wire[31:0] D_pc;

  wire[31:0] F_inst;
  wire[31:0] D_inst;

  wire[4:0] opcode;
  wire[4:0] E_op;

  wire[2:0] fun_3;
  wire[2:0] E_fun_3;
  wire[2:0] W_fun_3;

  //new
  wire[4:0] fun_5;
  wire[4:0] E_fun_5;
  //

  wire      fun_7;
  wire      E_fun_7;

  wire[4:0] rs1_index;
  wire[4:0] rs2_index;
  wire[4:0] rd_index;
  wire [4:0] W_rd_index;

  wire[31:0] rs1_data;
  wire[31:0] rs2_data;
  wire[31:0] f_rs1_data;//new
  wire[31:0] f_rs2_data;//new
  wire[31:0] M_rs2_data;

  wire[31:0] D_imme;
  wire[31:0] E_imme;

  wire[31:0] E_alu_out;
  wire[31:0] E_falu_out;//new
  wire[31:0] E_alu_falu_out;//new
  wire[31:0] M_alu_out;
  

  wire[31:0] M_ld_data;
  wire[31:0] W_ld_data;
  wire[31:0] ld_data_f;
  wire[31:0] wb_data;
  wire[31:0] jb_pc;
  wire wb_en;
  wire next_pc_sel;
  wire jb_op1_sel;
  wire alu_op1_sel;
  wire alu_op2_sel;
  wire wb_sel;
  wire[3:0] im_w_en;
  wire[3:0] dm_w_en;
  wire[31:0] operand1;
  wire[31:0] operand2;
  wire[31:0] jb_operand1;
  wire[31:0]rs1_data_out;
  wire[31:0]rs2_data_out;
  wire[31:0]f_rs1_data_out;//new
  wire[31:0]f_rs2_data_out;//new
  wire[31:0]D_rs1_out;
  wire[31:0]D_rs2_out;
  wire D_rs1_data_sel;
  wire D_rs2_data_sel;
  wire[1:0]E_rs1_data_sel;
  wire[1:0]E_rs2_data_sel;
  wire[31:0]rs1_data_out_to_mux;
  wire[31:0]rs2_data_out_to_mux;
  wire[31:0]newest_rs1_data;
  wire[31:0]newest_rs2_data;
  wire[31:0]alu_out_to_wbmux;
  wire stall;

Mux mux(
.next_pc_sel(next_pc_sel),
.F_pc(F_pc),
.E_pc(E_pc),
.next_pc(next_pc), 
.jb_pc(jb_pc),
.rs1_data(rs1_data),
.rs2_data(rs2_data),
.f_rs1_data(f_rs1_data),//new
.f_rs2_data(f_rs2_data),//new
.wb_data(wb_data),
.E_alu_falu_sel(),//new
.rs1_data_out(rs1_data_out),
.rs2_data_out(rs2_data_out),
.f_rs1_data_out(f_rs1_data_out),//new
.f_rs2_data_out(f_rs2_data_out),//new
.D_rs1_data_sel(D_rs1_data_sel),
.D_rs2_data_sel(D_rs2_data_sel),
.E_rs1_data_sel(E_rs1_data_sel),
.E_rs2_data_sel(E_rs2_data_sel),
.M_alu_out(M_alu_out),//chage alu_out to M_alu_out
.E_alu_out(E_alu_out)//new
.E_falu_out(E_falu_out),//new
.rs1_data_out_to_mux(rs1_data_out_to_mux),
.rs2_data_out_to_mux(rs2_data_out_to_mux),
.newest_rs1_data(newest_rs1_data),
.newest_rs2_data(newest_rs2_data),
.E_alu_op1_sel(alu_op1_sel),
.operand1(operand1),
.E_alu_op2_sel(alu_op2_sel),
.imme(E_imme),
.operand2(operand2),
.E_jb_op1_sel(jb_op1_sel),
.jb_operand1(jb_operand1),
.W_wb_sel(wb_sel),
.alu_out_to_wbmux(alu_out_to_wbmux),
.ld_data_f(ld_data_f),
.E_alu_falu_out(E_alu_falu_out)//new
);

//new
sMux sMux(
  rs1_data_out(rs1_data_out),
  rs2_data_out(rs2_data_out),
  f_rs1_data_out(f_rs1_data_out),
  f_rs2_data_out(f_rs2_data_out),
  //sel
  D_rs1_sel(D_rs1_sel);
  D_rs2_sel(D_rs2_sel);
  //out
  D_rs1_out(D_rs1_out);
  D_rs2_out(D_rs2_out);
);
//

Reg_PC PC(
.clk(clk),
.rst(rst),
.next_pc(next_pc),
.current_pc(F_pc),
.stall(stall)
);

/*SRAM im(
 .clk(clk),
 .w_en(im_w_en),
 .address(F_pc[15:0]),
 .read_data(F_inst),
 .write_data(1'b0)
);*/

Reg_D Reg_D(
.clk(clk),
.rst(rst),
.pc(F_pc),
.inst(F_inst),
.stall(stall),
.jb(next_pc_sel),
.pc_out(D_pc),
.inst_out(D_inst)
);

Decorder Decorder(
.inst(D_inst),
.dc_out_opcode(opcode),
.dc_out_func3(fun_3),
.dc_out_fun7(fun_7),
.dc_out_rs1_index(rs1_index),
.dc_out_rs2_index(rs2_index),
.dc_out_rd_index(rd_index)
);


Imm_Ext Imm_Ext(
.inst(D_inst),
.imm_ext_out(D_imme)
);

	
RegFile RegFile(
.clk(clk),
.wb_en(wb_en),
.wb_data(wb_data),
.rd_index(W_rd_index),
.rs1_index(rs1_index),
.rs2_index(rs2_index),
.rs1_data_out(rs1_data),
.rs2_data_out(rs2_data)
);
//new
FRegFile FRegFile(
clk(clk),
wb_en(wb_en),
wb_data(wb_data),
rd_index(W_rd_index),
rs1_index(rs1_index),
rs2_index(rs2_index),
rs1_data_out(f_rs1_data),// new wire
rs2_data_out(f_rs2_data)//new wire
);
//

Reg_E Reg_E(
.clk(clk),
.rst(rst),
.pc(D_pc),
.rs1_data(D_rs1_out),//change
.rs2_data(D_rs2_out),//change
.sext_imme(D_imme),
.stall(stall),
.jb(next_pc_sel),
.pc_out(E_pc),
.rs1_data_out(rs1_data_out_to_mux),
.rs2_data_out(rs2_data_out_to_mux),
.sext_imme_out(E_imme)
);


ALU ALU(
.opcode(E_op),
.fun_3(E_fun_3),
.fun_7(E_fun_7),
.operand1(operand1),
.operand2(operand2),
.alu_out(E_alu_out)
);

//new
FALU FALU(
   .func5(E_fun_5),//ir[31:27]
   .func3(E_fun_3),//ir[14:12]
   .func1(rs2_index[0]),//E_func1_out from controller//decide sign(0)or unsign(1) to transfer data
   .operand1(operand1),//輸入的運算子1
   .operand2(operand2),//輸入的運算子1
   .out(E_falu_out)//result
);
//

JB_Unit JB_Unit(
.operand1(jb_operand1),
.operand2(E_imme),
.jb_out(jb_pc)
);

Reg_M Reg_M(
.clk(clk),
.rst(rst),
.alu_out(E_alu_falu_out),//chage E_alu_out to E_alu_falu_out
.rs2_data(newest_rs2_data),
.alu_out_out(M_alu_out),
.rs2_data_out(M_rs2_data)
);

/*SRAM dm(
.clk(clk),
.w_en(dm_w_en),
.address(M_alu_out),
.write_data(M_rs2_data),
.read_data(M_ld_data)
);*/

Reg_W Reg_W(
.clk(clk),
.rst(rst),
.alu_out(M_alu_out),
.ld_data(M_ld_data),
.alu_out_out(alu_out_to_wbmux),
.ld_data_out(W_ld_data)
);

LD_Filter LD_Filter(
.fun_3(W_fun_3),
.ld_data(W_ld_data),
.ld_data_f(ld_data_f)
);



Controller Controller(
.clk(clk),
.rst(rst),
.opcode(opcode),
.fun_3(fun_3),
.fun_5(fun_5),//new
.fun_7(fun_7),
.alu_out(E_alu_falu_out[0]),//change E_alu_out to E_alu_falu_out[0]
.rd(rd_index),
.rs1(rs1_index),
.rs2(rs2_index),
.F_im_w_en(im_w_en),
.D_rs1_data_sel(D_rs1_data_sel),
.D_rs2_data_sel(D_rs2_data_sel),
.D_rs1_sel(D_rs1_sel),//new sel //0 for rs1 data 1 for frs1 data
.D_rs2_sel(D_rs2_sel),//new sel //0 for rs1 data 1 for frs1 data
.E_rs1_data_sel(E_rs1_data_sel),
.E_rs2_data_sel(E_rs2_data_sel),
.E_jb_op1_sel(jb_op1_sel),
.E_alu_op1_sel(alu_op1_sel),
.E_alu_op2_sel(alu_op2_sel),
.E_opcode(E_op),
.E_fun_3(E_fun_3),
.E_fun_5(E_fun_5),//new
.E_fun_7(E_fun_7),
.M_dm_w_en(dm_w_en),
.W_wb_sel(wb_sel),
.W_wb_en(wb_en),
.W_rd_index(W_rd_index), 
.W_fun_3(W_fun_3),
.next_pc_sel(next_pc_sel),
.stall(stall)
);



endmodule
