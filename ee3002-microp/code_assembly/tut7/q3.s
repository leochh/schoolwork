    AREA prog3, code, readonly
main
    mov r0, #2
    mov r1, #4
    mov r2, #2
    bl arithfunc
stop b stop

arithfunc
    ldr r3, =jumptable
    ldr pc, [r3, r0, LSL #2]
jumptable
    dcd DoAdd
    dcd DoSubtract
    dcd DoMultiply
DoAdd
    add r4, r1, r2
    bx lr
DoSubtract
    sub r4, r1, r2
    bx lr
DoMultiply
    mul r4, r1, r2
    bx lr
    end