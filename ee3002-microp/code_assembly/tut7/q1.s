    AREA PROGQ1, CODE, READONLY
SRAM_BASE EQU 0x40000000
    ENTRY
    mov r0, #0 ; count
    mov r1, #0 ; F0 = 0 
    mov r2, #1 ; F1 = 1
    mov r9, #SRAM_BASE 
    str r1, [r9]
    str r2, [r9, #4]!
    
loop    cmp r0, #3
    bge done
    add r3, r1, r2
    add r0, r0, #1
    str r3, [r9, r0, LSL #2]
    mov r1, r2
    mov r2, r3
    b loop
done b done
    end
    