module P_Mux(
  input [31:0] jb_out,
  input [31:0] pc,
  //sel
  input P_Mux_sel,
  //out
  output reg[31:0] jb_pc_out
);

always@(*)begin
	if(P_Mux_sel)
	jb_pc_out=jb_out;
	else 

	jb_pc_out=pc+32'd4;
end
endmodule

