module Decorder(
	input[31:0] inst,
	output reg[4:0] dc_out_opcode,
	output reg[2:0] dc_out_func3,
	output reg[4:0] dc_out_func5,
	output reg  dc_out_fun7,
	output reg[4:0] dc_out_rs1_index,
	output reg[4:0] dc_out_rs2_index,
	output reg[4:0] dc_out_rd_index,
	output reg mulbit//new
	);

always@(*)
begin
dc_out_opcode[4:0] = inst[6:2];
dc_out_rd_index[4:0] = inst[11:7];
dc_out_func3[2:0] = inst[14:12];
dc_out_rs1_index[4:0] = inst[19:15];
dc_out_rs2_index[4:0] = inst[24:20];
dc_out_fun7 = inst[30];
mulbit = inst[25];
dc_out_func5[4:0] = inst[31:27];
end

endmodule
