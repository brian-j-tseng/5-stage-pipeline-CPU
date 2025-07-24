`include "MUL_Booth.v"
module ALU(
	input[4:0] opcode,
	input[2:0] fun_3,
	input fun_7,
	input[31:0] operand1,
	input[31:0] operand2,
	input mulbit,//new
	output reg[31:0] alu_out
);
wire [31:0]mul_out;
MUL_Booth mul(.mult(operand1),.mulc(operand2),.updated_psum(mul_out));


always@(*)
begin
	case(opcode)
	// U lui
		5'b01101:
		alu_out=operand2;
	//U auipc
		5'b00101: 
		alu_out=operand1+operand2;
	//R 
		5'b01100:
		begin
		case(fun_3)

				3'b000:
				begin
				if(fun_7)
			// R sub
				alu_out = operand1 - operand2;
			// R add
				else begin
					if (mulbit)
					//mul
					alu_out= mul_out;//operand1*operand2;
					else
					alu_out = operand1 + operand2;
				end
			end
			//sll
				3'b001:
				alu_out = operand1 << operand2[4:0];
			//slt
				3'b010:
				begin
				if ($signed(operand1) < $signed(operand2))
					alu_out = 32'd1;
				else
					alu_out =32'd0;
				end
			//sltu
				3'b011:
				begin
				if (operand1 < operand2)
					alu_out = 32'd1;
				else
					alu_out = 32'd0;
				end
			//xor
				3'b100:
				alu_out = operand1 ^ operand2;
				3'b101:
					begin
				//sra
					if(fun_7)
					alu_out = $signed(operand1) >>> $signed(operand2[4:0]);
				//srl
					else
						alu_out =  operand1 >> operand2[4:0];
						
					end
					

			//or
				3'b110:
					alu_out = operand1 | operand2;
			//and
				default:
					alu_out = operand1 & operand2;
		

		endcase
		end
	//I type
		5'b00100:
			begin
			case(fun_3)
			//addi
			3'b000:
			alu_out = operand1 + operand2;
			//slli
			3'b001:
				alu_out = operand1 << operand2[4:0];
			
			3'b101:
			begin
				//srai
					if(fun_7)
					alu_out = $signed(operand1) >>> $signed(operand2[4:0]);
				//srli
					else
						alu_out =  operand1 >> operand2[4:0];
						
					end
			//slti
			3'b010:
				if ($signed(operand1) < $signed(operand2))
					alu_out = 32'd1;
				else
					alu_out = 32'd0;
			//sltiu
			3'b011:
				if (operand1 < operand2)
					alu_out = 32'd1;
				else
					alu_out = 32'd0;
			//xori
			3'b100:
				alu_out = operand1 ^ operand2;
			//ori
			3'b110:
				alu_out = operand1 | operand2;
			//andi
			default:
				alu_out = operand1 & operand2;

			endcase
				end
	//Load
		5'b00000:
				alu_out = operand1 + operand2;
	//Store
		5'b01000:
				alu_out = operand1 + operand2;
	
	//B type
		5'b11000:
			begin
				case(fun_3)
					3'b000: 
					alu_out = (operand1 == operand2) ?  32'd1 : 32'd0; //beq
					3'b001:
					alu_out = (operand1 == operand2) ? 32'd0 : 32'd1; //bne
					3'b100:
					alu_out = ($signed(operand1) < $signed(operand2)) ? 32'd1 : 32'd0; //blt
					3'b101:
					alu_out = ($signed(operand1) >= $signed(operand2)) ? 32'd1 : 32'd0; //bge
					3'b110:
					alu_out = (operand1 < operand2) ? 32'd1 : 32'd0; //bltu
					default:
					alu_out = (operand1 >= operand2) ? 32'd1 : 32'd0; //bgeu
					endcase
			end

		//jal
			5'b11011:
					alu_out = operand1 + 32'b100;
		//jalr:
			5'b11001:
					alu_out = operand1 + 32'b100;
	//FLW
		5'b00001:
				alu_out = operand1 + operand2;

	//FSW
		5'b01001:
				alu_out = operand1 + operand2;

		default: alu_out =32'd0;
		
	endcase
end
endmodule
