# Alex Chen
# Lab 5, 4/23/2024
# MUD Lab, dungeon game
.section .rodata
exit_string: .asciz "%s\n%s\nExits: "
north: .asciz "n "
east: .asciz "e "
south: .asciz "s "
west: .asciz "w "
newline: .asciz "\n"

.section .text
.global look_at_room
look_at_room:
    addi    sp, sp, -48         # allocate and save registers to stack
    sd      s1, 0(sp)           
    sd      s2, 8(sp)           # using save registers to store exits
    sd      s3, 16(sp)
    sd      s4, 24(sp)
    sd      ra, 32(sp)
    sd      s0, 40(sp)

    mv      s0, a0              # moving a0 into s0 because we call printf

    lw      s1, 16(s0)             # exits[0]
    lw      s2, 20(s0)             # exits[1]
    lw      s3, 24(s0)             # exits[2]
    lw      s4, 28(s0)             # exits[3]

    la      a0, exit_string       # load address of the format string
    ld      a1, 0(s0)             # load title from the Room struct (offset 0)
    ld      a2, 8(s0)             # load description from the Room struct (offset 8)
    call    printf                # print title and description

    li      t1, -1              # load -1 into t1 to use to show no exit

    beq     s1, t1, 1f            # check north exit, if equal then you jump to 1 and do not execute la/call
    la      a0, north             # load north into a0 and print it 
    call    printf
1:
    li      t1, -1            # load -1 into t1 again because t1 gets messed with in printf
    beq     s2, t1, 2f        # same logic as before, if equal then you jump to 2 and don't execute
    la      a0, east          # which shows there is no exit
    call    printf
2:
    li      t1, -1          # same logic
    beq     s3, t1, 3f
    la      a0, south
    call    printf
3:
    li      t1, -1          # same logic except jump to print a newline
    beq     s4, t1, 4f
    la      a0, west
    call    printf
4:
    la      a0, newline     # print newline after checking for exits
    call    printf

    # restore the stack and registers
    ld      s1, 0(sp)
    ld      s2, 8(sp)
    ld      s3, 16(sp)
    ld      s4, 24(sp)
    ld      ra, 32(sp)
    ld      s0, 40(sp)
    addi    sp, sp, 48
    ret

.global look_at_all_rooms
look_at_all_rooms:
    addi    sp, sp, -32         # allocate and save registers to stack
    sd      ra, 0(sp)
    sd      s0, 8(sp)
    sd      s1, 16(sp)          # using save registers for arguments and counter
    sd      s2, 20(sp)

    mv      s0, a0              # s0 will hold the base address of the rooms array
    mv      s1, a1              # s1 holds the number of rooms
    li      s2, 0               # s2 is i ( the counter for the for loop)
    
1:
    beq     s2, s1, 1f              # if t2(count)=a1(number of rooms), we are done
    mv      a0, s0                  # set a0 to the current room pointer
    call    look_at_room            # call look_at_room

    la      a0, newline             # load address of the newline string
    call    printf                  # print newline for separation

    addi    s0, s0, 32              # move to the next Room struct
    addi    s2, s2, 1               # increment the room count
    j       1b

1:
    ld      ra, 0(sp)       # deallocate, restore stack and registers
    ld      s0, 8(sp)
    ld      s1, 16(sp)
    ld      s2, 20(sp)
    addi    sp, sp, 32
    ret

.global move_to
move_to:
    slli    t0, a2, 2              # direction*4 to get the offset in bytes
    add     t0, a1, t0             # add offset to the base address of the current room's exits array
    lw      t0, 16(t0)             # load the room index from the exits array

    # check if the exit is valid
    li      t1, -1                 # load -1 into t1 
    beq     t0, t1, no_move        # if the exit is -1, jump to no_move to return zero register

    # calculate new room address based on the room index stored in t0
    slli    t0, t0, 5              # scale room index by  32 bytes (the size of each room struct)
    add     a0, a0, t0             # add offset to the base address of the rooms array to get the new room's address

    ret                            # return address of new room in a0

no_move:
    mv      a0, zero              # return zero register (null)
    ret
