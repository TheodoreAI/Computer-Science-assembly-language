; Author: Mateo Estrada
; Last Modified: 2/19/2020
; OSU email address: estradma@oregonstate.edu
; Course number/section: CS271/S400
; Project Number: 4                 Due Date: 2/19/2020
; Description: This program is designed to calculate composite numbers. The user is asked to enter the number of composites to be displayed, 
; then you have to enter an integer in the range [1-400].
; The program verifies that the number is in the range, if the number is not in range, then the loop repeats and the user is asked to enter a number that is within range.
; Then the program calculates and displays all of the composite numbers up to and including the nth cmposite.
; There is a specific format for the display of numbers. 




sortArray proc
; This procedure sorts the arrayN values in ascending order.
; Pre-conditions: array has to be filled with 200 values in the correct range
; Recieves: address of array 
; Returns: sorted values of arrayN
; Registers changed: eax, ecx, ebp, esi


					push		ebp
					mov			ebp, esp
					mov			esi, [ebp+12]		; addy of array
					mov			ecx, [ebp+8]
					dec			ecx					; decrement the counter
					
					ousiteLoop:
								mov			eax, [esi]
								mov			edx, esi
								push		ecx		; pushed to the top of stack to use in inner loop

								insideLoop:
											mov		ebx, [esi+4]
											mov		eax, [edx]
											cmp		eax, ebx			; if i <= i+1 else exchange them so the bigger value goes last
											JLE		leave
											add		esi, 4				; next value
											push	esi					; push on the stack
											push	edx
											push	ecx
											call	exchange
sortArray endp



INCLUDE Irvine32.inc

.data

; variables for displaying the messages to the user
myName			BYTE		"Mateo Estrada " , 0
who				BYTE		" Made by ", 0
intro1			BYTE		" Composite Numbers ", 0
intro2			BYTE		" Enter the number of composite numbers you would like to see ", 0
intro3			BYTE		" I'll accept orders in the range [1,..,400]. ", 0

composites		BYTE		" The composites are: ", 0
space			BYTE		"   ", 0
isIn			BYTE		" Its in here ", 0

userData1		BYTE		"Enter the number of composites to display [1 .. 400]:", 0			; 55
userData2       BYTE		" Out of range. Try again. (try more than 3 times with same value within range (there was a bug I couldn't find)", 0
userData3		BYTE		" The composite numbers start at 4. " ,0 

gdbye			BYTE		" The results are attempted to be verified by 'Jarvis' and, ", 0
gdbye0			BYTE		" But Ultron inter... ERROR...DELETE -------------------", 0
Ultron			BYTE		" ULTRON: [Speaking] 'What is this?...' ", 0 


; the constants that are the min and max

max EQU 400
min	EQU 1
rowLength EQU 10

; value that will be the cap 
dos				DWORD		?

; im going to use a global variable for user input
n				DWORD		?
currentComp		DWORD		?			; the first composite number
count			DWORD		?			; where we are in the loop
currentDiv		DWORD		?			; the first divisor that might yield a composite because the remainder == 0
nextComp		DWORD		?			; this value is the one that has the next composite value





.code
main PROC
			call	intro
			call	getUserData
			call	showComposite	
			call	farewell

; if the input value from the user is valid the next section of code will begin here
			
			exit
main ENDP


; this is the intro procedure that makes the proper introductions tot he user

intro PROC
; displays instructions using the intro and myName variables
; most of this code is just printing for the user to know what to do
; registers used: edx
			mov		edx, OFFSET intro1
			call	WriteString
			call	crlf
			mov		edx, OFFSET who
			call	WriteString
			
			mov		edx, OFFSET myName
			call	WriteString
			call	crlf
			mov		edx, OFFSET intro2
			call	WriteString
			call	crlf
			mov		edx, OFFSET intro3
			call	WriteString
			call	crlf	



			ret
intro ENDP


getUserData PROC
; Pre: This procedure takes the data from the user and calls a 
; subprocedure to validate if it's within the range.
; saves input data in: n
; post: uses eax, to save into global varibale n


			

		; get an integer from the user
again::		
			and		eax, eax
			mov		edx, OFFSET	userData1	; add 55 to skip ebp, eax, ebx, edx
			call	WriteString			
			call	ReadInt
			mov		n, eax
			call	valid
			ret

getUserData ENDP

valid PROC
; pre: this subprocedure to getUserData is used to check if the value in the register ebx,
; fits within the range 1-400. if not, then this loops back to getUserData
; used eax, ebx, ecx, 
; post: if the data is not correct it show error, otherwide it returns to main with a valid input
				and		eax, eax
				mov		eax, n
				cmp		eax, min			; if n > 1 and n < 400 go to the main procedure to show composites, else go back to the getUserData procedure
				JG		check2
				call	error
	check2:		
				mov		eax, n
				cmp		eax, max
				JL		validInt
				call	error				; if the secoond check is not satisfied then start again


	error:		mov		edx, OFFSET userData2
				call	WriteString
				call	crlf
				jmp		again

	validInt:
				ret
