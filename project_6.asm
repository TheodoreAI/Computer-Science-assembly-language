; Author: Mateo Estrada
; Last Modified: 3/15/2020
; OSU email address: estradma@oregonstate.edu
; Course number/section: CS271/S400
; Project Number: 6                 Due Date: 3/15/2020
; Description: This program is designed to implement calling low-level I/O procedures, and implementing it 
; using macros. The goal is to Get a user input, verify that the input is valid (signed integer) by converting it to an int, then converting it back to a string,
; then displaying the result. To test this out, an array is used. 



INCLUDE Irvine32.inc

; Macro for the intro and for the code input description
Intromacro		MACRO		buffer
; This macro is designed to display text and instructions. 
; Idea taken from lecture slides.
; Recieves: String
; Returns: Text
; Pre-conditions: Needs to get string into the buffer
; post-condtions: Displays the text.
				push		edx
				mov			edx, offset buffer
				call		WriteString
				call		crlf
				pop			edx
ENDM


Intromacro1		MACRO		buffer
; Same as above but for getting the inputs in ReadVal.
				push		edx
				mov			edx, offset buffer
				call		WriteString
				pop			edx
ENDM

; Macro for the getString
; D: Asks the user to input a string and then uses the user's input to put it in a memory location.
; Recieves: The Intromacro to display the message, getString buffer, length of the buffer
; Returns: N/A
; Preconditions: N/A
; Registers changed: edx, ecx

getString		MACRO		buffer, bufferLength
				push		ecx
				push		edx
				
				; asks the user
				Intromacro1	inst1
				call		WriteString
				mov			edx, buffer
				mov			ecx, bufferLength	
				call		ReadString
				pop			edx
				pop			ecx

ENDM

CallWriteString		MACRO	buffer
; Calls WriteString to get the string input
; Pre-condition: Passing the address of memory location of string.
; Recieves: memory location address
; Returns: Input string
; Post-condtion: returns the string in edx register	
					mov			edx, buffer
					call		WriteString		
ENDM

convertStr			MACRO	strLength		buffer
; Gets the input and converts it to string so that it may be properly printed.
; Pre-condtions: Ints have to have been inputted, valid ones.
; Recieves: arrayN, MaxIn, LengthStr
; Post-conditions: outputs the ints in string format to be displayed by stringDisplay



ENDM

; Displays string that has been stored in memory
; Preconditions: Must have string stored, and pass it as offset
; Recieves: string
; Returns: Display for user
; post: N/A
; Registers: edx 

displayString	MACRO		stringAddy
				push		edx,
				mov			edx, stringAddy
				call		WriteString
				call		crlf
				pop			edx
ENDM

.data
design			BYTE			" Made by: Mateo Estrada", 0
portfolio		BYTE			" Welcome to Portfolio Project for CS271: low-level I/O proc",0
			


intro1			BYTE			" Please provide 10 signed decimal integers.",0
intro2			BYTE			" Each number needs to be small enough to fit inside a 32 bit register. ",0
intro3			BYTE			" After you have finished inputting the numbers I will display a list ",0
intro4			BYTE			" of integers, their sum, and their average value. ", 0

inst1			BYTE			" Please enter a signed number: ",0
inst2			BYTE			" You entered the following numbers: ",0

error			BYTE			" ERROR: the values you entered were too big or not signed",0
inst3			BYTE			" Please try again: ",0


sum				BYTE			" The sum of these numbers is: ",0
average			BYTE			" The rounded average is: ",0



gdbye			BYTE			" Thank you for grading all the programs to the best of your ability, be safe out there! ",0



; array used and it's length
arrayN			DWORD		10		DUP(?)
stringIn		BYTE		25		DUP(?)
stringLength	DWORD		?				; helps to keep track of how many char's
; constant definitions
MaxIn = 10

.code

