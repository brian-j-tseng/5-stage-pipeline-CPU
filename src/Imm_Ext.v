module Imm_Ext(
	input[31:0] inst,
	output reg[31:0] imm_ext_out
);

always@(*)
begin
case(inst[6:2])
//U type
5'b01101:
imm_ext_out[31:0] = { inst[31:12], 12'b0};
5'b00101:
imm_ext_out[31:0] = {inst[31:12], 12'b0};
//I type
5'b00000:
imm_ext_out[31:0] = { {20{inst[31]}}, inst[31:20] };
5'b00100:
imm_ext_out[31:0] = { {20{inst[31]}}, inst[31:20] };
5'b11001:
imm_ext_out[31:0] = { {20{inst[31]}}, inst[31:20] };
//B type
5'b11000:
imm_ext_out[31:0] = { {20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0 };
//S type
5'b01000:
imm_ext_out[31:0] = {{20{inst[31]}},inst[31:25],inst[11:7]};
//J type
5'b11011:
imm_ext_out[31:0] = { {12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0 };
default:
imm_ext_out[31:0] = 32'b0;
endcase
end
endmodule
