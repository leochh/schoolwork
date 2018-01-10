    AREA Progq2, CODE, READONLY
        ENTRY
main    
        ldr r0, =list ; base table address
        ldr r5, =list
        ldr r1, =0x9abcdef1 ; target
        ldr r2, [r0] ; num of items, stored at the first place of table
        mov r3, #1 ; counter
        mov r9, #0 ; found target address
loop
        cmp r3, r2
        bgt notfd
        ldr r4, [r0, r3, LSL #2]
        cmp r4, r1
        beq found
        add r3, r3, #1
        b loop
found   
        add r9, r0, r3, LSL #2
        b stop
notfd    
        str r3, [r5]
        str r1, [r0, r3, LSL #2]
stop    b stop

        AREA DATA1,	DATA,	READWRITE						
list	DCD	   4				;number of items in list
		DCD    0x12345678		;1st item
		DCD    0x56789ABC		;2nd item
		DCD    0x9ABCDEF1		;3rd item
		DCD    0xDEF01234		;4th item
store	SPACE  20				;reserve 20 bytes of storage for list
		END
