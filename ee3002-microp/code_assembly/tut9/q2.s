ram_base equ 0x40000000
    AREA question2, code, readonly
    entry
main
    ldr sp, =ram_base + 0x1000
    mov r0, #7
    bl myPUSH
    bl myPOP
stop b stop
myPUSH
    sub sp, sp, #4
    str r0,[sp]
    bx lr
myPOP
    ldr r0, [sp]
    add sp, sp, #4
    bx lr
    END
    