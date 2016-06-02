TITLE Assignment 2     (Assignment2.asm)

; Author: Aviral Sinha
; Course / Project ID : CS 271                Date: 01/24/2016
; Description:  This program will calculate fibonacci, it will greet the user, show the program name, get the user's name, and then enter the number of fibonacci terms 
               ; and then validate the user input. Then it will validate the user input, calculate it all up to the nth term. 
			   ;The program will conclude with it terminating itself

INCLUDE Irvine32.inc

.data
myName				BYTE	"Aviral Sinha ", 0
programTitle		BYTE	"Assignment 2 ", 0
instructions		BYTE	"Enter two numbers and the sum, difference, product, quotient, and remainder will be displayed.", 0
prompt_1			BYTE	"What is your name? ", 0
prompt_2			BYTE	"Enter integers between 1 and 46 and then see the Fibonacci sequence", 0
ec_prompt			BYTE	"EC: Doing something awesome: Setting text color to teal-ish", 0
numFib				DWORD	?
prev1				DWORD	?
prev2				DWORD	?
spaces				BYTE	"     ",0
goodbye				BYTE	"Goodbye,  ", 0
firstTwo			BYTE	"1     1     ", 0
firstOne			BYTE	"1", 0
temp				DWORD	?
moduloFive			DWORD	5
UPPERLIMIT = 46
LOWERLIMIT = 1
;user's name
buffer				BYTE 21 DUP(0)
byteCount			DWORD	?

;greet user
hi					BYTE	"Hello, ",0

;validation
tooHighError		BYTE	"The number entered is too high. It Must be 46 or below. ", 0
tooLowError			BYTE	"The number entered is too low! It must be 1 or above. ", 0

;EC -> Something awesome creating background color
val1 DWORD 11
val2 DWORD 16

.code
 main PROC

	;EC: text color

	; setting text color to teal
		mov eax, val2
		imul eax, 16
		add eax, val1
		call setTextColor

	; INTRO
		mov		edx, OFFSET programTitle
		call	WriteString
		mov		edx, OFFSET myName
		call	WriteString
		call	CrLf

		; EC Prompt
		mov		edx, OFFSET ec_prompt
		call	WriteString
		call	CrLf


		mov		edx, OFFSET prompt_1
		call	WriteString
		call	CrLf


		; getting user name
		mov		edx, OFFSET buffer	;point to the buffer
		mov		ecx, SIZEOF	buffer	; specify max characters
		call	ReadString
		mov		byteCount, eax

		; Greeting the user
		mov		edx, OFFSET hi
		call	WriteString
		mov		edx, OFFSET buffer
		call	WriteString
		call	CrLf

	; USER INSTRUCTION
topPrompt:
			mov		edx, OFFSET prompt_2
			call	WriteString
			call	CrLf

	;  USER DATA
		call	ReadInt
		mov		numFib, eax

	; Validate user data
		cmp		eax, UPPERLIMIT
		jg		TooHigh
		cmp		eax, LOWERLIMIT
		jl		TooLow
		je		JustOne
		cmp		eax, 2
		je		JustTwo

	; DISPLAY FIBONACCI

		; prepare loop (post-test), first 2 done manually

		mov		ecx, numFib
		sub		ecx, 3			; starts at 3, 1st two are taken care of by JustOne and JustTwo
		mov		eax, 1
		call	WriteDec
		mov		edx, OFFSET spaces
		call	WriteString
		call	WriteDec
		mov		edx, OFFSET spaces
		call	WriteString
		mov		prev2, eax
		mov		eax, 2
		call	WriteDec
		mov		edx, OFFSET spaces
		call	WriteString
		mov		prev1, eax

		fib:
			; add prev 2 to eax
			add		eax, prev2
			call	WriteDec

			mov		edx, OFFSET spaces
			call	WriteString

			mov		temp, eax
			mov		eax, prev1
			mov		prev2, eax
			mov		eax, temp
			mov		prev1, eax

			
			mov		edx, ecx
			cdq
			div		moduloFive
			cmp		edx, 0
			jne		skip
			call	CrLf

		skip:
				; restore what was on eax
				mov		eax, temp
				; if ecx % 3 = 0 call CrLf
				loop	fib
		jmp		TheEnd

TooHigh:
			mov		edx, OFFSET tooHighError
			call	WriteString
			jmp		TopPrompt

TooLow:
			mov		edx, OFFSET tooLowError
			call	WriteString
			jmp		TopPrompt
JustOne:
			mov		edx, OFFSET firstOne
			call	WriteString
			jmp		TheEnd

JustTwo:
			mov		edx, OFFSET firstTwo
			call	WriteString
			jmp		TheEnd

	; Ending the Program
TheEnd:
			call	CrLf
			mov		edx, OFFSET goodbye
			call	WriteString
			mov		edx, OFFSET buffer
			call	WriteString
			call	CrLf

	exit	; exit the program
main ENDP

END main
