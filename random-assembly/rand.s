# Alex Chen, COSC230, Functions Program
# int64_t get_rand(int64_t mn, int64_t mx) {
#    return mn + rand() % (mx - mn + 1);
# }

# Registers:
# a0 get_rand(a0 mn, a1 mx) {
#    return mn + rand() % (mx - mn + 1);
# }
    .text
    .global get_rand
get_rand:
    addi    sp, sp, -32     # ra + s0 + s1 = 24 bytes aligned to 32
    sd      ra, (sp)        # Save return address
    sd      s0, 8(sp)       # Save old s0
    sd      s1, 16(sp)      # Save old s1

    mv      s0, a0          # minumum
    mv      s1, a1          # maximum
    call    rand            # rand()

    sub     t0, s1, s0      # t1 = max - min
    addi    t0, t0, 1       # t1 = (max - min) + 1
    rem     t1, a0, t0      # t2 = rand() % (max - min + 1)
    add     a0, s0, t1      # a0 = min + (rand() % (max - min + 1))

    ld      ra, (sp)        # Restore return address
    ld      s0, 8(sp)       # Restore original s0
    ld      s1, 16(sp)      # Restore original s1
    addi    sp, sp, 32      # Move stack back (deallocate)
    ret                     
