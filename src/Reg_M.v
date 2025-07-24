module Reg_M(
    input clk,
	input rst,
    input [31:0] alu_out,
    input [31:0] rs2_data,
input [31:0] pc,
    output reg [31:0] alu_out_out,
output reg [31:0] pc_out,
    output reg [31:0] rs2_data_out
);
always@(posedge clk or posedge rst)
begin
if (rst)begin
alu_out_out <= 32'd0;
rs2_data_out <= 32'd0;
pc_out<=32'd0;
end
else begin
alu_out_out <= alu_out;
rs2_data_out <= rs2_data;
pc_out<= pc;
end
end
endmodule
