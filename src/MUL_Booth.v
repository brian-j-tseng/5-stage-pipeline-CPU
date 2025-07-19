module MAC (input  [31:0]mult, //被乘數
            input  [31:0]mulc,//乘數
            output [32:0]updated_psum);

wire [32:0]mulcR;
reg signed [63:0]updated_psumR;
reg signed [63:0]mulshift;
reg signed [63:0]mulshift_C;
integer i;

always@(*)
begin

mulcR={mulc,1'b0};
mulshift={{{mult[7]}},mult};
//complement
mulshift_C= -{{{mult[7]}},mult};
updated_psumR=1'b0;

for(i=0;i<=31;i=i+1)
begin
    case({mulcR[i+1],mulcR[i]})
        //shift
        2'b00,2'b11:
        begin
            mulshift=mulshift<<1;
            mulshift_C=mulshift_C<<1;
        end
        //add
        2'b01:
        begin
            updated_psumR=updated_psumR + mulshift;
            mulshift=mulshift<<1;
            mulshift_C=mulshift_C<<1;
        end
        //sub
        2'b10:
        begin
             updated_psumR=updated_psumR + mulshift_C;
             mulshift=mulshift<<1;
             mulshift_C=mulshift_C<<1;
        end
    endcase
end

end
assign updated_psum = updated_psumR[31:0];
endmodule
