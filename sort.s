		.text
		.global _start

_start:
		LDR R0,=N			//R0 points to the number of elements
		ADD R1, R0, #4		//R1 points to the numbers array
		LDR R6,[R0]			//R6 stores the number of elements for innner loop
		MOV R10,#0			//boolean indicator for sorted
		
		

LOOP2:  LDR R6,[R0]			//R6 stores the number of elements for innner loop
		ADD R1, R0, #4		//R1 points to the numbers array
		CMP R10,#0			//check indicator 
		MOV R10,#1			//set indicator to sorted
		BEQ LOOP1			//if indicator is not sorted, go to loop 1
		B END
		
LOOP1:	
		LDR R4,[R1]			//store the data into R4
		LDR R5,[R1,#4]		//store next element into R5
		CMP R4,R5			//Ccompare R4 and R5
		BMI NEXT			//if R4<R5, dont swap
		STR R4,[R1,#4]		//move bigger value to next postion
		LDR R8,[R1,#4]		//test data
		STR R5,[R1]			//move the smaller value to previous position
		LDR R9,[R1]			//test data
		MOV R10,#0			//update indicator to unsorted

NEXT:	SUB R6,R6,#1		//decrement the counter of number of elements
		CMP R6,#1			//if R3 - 1 = 0, exit loop
		BEQ LOOP2			//get out of the loop if counter is zero
		ADD R1,R1, #4		//move to the the next element in the array
		B	LOOP1			//loop back 

END: 	B END



N: 		.word	8
NUMBERS:.word	4, -5, 3, 6	// the list data
		.word	1, 8, 2, 7
