// Alex Chen
// sum_prod.S
.section .text
.global sum_prod
sum_prod:
    # int32_t (a0)
    #     sum_prod
    #        const int32_t values[] (a0)
    #        uint64_t num_values    (a1)
    #        int32_t &product       (a2)
    # Rewritten:
    # a0      sum_prod (a0, a1, a2)

li     t0, 0 #t0 for sum
li     t1, 1 #t1 for product

li     t2, 0   # Use t2 for i

1: # loop
    bge     t2, a1, 1f   # end loop if i >= num_values
    slli    t3, t2, 2    # shift by 2 bytes because array of ints
    add     t3, t3, a0   # t3 = &values[i], get address of value
    lw      t4, 0(t3)    # t4 = values[i], load i-th value into t4
    add     t0, t0, t4   # t0 (sum) += t4 (values[i]), adding to total sum
    mul     t1, t1, t4   # t1 (product) *= t4 (values[i]), totaling the product
    addi    t2, t2, 1    # i += 1
    j       1b # jump to start of loop again
1: # end of loop
    mv      a0, t0       # return a0 (the sum)
    sw      t1, 0(a2)    # *product = t1 (accumulating product)
ret