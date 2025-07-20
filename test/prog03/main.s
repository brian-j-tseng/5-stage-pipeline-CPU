.text
.global main


main:
    addi sp, sp, -4
    sw s0, 0(sp)    
    la s0, _answer      #addr

############float test###################
fadd:
    li t0, 0x3FA00000       
    sw t0, 0(s0)
    flw f0, 0(s0)           # f0 = 1.25
    li t1, 0x3E000000       
    sw t1, 0(s0)
    flw f1, 0(s0)           # f1 = 0.125

    fadd.s f0, f0, f1       # f0 = 1.375
    fadd.s f0, f0, f1       # f0 = 1.5

    li t2, 0xBF800000       
    sw t2, 0(s0)
    flw f2, 0(s0)           # f2 = -1.0
    fadd.s f0, f0, f2       # f0 = 0.5
    fadd.s f0, f0, f2       # f0 = -0.5
    fadd.s f0, f0, f2       # f0 = -1.5
    fadd.s f0, f0, f2       # f0 = -2.5
    fadd.s f0, f0, f1       # f0 = -2.375
    fadd.s f0, f0, f1       # f0 = -2.25

    fsw f0, 0(s0)
    addi s0, s0, 4

fsub:
    li t0, 0x3FA00000      
    sw t0, 0(s0)
    flw f0, 0(s0)           # f0 = 1.25
    li t1, 0x3F400000       
    sw t1, 0(s0)
    flw f1, 0(s0)           # f1 = 0.75

    fsub.s f0, f0, f1       # f0 = 0.5
    fsub.s f0, f0, f1       # f0 = -0.25
    fsub.s f0, f0, f1       # f0 = -1.0
    fsub.s f0, f0, f1       # f0 = -1.75

    li t2, 0xBF800000       
    sw t2, 0(s0)
    flw f2, 0(s0)           # f2 = -1.0

    fsub.s f0, f0, f2       # f0 = -0.75
    fsub.s f0, f0, f2       # f0 = 0.25
    fsub.s f0, f0, f2       # f0 = 1.25
    fsub.s f0, f0, f2       # f0 = 2.25

    fsw f0, 0(s0)
    addi s0, s0, 4

fmul:
    li t0, 0x3FC00000    
    sw t0, 0(s0)
    flw f0, 0(s0)           # f0 = 1.5
    li t1, 0x40000000       
    sw t1, 0(s0)
    flw f1, 0(s0)           # f1 = 2.0

    fmul.s f0, f0, f1       # f0 = 3.0
    fmul.s f0, f0, f1       # f0 = 6.0

    li t2, 0xBF000000       
    sw t2, 0(s0)
    flw f2, 0(s0)           # f2 = -0.5
    fmul.s f0, f0, f2       # f0 = -3.0
    fmul.s f0, f0, f2       # f0 = 1.5
    fmul.s f0, f0, f2       # f0 = -0.75
    fmul.s f0, f0, f1       # f0 = -1.5
    fmul.s f0, f0, f1       # f0 = -3.0

    fsw f0, 0(s0)
    addi s0, s0, 4

fcvt_w_s:                   # float to int 
    fcvt.w.s t0, f0         # 3.0 -> 3
    sw t0, 0(s0)
    addi s0, s0, 4

    li t1, 0x3FC00000       
    sw t1, 0(s0)
    flw f1, 0(s0)           # f1 = 1.5
    fcvt.w.s t1, f1         # 1.5 -> 2  (round-to-even)
    sw t1, 0(s0)
    addi s0, s0, 4

    fcvt.w.s t2, f2         # -0.5 -> 0 (round-to-even)
    sw t2, 0(s0)
    addi s0, s0, 4

    li t3, 0xBFC00000       
    sw t3, 0(s0)
    flw f3, 0(s0)           # f3 = -1.5
    fcvt.w.s t3, f3         # -1.5 -> -2 (round-to-even)
    sw t3, 0(s0)
    addi s0, s0, 4

fcvt_wu_s:                  # float to unsigned int
    fcvt.wu.s t0, f0        # 3.0 -> 3
    sw t0, 0(s0)
    addi s0, s0, 4

    fcvt.wu.s t1, f1        # 1.5 -> 2 
    sw t1, 0(s0)
    addi s0, s0, 4

    fcvt.wu.s t2, f2        # -0.5 -> 0
    sw t2, 0(s0)
    addi s0, s0, 4

    fcvt.wu.s t3, f3        # -1.5 -> 0
    sw t3, 0(s0)
    addi s0, s0, 4

