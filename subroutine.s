		.text
		.global _start

_start:
		LDR R0,=NUMBERS		//R0 points to the array
		LDR R1, N			//R1 hold the number of elements
		PUSH {R0,R1,LR}		//push parameters and LR
		BL MAX				// calls subroutine MAX
		LDR R0,[SP,#4]		//get the max number
		STR R0,MAXNUMBER	//store into memory
		LDR LR,[SP,#8]		//restore LR
		ADD SP,SP,#12		//remove parameters from stack
stop:   B stop
		
MAX:	PUSH {R0-R3}		//callee-save the registers max will use 
		LDR R1, [SP,#20]	//R1 hold the number of elements
		LDR R2, [SP,#16]	//R2 points to the first number in the array
		LDR R0, [R2]		//move the temperory max to R0
LOOP:	SUBS R1,R1,#1		//decrement counter
		BMI DONE			//exit loop
		LDR R3,[R2,#4]!		//get next number
		CMP R3,R0			//compare next number and the max
		BLT LOOP			//IF R3 is less than R0, branch back to MAX
		MOV R0,R3			//if R3 is greater than r0, update max
		B LOOP

DONE:	STR R0, [SP,#20]	//store the max number on stack
		POP {R0-R3}			//restore registers
		BX LR				


N:			.word	5				// number of entries in the list
NUMBERS:	.word	9, 5, 8, 6,-2,	// the list data
MAXNUMBER:	.space 	4
			.end
	
