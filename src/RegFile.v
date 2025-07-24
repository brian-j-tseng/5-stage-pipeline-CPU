module RegFile(
	input clk,
	input rst,
	input wb_en,
	input[31:0] wb_data,
	input[4:0] rd_index,
	input[4:0] rs1_index,
	input[4:0] rs2_index,
	output reg[31:0] rs1_data_out,
	output reg[31:0] rs2_data_out
);
reg[31:0] registers[0:31];
integer i;
//read
always@(*)
begin
rs1_data_out[31:0] = registers[rs1_index];
rs2_data_out[31:0] = registers[rs2_index];
end

//write

always @ (posedge clk) begin
    if(rst)begin
		for(i=0;i<32;i=i+1)begin
			registers[i]<=32'd0;
		end
	end
    else if (wb_en && (rd_index != 5'b0)) begin
        registers[rd_index] <= wb_data;
    end
    registers[0] <= 32'd0;
end 

endmodule