fmv_x_w:                    #float transfer to int (IEEE-754)
    fmv.x.w t0, f0          # 3.0 -> 0x40400000
    sw t0, 0(s0)
    addi s0, s0, 4

    fmv.x.w t1, f1          # 1.5 -> 0x3FC00000 
    sw t1, 0(s0)
    addi s0, s0, 4

    fmv.x.w t2, f2          # -0.5 -> 0xBF000000 
    sw t2, 0(s0)
    addi s0, s0, 4

    fmv.x.w t3, f3          # -1.5 -> 0xBFC00000 
    sw t3, 0(s0)
    addi s0, s0, 4

fmv_w_x:                    # int transfer to float (IEEE-754)
    fmv.w.x f0, t0          # 0x40400000 -> 3.0
    fsw f0, 0(s0)
    addi s0, s0, 4

    fmv.w.x f1, t1          # 0x3FC00000 -> 1.5  
    fsw f1, 0(s0)
    addi s0, s0, 4

    fmv.w.x f2, t2          # 0xBF000000 -> -0.5
    fsw f2, 0(s0)   
    addi s0, s0, 4

    fmv.w.x f3, t3          # 0xBFC00000 -> -1.5
    fsw f3, 0(s0)
    addi s0, s0, 4

fcvt_s_w:                   # int to float
    li t0, 3       
    fcvt.s.w f0, t0         # 3 -> 3.0
    fsw f0, 0(s0)
    addi s0, s0, 4

    li t1, 1 
    fcvt.s.w f1, t1         # 1 -> 1.0  
    fsw f1, 0(s0)
    addi s0, s0, 4

    li t2, -1 
    fcvt.s.w f2, t2         # -1 -> -1.0
    fsw f2, 0(s0)
    addi s0, s0, 4

    li t3, -3 
    fcvt.s.w f3, t3         # -3 -> -3.0
    fsw f3, 0(s0)
    addi s0, s0, 4


fcvt.s.wu:                  # unsigned int to float
    fcvt.s.wu f0, t0        # 3 -> 3.0
    fsw f0, 0(s0)
    addi s0, s0, 4
    
    fcvt.s.wu f1, t1        # 1 -> 1.0  
    fsw f1, 0(s0)
    addi s0, s0, 4

    fcvt.s.wu f2, t2        # -1 -> 0x7F800000(+inf)
    fsw f2, 0(s0)
    addi s0, s0, 4
 
    fcvt.s.wu f3, t3        # -3 -> 0x7F800000(+inf)
    fsw f3, 0(s0)
    addi s0, s0, 4

fmin.s:
  li t0, 0x3FA00000       
  sw t0, 0(s0)
  flw f0, 0(s0)           # f0 = 1.25
  li t1, 0x3E000000       
  sw t1, 0(s0)
  flw f1, 0(s0)           # f1 = 0.125
  fmin.s f3,f0,f1	  # f3 = 0.125
  fmin.s f4,f0,f0	  # f4 = 1.25
  fsw f3, 0(s0)		  # mem[answer] = 0.125
  addi s0, s0, 4
  fsw f4, 0(s0)		  # mem[answer+4] = 1.25
  addi s0, s0, 4

fmax.s:
  fmax.s f3,f0,f1	  # f3 = 1.25
  fmax.s f4,f1,f1	  # f4 = 0.125
  fsw f3, 0(s0)		  # mem[answer+8] = 1.25
  addi s0, s0, 4
  fsw f4, 0(s0)		  # mem[answer+12] = 0.125
  addi s0, s0, 4

feq.s:
  feq.s t0,f0,f1	  # t0 = 0
  sw t0, 0(s0)		  # mem[answer+16]=0
  addi s0, s0, 4
  feq.s t0,f0,f0	  # t0 = 1
  sw t0, 0(s0)		  # mem[answer+20]=1
  addi s0, s0, 4
  
flt.s:
  flt.s t0,f0,f1	  # t0 = 0
  sw t0, 0(s0)
  addi s0, s0, 4          # mem[answer+24]=0
  flt.s t0,f0,f0	  # t0 = 0
  sw t0, 0(s0)
  addi s0, s0, 4	  # mem[answer+28]=0

fle.s:
  fle.s t0,f0,f1	  # t0 = 0
  sw t0, 0(s0)
  addi s0, s0, 4          # mem[answer+32]=0
  fle.s t0,f0,f0	  # t0 = 1
  sw t0, 0(s0)
  

main_exit:
    lw s0, 0(sp)
    addi sp, sp, 4
    ret
