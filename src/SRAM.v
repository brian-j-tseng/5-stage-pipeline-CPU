module SRAM(
	input clk,
	input[3:0] w_en,
	input[15:0] address,
	input [31:0] write_data,
	output reg[31:0] read_data
	);
reg[7:0] mem[0:65535];
reg[7:0] mem1,mem2,mem3,mem4;
always@(*)
begin
read_data[7:0] = mem[address];
read_data[15:8] = mem[address+1];
read_data[23:16] = mem[address+2];
read_data[31:24] = mem[address+3];
end

/*always@(posedge clk)begin
	if(w_en)begin
		$display("%b %h %h", w_en, address,  write_data);
	end
	
end
 */
always@(*)begin
case(w_en)
4'b0001:begin
mem1 = write_data[7:0];
mem2 = mem[address + 1];
mem3 = mem[address + 2];
mem4 = mem[address + 3];
end
4'b0011:
begin
mem1 = write_data[7:0];
mem2 = write_data[15:8];
mem3= mem[address + 2];
mem4= mem[address + 3];
end
4'b0111:
begin
mem1 = write_data[7:0];
mem2 = write_data[15:8];
mem3= write_data[23:16];
mem4= mem[address + 3];
end
4'b1111:
begin
mem1 = write_data[7:0];
mem2 = write_data[15:8];
mem3= write_data[23:16];
mem4 = write_data[31:24];
end
default: begin
mem1 = mem[address];
mem2 = mem[address + 1];
mem3 = mem[address + 2];
mem4 = mem[address + 3];
end
endcase 

end
always@(posedge clk)begin
if(w_en)begin
mem[address] <= mem1;
mem[address + 1] <= mem2;
mem[address + 2] <= mem3;
mem[address + 3] <= mem4;
end
end
endmodule
