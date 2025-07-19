module ALU(
	input[4:0] opcode,
	input[2:0] fun_3,
	input fun_7,
	input[31:0] operand1,
	input[31:0] operand2,
	output reg[31:0] alu_out
);

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
				else
				alu_out = operand1 + operand2;
			end
			//sll
				3'b001:
				alu_out = operand1 << operand2[4:0];
			//slt
				3'b010:
				begin
				if ($signed(operand1) < $signed(operand2))
					alu_out = 1;
				else
					alu_out = 0;
				end
			//sltu
				3'b011:
				begin
				if (operand1 < operand2)
					alu_out = 1;
				else
					alu_out = 0;
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
					alu_out = 1;
				else
					alu_out = 0;
			//sltiu
			3'b011:
				if (operand1 < operand2)
					alu_out = 1;
				else
					alu_out = 0;
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
					alu_out = (operand1 == operand2) ?  1 : 0; //beq
					3'b001:
					alu_out = (operand1 == operand2) ? 0 : 1; //bne
					3'b100:
					alu_out = ($signed(operand1) < $signed(operand2)) ? 1 : 0; //blt
					3'b101:
					alu_out = ($signed(operand1) >= $signed(operand2)) ? 1 : 0; //bge
					3'b110:
					alu_out = (operand1 < operand2) ? 1 : 0; //bltu
					default:
					alu_out = (operand1 >= operand2) ? 1 : 0; //bgeu
					endcase
			end

		//jal
			5'b11011:
					alu_out = operand1 + 32'b100;
		//jalr:
			5'b11001:
					alu_out = operand1 + 32'b100;
		default: alu_out = alu_out;
		
	endcase
end
endmodule
