TITLE Programming Assignment    Assignment5.asm

; Author:Aviral Sinha
;Course/Project ID: CS 271        Date: 2/28/16
; Description:
;Write and test a MASM program to perform the following tasks:
;1. Introduce the program.
;2. Get a user request in the range [min = 10 .. max = 200].
;3. Generate request random integers in the range [lo = 100 .. hi = 999], storing them in consecutive elements
;of an array.
;4. Display the list of integers before sorting, 10 numbers per line.
;5. Sort the list in descending order (i.e., largest first).
;6. Calculate and display the median value, rounded to the nearest integer. 7. Display the sorted list, 10 numbers per line.


INCLUDE Irvine32.inc

.data

welcome					   BYTE	  "Welcome to Sorting Random Integers by Aviral Sinha.", 0
instructions_1			   BYTE	  "Enter a number between [10, 200] to see all ",0
instructions_2			   BYTE   "Numbers before and after they're sorted. It will display the median value and show the sorted list in descending order", 0
instructions_3			   BYTE   "Enter a number between 10 and 200.", 0
belowError				   BYTE   "Number entered was too small. ", 0
aboveError				   BYTE   "Number entered was too big. ", 0
medianString			   BYTE	  "The median is: ",0
spaces					   BYTE	  "   ", 0
goodbye					   BYTE	  "Thanks!", 0
beforeSort				   BYTE	  "Array before sorting: ", 0
afterSort				   BYTE	  "Array after sorting: ", 0
number					   DWORD  ?
request					   DWORD  ?
requestTemp			       DWORD  ?
;constants
MIN				=		 10
MAX				=		 200
LO				=		 100
HI				=		 999
MAX_SIZE		=		 200
;Array
list					   DWORD MAX_SIZE DUP(?)  
;text color
val1 DWORD 11
val2 DWORD 16
.code
 main PROC
	push val1
	push val2
	call changeColor
	call introduction
	push OFFSET request
	call getData
	call Randomize			
	push OFFSET list
	push request
	call fillArray
	mov  edx, OFFSET beforeSort
	call WriteString
	call CrLf
	push OFFSET list
	push request
	call displayList
	push OFFSET list
	push request
	call sortList
	call CrLf
	push OFFSET list
	push request
	call displayMedian
	call CrLf
	mov  edx, OFFSET afterSort
	call WriteString
	call CrLf
	push OFFSET list
	push request
	call displayList
	call farewell
	exit
main ENDP
; ******************************************************************************************************
; CHANGE COLOR PROCEDURE:
; Description :		 Procedure that changes colors of console output to teal.
; Receives:			 val1 and val2 are pushed onto stack before called.
; Returns:			 null
; Preconditions:	 val1 and val2  set to integers between 0 and 16
; Registers Changed: eax, esp
; ******************************************************************************************************
changeColor PROC
	;text color
		push ebp
		mov	 ebp, esp
		mov  eax, [ebp + 8] ; val 1
		imul eax, 16
		add  eax, [ebp + 12] ; val 2
		call setTextColor
		pop	 ebp
		ret  8	; Clean up the stack
changeColor	ENDP
; ******************************************************************************************************
; INTRODUCTION PROCEDURE:
; Description :		 Procedure gives  user instructions and  introduction to  program.
; Receives:			 welcome, instructions_1, and instructions_2 are global variables
; Returns:		     null
; Preconditions:	 welcome, instructions_1, and instructions_2 must be set to strings
; Registers Changed: edx,
; ******************************************************************************************************
introduction PROC
	; Programmer name and title of assignment
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
	ret
introduction ENDP
; ******************************************************************************************************
; GETDATA PROCEDURE:
; Description :		 get and validate an integer between 10 and 200 from the user.
; Receives:			 instructions_3 is global variable. Receives OFFSET of request variable. MAX and MIN global constants.
; Returns:			 puts user's request integer into the request variable.
; Preconditions:	 instructions_3 set to strings. Request must be declared as a DWORD
; Registers Changed: edx, eax,
; ******************************************************************************************************

getData PROC

	; loop to allow user to continue entering numbers until within range of MIN and MAX
		push ebp
		mov	 ebp, esp
		mov	 ebx, [ebp + 8] 


	userNumberLoop:
					mov		edx, OFFSET instructions_3
					call	WriteString
					call	CrLf
					call    ReadInt
					mov     [ebx], eax		; save the user's request into var request
					cmp		eax, MIN
					jb		errorBelow
					cmp		eax, MAX
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
			pop ebp
	ret 4 
getData ENDP

; ******************************************************************************************************
; FILLARRAY PROCEDURE:
; Description :		 Fill array with random numbers
; Receives:			 list: @array and request: number of array elements
; Returns:			 null
; Preconditions:	 request must be set to an integer between 10 and 200
; Registers Changed: eax, ecx, esi
; ******************************************************************************************************

