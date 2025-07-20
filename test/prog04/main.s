.text
.global main


main:
    addi sp, sp, -4
    sw s0, 0(sp)    
    la s0, _answer      #addr

mul:
    li t0, 1
    li t1, 2
    li t2, -2
    mul t0, t0, t1          # t0 = 2
    sw t0, 0(s0)
    addi s0, s0, 4
    mul t0, t0, t1          # t0 = 4
    sw t0, 0(s0)
    addi s0, s0, 4
    mul t0, t0, t2          # t0 = -8
    sw t0, 0(s0)
    addi s0, s0, 4
    mul t0, t0, t2          # t0 = 16
    sw t0, 0(s0)
    addi s0, s0, 4
    mul t0, t0, t2          # t0 = -32
    sw t0, 0(s0)
    addi s0, s0, 4
    mul t0, t0, t2          # t0 = 64
    sw t0, 0(s0)
    addi s0, s0, 4
    mul t0, t0, t2          # t0 = -128
    sw t0, 0(s0)
    addi s0, s0, 4
    mul t0, t0, t1          # t0 = -256
    sw t0, 0(s0)
    addi s0, s0, 4
    mul t0, t0, t1          # t0 = -512
    sw t0, 0(s0)
    addi s0, s0, 4
    mul t0, t0, x0          # t0 = 0
    sw t0, 0(s0)

main_exit:
    lw s0, 0(sp)
    addi sp, sp, 4
    ret
