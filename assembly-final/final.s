# Alex Chen
# Final
.section .text
.global find
find:
    addi    sp, sp, -32         #ALLOCATE THAT MEMORY!!!
    sd      ra, 0(sp)
    sd      s0, 8(sp)
    sd      s1, 16(sp)

    mv      t1, a0         # t1 = array
    mv      t2, a1         # t2 = num_values 
    mv      t3, a2         # t3 = key 

loop:
    beqz    t2, not_found        # If num_values is 0, jump to not_found
    mv      t4, t1               # t4 = address of the current struct's key
    li      t5, 24                 # t5 = number of characters to compare
compare_keys:
    lb      s0, 0(t3)             # load char from search key
    lb      s1, 0(t4)             # load char from  struct key

    bne     s0, s1, next_struct   # if char do not match, increment to next struct

    addi    t3, t3, 1            # increment pointer to next char of key
    addi    t4, t4, 1            # increment pointer to next char of the struct key
    addi    t5, t5, -1           # decrement the count of characters left

    beqz    t5, found            # if no more characters left (t5=0), same string, so jump to found
    j       compare_keys         # jump back to compare keys

next_struct:
    addi    t1, t1, 32           # move to the next struct 
    addi    t2, t2, -1           # decrement num_values left
    j       loop                 # jump back to start

found:
    sub     a0, t1, a0            # calc the index of found struct
    li      t6, 32                # store 32 in t6 to calculate index
    div     a0, a0, t6            # divide by 32 to get index
    ld      ra, 0(sp)
    ld      s0, 8(sp)
    ld      s1, 16(sp)      #DEALLOCATE
    addi    sp, sp, 32
    ret

not_found:
    li      a0, -1                 # ret -1 if not found
    ld      ra, 0(sp)            #DEALLOCATE
    ld      s0, 8(sp)
    ld      s1, 16(sp)
    addi    sp, sp, 32
    ret