main proc
				; the introduction using a  Macro
				Intromacro	design
				Intromacro	portfolio

				Intromacro	intro1		
				Intromacro	intro2
				Intromacro	intro3
				Intromacro	intro4
				
			
				; is intended to begin the process of getting string input 
				push	offset	MaxIn 		; 28
				push	offset	inst1		; 24
				push	offset	error		; 20
				push	offset	inst3		; 16
				push	offset	arrayN		; 12
				push	offset	stringLength; 8
				call	fillArray

				; is intended to display the contents of arrayN
				push	offset	MaxIn		; 20
				push	offset	arrayN		; 16
				push	offset	stringIn	; 12
				call	writeVal

				
				; farewell is implemented with the IntroMacro for displaying msgs
				call		crlf
				Intromacro	gdbye
				exit


main endp


fillArray		proc

; Gets user input to fill arrayN. Calls on ReadVal to
; read input, ReadVal calls Valid to make sure the input is
; digits, then Valid calls convertStr to convert the  string into a number.
; Preconditions: arrayN, inst1, error, and are passed as offset
; and LENGTHOF arrayN is passed as value by pushing them to the stack.
; Receives: arrayN, error, inst1, etc by reference.
; Returns: n/a
; Registers used: eax, ecx, ebp, esi, ebx
				
			   ; begin the usual stack process
				push	ebp
				mov		ebp, esp
				mov		ecx, [ebp + 8]		; the length of array to loop
				mov		edi, [ebp + 20]		; arrayN address
				fill:
					push	[ebp + 28]		; push the error msg
					call	 ReadVal			; call ReadVal to make the string <--> integer changes
					pop		[edi]			; iterate throughout the string array
					add		 edi, 4
					loop	 fill 
				pop	ebp
				pop eax
				pop ebx
				ret	24

fillArray		endp


ReadVal			proc

; Reads user input, calls Valid to make sure the input is made of numbers. 
; Recieves: Error, inst1, inst3 by reference by pushing on stack.
; Pre-conditions: All parameters are passed by reference by pusing on stack using offset.
; Returns: Valid inputs of signed integers 
; post-conditions: returns a valid signed integer on the top of the stack to be referenced by value.
; Registers used: eax, ebp, ebx, esi, ecx
				LOCAL	    inNum[16]:DWORD
				push		edp
				mov			edp, esp
				push		edi
				push		ecx
				lea			eax, inNum

				InNumLoop:
							getString	eax, inNum		; use the getString macro to input the integers
							push		[ebp + 28]				; loading the error messages
							push		ebx						; pusing it to stack so Valid gets it
							mov			eax, inNum
							push		eax					    ; pushin inNum
							push	    inNum
							call		Valid

				pop		eax
				pop		ebx
				pop		ebp

				ret		28
ReadVal			endp


Valid			proc
; Makes sure the user input string is a signed integer.
; Pre-conditions: Push on stack by offset the following: error, inst1, inst3, and the LENGTHOF inStrNum
; Recieves: Error, inst1, inst3, by reference and LENGTHOF inStrNum by value.
; Returns: A valid value, while changing the state of Valid to 0 if invalid. 
; post-conditions: int is valid, valid state is changed to 0 if invalid number was inputter.
; Registers used: eax, edx, ecx, esi, ebp
				push	ebp
				mov		esp, ebp			; 
				
				; loading the string
				mov		esi, [ebp + 12]		; ESI pointing to the source 
				mov		ecx, [ebp + 8]		; setting the rep counter
				
				; from the book/lecture slides on checking to see if strings 
				; are digits and signed
				strCheck:
					
						lodsb
						cmp		al, 0
						JE		NotString
						cmp		al, 48
						JL		ChngState
						cmp		al, 57
						JG		ChngState
						loop	strCheck
						JMP		ending
				NotString:
						jmp		ending

				chngState:
					
						Intromacro	error		; load the error message
						call		crlf
						jmp			ending
				ending:

						pop			edx
						ret			8

Valid			endp


writeVal		proc
; Is supposed to write an integer to the console as a string using the convertChar MACRO to do so.
; Recieves: int by value
; Pre-conditions: int is passed onto the stack by offset
; returns: nothing
; post-conditions: integer is printed as a str to the display
; Registers used: ebp,
						push		ebp
						mov			ebp, esp

						pop			ebp
						ret			
writeVal		endp

END main