valid ENDP

showComposite PROC
; pre: this procedure takes some string variables, and the number of composite values that we want
; this procedure shows the composites
; I will do this using a long approach of checking if the numbers from 4 to n are divisible by 2+i
; if they are then they are composite and get printed, if not then it increments to the next
; until the end of the loop
; used eax, ebx, ecx
; Post: it gives out the number of composite values calculated using the isComposite sub-procedure
			
				mov		edx, OFFSET composites
				call	WriteString
				call	crlf

; moves the 0 into the count
				mov		eax, count
				mov		eax, 0
				mov		count, eax 

; moves the 4 into the currentComp to initialize the currentComp
				mov		eax, currentComp
				mov		eax, 4
				mov		currentComp, eax
				mov		nextComp, eax
				call	WriteDec
				mov		edx, OFFSET space
				call	WriteString
; initialize the the currentDiv to 2
				mov		eax, currentDiv
				mov		eax, 2
				mov		currentDiv, eax
; setting up how many times the loop should happen maximum (equal to n)
				mov     eax, n
				mov		ecx, eax
			
				
loopcomposite:	
					
				call	isComposite						; calls the isComposite procedure
	print:

; if the currentComp > n then stop the loop, jumps to return
; otherwise it will continue to execute the loop
				mov		eax, n							; places the input value inside eax
														; decremets count cause it started at 1, cause of the initial 4
				cmp		count, eax						; if the count is bigger than the eax, then we have gone too far
				je		return
				mov		eax, currentComp				; prints the composite value that was divisible by currentDiv
				call	WriteDec 
				mov		edx, OFFSET space				; gives it the three spaces
				call	WriteString
				loop	loopcomposite					; starts loop again
	return:
				ret

showComposite ENDP

isComposite PROC
; pre: this proc gets called and gets the number of composite numbers the main function wants
; variables used: currentComp = keeps track of what is the composite number that is going to be printed
;				  count = how many composite numbers do we need to print
;			      currentDiv = in what iteration of division we are ( 2,3,4,5,..., n - 1)
;				  registers: eax, edx, ecx, 
; post: returns the values that are composites by starting at 4, then summing by 1, until the number the user want of composite numbers
	
iteration:
; if nextComp <= n, then execute else return to the showComposite
			
	increase:
				mov		eax, currentComp			; intitially its 4
				inc     eax							; increased eax + 1
				mov		currentComp, eax			; saved that new value in the currentComp

; I need to make sure that a new row gets created every 10 composite numbers
				cmp		count, rowLength			; if the count = rowLength (10), we go to the newRow
				je		newRow
		
; the division is done to see if the number is a composite of smaller integers
			
				cdq
				div		currentDiv					; eax/currentDiv
				cmp		edx, 0						; if the remainder is 0 , then finish
				je		endIteration				
				jmp		increaseDiv					; increment currentDiv = currentDiv + 1 

; checks to see if the currentComp could be divisible by currentDiv, if it is then it saves it and writes it down
	increaseDiv:					
				mov		eax, currentComp			; the numbers that are not divisible by 2, get tested to see if divisible by 3
				cmp		eax, 5						; had a bug that kept saying that 5 is a composite number, but it's not
				je		increase					; this is a small patch for now
				mov		currentComp, eax			; mov the number to this global variable
				inc		currentDiv					; increment the divisor
				div		currentDiv					; divide by the divisor and if there is not remainder then go to assignComp
				cmp		edx, 0
				je		assignComp
				jmp		increase


; checks to see if the currentComp could be divisible by currentDiv, if it is then it saves it and writes it down
; this is going to be an attempt at making a loop that generates the rest of the composite numbers
	increaseDiv5:

			
								
				mov		eax, currentComp			; the numbers that are not divisible by 2, get tested to see if divisible by 3
													; had a bug that kept saying that 5 is a composite number, but it's not
				mov		currentComp, eax			; mov the number to this global variable
				inc		currentDiv					; increment the divisor
				div		currentDiv					; divide by the divisor and if there is not remainder then go to assignComp
				cmp		edx, 0
				je		assignComp
				jmp		increase


; is used to assign a composite value that is divisible by 3
	assignComp:
				mov		eax, currentComp			; if we find another composite number, we save it to currentComp and end isComposite procedure
				mov		currentComp, eax
				jmp		endIteration

; if there is a composite value found it goes here			
endIteration:	
				inc		count						; since there was a composite found we increase the count
				ret
newRow:			
				call	crlf
				mov		count, 0
				jmp    iteration

isComposite ENDP


farewell PROC
; uses the gdbye, myName, and gdbye1 variables
; to print out the farewell message
				call	crlf
				mov		edx, OFFSET gdbye
				call	WriteString
				mov		edx, OFFSET myName
				call	WriteString
				mov		edx, OFFSET space
				call	WriteString
				call	crlf
				mov		edx, OFFSET gdbye0
				call	WriteString
				mov		edx, OFFSET Ultron
				call	WriteString
				ret
			
farewell ENDP

END main