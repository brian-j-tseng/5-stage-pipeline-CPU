module Reg_E(
    input clk,
	input rst,
    input [31:0] pc,
    input [31:0] rs1_data,
    input [31:0] rs2_data,
    input [31:0] sext_imme,
    input stall,
    input jb,
    output reg [31:0] pc_out,
    output reg [31:0] rs1_data_out,
    output reg[31:0] rs2_data_out,
    output reg[31:0] sext_imme_out
);

always@(posedge clk or posedge rst)
begin
if (rst)begin 
 pc_out <= 32'b0;
    rs1_data_out <= 32'b0;
    rs2_data_out <= 32'b0;
    sext_imme_out <= 32'b0;
end
else if(stall || jb)
    begin
    pc_out <= 32'b0;
    rs1_data_out <= 32'b0;
    rs2_data_out <= 32'b0;
    sext_imme_out <= 32'b0;
    end
else
    begin
    pc_out <= pc;
    rs1_data_out <= rs1_data;
    rs2_data_out <= rs2_data;
    sext_imme_out <= sext_imme;
    end


end
endmodule
