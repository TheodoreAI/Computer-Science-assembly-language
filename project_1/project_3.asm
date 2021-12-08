
; Author: Mateo Estrada
; Last Modified:
; OSU email address: estradma@oregonstate.edu
; Course number/section: CS271/S400
; Project Number: 1                 Due Date: 1/19/2020
; Description: MASM program to display my name, and program title on the output screen. Display instructions for the user, 
; prompt the user to enter three numbers. caluclate and dispolay the sum and differences, and display a terminating message. 


; does this get saved in the other file?
INCLUDE Irvine32.inc

.data

; variables for displaying the messages to the user
myName			BYTE		"Mateo Estrada " , 0
myProgram		BYTE		"CS271: Project 1" , 0
myInstr			BYTE		"Enter three different positive integers in descending order" , 0
myInstr1		BYTE		"to get their sum and difference.", 0
num1			BYTE		"First number: ",0
num2			BYTE		"Second number: ",0
num3			BYTE		"Third number: ",0
sumEqual_1		BYTE		"Their sum is: ",0
diffEqual_1		BYTE		"Their difference is: ",0
sumEqual_2		BYTE		"Their sum is (A+C): ",0
diffEqual_2		BYTE		"Their difference is: ",0
sumEqual_3		BYTE		"Their sum is: ",0
diffEqual_3		BYTE		"Their difference is: ",0
sumEqual_4		BYTE		"Their sum is: ",0
byeMsg			BYTE		"That is all folks! ",0

plus_str	    BYTE		" + ",0
minus_str		BYTE		" - ",0
equal_str		BYTE		" = ",0


; These variables hold the values.
numOne				DWORD		?
numTwo				DWORD		?
numThree			DWORD		?
sum_1				DWORD		?
sum_2				DWORD		?
sum_3				DWORD		?
sum_4				DWORD		?

difference_1		DWORD		?
difference_2		DWORD		?
difference_3		DWORD		?

.code
main PROC

;this code displays my name and the project that I'm working on
				mov			edx, OFFSET myName						; begins displaying the string stored in myName
				call		WriteString								; writes the string on the display
				mov			edx, OFFSET myProgram					; calls to start the other part of the string that is saved in myProgram
				call		WriteString
				call		crlf
; display the user the instructions in the first line 

				mov			edx, OFFSET myInstr						; calls the string from myInstr
				call		WriteString
				call		crlf

; display the user the rest of the intrustions; second line

				mov			edx, OFFSET myInstr1					; calls  the string from myInstr1
				call		WriteString
				call		crlf
				call		crlf

; Getting the numbers from the user (below are all similar, but with different variable names, and messages)
; get the first int
				mov			edx, OFFSET num1		; place the string into the beginning for user to input an int
				call		WriteString				; writes a null-terminated string to standard output
				call		ReadInt					; this allows user input of an int, from Irvine library using ReadInt(same as below).
				mov			numOne, eax				; the register saves numOne

;get the second int
				mov			edx, OFFSET num2
				call		WriteString
				call		ReadInt					;this allows user input of an int
				mov			numTwo, eax

;get the third int
				mov			edx, OFFSET num3		; Assignes a memory address to access
				call		WriteString				; tells user to input a number
				call		ReadInt					; this allows user input of an int
				mov			numThree, eax			; places the value inside the variable numThree

; A + B: I will explain the code for sum and difference, and its similar for below, except different variables, and sum/difference.
; calulate the sum for numOne and numTwo and save it in sum_1

				mov			eax, numOne				; saves user input numOne to register
				add			eax, numTwo				; user input numTwo gets added to register which contains numOne already
				mov			sum_1, eax				; saves the addition of the two user ints to the variable sum_1
; A - B
; calculate the difference for numOne and numTwo and save it in difference_1
				mov			eax, numOne				; saves the value of numOne inside register
				sub			eax, numTwo				; subtracts numTwo from the regiser eax which had the value numOne
				mov			difference_1, eax		; saves the difference inside the variable difference_1


; A + C 
; calulate the sum for numOne and numThree and saves it in sum_2

				mov			eax, numOne
				add			eax, numThree
				mov			sum_2, eax
; A - C
; calculate the difference for numOne and numThree and saves it in difference_2
				mov			eax, numOne
				sub			eax, numThree
				mov			difference_2, eax

; B + C

; calulate the sum for numOne and numThree and saves it in sum_3

				mov			eax, numTwo
				add			eax, numThree
				mov			sum_3, eax
