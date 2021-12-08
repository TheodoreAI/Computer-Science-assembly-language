; Author: Mateo Estrada
; Last Modified: 3/1/2020
; OSU email address: estradma@oregonstate.edu
; Course number/section: CS271/S400
; Project Number: 5                 Due Date: 3/1/2020
; Description: Introduce the program, Generate an array with random numbers in a range(LO =10 - HI = 29),
; Display them before sorting them,
; sort the list in ascending order
; calculate and display the median value - rounded to the nearest integer.
; display the sorted list
; display an array, 20 values per line with 3 spaces


INCLUDE Irvine32.inc

; data that will be used throughout (constants)
LO EQU 10
HI EQU 29
len = 20
con	= 2
zero =0
.data


intro1		BYTE		"Sorting and Counting Random Integers! ",0 ; 39
intro2		BYTE		"Programmed by Mateo Estrada ",0   ; 29
intro3		BYTE		"This program generates 200 random numbers in the range [10 ... 29], displays the", 0   ;81
intro4      BYTE		" original list, sorts the list, displays the median value, displays the list sorted in ", 0
intro5		BYTE		" ascending order, then displays the number of instances of each generated value.",0

; descriptions of sorted and unsorted lists
des1	BYTE		" Your unsorted random numbers: ", 0
des2	BYTE		" Your sorted list of random numbers", 0
des3	BYTE		" Your list of instances of each generated number, starting with the number of 10's: ",0
des4	BYTE		" List Median: ", 0
; spaces
space1		BYTE		"                          ", 0
spaceTwo	BYTE		"  ", 0

gdbye		BYTE	" Thank you for your time, goodbye. ", 0

; Array data
Max_size = 200
arrayN		DWORD	 Max_size	DUP(?)
count		DWORD	 200

; helps to see how many times things 
countArray	DWORD	 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
countR		DWORD	 ?

.code
mainp proc
					call		Randomize			; initiate the seed

					; the intro
					push		OFFSET intro1
					push		OFFSET intro2
					push		OFFSET intro3
					push		OFFSET intro4
					push		OFFSET intro5
					call		intro
					
					;filling the array up
					push		OFFSET arrayN			; 12
					push	    count  					; 8
					call		generateArray


					; display the unsorted array
					push		OFFSET spaceTwo 		; 20
					push		OFFSET arrayN			; 16
					push		count			        ; 12
					push		OFFSET des1				; 8
					call		displayArray

					; sorts the arrayN values in ascending order
					push		OFFSET arrayN			; 12
					push		count					; 8
					call		sortList


					; calculate and show the median value
					push		OFFSET des4				; 16
					push		OFFSET arrayN			; 12
					push		count					; 8
					call		displayMedian

						; display the sorted array
					push		OFFSET spaceTwo 		; 20
					push		OFFSET arrayN			; 16
					push		count			        ; 12
					push		OFFSET des2				; 8
					call		displayArray
						



					;;; there is something wrong with this code!! from here on
						; create the countList array	& display it
					push		OFFSET des3				; 28
					push		OFFSET countArray		; 24
					push		OFFSET spaceTwo			; 20
					push		OFFSET arrayN			; 16
					push		count					; 12
					push		countR					; 8
					call		countList

					

					
							; farewell message for user
					push		OFFSET gdbye			; 8
					call		farewell


					exit


mainp endp

intro proc
; Program intro and programmer, describes the program.
; Recieves: [ebp+24] = @intro1, [ebp+20] = @intro2, [ebp+16] = @intro3, [ebp+12] = @intro4, [ebp+8] = @intro5
; Returns: nada
; Preconditions: none
; Registers changes: None
					push		ebp
					mov			ebp, esp
					
					;intro5
					mov			edx, [ebp+24]
					call		WriteString
					call		crlf					

					;intro4
					mov			edx, [ebp+20]
					call		WriteString
					call		crlf

					;intro3
					mov			edx, [ebp +16]
					call		WriteString
					call		crlf

					;intro2
					mov			edx, [ebp+12]
					call		WriteString
					call		crlf

					;intro1
					mov			edx, [ebp+8]
					call		WriteString
					call		crlf


					pop			ebp
					ret			8
intro endp


generateArray proc
; Generates an array of size 200 and fills it with consecutive random values using irvines procedures Randomize and RandomRange.
; Recieves: addyArray, value of sizeArray, Randomize
; Returns: a randomized array of length 200
; Preconditions: Randomize and RandomRange must be called to make the array
; Register changed: ecx, edi, ebp, eax
					
					push		ebp
					mov			ebp, esp

					mov			edi, [ebp+12]		; addy of the array
					mov			ecx, [ebp + 8]		; set the loop counter to size of array
			

					fillLoop:
								mov		eax, HI
								sub		eax, LO
								inc		eax		; Range = HI - LO + 1
								call	RandomRange
								add		eax, LO
								mov		[edi], eax	; puts the random num in the array
								add		edi, 4		; move to next index 
								loop	fillLoop    ; loop 200 times
								
					pop			ebp
					ret			8

generateArray endp



