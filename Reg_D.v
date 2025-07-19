module Reg_D(
    input clk,
	input rst,
    input [31:0] pc,
    input [31:0] inst,
    input stall,
    input jb,
    output reg [31:0] pc_out,
    output reg [31:0] inst_out
);

always@(posedge clk or posedge rst)
begin
if (rst)begin
 pc_out <= 32'b0;
inst_out <=32'b0;
end
//stall
else if(stall)
    begin
    pc_out <= pc_out;
    inst_out <= inst_out;
    end

else if(jb)
//jb
    begin
    pc_out <= 32'b0;
    inst_out <= {25'b0,7'b0010011};
    end
else
    begin 
    pc_out <= pc;
    inst_out <= inst;
    end
end
endmodule
