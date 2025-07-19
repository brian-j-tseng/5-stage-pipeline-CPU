module sMux(
  input [31:0] rs1_data_out,
  input [31:0] rs2_data_out,
  input [31:0] f_rs1_data_out,
  input [31:0] f_rs2_data_out,
  //sel
  input D_rs1_sel;
  input D_rs2_sel;
  //out
  output [31:0] D_rs1_out;
  output [31:0] D_rs2_out;
);
always @(*) begin
  //D_rs1_out
  if(~D_rs1_sel)D_rs1_out=rs1_data_out;
  else D_rs1_out=f_rs1_data_out;
  //D_rs2_out
  if(~D_rs2_sel)D_rs2_out=rs2_data_out;
  else D_rs2_out=f_rs2_data_out;
end
