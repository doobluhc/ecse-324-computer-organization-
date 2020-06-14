		.text
		.global _start

_start:
		LDR R4, =MAX 		//R4 points to the result location of the max number
		LDR R5, =MIN		//R5 points to the result location of the min number
		LDR R2, [R4,#8]		//R2 holds the number of elements in the list for max
		LDR R6, [R5,#4]		//R6 holds the number of elements in the list for min
		ADD R3,R4, #12		//R3 points to the first number when looking for the max
		ADD R7,R5, #8		//R7 points to the first number when looking for the min
		LDR R0, [R3]		//R0 holds the first number in the list for max
		LDR R8, [R7]		//R8 holds the first number in the list for min

LOOP1:	SUBS R2,R2, #1		// decrement the loop counter
		BEQ DONE1			// end loop if counter has reached 0
		ADD R3, R3, #4		// R3 points to next number in the list
		LDR R1, [R3]		// R1 holds the next number in the list
		CMP R0, R1			// check if it is greater than the maximum
		BGE LOOP1			// if no, branch back to the loop
		MOV R0, R1			// if yes. update the current max
		B LOOP1				// branch back to the loop

DONE1:	STR R0, [R4]		// store the max result to the memory location

LOOP2:	SUBS R6,R6, #1		// decrement the loop counter
		BEQ DONE2			// end loop if counter has reached 0
		ADD R7, R7, #4		// R3 points to next number in the list
		LDR R1, [R7]		// R1 holds the next number in the list
		CMP R8, R1			// check if it is greater than the maximum
		BLT LOOP2			// if no, branch back to the loop
		MOV R8, R1			// if yes. update the current max
		B LOOP2				// branch back to the loop

DONE2:	STR R8, [R5]		// store the min result to the memory location

		SUBS R9,R0, R8		//calculate the difference between the max and min number
		LSR R10,R9,#2 		// divide the difference by 4

END:	B END				// infinite loop!

MAX: 	.word	0			// memory assigned for result location
MIN: 	.word 	0
N:		.word	7			// number of entries in the list
NUMBERS:.word	4, -100, 3, 6	// the list data
		.word	1, 8, 2