;  B - C
; calculate the difference for numOne and numThree and saves it in difference_3
				mov			eax, numTwo
				sub			eax, numThree
				mov			difference_3, eax

; A + B + C
; calculate the sum A + B + C

				mov			eax, numOne		; saves numOne inside eax
				mov			ebx, numTwo		; saves numTwo inside the register
				mov			ecx, numThree	; saves the numThree inside the register
				add			eax, ebx		; adds the values inside the first and second register
				add			eax, ecx		; adds the value of the third register to the first
				mov			sum_4, eax		; saves the value inside the first register to the variable sum_4


; displaying the results for each calculation, I will explain the code for the first display of summation and difference, the rest are similar.
;diplay the sum A + B

				mov			eax, numOne					; saves numOne to a register
				call		WriteDec					; writes the value of numOne on the screen as a decimal
				mov			edx, OFFSET plus_str		; calls the address of the variable that has the string "+"
				call		WriteString					; writes the plus sign on the display
						
				mov			eax, numTwo					; saves numTwo inside the register
				call		WriteDec					; displays the value inside the register 
				mov			edx, OFFSET	equal_str		; calls the address that contains the "+" sign
				call		WriteString					; wrties the plus sign on display
				mov			eax, sum_1					; saves the sum of the numOne and numTwo on a register
				call		WriteDec					; displays the value of said sum (sum_1)
				call		crlf						; ends the code section


; displaying the results for the differences A - B		
			
				
				mov			eax, numOne					; (to not overwhelm with comments, this section is similar to above with a few exceptions)
				call		WriteDec	
				mov			edx, OFFSET minus_str		; used a string for "-" instead of "+"
				call		WriteString

				mov			eax, numTwo
				call		WriteDec
				mov			edx, OFFSET equal_str
				call		WriteString
				mov			eax, difference_1			
				call		WriteDec					; display the difference between the two numbers 
				call		crlf


;diplay the sum A + C IN the right way					; same as A + B, but A + C

				mov			eax, numOne
				call		WriteDec
				mov			edx, OFFSET plus_str
				call		WriteString

				mov			eax, numThree
				call		WriteDec
				mov			edx, OFFSET	equal_str
				call		WriteString
				mov			eax, sum_2
				call		WriteDec
				call		crlf


; displaying the results for the differences A - C		; same as A - B, but A - C
		
				mov			eax, numOne
				call		WriteDec
				mov			edx, OFFSET minus_str
				call		WriteString

				mov			eax, numThree
				call		WriteDec
				mov			edx, OFFSET equal_str
				call		WriteString
				mov			eax, difference_2
				call		WriteDec
				call		crlf



;diplay the sum B + C IN the right way					; same as above

				mov			eax, numTwo
				call		WriteDec
				mov			edx, OFFSET plus_str
				call		WriteString

				mov			eax, numThree
				call		WriteDec
				mov			edx, OFFSET	equal_str
				call		WriteString
				mov			eax, sum_3
				call		WriteDec
				call		crlf




; displaying the results for the differences B - C
				
				mov			eax, numTwo
				call		WriteDec
				mov			edx, OFFSET minus_str
				call		WriteString

				mov			eax, numThree
				call		WriteDec
				mov			edx, OFFSET equal_str
				call		WriteString
				mov			eax, difference_3
				call		WriteDec
				call		crlf


; the sum A + B + C

				mov			eax, numOne				; saves the numOne variable to register
				call		WriteDec				; display the value of the variable
				mov			edx, OFFSET plus_str	; saves the address the address value of variable plus_str
				call		WriteString				; writes the plus_str

				mov			eax, numTwo				; saves the numTwo variable to register
				call		WriteDec				; displays the value of the variable
				mov			edx, OFFSET plus_str	; saves the address value of the variable plus_str in register
				call		WriteString				; writes the string plus_str

				mov			eax, numThree			; saves the numThree variable to register
				call		WriteDec				; displays the value of the variable to user
				mov			edx, OFFSET	equal_str	; saves the address value of the variable equal_str in register
				call		WriteString				; writes "="
				mov			eax, sum_4				; saves the sum of all input variables into register
				call		WriteDec				; displays the value of the variables
				call		crlf					; ends line and calls new one
; saying bye to the user

				mov			edx, OFFSET byeMsg		; referencing the address of the variable byeMsg
				call		WriteString				; printing the value of the address byeMsg
				call		crlf

	exit	; exit to operating system
main ENDP

END main
