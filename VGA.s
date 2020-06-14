.global _start
_start:
.equ CHAR_BUFFER, 0xC9000000
.equ PIXEL_BUFFER, 0xC8000000
.equ PUSH_BUTTON_DATA, 0xFF200050
.equ PUSH_BUTTON_MASK, 0xFF200058
.equ PUSH_BUTTON_EDGE, 0xFF20005C
	
BL read_PB_data_ASM
CMP 	R0,#0x0001
BLEQ	test_byte
CMP 	R0,#0x0002
BEQ 	test_char
CMP 	R0,#0x0004
BEQ 	test_pixel
CMP 	R0,#0x0008
BLEQ	VGA_clear_pixelbuff_ASM
BLEQ 	VGA_clear_charbuff_ASM
B end

test_pixel:
	PUSH {R0-R2,LR}
	MOV R0,#0			//X
	MOV R1,#0			//Y
	MOV R2,#0			//colour
loop_y_test_pixel:
	CMP R1,#240
	BEQ TEST_PIXEL_END
	MOV R0,#0
	B loop_x_test_pixel
loop_x_test_pixel:
	BL VGA_draw_point_ASM
	ADD R2,R2,#1
	ADD R0,R0,#1
	CMP R0,#320
	ADDEQ R1,#1
	BEQ	loop_y_test_pixel
	B	loop_x_test_pixel
TEST_PIXEL_END:
	POP {R0-R2,LR}
	B end
	
	

test_char:
	PUSH {R0-R2,LR}
	MOV R0,#0			//X
	MOV R1,#0			//Y
	MOV R2,#0			//C
loop_y_test_char:
	CMP R1,#60
	BEQ TEST_CHAR_END
	MOV R0,#0
	B loop_x_test_char
loop_x_test_char:
	BL VGA_write_char_ASM
	ADD R2,R2,#1
	ADD R0,R0,#1
	CMP R0,#80
	ADDEQ R1,#1
	BEQ	loop_y_test_char
	B	loop_x_test_char
TEST_CHAR_END:
	POP {R0-R2,LR}
	B end
	

test_byte:
	PUSH {R0-R2,LR}
	MOV R0,#0			//X
	MOV R1,#0			//Y
	MOV R2,#0			//C
loop_y_test_byte:
	CMP R1,#60
	BEQ TEST_BYTE_END
	MOV R0,#0
	B loop_x_test_byte
loop_x_test_byte:
	BL VGA_write_byte_ASM
	ADD R2,R2,#1
	ADD R0,R0,#3
	CMP R0,#80
	ADDGE R1,#1
	BGE	loop_y_test_byte
	B	loop_x_test_byte
TEST_BYTE_END:
	POP {R0-R2,LR}
	B end


VGA_clear_charbuff_ASM:
	PUSH {R0-R6,LR}
	LDR R0,=CHAR_BUFFER	//base address
	MOV R1,#0			//Y
	MOV R2,#0			//X

LOOP_CHAR:
	LSL R4,R1,#7
	ORR R5,R0,R4
	ORR R3,R2,R5		//r3 = the full address
	MOV R6,#0
	STRB R6,[R3]
	ADD R2,R2,#1
	CMP R2,#80
	ADDEQ R1,#1
	MOVEQ R2,#0
	CMP R1,#60
	POPEQ {R0-R6,LR}
	BXEQ LR
	B LOOP_CHAR

VGA_clear_pixelbuff_ASM:
	PUSH {R0-R7,LR}
	LDR R0,=PIXEL_BUFFER	//base address
	MOV R1,#0			//Y
	MOV R2,#0			//X

LOOP_PIXEL:
	LSL R4,R1,#10
	LSL R7,R2,#1
	ORR R5,R0,R4
	ORR R3,R5,R7		//r3 = the full address
	MOV R6,#0
	STRH R6,[R3]
	ADD R2,R2,#1
	CMP R2,#320
	ADDEQ R1,#1
	MOVEQ R2,#0
	CMP R1,#240
	POPEQ {R0-R7,LR}
	BXEQ LR
	B LOOP_PIXEL

VGA_write_char_ASM:
	PUSH {R0-R3,LR}
	CMP R0,#79
	BGT WRITE_CHAR_END
	CMP R0,#0
	BLT WRITE_CHAR_END
	CMP R1,#59
	BGT WRITE_CHAR_END
	CMP R1,#0
	BLT WRITE_CHAR_END	//check if the coordinates are valid
	LDR R3,=CHAR_BUFFER
	LSL R1,R1,#7
	ORR R3,R3,R1
	ORR R3,R3,R0		//R3 = full address
	STRB R2,[R3]

WRITE_CHAR_END:
	POP {R0-R3,LR}
	BX LR



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

VGA_draw_point_ASM:
	PUSH {R0-R6,LR}
	CMP R0,#320
	BGT WRITE_CHAR_END
	CMP R0,#0
	BLT WRITE_CHAR_END
	CMP R1,#240
	BGT WRITE_CHAR_END
	CMP R1,#0
	BLT WRITE_CHAR_END
	LDR R3,=PIXEL_BUFFER
	LSL R5,R1,#10
	LSL R6,R0,#1
	ORR R3,R3,R5
	ORR R3,R3,R6		//r3 = the full address
	STRH R2,[R3]
DRAW_POINT_END:
	POP {R0-R6,LR}
	BX LR


read_PB_data_ASM:
LDR R1, =PUSH_BUTTON_DATA
LDR R0, [R1]
AND R0, R0, #0xF
BX LR

PB_data_is_pressed_ASM:
LDR R1, =PUSH_BUTTON_DATA
LDR R2, [R1]
AND R2, R2, R0
CMP R2, R0
MOVEQ R0, #1
MOVNE R0, #0
BX LR

read_PB_edgecap_ASM:
LDR R1, =PUSH_BUTTON_EDGE
LDR R0, [R1]
AND R0, R0, #0xF
BX LR

PB_edgecap_is_pressed_ASM:
LDR R1, =PUSH_BUTTON_EDGE
LDR R2, [R1]
AND R2, R2, R0
CMP R2, R0
MOVEQ R0, #1
MOVNE R0, #0
BX LR


PB_clear_edgecap_ASM:
LDR R1, =PUSH_BUTTON_EDGE	  
MOV R2, R0
STR R2, [R1]
BX LR

enable_PB_INT_ASM:
LDR R1, =PUSH_BUTTON_MASK
AND R2, R0, #0xF
STR R2, [R1]
BX LR

disable_PB_INT_ASM:
LDR R1, =PUSH_BUTTON_MASK
LDR R2, [R1]
BIC R2, R2, R0
BX LR


end: B end

.end
