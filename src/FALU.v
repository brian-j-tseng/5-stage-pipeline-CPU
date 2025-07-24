`define ABS_1 operand1 [30:0]//absolute value of op1
`define ABS_2 operand2 [30:0]//absolute valve of op2
`define EXP_1 operand1 [30:23]//exponenent 1
`define EXP_2 operand2 [30:23]//exponenent 2
`define MAN_1 operand1 [22:0]//mantissa 1
`define MAN_2 operand2 [22:0]//mantissa 2

//define funct5
`define ADD 5'b00000//FADD
`define SUB 5'b00001//FSUB
`define MUL 5'b00010//FMUL
`define MIN_MAX 5'b00101//FMIN or FMAX
`define FCVTWS 5'b11000//FCVT.W.S
`define FCVTSW 5'b11010//FCVT.S.W
`define FMVWX 5'b11110//FMV.X.W 
`define FMVXW 5'b11100//FMV.W.X 
`define FEQ_LT_LE 5'b10100//FEQ or FLT or FLE

module FALU(
   input [4:0] func5,//ir[31:27]
   input [2:0] func3,//ir[14:12]
   input func1,//from E_rs2[0]
   input [31:0] operand1,
   input [31:0] operand2,
   output reg [31:0] out//result
);
//add and sub set
   reg [7:0] exp_shift;
   reg [36:0] add_man1, add_man2, temp_result_add, shift_1, shift_2;//37bits
   reg lar , true_sign; ////true_sign
//MUL set
   reg [23:0] mul_man1, mul_man2;
   reg [8:0] exp_mul_res;
   reg [47:0] temp_result_mul;//why 48bits
//universe set
   reg overflow, mul_sign;

/////////////////////////// ADD or SUB ///////////////////////
   wire sign_add;
   always@(*) begin
      if(`ABS_1 > `ABS_2) begin
         exp_shift = `EXP_1-`EXP_2;
         lar= 1'b0;
      end
      else begin
         exp_shift = `EXP_2-`EXP_1;
         lar= 1'b1;
      end
   end
   
   always@(*) begin
      
      true_sign=func5[0]^operand1[31]^operand2[31];//func5[0]:0 for add,1 for sub
      add_man1={2'd1,`MAN_1,{12'd0}};
      add_man2={2'd1,`MAN_2,{12'd0}};
   end
   always@(*) begin
            if(~lar) begin//abs_op1>abs_op2
               shift_2=add_man2>>exp_shift;
               shift_1=add_man1;
            end
            else begin//abs_op2>abs_op1
               shift_1=add_man1>>exp_shift;
               shift_2=add_man2;
            end
      if(true_sign) begin
         if(shift_1>shift_2) temp_result_add=shift_1-shift_2;
         else temp_result_add=shift_2-shift_1;
      end
         else temp_result_add=shift_1+shift_2;
   end
   assign sign_add=(~true_sign)? operand1[31]: (shift_1<shift_2)?(operand2[31]^func5[0]):operand1[31];
