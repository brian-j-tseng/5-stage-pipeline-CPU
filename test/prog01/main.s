.data
num_test: .word 3 
TEST1_SIZE: .word 34
TEST2_SIZE: .word 19
TEST3_SIZE: .word 29
test1: .word 3,41,18,8,40,6,45,1,18,10,24,46,37,23,43,12,3,37,0,15,11,49,47,27,23,30,16,10,45,39,1,23,40,38
test2: .word -3,-23,-22,-6,-21,-19,-1,0,-2,-47,-17,-46,-6,-30,-50,-13,-47,-9,-50
test3: .word -46,0,-29,-2,23,-46,46,9,-18,-23,35,-37,3,-24,-18,22,0,15,-43,-16,-17,-42,-49,-29,19,-44,0,-18,23

.text
.global main

main:

# ######################################
# ### Load address of _answer to s0 
# ######################################

  addi sp, sp, -4
  sw s0, 0(sp)
  la s0, _answer

# ######################################


# ######################################
# ### Main Program
# ######################################

#######################################################
    # <  Variable >
    #    s0 : test_size
    #    t0 : address of test
############### callee save ###########################
    addi sp,sp,-8    # 給定儲存空間
                     # sp=sp-8
    sw   ra,0(sp)    # ra->mem[@sp-4]
    sw   s0,4(sp)
############### merge test1 ###########################
    la   t0,test1       # t0 = address of  test1
    lw   s0,TEST1_SIZE  # s0 = t1_size
    addi s0,s0,-1       # t1_size-1

    mv   a0,t0          # a0= address of test1
    mv   a1,x0          # a1= 0
    mv   a3,s0          # a3= size-1

    # call mergesort and do caller saving
    addi sp,sp,-4
    sw   ra,0(sp)
    jal  ra,mergesort
    lw   ra,0(sp)
    addi sp,sp,4


############### merge test2 ###########################
    la   t0,test2
    lw   s0,TEST2_SIZE
    addi s0,s0,-1

    mv   a0,t0
    mv   a1,x0
    mv   a3,s0

    # call mergesort and do caller saving
    addi sp,sp,-4
    sw   ra,0(sp)
    jal  ra,mergesort
    lw   ra,0(sp)
    addi sp,sp,4

############### merge test3 ###########################
    la   t0,test3
    lw   s0,TEST3_SIZE
    addi s0,s0,-1

    mv   a0,t0
    mv   a1,x0
    mv   a3,s0

    # call mergesort and do caller saving
    addi sp,sp,-4
    sw   ra,0(sp)
    jal  ra,mergesort
    lw   ra,0(sp)
    addi sp,sp,4
############# resave data###############################
    lw      ra,0(sp)
    lw      s0,4(sp)
    addi    sp,sp,8

# move data to assigned address #
    la      t1,test1
    lw      t2,TEST1_SIZE
    lw      t3,TEST2_SIZE
    lw      t4,TEST3_SIZE
    add     t2,t2,t3            
    add     t2,t2,t4            # t2 = size1 + size2 +size3
    li      t5,0                # t5 = i
    li      t3,0x9000           # t3 = answer target
datamove:
    lw      t4,0(t1)
    sw      t4,0(t3)            #  MOVE data to t3
    addi    t5,t5,1
    addi    t1,t1,4
    addi    t3,t3,4
    blt     t5,t2,datamove      # if i < total size  do loop

    jal     x0,main_exit


merge:
#######################################################
    # < Function >
    #    merge
    # < Parameters >
    #    a0 : array address
    #    a1 : start
    #    a2 : mid
    #    a3 : end
#######################################################
    # <  Variable >
    #    t0 : temp_size
    #    t1 : space for temp_size array
    #    t2 : i
    #    t3 : 轉存陣列資料處
    #    t4 : left_index
    #    t5 : right_index
    #    t6 : add[i+start]

    #    s0 : left_max
    #    s1 : right_max
    #    s2 : arr_index
    #    s3 : 4*left_index+ temp address
    #    s4 : 4*right_index+ temp address
    #    s5 : 4*s2+address of arr
    #    s6 : *(s3)
    #    s7 : *(s4)
    #    s8 : 0x01000000
    #    s9 : addtress of temp
############### callee save ###########################
    addi    sp, sp, -44               # Allocate stack space
                                      # sp = @sp - 44
    
    sw      ra, 0(sp)                 # @ra -> MEM[@sp - 4]
    sw      s0, 4(sp)
    sw      s1, 8(sp)
    sw      s2, 12(sp)
    sw      s3, 16(sp)
    sw      s4, 20(sp)
    sw      s5, 24(sp)
    sw      s6, 28(sp)
    sw      s7, 32(sp)
    sw      s8, 36(sp)
    sw      s9, 40(sp)
#######################################################
    sub     t0,a3,a1                 # t0=temp_size=end-start+1
    addi    t0,t0,1

    slli    t1,t0,2                  # give temp array a space
    addi    s9,sp,-4                 # now s9 =address of temp
    sub     sp,sp,t1

    li      t2,0                     # i=0
    slli    t6,a1,2                  # t6=4*start
    add     t6,t6,a0                 # t6=address of arr[start]
    
    addi    sp, sp, -4              
    sw      s9, 0(sp)
