.text
.global main

main:
    # TODO
    # remember to exit the program by setting $a0 to 0 and using ecall

    addi	sp, sp, -16                         # allocate stack space    sp = @sp - 4                                                   
    sw	    ra, 12(sp)                          # ra -> @sp - 4
    sw	    s0, 8(sp)
    sw	    s1, 4(sp)
    li      a5, 2                               # used by for loop int i = 2
    sw	    a5, 0(sp)
    addi	s0, sp, 0
    
    la      s1, _answer                                                  
    sw	    zero, 0(s1)                         # '0' -> @M[0x00000100]
     
    li      a3, 1                               # a3 is function argument (a3 = 1)
    addi	s1, s1, 4
    sw	    a3, 0(s1)                           # 1 -> @M[0x00000100+4]
    
    j loop

loop:
    addi	s1, s1, 4
    lw	    a2, -8(s1)                          # load f(n-2) to a2   
    lw	    a3, -4(s1)                          # load f(n-1) to a3   
    add	    a4, a2, a3                          # a4 = a2 + a3     => result = a + b
    sw	    a4, 0(s1)                           # store to mem

    lw	    a5, 0(s0)
    addi	a5, a5, 1                           # i = i + 1
    sw	    a5, 0(s0)
    li      a6, 20                              # a6 = 21
    bge	    a6, a5, loop                        # check if a5(i) <= a6(20), if true branch to loop

    
main_exit:
    lw      ra, 12(sp)
    lw	    s0, 8(sp)
    sw	    s1, 4(sp)
    lw	    a5, 0(sp)
    addi    sp,sp,16 
    ret
