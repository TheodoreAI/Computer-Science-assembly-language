; Author: Mateo Estrada
; Last Modified: 2/9/2020
; OSU email address: estradma@oregonstate.edu
; Course number/section: CS271/C400
; Project Number: 3             Due Date: 2/9/2020
; Description: Write a program that takes input string from the user, 
; then it displays their name and greets, then asks for a number,
; Repeatedly prompt the user to enter a number
; Then prints the max and min, summation of valid inputs, and the rounded average.



INCLUDE Irvine32.inc

.data

; string variables will be defined below:
myName					BYTE				"Mateo Estrada ", 0 
whoMade					BYTE				"Welcom to the Integer Accumulator by: ", 0
askUser					BYTE				"What is your name dear user? ", 0
hello					BYTE				"Why hello there, ", 0

; directions 
direc1					BYTE				"Enter a number between: [-88, -55] or [-40, -1] ", 0
direc2					BYTE				"Enter a non-negative number to see the results when you are finished. ", 0
direc3					BYTE				" Invalid input! ", 0
direc4					BYTE				" Enter some value: ", 0
gdbye					BYTE				" Always a pleasure to be of service, ", 0


countTimes1				BYTE				" You entered ", 0
countTimes2				BYTE				" valid numbers. ", 0
maxval					BYTE				" The maximum valid value entered is: ", 0
minval					BYTE				" The minimum valid value entered is: ", 0
sumValues				BYTE				" The sum of your valid numbers is: ", 0
roundAverage			BYTE				" The rounded average is: ", 0
noValid					BYTE				" ERROR! You did not enter any valid inputs. ", 0



; extra credit variables 
line					BYTE				".) ", 0
ec0						BYTE				"--Program Intro-- ", 0
ec1						BYTE				"**EC: Number the lines during user input.", 0
ec2						BYTE				"DESCRIPTION: Number the lines during user input for valid cases.  ", 0


; variables that will be taken from the user
MAX = 80									;max chars to read
userName				BYTE				 MAX+1 DUP (?)					; room for null, for the input of the name of the user
input					DWORD				?								; the variable that has the inputted value from the user
valMax					SDWORD				-100
valMin					DWORD				0
count					DWORD				0
summation				DWORD				0
roundAve				DWORD				?
Ave						DWORD				?

; defining the constants that I will be using to set the max and min values
lowMin = -88
lowMax = -55
hiMin = -40
hiMax = -1

.code
main PROC
;a. introduction
						; Starts the introduction to the user
						mov				edx, OFFSET whoMade
						call			WriteString

						mov				edx, OFFSET myName
						call			WriteString
						call			crlf


;b. userInstructions
					; Asks the user for his name	
						mov				edx, OFFSET askUser
						call			WriteString						
						mov				edx, OFFSET userName				; saves the input string from the user
						mov				ecx, MAX							; saves it on userName
						call			ReadString
						call			crlf

;c. getUserData
						; Greet the user with a message, 
						; and give him directions for inputting an int n
						mov				edx, OFFSET hello				; Greets user, by the input name
						call			WriteString
						mov				edx, OFFSET userName
						call			WriteString
						call			crlf

						mov				edx, OFFSET direc1
						call			WriteString
						call			crlf
						
; The beginning of input and sorting of values
loopValues:
						
						mov				edx, OFFSET direc4		; tells user to enter a value
						call			WriteString				
						call			readInt					; reads the value
						
						mov				input, eax				; n = some value inputted
						cmp				eax, 0					; if n >= 0 go to STOP, else continue
						JGE				stop
						cmp				eax, hiMax				; if n <= -1 go to condition1, else continue
						JLE				condition1
otherCondition:													; designed to test the other range							
						cmp				eax, lowMin				; if n >= -88 go to condition, else continue
						JGE				condition2
						mov				edx, OFFSET direc3		; call the variable that says the value is not within first range
						call			WriteString
						call			crlf
						loop			loopValues				; loops through this again until STOP is executed
						call			crlf
	condition1:
						mov				eax, input
						cmp				eax, hiMin				; if n >= -40
						JGE				True1
						call			otherCondition		

	condition2: 
						mov				eax, input	
						cmp				eax, lowMax				; if n <= -55, go to True
						JLE				True1
						mov				edx, OFFSET direc3
						call			WriteString
						call			crlf
						call			loopValues				; else go back to the beginning of the loop

						
True1:								
						mov				eax, count				; starts the counting
						add 			eax, 1					; increments the loop each time a valid value is entered
						call			WriteDec
						mov				edx, OFFSET line
						call			WriteString
						mov				count, eax
						call			categorize
						call			crlf
							
categorize:				; Add the valid input into the summation
						; if the new numbers are bigger than the saved ones, reassign										
						mov				eax, summation
						add				eax, input				
						mov				summation, eax
											
						; compares to see if the new input value is bigger than the previous value
						mov				eax, valMax
						cmp				input, eax   			; if n > ValMax, go to assign the new max value
						JG				AssignMax
						call			minimum					; if values are the same then it starts again
minimum:
						; compares to see if the new input value is smaller than the previous value
						mov				eax, valMin
						cmp				input, eax				; if n < valMin
						JL				AssignMin
						; else loopValues again
						jmp				loopValues
			
AssignMax:				
						; assigns the new max value if the input is bigger than the original value
						mov				eax, valMax
						mov				eax, input
						mov				valMax, eax
						jmp				minimum
AssignMin:				
						; assigns the new max value if the input is bigger than the original value
						mov				eax, valMin				
						mov				eax, input
						mov				valMin, eax
						jmp				loopValues


error:
						; if the variable summation is equal to 0, then no valid numbers have been passed and it reads an error message
						mov				edx, OFFSET noValid
						call			WriteString
						call			crlf
						jmp				loopValues							; jmps back to the loop to take in a value
	

stop:				; prints the messages and results and does the rounded average
						mov				eax, summation						; checks to see if the summation is 0
						cmp				eax, 0								; if its equal to 0, then jumps to error
						JE				error
						; the rounded summation calculation 
						mov				eax, summation						; use the summation
						cdq													; change dword to qword
						mov				ebx, count							; use the valid input counter
						idiv			ebx
						mov				roundAve, eax						; place summation in roundAve
						imul			eax, edx, 2							
						cdq
						idiv			ebx
						add				roundAve, eax						; save the rounded average on roundAve
						; prints the data
						mov				edx, OFFSET countTimes1
						call			WriteString
						mov				eax, count
						call			WriteDec

						mov			    edx, OFFSET countTimes2
						call			WriteString
						call			crlf

						mov				edx, OFFSET maxval
						call			WriteString
						mov				eax, valMax
						call			WriteInt
						call			crlf
; this will be showing the minumim value that was entered
						mov				edx, OFFSET minval
						call			WriteString	
						mov				eax, valMin
						call			WriteInt
						call			crlf
						
; this is the summation and will be showed in the output
						mov				edx, OFFSET sumValues
						call			WriteString
						mov				eax, summation
						call			WriteInt
						call			crlf
; this is going to be the rounded summation
						mov				edx, OFFSET RoundAverage
						call			WriteString
						mov				eax, roundAve
						call			WriteInt
						call			crlf
						; gdbye message
						mov				edx, OFFSET gdbye
						call			WriteString
						mov				edx, OFFSET userName
						call			WriteString
						call			crlf
						mov				edx, OFFSET ec0
						call			WriteString
						call			crlf
						mov				edx, OFFSET ec1
						call			WriteString
						call			crlf
						mov				edx, OFFSET ec2
						call			WriteString
		
						
					
	exit	; exit to operating system
main ENDP


END main