//ADD or SUB normalize
   wire [22:0] man_result_add;
   wire [36:0] temp_result_add_s;
   reg [8:0]  exp_result_add;
   reg [8:0]  normal_add;
   reg [5:0]  normal_add_shift;
   


   always@(*) begin
      if(temp_result_add[36]&&(~true_sign)) normal_add=9'b111111111;
      else if (temp_result_add[35]) normal_add=9'd0;
      else if (temp_result_add[34]) normal_add=9'd1;
      else if (temp_result_add[33]) normal_add=9'd2;
      else if (temp_result_add[32]) normal_add=9'd3;
      else if (temp_result_add[31]) normal_add=9'd4;
      else if (temp_result_add[30]) normal_add=9'd5;
      else if (temp_result_add[29]) normal_add=9'd6;
      else if (temp_result_add[28]) normal_add=9'd7;
      else if (temp_result_add[27]) normal_add=9'd8;
      else if (temp_result_add[26]) normal_add=9'd9;
      else if (temp_result_add[25]) normal_add=9'd10;
      else if (temp_result_add[24]) normal_add=9'd11;
      else if (temp_result_add[23]) normal_add=9'd12;
      else if (temp_result_add[22]) normal_add=9'd13;
      else if (temp_result_add[21]) normal_add=9'd14;
      else if (temp_result_add[20]) normal_add=9'd15;
      else if (temp_result_add[19]) normal_add=9'd16;
      else if (temp_result_add[18]) normal_add=9'd17;
      else if (temp_result_add[17]) normal_add=9'd18;
      else if (temp_result_add[16]) normal_add=9'd19;
      else if (temp_result_add[15]) normal_add=9'd20;
      else if (temp_result_add[14]) normal_add=9'd21;
      else if (temp_result_add[13]) normal_add=9'd22;
      else if (temp_result_add[12]) normal_add=9'd23;
      else if (temp_result_add[11]) normal_add=9'd24;
      /*else if (temp_result_add[10]) normal_add=9'd25;
      else if (temp_result_add[9]) normal_add=9'd26;
      else if (temp_result_add[8]) normal_add=9'd27;
      else if (temp_result_add[7]) normal_add=9'd28;
      else if (temp_result_add[6]) normal_add=9'd29;
      else if (temp_result_add[5]) normal_add=9'd30;
      else if (temp_result_add[4]) normal_add=9'd31;
      else if (temp_result_add[3]) normal_add=9'd32;
      else if (temp_result_add[2]) normal_add=9'd33;
      else if (temp_result_add[1]) normal_add=9'd34;
      else if (temp_result_add[0]) normal_add=9'd35;*/
      else  normal_add=9'd36;
   end
   
    always@(*) begin
      if(temp_result_add[36]&&(~true_sign)) normal_add_shift=6'd0;
      else if (temp_result_add[35]) normal_add_shift=6'd1;
      else if (temp_result_add[34]) normal_add_shift=6'd2;
      else if (temp_result_add[33]) normal_add_shift=6'd3;
      else if (temp_result_add[32]) normal_add_shift=6'd4;
      else if (temp_result_add[31]) normal_add_shift=6'd5;
      else if (temp_result_add[30]) normal_add_shift=6'd6;
      else if (temp_result_add[29]) normal_add_shift=6'd7;
      else if (temp_result_add[28]) normal_add_shift=6'd8;
      else if (temp_result_add[27]) normal_add_shift=6'd9;
      else if (temp_result_add[26]) normal_add_shift=6'd10;
      else if (temp_result_add[25]) normal_add_shift=6'd11;
      else if (temp_result_add[24]) normal_add_shift=6'd12;
      else if (temp_result_add[23]) normal_add_shift=6'd13;
      else if (temp_result_add[22]) normal_add_shift=6'd14;
      else if (temp_result_add[21]) normal_add_shift=6'd15;
      else if (temp_result_add[20]) normal_add_shift=6'd16;
      else if (temp_result_add[19]) normal_add_shift=6'd17;
      else if (temp_result_add[18]) normal_add_shift=6'd18;
      else if (temp_result_add[17]) normal_add_shift=6'd19;
      else if (temp_result_add[16]) normal_add_shift=6'd20;
      else if (temp_result_add[15]) normal_add_shift=6'd21;
      else if (temp_result_add[14]) normal_add_shift=6'd22;
      else if (temp_result_add[13]) normal_add_shift=6'd23;
      else if (temp_result_add[12]) normal_add_shift=6'd24;
      else if (temp_result_add[11]) normal_add_shift=6'd25;
      /*else if (temp_result_add[10]) normal_add_shift=6'd26;
      else if (temp_result_add[9]) normal_add_shift=6'd27;
      else if (temp_result_add[8]) normal_add_shift=6'd28;
      else if (temp_result_add[7]) normal_add_shift=6'd29;
      else if (temp_result_add[6]) normal_add_shift=6'd30;
      else if (temp_result_add[5]) normal_add_shift=6'd31;
      else if (temp_result_add[4]) normal_add_shift=6'd32;
      else if (temp_result_add[3]) normal_add_shift=6'd33;
      else if (temp_result_add[2]) normal_add_shift=6'd34;
      else if (temp_result_add[1]) normal_add_shift=6'd35;
      else if (temp_result_add[0]) normal_add_shift=6'd36;*/
      else  normal_add_shift=9'd37;
   end 
  
   assign temp_result_add_s= temp_result_add << normal_add_shift;
   
   assign man_result_add = temp_result_add_s[35:13];

   always@(*) begin
      if(~lar && normal_add!=9'd36) begin
            exp_result_add={1'b0,`EXP_1}-normal_add;
         end
      else if(lar && normal_add!=9'd36)begin
            exp_result_add={1'b0,`EXP_2}-normal_add;
      end
      else begin
            exp_result_add=9'd0;
      end
   end
//MUL  
   always@(*) begin
      exp_mul_res={{1'b0,`EXP_1}+{1'b0,`EXP_2}-9'd127};
      mul_sign=operand1[31]^operand2[31];
      mul_man1={1'b1,`MAN_1};
      mul_man2={1'b1,`MAN_2};
   end
   always@(*) begin
      temp_result_mul=mul_man1*mul_man2;
   end

//MUL normalize
   wire [22:0] man_result_mul;
   wire [7:0]  exp_result_mul;
   assign exp_result_mul=(temp_result_mul[47])? exp_mul_res+8'd1 : exp_mul_res;
   assign man_result_mul= (temp_result_mul[47])? temp_result_mul[46:24]: temp_result_mul[45:23];
   
///////////////////////////////   FCVT .W.S or .WU.S  ////////////////////////////////
   reg [7:0] shift_CVT, temp_operand_1, temp_operand_2;//exp
   reg rl;
   reg [31:0] FCVTSW_result;//freg to reg(rd1) 
   reg [54:0] man_after_shift;
   wire FCVT_S_overflow;

   always@(*) begin
         if(`EXP_1<8'd127) begin 
            temp_operand_2=`EXP_1;
            temp_operand_1=8'd127;
            rl=1'b1;
         end
         else begin
            temp_operand_1=`EXP_1;
            temp_operand_2=8'd127;
            rl=1'b0;
         end
         shift_CVT=temp_operand_1-temp_operand_2;//big-small-1
   end
   always@(*) begin
      man_after_shift={32'd1,`MAN_1} << shift_CVT;
   end
   always@(*) begin
      
     if(~func1) begin	//signed
	 if(rl) begin		//between-1 and 1
         	if(operand1[31]==0)
			FCVTSW_result=32'd1;
		else
			FCVTSW_result=32'hffffffff;
      	end
	 else if(man_after_shift[22:0]==23'd0)     	
			FCVTSW_result= ({32{operand1[31]}}^man_after_shift[54:23])+operand1[31];
	  else begin	  
		if(operand1[31]==0)       	
			FCVTSW_result= ({32{operand1[31]}}^man_after_shift[54:23])+operand1[31]+32'd1;
	  	else 
			FCVTSW_result= ({32{operand1[31]}}^man_after_shift[54:23])+operand1[31]-32'd1;
	  end		
      end
      else begin
	if(rl)
		FCVTSW_result=32'd1;
	else if(man_after_shift[22:0]==23'd0)	//int 
		FCVTSW_result=man_after_shift[54:23];
	else  
         	FCVTSW_result=man_after_shift[54:23]+32'd1;
	
      end
   end
   assign FCVT_S_overflow=(`EXP_1>8'd158)?1'b1: 1'b0 ;
///////////////////////////////   FCVT .S.W or S.WU  ////////////////////////////////
   reg [5:0] normal_CVT;
   wire [31:0] temp_normal_result,operand1_abs;
   wire [22:0] man_FCVT;
   wire [7:0] exp_FCVT;
   wire sign_FCVT;
  		
   assign operand1_abs = ({32{operand1[31]}}^operand1)+operand1[31]; //1 UNSIGN 0 SIGN
   //assign operand1_abs = (func1)? operand1: (({32{operand1[31]}}^operand1)+operand1[31]); //1 UNSIGN 0 S
   always@(*) begin
      if(operand1_abs[31]) normal_CVT=6'd31;
      else if (operand1_abs[30]) normal_CVT=6'd30;
      else if (operand1_abs[29]) normal_CVT=6'd29;
      else if (operand1_abs[28]) normal_CVT=6'd28;
      else if (operand1_abs[27]) normal_CVT=6'd27;
      else if (operand1_abs[26]) normal_CVT=6'd26;
      else if (operand1_abs[25]) normal_CVT=6'd25;
      else if (operand1_abs[24]) normal_CVT=6'd24;
      else if (operand1_abs[23]) normal_CVT=6'd23;
      else if (operand1_abs[22]) normal_CVT=6'd22;
      else if (operand1_abs[21]) normal_CVT=6'd21;
      else if (operand1_abs[20]) normal_CVT=6'd20;
      else if (operand1_abs[19]) normal_CVT=6'd19;
      else if (operand1_abs[18]) normal_CVT=6'd18;
      else if (operand1_abs[17]) normal_CVT=6'd17;
      else if (operand1_abs[16]) normal_CVT=6'd16;
      else if (operand1_abs[15]) normal_CVT=6'd15;
      else if (operand1_abs[14]) normal_CVT=6'd14;
      else if (operand1_abs[13]) normal_CVT=6'd13;
      else if (operand1_abs[12]) normal_CVT=6'd12;
      else if (operand1_abs[11]) normal_CVT=6'd11;
      else if (operand1_abs[10]) normal_CVT=6'd10;
      else if (operand1_abs[9]) normal_CVT=6'd9;
      else if (operand1_abs[8]) normal_CVT=6'd8;
      else if (operand1_abs[7]) normal_CVT=6'd7;
      else if (operand1_abs[6]) normal_CVT=6'd6;
      else if (operand1_abs[5]) normal_CVT=6'd5;
      else if (operand1_abs[4]) normal_CVT=6'd4;
      else if (operand1_abs[3]) normal_CVT=6'd3;
      else if (operand1_abs[2]) normal_CVT=6'd2;
      else if (operand1_abs[1]) normal_CVT=6'd1;
      else if (operand1_abs[0]) normal_CVT=6'd0;
      else  normal_CVT=6'd40;
   end
   assign temp_normal_result = (normal_CVT== 6'd40) ? 31'd0 : operand1_abs<<(6'd32-normal_CVT);
   assign sign_FCVT = (func1)? 1'b0 : operand1[31];
   assign man_FCVT = temp_normal_result[31:9];
   assign exp_FCVT = 8'd127+normal_CVT;//


//min,max,EQ,LT,LE
   reg [31:0] temp_result_minmax;
   reg temp_result_eq,temp_result_lt,temp_result_le;

   always @(*) begin
      if(operand1[31]==0 &&operand2[31]==0) begin
         if(`ABS_1>`ABS_2) begin //op1>op2
         //EQ
            temp_result_eq = 1'b0;
         //LT
            temp_result_lt = 1'b0;
         //LE
            temp_result_le = 1'b0;
         //min_max
            if(func3[0])begin//max
            temp_result_minmax = operand1;
            end
            else temp_result_minmax = operand2;//min
         end
         else begin//op1<=op2
            	temp_result_le = 1'b1;
		if(`ABS_1==`ABS_2) begin
	   		temp_result_eq = 1'b1;
               		temp_result_lt = 1'b0;
			temp_result_minmax = operand1;
            	end
		else begin
              		temp_result_eq = 1'b0;
               		temp_result_lt = 1'b1;
	   		if(func3[0]) temp_result_minmax = operand2;//max
               		else temp_result_minmax = operand1;//min
            	end
         end
      end
      else if(operand1[31]==0 &&operand2[31]==1) begin//op1>op2
         //EQ
            temp_result_eq = 1'b0;
         //LT
            temp_result_lt = 1'b0;
         //LE
            temp_result_le = 1'b0;
         if(func3[0])temp_result_minmax = operand1;
         else temp_result_minmax = operand2;
      end
      else if(operand1[31]==1 &&operand2[31]==0) begin//op1<op2
         //EQ
            temp_result_eq = 1'b0;
         //LT
            temp_result_lt = 1'b1;
         //LE
            temp_result_le = 1'b1;
         if(func3[0]) temp_result_minmax = operand2;
         else temp_result_minmax = operand1;
      end
      else begin//operand1[31]==1 &&operand2[31]==1
	if(`ABS_1>=`ABS_2) begin //op2>=op1
	   temp_result_le = 1'b1;
               if(`ABS_1==`ABS_2) begin
                  temp_result_eq = 1'b1;
                  temp_result_lt = 1'b0;
		  temp_result_minmax = operand1;	
               end
               else begin
                  temp_result_eq = 1'b0;
                  temp_result_lt = 1'b1;
	      if(func3[0]) temp_result_minmax = operand2;//max
                  else temp_result_minmax = operand1;//min
               end
         end
         else begin  //op2<op1
         //EQ
            temp_result_eq = 1'b0;
         //LT
            temp_result_lt = 1'b0;
         //LE
            temp_result_le = 1'b0;
	if(func3[0]) temp_result_minmax = operand1;//max
            else temp_result_minmax = operand2;//min
      end
   end
end
/////////////////////////////////////////////  choose result ///////////////////////////////
   always@(*) begin
      case(func5) 
         `ADD: begin
            overflow=exp_result_add[8];
            out=(overflow)? 32'hffffffff: {sign_add,exp_result_add[7:0],man_result_add};
         end
         `SUB: begin
            overflow=exp_result_add[8];
            out=(overflow)? 32'hffffffff: {sign_add,exp_result_add[7:0],man_result_add};
         end
         `MUL: begin
            overflow=exp_mul_res[8];
            out=(overflow)? 32'hffffffff: {mul_sign,exp_result_mul,man_result_mul};
         end
         `MIN_MAX: begin
            overflow=1'b0;
            out= temp_result_minmax;
         end
         `FCVTSW: begin
			overflow=1'b0;
            out={sign_FCVT,exp_FCVT,man_FCVT};
         end
         `FCVTWS: begin
			overflow=1'b0;
            out=(FCVT_S_overflow)? 32'hffffffff:FCVTSW_result;
         end
         `FMVWX: begin
			overflow=1'b0;
            out=operand1;
         end
         `FMVXW: begin
			   overflow=1'b0;
            out=operand1;
         end
         `FEQ_LT_LE: begin
            overflow=1'b0;
            if(func3[1:0]==2'b10) out = temp_result_eq;//eq
            else if(func3[1:0]==2'b01) out = temp_result_lt;//LT
            else out = temp_result_le;//LE 2'b00
         end
         default: begin
			overflow=1'b0;
            out=32'd0;
         end
      endcase
   end

endmodule

