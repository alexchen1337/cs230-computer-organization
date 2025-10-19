# Alex Chen

.global make_triangle
.section .text
make_triangle:

    addi    sp, sp, -48     # allocate and save registers to stack
    fsd     fs0, 0(sp)
    fsd     fs1, 8(sp)
    fsd     fs2, 16(sp)
    sd      s0, 24(sp)      # using s0 because calls like sqrtf or asinf might use a0
    sd      ra, 32(sp)

    fmv.s   fs0, fa0    # move side0 to fs0
    fmv.s   fs1, fa1    # move side1 to fs1
    mv      s0, a0      # move address of RightTriangle struct into s0

    fsw     fs0, 0(s0)  # store sides into struct at offsets 0 and 4
    fsw     fs1, 4(s0)

    fmul.s  fa0, fs0, fs0   # fa0 = side0 * side0
    fmul.s  fa1, fs1, fs1   # fa1 = side1 * side1
    fadd.s  fa0, fa1, fa0   # fa0 = side0^2 + side1^2
    call    sqrtf           # fa0 = sqrtf(fa0)

    fmv.s   fs2, fa0        # store hypotenuse into fs2
    fsw     fs2, 8(s0)      # store hypotenuse

    fdiv.s  fa0, fs0, fa0   # fa0 = side0/hypotenuse
    call    asinf           # fa0 = asinf(fa0)
    fsw     fa0, 12(s0)     # store theta0

    fdiv.s  fa0, fs1, fs2   # fa0 = side1/hypotenuse
    call    asinf           # fa0 = asinf(fa0)
    fsw     fa0, 16(s0)     # store theta1

    mv      a0, s0      # moving values of the structure into return value

    flw     fs0, 0(sp)  # loading registers and return address from stack
    flw     fs1, 8(sp)
    flw     fs2, 16(sp)
    ld      s0, 24(sp)
    ld      ra, 32(sp)

    addi    sp, sp, 48 # deallocate 48 bytes from stack

    ret
