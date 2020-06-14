.text

			.equ TIME0, 0xFFC08000
			.equ TIME1, 0xFFC09000
			.equ TIME2, 0xFFD00000
			.equ TIME3, 0xFFD01000
			.global HPS_TIM_config_ASM
			.global HPS_TIM_read_INT_ASM
			.global HPS_TIM_clear_INT_ASM

HPS_TIM_config_ASM:
			PUSH {R1-R7}
			LDR R3, [R0]				
			AND R3, R3, #0xF		
			MOV R1, #0					

configuration_loop:
			CMP R1, #4					
			BGE configuration_end			//if it is greater than 4, jump to end tag
			AND R5, R3, #1			
			CMP R5, #0				
			ASR R3, R3, #1			
			ADD R1, R1, #1			
			BEQ configuration_loop			

			//Load timer into R2
			CMP R1, #1					//first timer 
			LDREQ R2, =TIME0
			CMP R1, #2					//second timer 
			LDREQ R2, =TIME1
			CMP R1, #3					//third timer 
			LDREQ R2, =TIME2
			CMP R1, #4					//fourth timer 
			LDREQ R2, =TIME3

			//configuration
			LDR R4, [R0, #0x8]		//Load "LD_en" 
			AND R4, R4, #0x6			
			STR	R4, [R2, #0x8]		

			LDR R4, [R0, #0x4]		//Load timeout 
			STR R4, [R2] 					

			LDR R4, [R0, #0x8]		//Load "LD_en" 
			LSL R4, R4, #1				

			LDR R5, [R0, #0xC]		//Load "INT_en" 
			LSL R5, R5, #2				

			LDR R6, [R0, #0x10]		//Load "enable" 

			ORR R7, R4, R5
			ORR R7, R7, R6				//initialize M, I and E bits

			STR R7, [R2, #0x8]			
			ADD R1, R1, #1
			B configuration_loop

configuration_end:					
			POP {R1-R7}		
			BX LR					


HPS_TIM_read_INT_ASM:
			PUSH {R1-R4}				
			AND R0, R0, #0xF		
			MOV R1, #0					

read_loop:
			CMP R1, #4								
			BGE read_end	//if counter is greater than 4, jump to end tag
			AND R4, R0, #1						
			CMP R4, #0								
			ASR R0, R0, #1						
			ADD R1, R1, #1						
			BEQ read_loop	

			//Load timer into R2
			CMP R1, #1							//first timer in use
			LDREQ R2, =TIME0
			CMP R1, #2							//second timer in use
			LDREQ R2, =TIME1
			CMP R1, #3							//third timer in use
			LDREQ R2, =TIME2
			CMP R1, #4							//fourth timer in use
			LDREQ R2, =TIME3
			LDR R3, [R2, #0x10]			//Load S-bit of the timer
			AND R0, R3, #1
			POP {R1-R4}							
			BX LR										

HPS_TIM_clear_INT_ASM:
			PUSH {R1-R4}
			AND R0, R0, #0xF			
			MOV R1, #0						

clear_loop:
			CMP R1, #4					
			BGE clear_end				
			AND R4, R0, #1			
			CMP R4, #0					
			ASR R0, R0, #1			
			ADD R1, R1, #1			
			BEQ clear_loop			

			
			CMP R1, #1					//first timer in use
			LDREQ R2, =TIME0
			CMP R1, #2					//second timer in use
			LDREQ R2, =TIME1
			CMP R1, #3					//third timer in use
			LDREQ R2, =TIME2
			CMP R1, #4					//fourth timer in use
			LDREQ R2, =TIME3

			LDR R4, [R2, #0xC]			//Reading F to clear the timer

			ADD R1, R1, #1				//Increment counter
			B clear_loop
			POP {R1-R4}						
			BX LR									
			.end