temp_duplicated_for:
    lw      t3,0(t6)                   # t3=arr[i+start]
    sw      t3,0(s9)                    # temp[i]=t3

    addi    t6,t6,4                     # arr[i+START+1]
    addi    s9,s9,-4                    # temp[i+1]

    addi    t2,t2,1                     # i++
    blt     t2,t0,temp_duplicated_for   # if i<temp_size loop

    lw      s9, 0(sp)
    addi    sp, sp, 4 

    #   load some variable #
    li      t4,0        # left_index=0

    sub     t5,a2,a1    # right_index=mid-start+1
    addi    t5,t5,1

    sub     s0,a2,a1    # left_max = mid-start
    sub     s1,a3,a1    # right_max = end-start
    mv      s2,a1       # arr_index = start

    slli    s3,t4,2     
    sub     s3,s9,s3    # s3= temp[left_index] address
  

    slli    s4,t5,2     
    sub     s4,s9,s4    # s4= temp[right_index] address

    
    slli    s5,s2,2     # s5= address of arr[array index]
    add     s5,s5,a0    
    
    blt     s0,t4,while_loop_A_end  # if left_max < index
    blt     s1,t5,while_loop_A_end  # or right_max < index endloop
while_loop_sort_A:
    lw      s6,0(s3)        # s6=*s3
    lw      s7,0(s4)        # s7=*s4
    bge     s7,s6,if_a      # temp[left_index] <= temp[right_index] go if
    jal     x0,else_a   

if_a:
    sw      s6,0(s5)        # arr[arr_index] = temp[left_index]
    addi    s2,s2,1         # arr_index++
    addi    t4,t4,1         # left_index++
    addi    s3,s3,-4
    addi    s5,s5,4
    lw      s6,0(s3)

    blt     s0,t4,while_loop_A_end
    blt     s1,t5,while_loop_A_end
    jal     x0,while_loop_sort_A
else_a:
    sw      s7,0(s5)        # arr[arr_index] = temp[right_index]
    addi    s2,s2,1         # arr_index++
    addi    t5,t5,1         # right_index++
    addi    s4,s4,-4
    addi    s5,s5,4
    lw      s7,0(s4)

    blt     s0,t4,while_loop_A_end
    blt     s1,t5,while_loop_A_end
    jal     x0,while_loop_sort_A

while_loop_A_end:
    bge     s0,t4,while_loop_B  # left_max >= left_index do loop B
    bge     s1,t5,while_loop_C  # right_max>= right_index do loop C
    jal     x0,merge_end        

while_loop_B:
    sw      s6,0(s5)            # arr[arr_index] = temp[left_index]
    addi    s2,s2,1
    addi    t4,t4,1
    addi    s3,s3,-4
    addi    s5,s5,4
    lw      s6,0(s3)

    bge     s0,t4,while_loop_B
    jal     x0,while_loop_A_end

while_loop_C:
    sw      s7,0(s5)            # arr[arr_index] = temp[right_index]
    addi    s2,s2,1
    addi    t5,t5,1
    addi    s4,s4,-4
    addi    s5,s5,4
    lw      s7,0(s4)

    bge     s1,t5,while_loop_C
    jal     x0,while_loop_A_end
######## ############### end merge #################### ###########
######## ############### resave Parameters #################### ###########
merge_end:
    add     sp,sp,t1

    lw      ra, 0(sp)                 
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    lw      s2, 12(sp)
    lw      s3, 16(sp)
    lw      s4, 20(sp)
    lw      s5, 24(sp)
    lw      s6, 28(sp)
    lw      s7, 32(sp)
    lw      s8, 36(sp)
    lw      s9, 40(sp)
    addi    sp, sp, 44
    ret
mergesort:
#######################################################
    # < Function >
    #    merge
    # < Parameters >
    #    a0 : array address
    #    a1 : start
    #    a3 : end

    #    s1 : start
    #    s2 : mid
    #    s3 : end
############### callee save ###########################
    addi    sp,sp,-12                   
    sw      s1,0(sp)
    sw      s2,4(sp)
    sw      s3,8(sp)
    addi    sp, sp, -4                # Allocate stack space
                                      # sp = @sp - 4
    
    sw      ra, 0(sp)                 # @ra -> MEM[@sp - 4]
    bge     a1,a3,end
if_b:
    add     s2,a1,a3
    srli    s2,s2,1                   # mid=(end+start)/2
    mv      s1,a1
    mv      s3,a3
    ############### caller save ###########################
    addi    sp,sp,-4   # 給定儲存空間
                     # sp=sp-4
    sw      ra,0(sp)   # ra->mem[@sp-4]
    mv      a3,s2
    jal     ra,mergesort
    lw      ra,0(sp)
    addi    sp,sp,4
    ############### caller save ###########################
    addi    s2,s2,1         # mid+1
    mv      a1,s2           # start(argument)=mid+1(para)
    mv      a3,s3
    addi    sp,sp,-4   # 給定儲存空間
                     # sp=sp-4
    sw      ra,0(sp)   # ra->mem[@sp-4]
    jal     ra,mergesort
    lw      ra,0(sp)
    addi    sp,sp,4
    ############### caller save ###########################
    addi    s2,s2,-1       # mid+1-1=mid
    mv      a1,s1
    mv      a2,s2
    mv      a3,s3
    addi    sp,sp,-4   # 給定儲存空間
                     # sp=sp-4
    sw       ra,0(sp)   # ra->mem[@sp-4] 
    jal     ra,merge
    lw      ra,0(sp)
    addi    sp,sp,4

end:
    lw      ra,0(sp)
    addi    sp,sp,4

    lw      s1,0(sp)
    lw      s2,4(sp)
    lw      s3,8(sp)
    addi    sp,sp,12
    ret

main_exit:

# ######################################
# ### Return to end the simulation
# ######################################

  lw s0, 0(sp)
  addi sp, sp, 4
  ret
