        AREA TEST, CODE
        ENTRY
        ;ldr r7, =31
        ;ldr r0, =0x12345678
        ;ldr r1, =0x1
;loop    and r2, r1, r0 
        ;orr r3, r3, r2
        ;lsr r0, #1
        ;lsl r3, #1
        ;sub r7, #1
        ;cmp r7, #0
        ;bne loop
        
max RN 3
counter RN 0
index RN 2
        
        ldr counter, =49
        adr index, values
        ldr max,[index],#4
loop        ldr r4, [index],#4
        cmp max,r4
        movlt max, r4
        subs counter, counter,#1
        bne loop
values dcd 1,2,3,4,5,6 
stop    B stop
        end
            
