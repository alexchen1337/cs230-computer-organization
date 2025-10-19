# Alex Chen

#void map(double *values, uint64_t num_values, double (*func)(double left, double right), double map_value);
#double map_add(double left, double right);
#double map_sub(double left, double right);
#double map_min(double left, double right);
#double map_max(double left, double right);

.global map_add
map_add:
    fadd.d  fa0, fa0, fa1  # add f.p. vals
    ret

.global map_sub
map_sub:
    fsub.d  fa0, fa0, fa1  # subtract f.p. vals
    ret

.global map_min
map_min:
    fmin.d  fa0, fa0, fa1  # minimum f.p. vals
    ret

.global map_max
map_max:
    fmax.d  fa0, fa0, fa1  # maximum f.p. vals
    ret

.section .text
# void map(double values[],
#          uint64_t num_values,
#          double (*mapping_func)(double left, double right),
#          double map_value)

# void map(a0,
#          a1,
#          a2,
#          fa0)
.global map
map:
    addi    sp, sp, -16  # allocate bytes to stack
    sd      ra, 0(sp)  # save ret address
    fsd     fa0, 8(sp) # save map_value on stack
    fsd     fa1, 16(sp) # save fa1 on stack
    sd      s0, 24(sp)

    fmv.d   fs0, fa0        # Move map_value into fs0
    mv      s3, a2          # mapping_func address is now in s3
    mv      s4, a1          # Move num_values into s4
    li      s5, 0           # uint64_t i

1:
    bge     s5, s4, 1f      # Jump out if i >= num_values

    slli    s6, s5, 3       # shift left, (offset s5 * 2^3)
    add     s6, s6, a0      # add offset to values array
    fld     fa0, (s6)       # fa0 = values[i]

    fmv.d   fa1, fs0        # set double right = map_value
    jalr    s3              # mapping_func(fa0, fa1)

    fsd     fa0, (s6)       # values[i] = fa0, store return alue

    addi    s5, s5, 1       # i++, adding to loop counter
    j       1b              # Loop again

1:
    ld      s0, 24(sp)
    fsd     fa1, 16(sp)
    fld     fa0, 8(s0)      # fa0 = *(double*)s0
    ld      ra, 0(sp)
    addi    sp, sp, 32

    ret
