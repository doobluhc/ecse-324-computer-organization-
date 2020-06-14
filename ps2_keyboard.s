.global _start
_start:
.equ PS2_DATA_BASE, 0xFF200100
.equ CHAR_BUFFER, 0xC9000000

	MOV R0,#0x00000000
	MOV R3,#0			//X
	MOV R4,#0			//Y
check_valid:
	MOV 	R7,R0
	BL 		read_PS2_data_ASM
	CMP		R0,#1
	MOV		R6,R0
	MOV		R0,R7
	BLEQ	keyboard_app
	CMP		R6,#1
	ADDEQ	R3,R3,#3
	CMP		R3,#80
	MOVGE	R3,#0
	ADDGE	R4,#1
	CMP		R4,#60
	MOVEQ	R4,#0
	B check_valid


keyboard_app:
	PUSH	{R0-R2,LR}
	LDRB 	R2,[R0]			//data to display
	MOV 	R0,R3			//X
	MOV 	R1,R4			//Y
	BL		VGA_write_byte_ASM
	POP		{R0-R2,LR}
	BX		LR



read_PS2_data_ASM:
	PUSH 	{R1-R4,LR}
	LDR	 	R1,=PS2_DATA_BASE
	LDR 	R2,[R1]				//WHOLE PS2_DATA
	MOV		R4,R2
	AND		R4,R4,#0xFF			//data
	AND 	R3,R2,#0x8000		//get Rvalid bit
	LSR 	R3,R3,#15
	CMP 	R3,#1
	STREQ	R4,[R0]
	MOVEQ	R0,#1
	POPEQ	{R1-R4,LR}
	BXEQ 	LR
	MOV		R0,#0
	POP		{R1-R4,LR}
	BX		LR


VGA_write_byte_ASM:
	PUSH {R0-R6,LR}
	CMP R0,#79
	BGT WRITE_BYTE_END
	CMP R0,#0
	BLT WRITE_BYTE_END
	CMP R1,#59
	BGT WRITE_BYTE_END
	CMP R1,#0
	BLT WRITE_BYTE_END	//check if the coordinates are valid
	LDR R3,=CHAR_BUFFER
	LSL R1,R1,#7
	ORR R3,R3,R1
	ORR R3,R3,R0		//R3 = full address
	AND R4,R2,#0x0F		//R4 = last four bits
	AND R5,R2,#0xF0
	LSR R5,R5,#4		//R5 = first four bits
    CMP R5, #0x0
	MOVEQ R5, #48
    CMP R5, #0x1
    MOVEQ R5, #49
    CMP R5, #0x2
    MOVEQ R5, #50
    CMP R5, #0x3
    MOVEQ R5, #51
    CMP R5, #0x4
    MOVEQ R5, #52
    CMP R5, #0x5
    MOVEQ R5, #53
    CMP R5, #0x6
    MOVEQ R5, #54
	CMP R5, #0x7
    MOVEQ R5, #55
    CMP R5, #0x8
    MOVEQ R5, #56
    CMP R5, #0x9
    MOVEQ R5, #57
    CMP R5, #0xA
    MOVEQ R5, #65
    CMP R5, #0xB
    MOVEQ R5, #66
    CMP R5, #0xC
    MOVEQ R5, #67
    CMP R5, #0xD
    MOVEQ R5, #68
    CMP R5, #0xE
    MOVEQ R5, #69
    CMP R5, #0xF
    MOVEQ R5, #70
	STRB R5,[R3]
	CMP R4, #0x0
	MOVEQ R4, #48
    CMP R4, #0x1
    MOVEQ R4, #49
    CMP R4, #0x2
    MOVEQ R4, #50
    CMP R4, #0x3
    MOVEQ R4, #51
    CMP R4, #0x4
    MOVEQ R4, #52
    CMP R4, #0x5
    MOVEQ R4, #53
    CMP R4, #0x6
    MOVEQ R4, #54
	CMP R4, #0x7
    MOVEQ R4, #55
    CMP R4, #0x8
    MOVEQ R4, #56
    CMP R4, #0x9
    MOVEQ R4, #57
    CMP R4, #0xA
    MOVEQ R4, #65
    CMP R4, #0xB
    MOVEQ R4, #66
    CMP R4, #0xC
    MOVEQ R4, #67
    CMP R4, #0xD
    MOVEQ R4, #68
    CMP R4, #0xE
    MOVEQ R4, #69
    CMP R4, #0xF
    MOVEQ R4, #70
	STRB R4,[R3,#1]

WRITE_BYTE_END:
	POP {R0-R6,LR}
	BX LR


B end
.end