displayArray proc
; This displays the unsorted array that I have just generated "randomly"
; Pre-conditions: the array_n must be filled
; Recieves: the array_n, count, length, descrip1
; Returns: Displays in row of 20 the random numbers
; Registers changed: ecx, esi, eax, edx, ebx


					push		ebp
					mov			ebp, esp
					mov			ebx, 0				; counting to 20 nums per line

					call		crlf
					mov			edx, [ebp+8]		; indirect addressing of the des1
					call		WriteString	
					call		crlf

					mov			esi, [ebp+16]		; addy of the array
					mov			ecx, [ebp + 12]		; loop counter

					displayLoop:
								mov		eax, [esi]	; place current element into eax
								call	WriteDec
								mov		edx, [ebp+20] ; printing the spaces
								call	WriteString
								inc		ebx
								cmp		ebx, len ; if count < 20 then continue adding values to the display row
								JL		skipCount
								call	crlf			; else start a  new line and begin counter again
								mov		ebx, 0
								
					skipCount:
								add		esi, 4		; next item in array
								loop	displayLoop
					pop			ebp
					ret			8
displayArray endp



sortList proc
; This procedure sorts the arrayN values in ascending order.
; Pre-conditions: array has to be filled with 200 values in the correct range
; Recieves: address of array 
; Returns: sorted values of arrayN
; Registers changed: eax, ecx, ebp, esi, edi


					push		ebp	
					mov			ebp, esp
					mov			edi, [ebp+12]		; the arrayN
					mov			ebx, [ebp+8]		; the count
			; remember to pop in opposite order		
					push		eax                        ; push AX onto the stack and same for other ones for later use  
					push		ebx	                        
					push		ecx
					push		edx
					push		edi	

					dec			ebx                
					mov			ecx, ebx             
					mov			eax, esi            
					outLoop:						
							mov		ebx, ecx
							mov		esi, eax
							mov		edi, eax
							mov		edx, [edi]		; set dl register to the current index value from array
							insideLoop:                
									inc		esi		; set the si = 1+si
									cmp		[esi], edx	
									JNG     jumpOver                  ; if current array value is smaller than the one we are comparing it to 
									mov		edi, esi		
									mov		edx, [edi]			      ; set the new number we will be comparing to the rest

					jumpOver:                     ; jump label

						dec		ebx                ; set BX=BX-1
						JNZ		insideLoop			

						mov		edx, [esi]
						xchg	edx, [edi]
						mov		[esi], edx
						loop	outLoop
					endSort:			
					; gotta pop in the opposite order of push!
						pop		edi
						pop		edx
						pop		ecx
						pop		ebx
						pop		eax

				RET                            

					
sortList endp


displayMedian proc
; This procedure is designed to calculate the median from the random ints arrayN.
; Pre-conditions: arrayN is full and is sorted in ascending order, the counter is set
; Recieves: arrayN, counter, des2
; Returns: the median, rounded to nearest int
; post-conditions: since the array its sorted, 
; I only need to go to the 100th place and 99th place add those two and divide by 2
; Registers changed: eax, ecx, esi, ebx
					push		ebp
					mov			ebp, esp
					call		crlf
					mov			edx, [ebp+16]			; passing by reference the des4
					call		WriteString

					mov			esi, [ebp+12]			; @ array
					;mov			eax, [ebp+8]			; @ counter

					mov			eax, [esi + 400]		; place the 100th term from the array in the eax register
					mov			ecx, [esi + 404]		; move the 99th term into ebx
					add			eax, ecx				; add and divide by two
					mov			edx, 0
					mov			ebx, 2
					div			ebx
					dec			eax
					call		WriteDec
					pop			ebp
					ret			8
								
displayMedian endp					

countList proc
; This procedure is designed to count how many times a value (10,..,29) appears.
; Pre-conditions: arrayN is filled and is sorted.
; Recieves: arrayN, count, and repeat = 0 at start
; Returns: an ArrayCount that has the amount of times each value repeats
; Registers changed: eax, ebx, ecx, esi, edi


					push		ebp
					mov			ebp, esp
					call		crlf
					mov			esi, [ebp+24]			; mov the countArray into the esi register
					mov			edx, [ebp+20]			; @ spaceTwo	I will use this when printing countR
					mov			edi, [ebp+16]		    ; @ arrayN
					mov			ecx, [ebp+12]			; counter
					
					mov			ebx, 0					; initialize countR at 0	
					mov			edx, [ebp+28]			; printing the description
					call		WriteString
					call		crlf
					countInts:	
								
								mov			eax, [edi]		; i term from arrayN into eax	
								cmp			eax, [esi]		; compare i to n from countArray
								JE			addCount
								; for the transitions between elements that aren't similar print it and start over
								; again
								cmp			eax, [esi]
								JNE			print

						continue:
								loop		countInts
								jmp			endit			; when the loops end go to the endit

						
						print:
						; when its no longer looping print it to test
								
								mov			eax, ebx
								call		WriteDec		; write the count value 
								mov			edx, [ebp+20]	; print the spaces
								call		WriteString	
								jmp			increaseESI		; increaseESI 

					addCount:
								inc			ebx				; every time there is a ten we increment
								add			edi, 4
								jmp			continue

					increaseESI:
								mov			ebx, 0			; restart count
								add			esi, 4			; next number
								jmp			countInts

					endit:
								

					pop			ebp
					ret			16
				
countList endp

farewell proc
; This program prints the goodbye message.
; Pre-conditions: None
; REcieves: gdbye
; returns: nada
; post-conditions: none

								push		ebp
								mov			ebp, esp

								call		crlf
								call		crlf
								mov			edx, [ebp+8]
								call		WriteString

								pop			ebp
								ret			4	

farewell endp
end main


; Citation:
; Casillas, M (2020) QuickSort source code (Version 1.0) [Source Code]. http://www.miguelcasillas.com/?p=354