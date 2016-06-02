TITLE Assignment 3     (assignment3.asm)

;Author: Aviral Sinha
;Course/Project ID: CS 271   Date: 2/7/2016
;Description: This program will get the user's name, greet them, then display
;instructions. Repeatedly prompt the user to enter a number. Validate the user 
;input to be in [-100, -1] (inclusive).
;Count and accumulate the valid user numbers until a non-negative number is entered. 
;(The nonnegative number is discarded.)
;After displaying the various features it will end the program. 

INCLUDE Irvine32.inc

.data

welcome					       BYTE	"Welcome to the Integer Accumulator", 0
instructions_1			   BYTE	"Please enter numbers between [-100, -1].", 0
instructions_2			   BYTE	"Then, enter a non-negative number.", 0
instructions_3			   BYTE	" Enter a number: ", 0
userNameInstructions   BYTE	"What is your name?", 0
greeting				       BYTE	"Hello, ", 0
goodbye					       BYTE	"Goodbye, ", 0
number					       DWORD  ?
userName				       BYTE   21 DUP(0)
userNameByteCount		   DWORD	?
count					         DWORD	1
accumulator				     DWORD	0
totalIs					       BYTE	"The total is:                  ", 0
quantNumbersEntered 	 BYTE	"Amount of numbers accumulated:  ", 0
roundedAve_prompt		   BYTE	"The Rounded Average is:        ", 0
roundedAve				     DWORD  0
remainder				       DWORD	?
floating_point_point	 BYTE	".",0
floating_point_prompt	 BYTE	"As a floating point number:    ", 0
neg1k					         DWORD  -1000
onek					         DWORD	1000
subtractor				     DWORD	?
floating_point			   DWORD	?
;ec promp
ec_prompt_1				     BYTE	"EC: Display as floating point value.", 0
ec_prompt_2				     BYTE	"EC: Lines are numbered during user input.", 0
;constants
LOWERLIMIT		=		 -100
UPPERLIMIT		=		 -1
;change text color
val1 DWORD 11
val2 DWORD 16
.code
 main PROC
	; Set text colour as teal
		mov  eax, val2
		imul eax, 16
		add  eax, val1
		call setTextColor
	; Programmer name and Assignment name
  	call	 CrLf
  	mov		 edx, OFFSET welcome
  	call	 WriteString
  	call	 CrLf
	;ec prompts
  	mov		 edx, OFFSET ec_prompt_1
  	call	 WriteString
  	call	 CrLf
  	mov		 edx, OFFSET ec_prompt_2
  	call	 WriteString
  	call	 CrLf
	; get user name
  	mov		edx, OFFSET userNameInstructions
  	call	WriteString
  	call	CrLf
  	mov		edx, OFFSET userName
  	mov		ecx, SIZEOF userName
  	call	ReadString
  	mov		userNameByteCount, eax
	;test username
  	mov		edx, OFFSET greeting
  	call	WriteString
  	mov		edx, OFFSET userName
  	call	WriteString
  	call	CrLF
	; assignment instructions
  	mov		edx, OFFSET instructions_1
  	call	WriteString
  	call	CrLf
  	mov		edx, OFFSET instructions_2
  	call	WriteString
  	call	CrLf
  	mov		ecx, 0
	; loop to let user to continue entering negative numbers
	userNumbers:	;read user number
			mov		eax, count
			call	WriteDec
			add		eax, 1
			mov		count, eax
			mov	  edx, OFFSET instructions_3
			call	WriteString
			call  ReadInt
			mov   number, eax
			cmp		eax,LOWERLIMIT
			jb		accumulate;
			cmp		eax, UPPERLIMIT
			jg		accumulate
			add		eax, accumulator
			mov		accumulator, eax
			loop	userNumbers
	; accumulation
	accumulate:
			; Make sure user enters valid numbers, if not exit the program
			mov		eax, count
			sub		eax, 2
			jz		sayGoodbye
			mov		eax, accumulator
			call	CrLF
			; accumulated total
			mov		edx, OFFSET  totalIs
			call	WriteString
			mov		eax, accumulator
			call	WriteInt
			call	CrLF
			; total numbers accumulated
			mov		edx, OFFSET quantNumbersEntered
			call	WriteString
			mov		eax, count
			sub		eax, 2
			call	WriteDec
			call	CrLf
			; integer rounded average
			mov		edx, OFFSET roundedAve_prompt
			call	WriteString
			mov		eax, 0
			mov		eax, accumulator
			cdq
			mov		ebx, count
			sub		ebx, 2
			idiv	ebx
			mov		roundedAve, eax
			call	WriteInt
			call	CrLf
			; integer average for accumulator
			mov		remainder, edx
			mov		edx, OFFSET floating_point_prompt
			call	WriteString
			call	WriteInt
			mov		edx, OFFSET floating_point_point
			call	WriteString
			; floating point creation
			mov		eax, remainder
			mul		neg1k
			mov		remainder, eax 
			mov		eax, count
			sub		eax, 2		   
			mul		onek
			mov		subtractor, eax
			; floating point creation stack
			fld		remainder
			fdiv	subtractor
			fimul	onek
			frndint
			fist	floating_point
			mov		eax, floating_point
			call	WriteDec
			call	CrLf
	; say goodbye
	sayGoodbye:
			call	CrLf
			mov		edx, OFFSET goodbye
			call	WriteString
			mov		edx, OFFSET userName
			call	WriteString
			mov		edx, OFFSET floating_point_point
			call	WriteString
			call	CrLf
			call	CrLf
exit	; exit the program 
main ENDP
END main