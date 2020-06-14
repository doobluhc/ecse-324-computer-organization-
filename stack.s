	.text
	.global _start

_start:
	LDR R0,=NUMBERS		//R0 points to the first number in the array  
	LDR R1,[R0]			//R1 stores the number in the array 
	LDR R2,N			//R2 store the number of elements
	LDR SP, [R0,#32]	//innitialize SP
LOOP1:
	STR R1, [SP, #-4]!	//store R1 into SP then decrement SP
	ADD R0,R0, #4		//move to next number in the array
	LDR R1, [R0]		//load number into R1
	SUBS R2, R2, #1		//decrement count
	BNE LOOP1			//if R2 != 0, GO BACK TO THE LOOP
	
	LDR R2,N			//R2 store the number of elements

LOOP2:
	LDR R1, [SP], #4	//load number into R1 then increment SP
	SUBS R2, R2, #1		//devrement count	
	BNE LOOP2			//if R2 != 0, GO BACK TO THE LOOP
	
	
	

END:
	B END


N:			.word	4
NUMBERS: 	.word	1,2,3,4
