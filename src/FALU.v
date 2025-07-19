`timescale 1ns/100ps
`define ABS_1 operand1 [30:0]//absolute value of op1
`define ABS_2 operand2 [30:0]//absolute valve of op2
`define EXP_1 operand1 [30:23]//exponenent 1
`define EXP_2 operand2 [30:23]//exponenent 2
`define MAN_1 operand1 [22:0]//mantissa 1
`define MAN_2 operand2 [22:0]//mantissa 2

//define funct5
`define ADD 5'b00000//FADD:FADD: 將frs1, frs2的值做加法，以無條件捨棄法存入frd中
`define SUB 5'b00001//FSUB: 將frs1, frs2的值做減法，以無條件捨棄法存入frd中
`define MUL 5'b00010//FMUL: 將frs1, frs2的值做乘法，以無條件捨棄法存入frd中
`define MIN_MAX 5'b00101//FMIN or FMAX
`define FCVTWS 5'b11000//FCVT.W.S: 將frd的值，以無條件捨棄法轉換至rs1中
`define FCVTSW 5'b11010//FCVT.S.W: 將rs1的值，轉換至frd中
`define FMVWX 5'b11110//FMV.X.W 將frs1的值原封不動搬入rd中
`define FMVXW 5'b11100//FMV.W.X 將rd的值原封不動搬入frs中
`define FEQ_LT_LE 5'b10100//FEQ or FLT or FLE

module FALU(
   input [4:0] func5,//ir[31:27]
   input [2:0] func3,//ir[14:12]
   input func1,//E_func1_out from controller//決定要以sign(0)還是unsign(1)來轉換資料
   input [31:0] operand1,//輸入的運算子1
   input [31:0] operand2,//輸入的運算子1
   output reg [31:0] out//result
);
//add and sub set
   reg [7:0] exp_shift;
   reg [36:0] add_man1, add_man2, temp_result_add, shift_1, shift_2;//37bits
   reg lar , true_sign; ////true_sign:異號相加或同好相減時=1//
//MUL set
   reg [23:0] mul_man1, mul_man2;
   reg [8:0] exp_mul_res;
   reg [47:0] temp_result_mul;//why 48bits
//universe set
   reg overflow, mul_sign;

/////////////////////////// ADD or SUB ///////////////////////
   wire sign_add;
   always@(*) begin
      if(`ABS_1 > `ABS_2) begin//不可以改成`EXP_1-`EXP_2，exp相等的時候會比較man
         exp_shift = `EXP_1-`EXP_2;
         lar= 1'b0;
      end
      else begin
         exp_shift = `EXP_2-`EXP_1;
         lar= 1'b1;
      end
   end
   //把整數部分取出來
   always@(*) begin
      //true_sign:異號相加或同好相減時=1
      true_sign=func5[0]^operand1[31]^operand2[31];//func5[0]:0 for add,1 for sub
      add_man1={2'd1,`MAN_1,{12'd0}};//把1補回來
      add_man2={2'd1,`MAN_2,{12'd0}};//把1補回來
   end
//////1000倍會導致精度太差
   always@(*) begin
            if(~lar) begin//abs_op1>abs_op2
               shift_2=add_man2>>exp_shift;//位移過後的結果，移到相同的base上，絕對值
               shift_1=add_man1;
            end
            else begin//abs_op2>abs_op1
               shift_1=add_man1>>exp_shift;//位移過後的結果，移到相同的base上
               shift_2=add_man2;
            end
      if(true_sign) begin//異號相加或同號相減時
         if(shift_1>shift_2) temp_result_add=shift_1-shift_2;//大減小
         else temp_result_add=shift_2-shift_1;
      end
         else temp_result_add=shift_1+shift_2;//加法
   end
   //判斷正負
   assign sign_add=(~true_sign)? operand1[31]: (shift_1<shift_2)?(operand2[31]^func5[0]):operand1[31];
