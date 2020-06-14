		.text
		.global _start

_start:
			LDR R0, N
			LDR R1, N
			BL fact
END: B END
N: .word 7
