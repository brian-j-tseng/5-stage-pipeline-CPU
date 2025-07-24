module MuxTwo(
	input [31:0] in0,
	input [31:0] in1,
	input sel,
	output reg [31:0] out

);

always@(*) begin
	if(sel == 1'd0)
		out = in0;
	else 
		out = in1;

end
endmodule


