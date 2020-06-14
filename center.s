		.text
		.global _start

_start:
		LDR R0,=N			//R0 points to the number of elements
		LDR R3,[R0]			//R3 stores the number of elements
		ADD R1, R0, #4		//R1 points to the numbers array
		MOV R5,#0			//R5 stores the sum
		
LOOP1:	LDR R4,[R1]			//store the data into R4
		ADD R5,R5,R4		//accumulate the sum
		SUBS R3,R3,#1		//decrement the counter of number of elements
		BEQ DONE1			//get out of the loop if counter is zero
		ADD R1,R1, #4		//move to the the next element in the array
		B	LOOP1			//loop back 

DONE1: 	LSR R5,R5,#3		//store the average into R5

		LDR R0,=N			//R0 points to the number of elements
		LDR R3,[R0]			//R3 stores the number of elements
		ADR R1, NUMBERS		//R1 points to the numbers array
		MOV R8,#0			//initialize R8

LOOP2:	LDR R4,[R1]			//store the data into R4
		SUB R4,R4,R5		//subtract the average from the element
		STR R4,[R1]			//change the value at that address
		ADD R8,R8,R4		//accumulate the sum
		SUBS R3,R3,#1		//decrement the counter of number of elements
		BEQ END				//get out of the loop if counter is zero
		ADD R1,R1, #4		//move to the the next element in the array
		B	LOOP2			//loop back 

END:	LSR R8,R8,#3		//divide the average by 8
		B END

N: 		.word	8
NUMBERS:.word	4, 5, 6, 6	// the list data
		.word	1, 8, 2, 7
