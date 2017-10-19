ram_base equ 0x40000000
    area ques3, code, readonly
    entry
main
    ldr sp, =ram_base + 0x1000
    mov r0, #10
    bl compute
stop b stop    
compute
    stmfd sp!, {r4,r5,lr}
    mov r1, r0
    mov r4, r0
loop
    sub r4, r4, #1
    mul r5, r1, r4
    mov r1, r5
    cmp r4, #1
    bne loop
    ldmfd sp!, {r4,r5,lr}
    bx lr
    end
    