TITLE Assignment 4     (Assignment4.asm)
;Author: Aviral Sinha
;Course: CS 271     Date: 2/14/16
;Description: Write a program to calculate composite numbers. 
;user is instructed to enter the number of
;composites to be displayed, and is prompted to enter an integer in the range [1 .. 400].
;user enters a number, n, and the program verifies that 1 ≤ n ≤ 400. If n is out of range, the user is reprompted
;until s/he enters a value in the specified range. program then calculates and displays
;all of the composite numbers up to and including the nth composite. 


INCLUDE Irvine32.inc

.data

welcome					   BYTE	  "Welcome to Composites by Aviral Sinha.", 0
instructions_1			   BYTE	  "Enter a number between [1, 400] to see the ",0
instructions_2			   BYTE   "composites up to and including the number you entered", 0
instructions_3			   BYTE   "Enter a number between 1 and 400.", 0
belowError				   BYTE   "The number entered was too small. ", 0
aboveError				   BYTE   "The number entered was too big. ", 0
spaces					   BYTE	  "   ", 0
goodbye					   BYTE	  "Goodbye!", 0
number					   DWORD  ?
count					   DWORD  1

userNumber				   DWORD  ?
userNumberTemp			   DWORD  ?
innerLoopCount			   DWORD  ?
outerLoopCount			   DWORD  ?
underScore				   BYTE	  " _ ", 0
barr					   BYTE	  " | ", 0
outerCompare			   DWORD  ?
innerCompare			   DWORD  ?
writeCount				   DWORD  0
tenn				       DWORD  10



;constants
LOWERLIMIT		=		 1
UPPERLIMIT		=		 400

;text color change
val1 DWORD 11
val2 DWORD 16


.code
 main PROC

	call changeColor
	call introduction
	call getUserData
		;validate
	call showComposites
		;validate is composite
	call farewell

	exit
main ENDP

changeColor PROC

	
		mov  eax, val2
		imul eax, 16
		add  eax, val1
		call setTextColor
		ret
changeColor	ENDP

introduction PROC

	; Programmer and Assignment name
	call	 CrLf
	mov		 edx, OFFSET welcome
	call	 WriteString
	call	 CrLf

	; assignment instructions
	mov		edx, OFFSET instructions_1
	call	WriteString
	mov		edx, OFFSET instructions_2
	call	WriteString
	call	CrLf
	mov		ecx, 0
	ret

introduction ENDP

getUserData PROC

	; loop to let user to enter negative numbers
	userNumberLoop:
					mov		eax, count
					add		eax, 1
					mov		count, eax
					mov		edx, OFFSET instructions_3
					call	WriteString
					call	CrLf
					call    ReadInt
					mov     userNumber, eax
					cmp		eax,LOWERLIMIT
					jb		errorBelow
					cmp		eax, UPPERLIMIT
					jg		errorAbove
					jmp		continue
	;validation

	errorBelow:
					mov		edx, OFFSET belowError
					call	WriteString
					call	CrLf
					jmp		userNumberLoop
	errorAbove:
					mov		edx, OFFSET aboveError
					call	WriteString
					call	CrLf
					jmp		userNumberLoop
	continue:
					; prep the loop
					mov		ecx, 4
					mov		userNumberTemp, ecx

					cmp		ecx, userNumber
					ja		farewell

	ret
getUserData ENDP


showComposites PROC

		; for inner loop
		mov		eax, userNumber
		sub		eax, 2
		mov		innerLoopCount, eax

		; for outer loop
		mov		eax, userNumber
		sub		eax, 3
		mov		outerLoopCount, eax
		mov		ecx, outerLoopCount
		mov		eax, 4
		mov		outerCompare, eax

		; reset inner loop after each complete inner loop cycle
		mov		eax, 2
		mov		innerCompare, eax
		call	CrLf

		outerLoop:
				skipCarry:
					mov		eax, 2
					mov		innerCompare, eax
					mov		eax, outerCompare
					push	ecx
					push	eax
					mov		ecx, innerLoopCount

				isComposite:
							mov		eax, outerCompare
							mov		edx, 0
							div		innerCompare
							cmp		edx, 0
							jne		skipPrint
							; print out Composites
							mov		eax, outerCompare
							call	WriteDec
							mov		edx, OFFSET spaces
							call	WriteString
							mov		ebx, writeCount
							inc		ebx
							mov		writeCount, ebx
							cmp		ebx, 10
							jne		exitInnerLoop
							call	CrLf
							mov		writeCount,esi
							jmp		exitInnerLoop

							skipPrint:

							mov		ebx, innerCompare

							sub		eax, 1
							cmp		eax, ebx
							jae		skipIncrement
							add		eax, 1
							mov		innerCompare, eax
							skipIncrement:
							loop isComposite
							exitInnerLoop:

				pop		eax
				pop		ecx
				inc		eax
				mov		outerCompare, eax
				loop	outerLoop

	ret
showComposites ENDP

farewell PROC
	; goodbye
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf
	call	CrLf
	exit
farewell ENDP
END main