//ADD or SUB normalize
   wire [22:0] man_result_add;
   wire [36:0] temp_result_add_s;
   reg [8:0]  exp_result_add;
   reg [8:0]  normal_add;
   reg [5:0]  normal_add_shift;
   //normal_add 紀錄哪個bit是第一個1，計算exp要是多少
   //(~true_sign)代表同號相加或異號相減，這時temp_result_add[36]==1代表overflow
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
      else if (temp_result_add[10]) normal_add=9'd25;
      else if (temp_result_add[9]) normal_add=9'd26;
      else if (temp_result_add[8]) normal_add=9'd27;
      else if (temp_result_add[7]) normal_add=9'd28;
      else if (temp_result_add[6]) normal_add=9'd29;
      else if (temp_result_add[5]) normal_add=9'd30;
      else if (temp_result_add[4]) normal_add=9'd31;
      else if (temp_result_add[3]) normal_add=9'd32;
      else if (temp_result_add[2]) normal_add=9'd33;
      else if (temp_result_add[1]) normal_add=9'd34;
      else if (temp_result_add[0]) normal_add=9'd35;
      else  normal_add=9'd36;
   end
   //normal_add_shift 紀錄哪個bit是第一個1，或是等等要shift多少來產生man
   //或許可以改寫法
   //(~true_sign)代表同號相加或異號相減，這時temp_result_add[36]==1代表overflow       
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
      else if (temp_result_add[10]) normal_add_shift=6'd26;
      else if (temp_result_add[9]) normal_add_shift=6'd27;
      else if (temp_result_add[8]) normal_add_shift=6'd28;
      else if (temp_result_add[7]) normal_add_shift=6'd29;
      else if (temp_result_add[6]) normal_add_shift=6'd30;
      else if (temp_result_add[5]) normal_add_shift=6'd31;
      else if (temp_result_add[4]) normal_add_shift=6'd32;
      else if (temp_result_add[3]) normal_add_shift=6'd33;
      else if (temp_result_add[2]) normal_add_shift=6'd34;
      else if (temp_result_add[1]) normal_add_shift=6'd35;
      else if (temp_result_add[0]) normal_add_shift=6'd36;
      else  normal_add_shift=9'd37;
   end 
   //把第一個1移到第36個bits
   assign temp_result_add_s= temp_result_add << normal_add_shift;
   //把第36個bits捨棄round，只取後面23個bits，剩下的捨棄
   assign man_result_add = temp_result_add_s[35:13];

   always@(*) begin
      if(~lar && normal_add!=9'd36) begin//前面是調整到exp_1的狀況，且沒有overflow
            exp_result_add={1'b0,`EXP_1}-normal_add;
         end
      else if(lar && normal_add!=9'd36)begin//前面是調整到exp_2的狀況，且沒有overflow
            exp_result_add={1'b0,`EXP_2}-normal_add;
      end
      else begin//沒有任何一個bits是1，所以結果
            exp_result_add=9'd0;
      end
   end
//MUL  
   always@(*) begin
      exp_mul_res={{1'b0,`EXP_1}+{1'b0,`EXP_2}-9'd127};//超過127指數次方才是正的//多加1 bits避免溢位
      mul_sign=operand1[31]^operand2[31];//判斷相乘後的正負
      mul_man1={1'b1,`MAN_1};//還原man前面的1
      mul_man2={1'b1,`MAN_2};
   end
   always@(*) begin
      temp_result_mul=mul_man1*mul_man2;//相乘
   end

//MUL normalize
   wire [22:0] man_result_mul;
   wire [7:0]  exp_result_mul;
   //根據結果shift
   assign exp_result_mul=(temp_result_mul[47])? exp_mul_res+8'd1 : exp_mul_res;
   //相乘後47和46一定有一個是1，因為一開始有補1在23
   assign man_result_mul= (temp_result_mul[47])? temp_result_mul[46:24]: temp_result_mul[45:23];
   
///////////////////////////////   FCVT .W.S or .WU.S  ////////////////////////////////
   reg [7:0] shift_CVT, temp_operand_1, temp_operand_2;//exp
   reg rl; // right 0, left 1//判斷指數正負
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
      if(rl) begin
         FCVTSW_result=32'd0;
      end
      else if(~func1) begin
         FCVTSW_result= ({32{operand1[31]}}^man_after_shift[54:23])+operand1[31];
      end
      else begin
         FCVTSW_result=man_after_shift[54:23];
      end
   end
   assign FCVT_S_overflow=(`EXP_1>8'd158)?1'b1: 1'b0 ;
///////////////////////////////   FCVT .S.W or S.WU  ////////////////////////////////
   reg [5:0] normal_CVT;
   wire [31:0] temp_normal_result,operand1_abs;
   wire [22:0] man_FCVT;
   wire [7:0] exp_FCVT;
   wire sign_FCVT;
   assign operand1_abs = {32{operand1[31]}}^operand1+operand1[31]; //1 UNSIGN 0 SIGN
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
//min_max
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
            else if(func3[1:0]==2'b00) out = temp_result_le;//LE
            else out=32'd0;
         end
         default: begin
			overflow=1'b0;
            out=32'd0;
         end
      endcase
   end

endmodule

