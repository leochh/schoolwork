ram_base equ 0x40000000
    area ques3, code, readonly
    entry
main
    ldr sp, =ram_base + 0x1000
    mov r0, #10
    mov r4, #99
    
    stmfd sp!, {r0-r3}
    bl compute
    ldmfd sp!, {r0-r3}
stop b stop    
compute
    stmfd sp!, {r4-r6,lr}
    ldr r4, [sp, #16]
    ldr r5, [sp, #16]
    ldr r6, [sp, #16]
loop
    sub r4, r4, #1
    mul r5, r6, r4
    mov r6, r5
    cmp r4, #1
    bne loop
    str r6, [sp, #20]
    ldmfd sp!, {r4-r6,lr}
    bx lr
    end
    