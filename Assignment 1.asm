TITLE Assignment 1     (Assignment1.asm)

; Author: Aviral Sinha
; Course / Project ID : CS 271                Date: 01/17/2016
; Description:  This program will let the user enter 2 numbers and then either let them add, subtract, multiply, divide, or find the remainder.

INCLUDE Irvine32.inc

.data
myName				BYTE	"Aviral Sinha", 0
programTitle		BYTE	" Assignment 1", 0
instructions		BYTE	"Enter 2 numbers and you will be shown the sum, difference, product, quotient, and remainder!", 0
prompt_1			BYTE	"1st Number: ", 0
prompt_2			BYTE	"2nd Number: ", 0
firstNumber			DWORD	?							 ; integer entered by user
secondNumber		DWORD	?							 ; second integer entered by user.
goodBye				BYTE	"Thank you!",0
equalsString		BYTE	" = ", 0
sum					DWORD	?
sumString			BYTE	" + ",0
difference			DWORD	?
differenceString	BYTE	" - ",0
product				DWORD	?
productString		BYTE	" * ",0
quotient			DWORD	?
quotientString		BYTE	" / ",0
remainder			DWORD	?
remainderString		BYTE	" remainder ",0

; **EC

EC1prompt			BYTE	"**EC: Verification if the second number is less than the first. ", 0
EC1warn				BYTE	"The second number must be less than the first!", 0
EC2prompt			BYTE	"**EC: Quotient value rounded to nearest .001", 0
EC2string			BYTE	"EC: Floating-point value: ", 0
EC2FloatingPoint	REAL4	?	; short real single precision floating point variable
oneThousand			DWORD	1000						; to convert an int to a floating point number rounded to .001 (can be changed to increase or decrease precision)
bigInt			    DWORD	0							; represents the floating point number multiplied by 1000
ECremainder			DWORD	?							; for floating point creation
dot					BYTE	".",0						; to serve as the decimal place of a floating point number
firstPart			DWORD	?							; for the first part of the floating point representation of the quotient
secondPart			DWORD	?							; fot the part of the floating point number after the decimal place
temp				DWORD	?							; temporary holder for floating point creation
EC3prompt			BYTE	"**EC: Would you like to play again? Enter 1 for YES or 0 for NO: ", 0
EC3explain			BYTE	"**EC: Program will loop until you decide to quit.", 0
EC3response			DWORD	?							; BOOL for user to loop or exit.

.code
 main PROC

	; Introduction
	; This section prints out the instructions and **EC options

		mov		edx, OFFSET myName
		call	WriteString
		mov		edx, OFFSET programTitle
		call	WriteString
		call	CrLf
		mov		edx, OFFSET EC1prompt
		call	WriteString
		call	CrLf
		mov		edx, OFFSET EC2prompt
		call	WriteString
		call	CrLf
		mov		edx, OFFSET EC3explain
		call	WriteString
		call	CrLf

	; Data Collection
	; Get the 1st and 2nd numbers and jump if the 2nd is greater than the 1st
	; Program will loop if 2nd number is greater than the 1st
		mov		edx, OFFSET instructions
		call	WriteString
		call	CrLf

			; get firstNumber
top:
			mov		edx, OFFSET prompt_1
			call	WriteString
			call	ReadInt
			mov		firstNumber, eax


			; get secondNumber
			mov		edx, OFFSET prompt_2
			call	WriteString
			call	ReadInt
			mov		secondNumber, eax

			; **EC: Jump if second number greater than first
			mov		eax, secondNumber
			cmp		eax, firstNumber
			jg		Warning
			jle		Calculate

Warning:
			mov		edx, OFFSET EC1warn
			call	WriteString
			call	CrLf
			jg		JumpToLoop				; jump if secondNumber > firstNumber


Calculate:		; Calculate Required Values
				; sum
				mov		eax, firstNumber
				add		eax, secondNumber
				mov		sum, eax

				; difference
				mov		eax, firstNumber
				sub		eax, secondNumber
				mov		difference, eax

				; product
				mov		eax, firstNumber
				mov		ebx, secondNumber
				mul		ebx
				mov		product, eax


				; quotient
				mov		edx, 0
				mov		eax, firstNumber
				cdq
				mov		ebx, secondNumber
				cdq
				div		ebx
				mov		quotient, eax
				mov		remainder, edx

				; EC floating point representation of quotient and remainder
				fld		firstNumber					; load firstNumber (integer) into ST(0)
				fdiv	secondNumber				; divide firstNumber by secondNumber ?
				fimul	oneThousand
				frndint	
				fist	bigInt
				fst		EC2FloatingPoint			; take value off stack, put it in EC2FloatingPoint

			; Display Results

				; sum results
				mov		eax, firstNumber
				call	WriteDec
				mov		edx, OFFSET sumString
				call	WriteString
				mov		eax, secondNumber
				call	WriteDec
				mov		edx, OFFSET equalsString
				call	WriteString
				mov		eax, sum
				call	WriteDec
				call	CrLf

				; difference results
				mov		eax, firstNumber
				call	WriteDec
				mov		edx, OFFSET differenceString
				call	WriteString
				mov		eax, secondNumber
				call	WriteDec
				mov		edx, OFFSET equalsString
				call	WriteString
				mov		eax, difference
				call	WriteDec
				call	CrLf

				; product results
				mov		eax, firstNumber
				call	WriteDec
				mov		edx, OFFSET productString
				call	WriteString
				mov		eax, secondNumber
				call	WriteDec
				mov		edx, OFFSET equalsString
				call	WriteString
				mov		eax, product
				call	WriteDec
				call	CrLf

				; quotient results
				mov		eax, firstNumber
				call	WriteDec
				mov		edx, OFFSET quotientString
				call	WriteString
				mov		eax, secondNumber
				call	WriteDec
				mov		edx, OFFSET equalsString
				call	WriteString
				mov		eax, quotient
				call	WriteDec
				mov		edx, OFFSET remainderString
				call	WriteString
				mov		eax, remainder
				call	WriteDec
				call	CrLf

				; EC2 Output
				mov		edx, OFFSET EC2string
				call	WriteString
				mov		edx, 0
				mov		eax, bigInt
				cdq
				mov		ebx, 1000
				cdq
				div		ebx
				mov		firstPart, eax
				mov		ECremainder, edx
				mov		eax, firstPart
				call	WriteDec
				mov		edx, OFFSET dot
				call	WriteString

				;calculate remainder
				mov		eax, firstPart
				mul		oneThousand
				mov		temp, eax
				mov		eax, bigInt
				sub		eax, temp
				mov		secondPart, eax
				call	WriteDec
				call	CrLf

		; Loop until user quits
		; have user enter 0 or 1 to choose whether or not to continue
		; if they choose yes then it will  ask for a number again
		

				;  response for loop

JumpToLoop:			mov		edx, OFFSET EC3prompt
					call	WriteString
					call	ReadInt
					mov		EC3response, eax
					cmp		eax, 1
					je		top				; jump to top if response == 1


				; Saying Thank You
					mov		edx, OFFSET goodBye
					call	WriteString
					call	CrLf

	exit	; exit to operating system
main ENDP

END main

