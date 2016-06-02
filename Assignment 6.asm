TITLE Programming Assignment #6 Low Level I/O (Assignment6A.asm)

;Author: Aviral Sinha
;OSU Email: sinhaav@oregonstate.edu
;Course: CS 271 Assembly Language
;Assignment Number: 6A
;Due Date: March 13,  2016
;Description:1) User’s numeric input must be validated the hard way: Read the user's input as a string, and convert the string to numeric form. 
; If the user enters non-digits or the number is too large for 32-bit registers, an error message should be displayed and the number should be discarded.
;2) Conversion routines must appropriately use the lodsb and/or stosb operators.
;3) All procedure parameters must be passed on the system stack.
;4) Addresses of prompts, identifying strings, and other memory locations should be passed by address to the macros.
;5) Used registers must be saved and restored by the called procedures and macros.
;6) The stack must be “cleaned up” by the called procedure.
;7) The usual requirements regarding documentation, readability, user-friendliness, etc., apply.

INCLUDE Irvine32.inc

.data

welcome					   BYTE	  "Welcome to Low Level I/O by Aviral Sinha.", 0
instructions_1			   BYTE	  "Enter 10 unsigned decimal integers.",0 
instructions_2			   BYTE   "The numbers must fit inside a 32 bit register. Once finished, it will display the list of integers, its sum and its average.", 0
instructions_3			   BYTE   "Enter an unsigned integer: ", 0
aveString				   BYTE	  "Average is: ",0
errString				   BYTE	  "Error!", 0
spaces					   BYTE	  ", ", 0
goodbye					   BYTE	  "Thank You! ", 0
enteredString			   BYTE   "For these numbers: ", 0
sumString				   BYTE   "The sum is: ", 0
request					   DWORD  10 DUP(0)
requestCount			   DWORD  ? 
;constants
MIN				=		 0
LO				=		 30h
HI				=		 39h
MAX_SIZE		=		 10
;Array
list					   DWORD MAX_SIZE DUP(?)  
strResult				   db 16 dup (0)		  ; string buffer to store decimal to hex (magic)
; text color
val1 DWORD 11
val2 DWORD 16
getString MACRO	instruction, request, requestCount
	;get string macro
	push	edx
	push	ecx
	push	eax
	push	ebx
	mov		edx, OFFSET instructions_3
	call	WriteString
	mov		edx, OFFSET request
	mov		ecx, SIZEOF	request
	call	ReadString
	mov		requestCount, 00000000h
	mov		requestCount, eax	
	pop     ebx
	pop		eax
	pop		ecx
	pop		edx
ENDM
displayString MACRO  strResult
	push	edx
	mov		edx, strResult
	call	WriteString
	pop		edx
ENDM
.code
 main PROC
	push	val1
	push	val2
	call	changeColor
	call	introduction
	push	OFFSET list
	push	OFFSET request
	push	OFFSET requestCount
	call	readVal
	call	CrLf
	push	OFFSET aveString
	push	OFFSET sumString
	push	OFFSET list
	call	displayAve
	call	CrLf
	push	edx
	mov		edx, OFFSET enteredString
	call	WriteString
	pop		edx
	push	OFFSET strResult
	push	OFFSET list
	call	writeVal
	call	CrLf
	push	OFFSET goodbye
	call	farewell
	exit
main ENDP
; ******************************************************************************************************
; CHANGE COLOR PROCEDURE:
; Description :		 Change colors of console output to teal.
; Receives:			 val1 and val2 pushed onto stack before called.
; Returns:			 null
; Preconditions:	 val1 and val2 set to integers between 0 and 16
; Registers Changed: eax, esp
; ******************************************************************************************************
changeColor PROC
	; Text color is teal
	push	ebp
	mov		ebp, esp
	mov		eax, [ebp + 8] ; val 1
	imul	eax, 16
	add		eax, [ebp + 12] ; val 2
	call	setTextColor
	pop		ebp
	ret		8								;Stack is cleaned up
changeColor	ENDP
; ******************************************************************************************************
; INTRODUCTION PROCEDURE:
; Description :		 Give  user instructions and an introduction to  program.
; Receives:			 welcome, instructions_1, and instructions_2 are global variables
; Returns:		     null
; Preconditions:	 welcome, instructions_1, and instructions_2 must be set to strings
; Registers Changed: edx, 
; ******************************************************************************************************
introduction PROC
	; Program and Programmer Names
	call	 CrLf
	mov		 edx, OFFSET welcome
	call	 WriteString
	call	 CrLf
	call	 CrLf
	; assignment instructions
	mov		edx, OFFSET instructions_1
	call	WriteString
	mov		edx, OFFSET instructions_2
	call	WriteString
	call	CrLf
	ret
