ram_base equ 0x40000000
    area ques4, code, readonly
    entry
main
    ldr sp , =ram_base+0x1000
    ldr r0, =list
    stmfd sp!, {r0-r3}; r0 is input, r1 is output
    bl add_list
    ldmfd sp!, {r0-r3}
stop b stop

add_list
    ; preserve r4 to r7 for private use in this subroutine
    stmfd sp!, {r4-r7, lr} ; r4 is the list address, r5 is counter, r6 is the current value to be added, r7 is the sum
    ldr r4, [sp, #20]    
    mov r5, #0
    mov r7, #0
loop
    ldr r6, [r4, r5, LSL #2]
    mov r0, r6
    ; pass input to subroutine square_list
    stmfd sp!, {r0-r3}
    bl square_list
    ; get output from subroutine square_list, the output is stored at r1
    ldmfd sp!, {r0-r3}
    mov r6, r1 
    add r7, r7, r6
    add r5, r5, #1
    cmp r5, #4
    bne loop
    str r7, [sp, #24]; store final result to r1 as output
    ; restore r4-r7 value back
    ldmfd sp!, {r4-r7,lr}
    bx lr

square_list
    ; preserve r4 and r5 for private use in this subroutine
    stmfd sp!, {r4,r5,lr}
    ldr r4, [sp, #12]
    mul r5, r4, r4
    str r5, [sp, #16] ; store result to r1 as output
    ; restore value back to r4 and r5 
    ldmfd sp!, {r4,r5,lr}
    bx lr
    
    area list_array, data, readonly
list
    dcd 1,10,3,4
    end