fillArray PROC
	push ebp
	mov  ebp, esp
	mov  esi, [ebp + 12]  
	mov	 ecx, [ebp + 8]   ; loop control based on request

	fillArrLoop:
		mov		eax, HI
		sub		eax, LO
		inc		eax
		call	RandomRange
		add		eax, LO
		mov		[esi], eax  ; random number in array
		add		esi, 4	
		loop	fillArrLoop

	pop  ebp
	ret  8
fillArray ENDP

; ******************************************************************************************************
; DISPLAYLIST PROCEDURE:
; Description :		 Prints out values in list MIN numbers per row
; Receives:			 list: @array and request: number of array elements
; Returns:			 null
; Preconditions:	 request set to an integer between 10 and 200
; Registers Changed: eax, ecx, ebx, edx
; ******************************************************************************************************

displayList PROC
	push ebp
	mov  ebp, esp
	mov	 ebx, 0			  
	mov  esi, [ebp + 12]  ; @list
	mov	 ecx, [ebp + 8]   ; loop control based on request
	displayLoop:
		mov		eax, [esi]  ; current element
		call	WriteDec
		mov		edx, OFFSET spaces
		call	WriteString
		inc		ebx
		cmp		ebx, MIN
		jl		skipCarry
		call	CrLf
		mov		ebx,0
		skipCarry:
		add		esi, 4		; next element
		loop	displayLoop
	endDisplayLoop:
		pop		ebp
		ret		8
displayList ENDP

; ******************************************************************************************************
; SORTLIST PROCEDURE:
; Description :		 Prints out values in list
; Receives:			 list: @array and request: number of array elements
; Returns:			 null
; Preconditions:	 request must be set to an integer between 10 and 200
; Registers Changed: eax, ecx, ebx, edx
; ******************************************************************************************************

sortList PROC
	push ebp
	mov  ebp, esp
	mov  esi, [ebp + 12]			; @list
	mov	 ecx, [ebp + 8]				; loop control based on request
	dec	 ecx
	outerLoop:
		mov		eax, [esi]			; current element
		mov		edx, esi
		push	ecx					; save outer loop counter
		innerLoop:
			mov		ebx, [esi+4]
			mov		eax, [edx]
			cmp		eax, ebx
			jge		skipSwitch
			add		esi, 4
			push	esi
			push	edx
			push	ecx
			call	exchange
			sub		esi, 4
			skipSwitch:
			add		esi,4

			loop	innerLoop
			skippit:
		pop		ecx 			; restore outer loop counter
		mov		esi, edx		; reset esi

		add		esi, 4				; next element
		loop	outerLoop
	endDisplayLoop:
		pop		ebp
		ret		8
sortList ENDP

; ******************************************************************************************************
; exchange PROCEDURE:
; Description :		 Prints out values in list
; Receives:			 list: @array and request: number of array elements
; Returns:			 null
; Preconditions:	 request must be set to an integer between 10 and 200
; Registers Changed: eax, ecx, ebx, edx
; ******************************************************************************************************

exchange PROC
	push	ebp
	mov		ebp, esp
	pushad

	mov		eax, [ebp + 16]				; address of 2nd number
	mov		ebx, [ebp + 12]				; address of 1st number
	mov		edx, eax
	sub		edx, ebx					; edx has difference between the 1st and 2nd number

	
	mov		esi, ebx
	mov		ecx, [ebx]
	mov		eax, [eax]
	mov		[esi], eax  
	add		esi, edx
	mov		[esi], ecx

	popad
	pop		ebp
	ret		12
exchange ENDP

; ******************************************************************************************************
; DISPLAYMEDIAN PROCEDURE:
; Description :		 Fill array with random numbers
; Receives:			 list: @array and request: number of array elements
; Returns:			 null
; Preconditions:	 request set to an integer between 10 and 200
; Registers Changed: eax,ebx, ecx, edx,
; ******************************************************************************************************

displayMedian PROC
	push ebp
	mov  ebp, esp
	mov  esi, [ebp + 12]  ; @list
	mov	 eax, [ebp + 8]   ; loop control based on request
	mov  edx, 0
	mov	 ebx, 2
	div	 ebx
	mov	 ecx, eax


	medianLoop:
		add		esi, 4
		loop	medianLoop

	cmp		edx, 0
	jnz     itsOdd
	
	mov		eax, [esi-4]
	add		eax, [esi]
	mov		edx, 0
	mov		ebx, 2
	div		ebx
	mov		edx, OFFSET medianString
	call	WriteString
	call	WriteDec
	call	CrLf
	jmp		endDisplayMedian

	itsOdd:
	mov		eax, [esi]
	mov		edx, OFFSET medianString
	call	WriteString
	call	WriteDec
	call	CrLf

	endDisplayMedian:

	pop  ebp
	ret  8
displayMedian ENDP


; ******************************************************************************************************
; GOODBYE PROCEDURE:
; Description :		 say goodbye to the user.
; Receives:		     global variables.
; Returns:			 null
; Preconditions:	 goodbye must be set to strings.
; Registers Changed: edx
; ******************************************************************************************************

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