introduction ENDP
; ******************************************************************************************************
; readVal PROCEDURE:
; Description :		 Procedure to get and validate integer from user and turn decimal into string.
; Receives:			 Array to store values in, a buffer to read the input
; Returns:			 puts user's integers in an array of strings
; Preconditions:	 Array must be declared, and a way to count the number of digits entered as well as a place to store the original 
;					 decimal input.
; Registers Changed: edx, eax, ecx, ebx
; ******************************************************************************************************
readVal PROC

		push  ebp
		mov	  ebp, esp
		mov	  ecx, 10								;  10 numbers total. 
		mov	  edi, [ebp+16]							 

	userNumberLoop: 	
					
					getString instructions_3, request, requestCount    ; Call Macro

					push	ecx
					mov		esi, [ebp+12]			; put request into esi
					mov		ecx, [ebp+8]			; put the requestCount which is the number of digits the person entered
					mov		ecx, [ecx]				; get the value at ecx into ecx
					cld							
					mov		eax, 00000000			; clear eax
					mov		ebx, 00000000			; ebx is the ACCUMALATOR
					
						str2int:
							lodsb					;loads request into eax one byte at a time
							
							cmp		eax, LO			; error check
							jb		errMessage		
							cmp		eax, HI		
							ja		errMessage		
							
							sub		eax, LO			; 30
							push	eax
							mov		eax, ebx
							mov		ebx, MAX_SIZE
							mul		ebx
							mov		ebx, eax
							pop		eax
							add		ebx, eax
							mov		eax, ebx
							
							continn:
							mov		eax, 00000000
							loop	str2int

					mov		eax,ebx 
					stosd							;eax goes into list array
					
					add		esi, 4					
					pop		ecx						
					loop	userNumberLoop
					jmp		readValEnd
		
		errMessage:
				pop		ecx
				mov		edx, OFFSET  errString
				call	WriteString
				call	CrLf
				jmp		userNumberLoop

	readValEnd:
	pop ebp			
	ret 12													; clean up the stack.
readVal ENDP


; ******************************************************************************************************
; writeVal PROCEDURE:
; Description :		  MACRO's displayString to convert strings to ascii and prints it out
; Receives:			 list: @array and request: number of array elements
; Returns:			 prints out string in ASCII digits 
; Preconditions:	 Needs an array of integers as strings. 
; Registers Changed: eax, ecx, ebx, edx 
; ******************************************************************************************************

writeVal PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp + 8]				; @list
	mov		ecx, 10
	L1:	
				push	ecx
				mov		eax, [edi]
			    mov		ecx, 10         ; divide
				xor		bx, bx          ; counts number of digits

			divide:
				xor		edx, edx				  ; 
				div		ecx						  ; eax = quotient, edx = remainder
				push	dx						  ; DL should be between 0 and 9
				inc		bx						  ; count number of digits
				test	eax, eax				  ; See if EAX zero.
				jnz		divide					  ; no, continue

												  ; Reversed order POP!
				mov		cx, bx					  ; number of digits
				lea		esi, strResult			  ; string buffer
			next_digit:
				pop		ax
				add		ax, '0'					  ; convert  numbers to ASCII
				mov		[esi], ax				  ; write to strResult
				
				displayString OFFSET strResult

				loop	next_digit
			
		pop		ecx 
		mov		edx,	OFFSET spaces
		call	WriteString
		mov		edx, 0
		mov		ebx, 0
		add		edi, 4
		loop L1
	
	pop		ebp			
	ret		8										
writeVal ENDP


; ******************************************************************************************************
; displayAve PROCEDURE:
; Description :		 Takes array of numbers and prints out average and sum. 
; Receives:			 list: @array 
; Returns:			 Prints out average and sum of the array
; Preconditions:	Array should be filled with integers as integers and not strings. 
; Registers Changed: eax, ebx, ecx, edx
; ******************************************************************************************************

displayAve PROC
	push ebp
	mov  ebp, esp
	mov  esi, [ebp + 8]  ; @list
	mov	 eax, 10										; loop  
	mov  edx, 0
	mov	 ebx, 0
	mov	 ecx, eax

	medianLoop:
		mov		eax, [esi]
		add		ebx, eax
		add		esi, 4
		loop	medianLoop
	
	endMedianLoop:
	
	mov		edx, 0
	mov		eax, ebx
	mov		edx, [ebp+12]
	call	WriteString
	call	WriteDec
	call	CrLf
	mov		edx, 0
	mov		ebx, 10
	div		ebx
	mov		edx, [ebp+16]
	call	WriteString
	call	WriteDec
	call	CrLf

	endDisplayMedian:

	pop		ebp
	ret		12
displayAve ENDP


; ******************************************************************************************************
; FAREWELL PROCEDURE:
; Description :		Goodbye to the User
; Receives:		      global variables.
; Returns:			 null
; Preconditions:	 goodbyte set to strings.
; Registers Changed: edx,  
; ******************************************************************************************************

farewell PROC
	
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp + 8]							; @goodbye string

	call	CrLf	
	call	WriteString
	call	CrLf
	pop		ebp
	ret		4
	
farewell ENDP

exit
END main