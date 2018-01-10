    AREA GP,CODE,READONLY
TABLE_BASE EQU 0x40000000
    ENTRY
    mov r0, #5
    mov r1, #1
    mov r2, #3
    mov r3, #TABLE_BASE
    mov r4, #0
    mov r5, #1
    strh r1,[r3]
loop add r4,r4,#1
    cmp r4, r0
    bge done
    mul r5,r1,r2
    mov r1,r5
    strh r1,[r3,#2]!
    b loop
done b done
    end