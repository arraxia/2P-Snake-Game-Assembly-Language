.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode: DWORD
INCLUDE Irvine32.inc

.data

xWall BYTE 71 DUP("#"),0

strScore BYTE "P1 SCORE:",0
strScore2 BYTE "P2 SCORE:",0
score BYTE 0
score2 BYTE 0

strTryAgain BYTE "Try Again?  1 = Yes, 0 = No",0
invalidInput BYTE "Invalid Input",0
strTied BYTE "Tie!",0
strYouDied BYTE "Player 2 WINS!",0
strYouDied2 BYTE "Player 1 WINS!",0
strPoints1 BYTE " Points for P1",0
strPoints2 BYTE " Points for P2",0
blank BYTE "                                     ",0


snake BYTE "O", 104 DUP("o")
snake2 BYTE "O", 104 DUP("o")

xPos BYTE 45,44,43,42,41, 100 DUP(?)
yPos BYTE 11,11,11,11,11, 100 DUP(?)

xPos2 BYTE 45,44,43,42,41, 100 DUP(?)
yPos2 BYTE 17,17,17,17,17, 100 DUP(?)

xPosWall BYTE 24,24,95,95			;position of upperLeft, lowerLeft, upperRight, lowerRignt wall 
yPosWall BYTE 3,26,3,26

xCoinPos BYTE ?
yCoinPos BYTE ?

inputChar BYTE "+"					; + denotes the start of the game
lastInputChar BYTE "+"
lastInputChar2 BYTE "+"

strSpeed BYTE "Controls: (P1) WASD / (P2) IJKL     Difficulty (1 - Hard, 2 - Medium, 3 - Easy): ",0
speed	DWORD 0

.code
main PROC
	call DrawWall			;draw walls
	call DrawScoreboard		;draw scoreboard
	call ChooseSpeed		;let player to choose Speed

	mov esi,0
	mov ecx,5
drawSnake:
	call DrawPlayer			;draw snake(start with 5 units)
	call DrawPlayer2
	inc esi
loop drawSnake

	call Randomize
	call CreateRandomCoin
	call DrawCoin			;set up finish

	gameLoop::
		mov dl,106						;move cursor to coordinates
		mov dh,1
		call Gotoxy

		; get user key input
		call ReadKey
        jz noKey						;jump if no key is entered
		processInput:

		mov bl, inputChar

		cmp bl,"w"
		je lastkey
		cmp bl,"i"
		je lastkey2
		cmp bl,"s"
		je lastkey
		cmp bl,"k"
		je lastkey2
		cmp bl,"a"
		je lastkey
		cmp bl,"j"
		je lastkey2
		cmp bl,"d"
		je lastkey
		cmp bl,"l"
		je lastkey2

		mov inputChar,al
		jmp noKey

		lastkey:
		mov lastInputChar, bl
		mov inputChar,al
		jmp noKey
		
		lastkey2:
		mov lastInputChar2, bl
		mov inputChar,al
		jmp noKey

		noKey:
		cmp inputChar,"x"	
		je exitgame						;exit game if user input x

		cmp inputChar,"w"
		je checkTop
		cmp inputChar,"i"
		je checkTop2

		cmp inputChar,"s"
		je checkBottom
		cmp inputChar,"k"
		je checkBottom2

		cmp inputChar,"a"
		je checkLeft
		cmp inputChar,"j"
		je checkLeft2

		cmp inputChar,"d"
		je checkRight
		cmp inputChar,"l"
		je checkRight2

		jne gameLoop					; reloop if no meaningful key was entered


		; check whether can continue moving
		checkBottom:	
		cmp lastInputChar, "w"
		je dontChgDirection		;cant go down immediately after going up
		mov cl, yPosWall[1]
		dec cl					;one unit ubove the y-coordinate of the lower bound
		cmp yPos[0],cl
		jl moveDown
		je bottomWall
		jmp moveDown

		bottomWall:
		call PortalDown
		jmp moveDown

		checkBottom2:
		cmp lastInputChar2, "i"
		je dontChgDirection		;cant go down immediately after going up
		mov cl, yPosWall[1]
		dec cl					;one unit ubove the y-coordinate of the lower bound
		cmp yPos2[0],cl
		jl moveDown2
		je bottomWall2
		jmp moveDown2

		bottomWall2:
		call PortalDown2
		jmp moveDown2

		
		recheckBottom:	
		cmp lastInputChar, "w"
		je dontChgDirection		;cant go down immediately after going up
		mov cl, yPosWall[1]
		dec cl					;one unit ubove the y-coordinate of the lower bound
		cmp yPos[0],cl
		jl alive7
		je reBottomWall
		jmp alive7
		alive7:
		call reMoveDown

		reBottomWall:
		call PortalDown
		call reMoveDown

		recheckBottom2:
		cmp lastInputChar2, "i"
		je dontChgDirection		;cant go down immediately after going up
		mov cl, yPosWall[1]
		dec cl					;one unit ubove the y-coordinate of the lower bound
		cmp yPos2[0],cl
		jl alive8
		je reBottomWall2
		jmp alive8
		alive8:
		call reMoveDown2

		reBottomWall2:
		call PortalDown2
		call reMoveDown2


		checkLeft:		
		cmp lastInputChar, "+"	;check whether its the start of the game
		je dontGoLeft
		cmp lastInputChar, "d"
		je dontChgDirection
		mov cl, xPosWall[0]
		inc cl
		cmp xPos[0],cl
		jg moveLeft
		je leftWall					; check for left wall
		jmp moveLeft

		leftWall:
		call PortalXl
		jmp moveLeft

		
		checkLeft2:		
		cmp lastInputChar2, "+"	;check whether its the start of the game
		je dontGoLeft
		cmp lastInputChar2, "l"
		je dontChgDirection
		mov cl, xPosWall[0]
		inc cl
		cmp xPos2[0],cl
		jg moveLeft2
		je leftWall2
		jmp moveLeft2

		leftWall2:
		call PortalXl2
		jmp moveLeft2

		recheckLeft:		
		cmp lastInputChar, "+"	;check whether its the start of the game
		je dontGoLeft
		cmp lastInputChar, "d"
		je dontChgDirection
		mov cl, xPosWall[0]
		inc cl
		cmp xPos[0],cl
		jl alive5
		je releftWall
		alive5:
		call reMoveLeft
		releftWall:
		call PortalXl
		call reMoveLeft
		
		recheckLeft2:		
		cmp lastInputChar2, "+"	;check whether its the start of the game
		je dontGoLeft
		cmp lastInputChar2, "l"
		je dontChgDirection
		mov cl, xPosWall[0]
		inc cl
		cmp xPos2[0],cl
		jl alive6
		je releftWall2
		alive6:
		call reMoveLeft2
		releftWall2:
		call PortalXl2
		call reMoveLeft2

		checkRight:		
		cmp lastInputChar, "a"
		je dontChgDirection
		mov cl, xPosWall[2]
		dec cl
		cmp xPos[0],cl
		jl moveRight
		je rightWall				; check for right	wall
		jmp moveRight

		rightWall:
		call PortalXr
		jmp moveRight

		checkRight2:		
		cmp lastInputChar2, "j"
		je dontChgDirection
		mov cl, xPosWall[2]
		dec cl
		cmp xPos2[0],cl
		jl moveRight2
		je rightWall2
		jmp moveRight2

		rightWall2:
		call PortalXr2
		jmp moveRight2


		recheckRight:		
		cmp lastInputChar, "a"
		je dontChgDirection
		mov cl, xPosWall[2]
		dec cl
		cmp xPos[0],cl
		jl alive
		je rerightWall					; check for right	wall
		jmp alive
		alive:
		call reMoveRight

		rerightWall:
		call PortalXr
		call reMoveRight

		recheckRight2:		
		cmp lastInputChar2, "j"
		je dontChgDirection
		mov cl, xPosWall[2]
		dec cl
		cmp xPos2[0],cl
		jl alive2
		je rerightWall2
		jmp alive2
		alive2:
		call reMoveRight2

		rerightWall2:
		call PortalXr2
		call reMoveRight2


		checkTop:		
		cmp lastInputChar, "s"
		je dontChgDirection
		mov cl, yPosWall[0]
		inc cl
		cmp yPos,cl
		jg moveUp
		je upperWall				; check for upper wall
		jmp moveUp

		upperWall:
		call PortalUp
		jmp moveUp

		checkTop2:		
		cmp lastInputChar2, "k"
		je dontChgDirection
		mov cl, yPosWall[0]
		inc cl
		cmp yPos2,cl
		jg moveUp2
		je upperWall2
		jmp moveUp2

		upperWall2:
		call PortalUp2
		jmp moveUp2


		recheckTop:		
		cmp lastInputChar, "s"
		je dontChgDirection
		mov cl, yPosWall[0]
		inc cl
		cmp yPos,cl
		jl alive3
		je reUpperWall
		jmp alive3
		alive3:
		call reMoveUp

		reUpperWall:
		call PortalUp
		call reMoveUp

		recheckTop2:		
		cmp lastInputChar2, "k"
		je dontChgDirection
		mov cl, yPosWall[0]
		inc cl
		cmp yPos2,cl
		jl alive4
		je reUpperWall2
		jmp alive4
		alive4:
		call reMoveUp2

		reUpperWall2:
		call PortalUp2
		call reMoveUp2

		
		reMoveUp:		
		mov eax,4 (black * 16)
		call SetTextColor
		mov eax, speed		;slow down the moving
		add eax, speed
		mov esi, 0			;index 0(snake head)
		call UpdatePlayer	
		mov ah, yPos[esi]	
		mov al, xPos[esi]	;alah stores the pos of the snake's next unit 
		dec yPos[esi]		;move the head up
		call DrawPlayer		
		call DrawBody
		call checkCollision
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		
		ret

		reMoveUp2:		
		mov eax,1 (black * 16)
		call SetTextColor
		mov eax, speed		;slow down the moving
		add eax, speed
		mov esi, 0			;index 0(snake head)
		call UpdatePlayer2	
		mov ah, yPos2[esi]	
		mov al, xPos2[esi]	;alah stores the pos of the snake's next unit 
		dec yPos2[esi]		;move the head up
		call DrawPlayer2		
		call DrawBody2
		call checkCollision
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		
		ret

		moveUp:		
		mov eax,4 (black * 16)
		call SetTextColor
		mov eax, speed		;slow down the moving
		add eax, speed
		call delay
		mov esi, 0			;index 0(snake head)
		call UpdatePlayer	
		mov ah, yPos[esi]	
		mov al, xPos[esi]	;alah stores the pos of the snake's next unit 
		dec yPos[esi]		;move the head up
		call DrawPlayer		
		call DrawBody
		call checkCollision
		call iteratePlayerTwo
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		

		moveUp2:		
		mov eax,1 (black * 16)
		call SetTextColor
		mov eax, speed		;slow down the moving
		add eax, speed
		call delay
		mov esi, 0			;index 0(snake head)
		call UpdatePlayer2	
		mov ah, yPos2[esi]	
		mov al, xPos2[esi]	;alah stores the pos of the snake's next unit 
		dec yPos2[esi]		;move the head up
		call DrawPlayer2		
		call DrawBody2
		call checkCollision
		call iteratePlayerOne
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		

		
		reMoveDown:			;move down
		mov eax,4 (black * 16)
		call SetTextColor
		mov eax, speed
		add eax, speed
		mov esi, 0
		call UpdatePlayer
		mov ah, yPos[esi]
		mov al, xPos[esi]
		inc yPos[esi]
		call DrawPlayer
		call DrawBody
		call checkCollision
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		
		ret


		reMoveDown2:			;move down
		mov eax,1 (black * 16)
		call SetTextColor
		mov eax, speed
		add eax, speed
		mov esi, 0
		call UpdatePlayer2
		mov ah, yPos2[esi]
		mov al, xPos2[esi]
		inc yPos2[esi]
		call DrawPlayer2
		call DrawBody2
		call checkCollision
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		
		ret

		moveDown:			;move down
		mov eax,4 (black * 16)
		call SetTextColor
		mov eax, speed
		add eax, speed
		call delay
		mov esi, 0
		call UpdatePlayer
		mov ah, yPos[esi]
		mov al, xPos[esi]
		inc yPos[esi]
		call DrawPlayer
		call DrawBody
		call checkCollision
		call iteratePlayerTwo
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake

		


		moveDown2:			;move down
		mov eax,1 (black * 16)
		call SetTextColor
		mov eax, speed
		add eax, speed
		call delay
		mov esi, 0
		call UpdatePlayer2
		mov ah, yPos2[esi]
		mov al, xPos2[esi]
		inc yPos2[esi]
		call DrawPlayer2
		call DrawBody2
		call checkCollision
		call iteratePlayerOne
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		


		reMoveLeft:			;move left
		mov eax,4 (black * 16)
		call SetTextColor
		mov eax, speed
		mov esi, 0
		call UpdatePlayer
		mov ah, yPos[esi]
		mov al, xPos[esi]
		dec xPos[esi]
		call DrawPlayer
		call DrawBody
		call checkCollision
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		ret
		
		reMoveLeft2:			;move left
		mov eax,1 (black * 16)
		call SetTextColor
		mov eax, speed
		mov esi, 0
		call UpdatePlayer2
		mov ah, yPos2[esi]
		mov al, xPos2[esi]
		dec xPos2[esi]
		call DrawPlayer2
		call DrawBody2
		call checkCollision
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		ret
		
		moveLeft:			;move left
		mov eax,4 (black * 16)
		call SetTextColor
		mov eax, speed
		call delay
		mov esi, 0
		call UpdatePlayer
		mov ah, yPos[esi]
		mov al, xPos[esi]
		dec xPos[esi]
		call DrawPlayer
		call DrawBody
		call checkCollision
		call iteratePlayerTwo
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		
		
		moveLeft2:			;move left
		mov eax,1 (black * 16)
		call SetTextColor
		mov eax, speed
		call delay
		mov esi, 0
		call UpdatePlayer2
		mov ah, yPos2[esi]
		mov al, xPos2[esi]
		dec xPos2[esi]
		call DrawPlayer2
		call DrawBody2
		call checkCollision
		call iteratePlayerOne
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		


		moveRight:			;move right
		mov eax,4 (black * 16)
		call SetTextColor
		mov eax, speed
		call delay
		mov esi, 0
		call UpdatePlayer
		mov ah, yPos[esi]
		mov al, xPos[esi]
		inc xPos[esi]
		call DrawPlayer
		call DrawBody
		call checkCollision
		call iteratePlayerTwo
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		
		

		moveRight2:			;move right
		mov eax,1 (black * 16)
		call SetTextColor
		mov eax, speed
		call delay
		mov esi, 0
		call UpdatePlayer2
		mov ah, yPos2[esi]
		mov al, xPos2[esi]
		inc xPos2[esi]
		call DrawPlayer2
		call DrawBody2
		call checkCollision
		call iteratePlayerOne
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		
		


		reMoveRight:			;move right
		mov eax,4 (black * 16)
		call SetTextColor
		mov eax, speed
		mov esi, 0
		call UpdatePlayer
		mov ah, yPos[esi]
		mov al, xPos[esi]
		inc xPos[esi]
		call DrawPlayer
		call DrawBody
		call checkCollision
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		ret

		reMoveRight2:			;move right
		mov eax,1 (black * 16)
		call SetTextColor
		mov eax, speed
		mov esi, 0
		call UpdatePlayer2
		mov ah, yPos2[esi]
		mov al, xPos2[esi]
		inc xPos2[esi]
		call DrawPlayer2
		call DrawBody2
		call checkCollision
		mov eax,white (black * 16)
		call SetTextColor
		call CheckSnake
		ret

	; getting points
		checkcoin::
		mov esi,0
		mov bl,xPos[0]
		cmp bl,xCoinPos
		jne checkplayer2			
		mov bl,yPos[0]
		cmp bl,yCoinPos
		jne checkplayer2			
		call EatingCoin			;call to update score, append snake and generate new coin
		
		checkplayer2:
		mov esi,0
		mov bl,xPos2[0]
		cmp bl,xCoinPos
		jne gameloop			;reloop if snake is not intersecting with coin
		mov bl,yPos2[0]
		cmp bl,yCoinPos
		jne gameloop			;reloop if snake is not intersecting with coin
		call EatingCoin2

jmp gameLoop					;reiterate the gameloop

	PortalUp PROC
	mov al, yPos[0]
	mov bl, xPos[0]
	mov ah, yPosWall[1]
	sub ah,2
	mov yPos[0], ah
	inc yPos[0]
	mov dl, bl
	mov dh, al
	call Gotoxy
	mov al, " "
	call WriteChar
	ret
	PortalUp ENDP
	
	PortalUp2 PROC
	mov al, yPos2[0]
	mov bl, xPos2[0]
	mov ah, yPosWall[1]
	sub ah,2
	mov yPos2[0], ah
	inc yPos2[0]
	mov dl, bl
	mov dh, al
	call Gotoxy
	mov al, " "
	call WriteChar
	ret
	PortalUp2 ENDP

	PortalDown PROC
	mov al, yPos[0]
	mov bl, xPos[0]
	mov ah, yPosWall[2]
	mov yPos[0], ah
	inc yPos[0]
	mov dl, bl
	mov dh, al
	call Gotoxy
	mov al, " "
	call WriteChar
	ret
	PortalDown ENDP

	PortalDown2 PROC
	mov al, yPos2[0]
	mov bl, xPos2[0]
	mov ah, yPosWall[2]
	mov yPos2[0], ah
	inc yPos2[0]
	mov dl, bl
	mov dh, al
	call Gotoxy
	mov al, " "
	call WriteChar
	ret
	PortalDown2 ENDP

	PortalXr PROC
	mov al, xPos[0]
	mov bl, yPos[0]
	mov ah, xPosWall[0]
	mov xPos[0], ah
	inc xPos[0]
	mov dl, al
	mov dh, bl
	call Gotoxy
	mov al, " "
	call WriteChar
	inc dl
	call Gotoxy
	mov al, "#"
	mov eax,white (white * 16)
    call SetTextColor
	call WriteChar
	mov eax,white (black * 16)
    call SetTextColor
	ret
	PortalXr ENDP

	PortalXr2 PROC
	mov al, xPos2[0]
	mov bl, yPos2[0]
	mov ah, xPosWall[0]
	mov xPos2[0], ah
	inc xPos2[0]
	mov dl, al
	mov dh, bl
	mov al, " "
	call Gotoxy
	call WriteChar
	inc dl
	call Gotoxy
	mov al, "#"
	mov eax,white (white * 16)
    call SetTextColor
	call WriteChar
	mov eax,white (black * 16)
    call SetTextColor
	ret
	PortalXr2 ENDP

	PortalXl PROC
	mov al, xPos[0]
	mov bl, yPos[0]
	mov ah, xPosWall[2]
	sub ah, 2
	mov xPos[0], ah
	inc xPos[0]
	mov dl, al
	mov dh, bl
	call Gotoxy
	mov al, " "
	call WriteChar
	ret
	PortalXl ENDP

	PortalXl2 PROC
	mov al, xPos2[0]
	mov bl, yPos2[0]
	mov ah, xPosWall[2]
	sub ah, 2
	mov xPos2[0], ah
	inc xPos2[0]
	mov dl, al
	mov dh, bl
	call Gotoxy
	mov al, " "
	call WriteChar
	ret
	PortalXl2 ENDP

	checkCollision PROC
    ; Check Player 1's head against Player 2's body
    mov al, xPos[0]
    mov ah, yPos[0]
    
	checkxH:
	cmp al, xPos2[0]
	je checkyH
	jne checkBody

	checkyH:
	cmp ah, yPos2[0]
	je tieBreaker
	jne checkBody

	tieBreaker:
	mov bh, score2
	cmp score, bh
	jg p2died
	jl p1died
	je tie


	checkBody:
	mov esi, 1       ; Start from Player 2's second segment (index 1)
    mov ecx, 4
    add cl, score2

checkP1vsP2Body:
    cmp al, xPos2[esi]
    jne nextSegmentP1vsP2   ; x-coordinates don't match, move to next segment

    cmp ah, yPos2[esi]  ; x-coordinates match, check y-coordinates
    je p1died             ; Collision detected

nextSegmentP1vsP2:
    inc esi
    loop checkP1vsP2Body


    ; Check Player 2's head against Player 1's body (similar logic) ;PLAYER 2 LOSS
    mov al, xPos2[0]
    mov ah, yPos2[0]
    mov esi, 1
    mov ecx, 4
    add cl, score

checkP2vsP1Body:
    cmp al, xPos[esi]
    jne nextSegmentP2vsP1

    cmp ah, yPos[esi]
    je p2died

nextSegmentP2vsP1:
    inc esi
    loop checkP2vsP1Body

    ret                  ; No collision detected
checkCollision ENDP

	iteratePlayerOne:
	cmp lastinputChar,"w"
	je recheckTop
	
	cmp lastinputChar,"s"
	je recheckBottom
	
	cmp lastInputChar,"a"
	je recheckLeft
	
	cmp lastInputChar,"d"
	je recheckRight
	ret

	iteratePlayerTwo:
	cmp lastInputChar2,"i"
	je recheckTop2

	cmp lastInputChar2,"k"
	je recheckBottom2

	cmp lastInputChar2,"j"
	je recheckLeft2

	cmp lastInputChar2,"l"
	je recheckRight2
	ret


	dontChgDirection:		;dont allow user to change direction
	mov inputChar, bl		;set current inputChar as previous
	jmp noKey				;jump back to continue moving the same direction 

	dontGoLeft:				;forbids the snake to go left at the begining of the game
	mov	inputChar, "+"		;set current inputChar as "+"
	jmp gameLoop			;restart the game loop

	p1died::
	mov eax,white (black * 16)
	call SetTextColor
	call P1Game

	p2died::
	mov eax,white (black * 16)
	call SetTextColor
	call P2Game

	tie::
	mov eax,white (black * 16)
	call SetTextColor
	call Tied
	 
	playagn::			
	call ReinitializeGame			;reinitialise everything
	
	exitgame::
	exit
INVOKE ExitProcess,0
main ENDP


DrawWall PROC                    ;procedure to draw wall
    mov dl,xPosWall[0]
    mov dh,yPosWall[0]
    mov eax,white (white * 16)
    call SetTextColor
    call Gotoxy
    mov edx,OFFSET xWall
    call WriteString            ;draw upper wall

    mov dl,xPosWall[1]
    mov dh,yPosWall[1]
    call Gotoxy
    mov edx,OFFSET xWall
    call WriteString            ;draw lower wall

    mov dl, xPosWall[2]
    mov dh, yPosWall[2]
    mov eax,white (white * 16)
    call SetTextColor
    mov eax,"#"
    inc yPosWall[3]
    L11: 
    call Gotoxy
    call WriteChar
    inc dh
    cmp dh, yPosWall[3]            ;draw right wall
    jl L11

    mov dl, xPosWall[0]
    mov dh, yPosWall[0]
    mov eax,"#"
    L12: 
    call Gotoxy
    call WriteChar
    inc dh
    cmp dh, yPosWall[3]            ;draw left wall
    jl L12
    ret
DrawWall ENDP



DrawScoreboard PROC                ;procedure to draw scoreboard
    mov dl,10                    ;player 1 scoreboard
    mov dh,14
    call Gotoxy
    mov eax,4 (black * 16)
    call SetTextColor
    mov edx,OFFSET strScore        ;print string that indicates score
    call WriteString
    mov dl,20
    mov dh,14
    call Gotoxy
    mov eax,15 (0 * 16)
    call SetTextColor
	mov eax, "0"
    call WriteChar

    mov dl,99                    ;player 1 scoreboard
    mov dh,14
    call Gotoxy
    mov eax,1 (0 * 16)
    call SetTextColor
    mov edx,OFFSET strScore2        ;print string that indicates score
    call WriteString
    mov dl,109
    mov dh,14
    call Gotoxy
    mov eax,15 (0 * 16)
    call SetTextColor
	mov eax, "0"
    call WriteChar
    
    ret
DrawScoreboard ENDP

ChooseSpeed PROC			;procedure for player to choose speed
	mov edx,0
	mov dl,20				
	mov dh,1
	call Gotoxy	
	mov eax,5 (black * 16)
    call SetTextColor
	mov edx,OFFSET strSpeed	; prompt to enter integers (1,2,3)
	call WriteString
	mov esi, 40				; milisecond difference per speed level
	mov eax,0
	call readInt			
	cmp ax,1				;input validation
	jl invalidspeed
	cmp ax, 3
	jg invalidspeed
	mul esi	
	mov speed, eax			;assign speed variable in mililiseconds
	ret

	invalidspeed:			;jump here if user entered an invalid number
	mov dl,105				
	mov dh,1
	call Gotoxy	
	mov edx, OFFSET invalidInput		;print error message		
	call WriteString
	mov ax, 1500
	call delay
	mov dl,105				
	mov dh,1
	call Gotoxy	
	mov edx, OFFSET blank				;erase error message after 1.5 secs of delay
	call writeString
	mov eax,white (black * 16)
    call SetTextColor
	call ChooseSpeed					;call procedure for user to choose again
	ret
ChooseSpeed ENDP

DrawPlayer PROC			; draw player at (xPos,yPos)
	mov dl,xPos[esi]
	mov dh,yPos[esi]
	call Gotoxy
	mov dl, al			;temporarily save al in dl
	mov al, snake[esi]		
	call WriteChar
	mov al, dl
	ret
DrawPlayer ENDP

DrawPlayer2 PROC			; draw player at (xPos,yPos)
	mov dl,xPos2[esi]
	mov dh,yPos2[esi]
	call Gotoxy
	mov dl, al			;temporarily save al in dl
	mov al, snake2[esi]		
	call WriteChar
	mov al, dl
	ret
DrawPlayer2 ENDP

DrawBody PROC				;procedure to print body of the snake
		mov ecx, 4
		add cl, score		;number of iterations to print the snake body n tail	
		printbodyloop:	
		inc esi				;loop to print remaining units of snake
		call UpdatePlayer
		mov dl, xPos[esi]
		mov dh, yPos[esi]	;dldh temporarily stores the current pos of the unit 
		mov yPos[esi], ah
		mov xPos[esi], al	;assign new position to the unit
		mov al, dl
		mov ah,dh			;move the current position back into alah
		call DrawPlayer
		cmp esi, ecx
		jl printbodyloop
	ret
DrawBody ENDP

DrawBody2 PROC
		mov ecx, 4
		add cl, score2		;number of iterations to print the snake body n tail	
		printbodyloop2:	
		inc esi				;loop to print remaining units of snake
		call UpdatePlayer2
		mov dl, xPos2[esi]
		mov dh, yPos2[esi]	;dldh temporarily stores the current pos of the unit 
		mov yPos2[esi], ah
		mov xPos2[esi], al	;assign new position to the unit
		mov al, dl
		mov ah,dh			;move the current position back into alah
		call DrawPlayer2
		cmp esi, ecx
		jl printbodyloop2
	ret
DrawBody2 ENDP

UpdatePlayer PROC		; erase player at (xPos,yPos)
	mov dl, xPos[esi]
	mov dh,yPos[esi]
	call Gotoxy
	mov dl, al			;temporarily save al in dl
	mov al, " "
	call WriteChar
	mov al, dl
	ret
UpdatePlayer ENDP

UpdatePlayer2 PROC		; erase player at (xPos,yPos)
	mov dl, xPos2[esi]
	mov dh, yPos2[esi]
	call Gotoxy
	mov dl, al			;temporarily save al in dl
	mov al, " "
	call WriteChar
	mov al, dl
	ret
UpdatePlayer2 ENDP

DrawCoin PROC						;procedure to draw coin
	mov eax,yellow (yellow * 16)
	call SetTextColor				;set color to yellow for coin
	mov dl,xCoinPos
	mov dh,yCoinPos
	call Gotoxy
	mov al,"X"
	call WriteChar
	mov eax,white (black * 16)		;reset color to black and white
	call SetTextColor
	ret
DrawCoin ENDP

CreateRandomCoin PROC				;procedure to create a random coin
	generateCoin:
		mov eax,49
		call RandomRange	;0-49
		add eax, 35			;35-84
		mov xCoinPos,al
		mov eax,17
		call RandomRange	;0-17
		add eax, 6			;6-23
		mov yCoinPos,al

		; Check for collision with Player 1
		mov ecx, 5
		add cl, score				;loop number of snake unit
		mov esi, 0
	checkCoinXPosP1:
		movzx eax,  xCoinPos
		cmp al, xPos[esi]		
		je checkCoinYPosP1			;jump if xPos of snake at esi = xPos of coin
	continueloopP1:
		inc esi
		loop checkCoinXPosP1
		jmp checkPlayer2			; Jump to check Player 2 if no collision with Player 1

	checkCoinYPosP1:
		movzx eax, yCoinPos			
		cmp al, yPos[esi]
		jne continueloopP1		; jump back to continue loop if yPos of snake at esi != yPos of coin
		jmp generateCoin		; coin generated on snake 1, generate a new coin


	checkPlayer2:
		; Check for collision with Player 2
		mov ecx, 5
		add cl, score2		
		mov esi, 0
	checkCoinXPosP2:
		movzx eax, xCoinPos
		cmp al, xPos2[esi]
		je checkCoinYPosP2
	continueloopP2:
		inc esi
		loop checkCoinXPosP2
		ret							; return when coin is not on either snake

	checkCoinYPosP2:
		movzx eax, yCoinPos
		cmp al, yPos2[esi]
		jne continueloopP2
		jmp generateCoin        ; Coin generated on snake 2, generate a new coin
CreateRandomCoin ENDP

CheckSnake PROC				;check whether the snake head collides w its body 
	mov al, xPos[0] 
	mov ah, yPos[0] 
	mov esi,4				;start checking from index 4(5th unit)
	mov ecx,1
	add cl,score
checkXposition:
	cmp xPos[esi], al		;check if xpos same ornot
	je XposSame
	contloop:
	inc esi
loop checkXposition
	jmp p2check
	XposSame:				; if xpos same, check for ypos
	cmp yPos[esi], ah
	je p1died					;if collides, snake dies
	jmp contloop

	p2check:

	mov al, xPos2[0] 
	mov ah, yPos2[0] 
	mov esi,4				;start checking from index 4(5th unit)
	mov ecx,1
	add cl,score2
checkXposition2:
	cmp xPos2[esi], al		;check if xpos same ornot
	je XposSame2
	contloop2:
	inc esi
loop checkXposition2
	jmp checkcoin
	XposSame2:				; if xpos same, check for ypos
	cmp yPos2[esi], ah
	je p2died					;if collides, snake dies
	jmp contloop2

CheckSnake ENDP




EatingCoin PROC
	; snake is eating coin
	inc score
	mov ebx,4
	add bl, score
	mov esi, ebx
	mov ah, yPos[esi-1]
	mov al, xPos[esi-1]	
	mov xPos[esi], al		;add one unit to the snake
	mov yPos[esi], ah		;pos of new tail = pos of old tail

	cmp xPos[esi-2], al		;check if the old tail and the unit before is on the yAxis
	jne checky				;jump if not on the yAxis

	cmp yPos[esi-2], ah		;check if the new tail should be above or below of the old tail 
	jl incy			
	jg decy
	incy:					;inc if below
	inc yPos[esi]
	jmp continue
	decy:					;dec if above
	dec yPos[esi]
	jmp continue

	checky:					;old tail and the unit before is on the xAxis
	cmp yPos[esi-2], ah		;check if the new tail should be right or left of the old tail
	jl incx
	jg decx
	incx:					;inc if right
	inc xPos[esi]			
	jmp continue
	decx:					;dec if left
	dec xPos[esi]

	continue:				;add snake tail and update new coin
	mov eax,red (black * 16)
	call SetTextColor
	call DrawPlayer		
	mov eax,white (black * 16)
	call SetTextColor
	call CreateRandomCoin
	call DrawCoin			

	mov dl,19				; write updated score
	mov dh,14
	call Gotoxy
	mov al,score
	call WriteInt
	mov dl,19				; remove the +
	mov dh,14
	call Gotoxy
	mov al, " "
	call WriteChar
	ret
EatingCoin ENDP

EatingCoin2 PROC
	; snake 2 is eating coin
	inc score2
	mov ebx,4
	add bl, score2
	mov esi, ebx
	mov ah, yPos2[esi-1]
	mov al, xPos2[esi-1]	
	mov xPos2[esi], al		;add one unit to the snake
	mov yPos2[esi], ah		;pos of new tail = pos of old tail

	cmp xPos2[esi-2], al		;check if the old tail and the unit before is on the yAxis
	jne checky2				;jump if not on the yAxis

	cmp yPos2[esi-2], ah		;check if the new tail should be above or below of the old tail 
	jl incy2			
	jg decy2
	incy2:					;inc if below
	inc yPos2[esi]
	jmp continue2
	decy2:					;dec if above
	dec yPos2[esi]
	jmp continue2

	checky2:					;old tail and the unit before is on the xAxis
	cmp yPos2[esi-2], ah		;check if the new tail should be right or left of the old tail
	jl incx2
	jg decx2
	incx2:					;inc if right
	inc xPos2[esi]			
	jmp continue2
	decx2:					;dec if left
	dec xPos2[esi]

	continue2:				;add snake tail and update new coin
	mov eax,blue (black * 16)
	call SetTextColor
	call DrawPlayer2
	mov eax,white (black * 16)
	call SetTextColor
	call CreateRandomCoin
	call DrawCoin			

	mov dl,108				; write updated score
	mov dh,14
	call Gotoxy
	mov al,score2
	call WriteInt
	mov dl,108				; remove the +
	mov dh,14
	call Gotoxy
	mov al, " "
	call WriteChar
	ret
EatingCoin2 ENDP

Tied PROC
	mov eax,5 (black * 16)
	call SetTextColor
	mov eax, 1000
	call delay
	Call ClrScr	
	
	mov dl,	59
	mov dh, 11
	call Gotoxy
	mov edx, OFFSET strTied	;"you died"
	call WriteString

	mov dl,	53
	mov dh, 14
	call Gotoxy
	movzx eax, score
	call WriteInt
	mov edx, OFFSET strPoints1	;display p1 score
	call WriteString

	mov dl,	53
	mov dh, 15
	call Gotoxy
	movzx eax, score2
	call WriteInt
	mov edx, OFFSET strPoints2	;display p1 score
	call WriteString

	mov dl,	48
	mov dh, 18
	call Gotoxy
	mov edx, OFFSET strTryAgain
	call WriteString		;"try again?"

	retry:
	mov dh, 19
	mov dl,	56
	call Gotoxy
	call ReadInt			;get user input
	cmp al, 1
	je playagn				;playagn
	cmp al, 0
	je exitgame				;exitgame

	mov dh,	17
	call Gotoxy
	mov edx, OFFSET invalidInput	;"Invalid input"
	call WriteString		
	mov dl,	56
	mov dh, 19
	call Gotoxy
	mov edx, OFFSET blank			;erase previous input
	call WriteString
	mov eax,white (black * 16)
	call SetTextColor
	jmp retry						;let user input again
Tied ENDP


P1Game PROC
	mov eax,blue (black * 16)
	call SetTextColor
	mov eax, 1000
	call delay
	Call ClrScr	
	
	mov dl,	54
	mov dh, 11
	call Gotoxy
	mov edx, OFFSET strYouDied	;"you died"
	call WriteString

	mov dl,	53
	mov dh, 14
	call Gotoxy
	movzx eax, score
	call WriteInt
	mov edx, OFFSET strPoints1	;display p1 score
	call WriteString

	mov dl,	53
	mov dh, 15
	call Gotoxy
	movzx eax, score2
	call WriteInt
	mov edx, OFFSET strPoints2	;display p1 score
	call WriteString

	mov dl,	48
	mov dh, 18
	call Gotoxy
	mov edx, OFFSET strTryAgain
	call WriteString		;"try again?"

	retry:
	mov dh, 19
	mov dl,	56
	call Gotoxy
	call ReadInt			;get user input
	cmp al, 1
	je playagn				;playagn
	cmp al, 0
	je exitgame				;exitgame

	mov dh,	17
	call Gotoxy
	mov edx, OFFSET invalidInput	;"Invalid input"
	call WriteString		
	mov dl,	56
	mov dh, 19
	call Gotoxy
	mov edx, OFFSET blank			;erase previous input
	call WriteString
	mov eax,white (black * 16)
	call SetTextColor
	jmp retry						;let user input again
P1Game ENDP

P2Game PROC
	mov eax,red (black * 16)
	call SetTextColor
	mov eax, 1000
	call delay
	Call ClrScr	
	
	mov dl,	54
	mov dh, 11
	call Gotoxy
	mov edx, OFFSET strYouDied2	;"you died"
	call WriteString

	mov dl,	53
	mov dh, 14
	call Gotoxy
	movzx eax, score
	call WriteInt
	mov edx, OFFSET strPoints1	;display p1 score
	call WriteString

	mov dl,	53
	mov dh, 15
	call Gotoxy
	movzx eax, score2
	call WriteInt
	mov edx, OFFSET strPoints2	;display p1 score
	call WriteString

	mov dl,	48
	mov dh, 18
	call Gotoxy
	mov edx, OFFSET strTryAgain
	call WriteString		;"try again?"

	retry:
	mov dh, 19
	mov dl,	56
	call Gotoxy
	call ReadInt			;get user input
	cmp al, 1
	je playagn				;playagn
	cmp al, 0
	je exitgame				;exitgame

	mov dh,	17
	call Gotoxy
	mov edx, OFFSET invalidInput	;"Invalid input"
	call WriteString		
	mov dl,	56
	mov dh, 19
	call Gotoxy
	mov edx, OFFSET blank			;erase previous input
	call WriteString
	mov eax,white (black * 16)
	call SetTextColor
	jmp retry						;let user input again
P2Game ENDP

ReinitializeGame PROC		;procedure to reinitialize everything
	; reset player 1
	mov xPos[0], 45
	mov xPos[1], 44
	mov xPos[2], 43
	mov xPos[3], 42
	mov xPos[4], 41
	mov yPos[0], 11
	mov yPos[1], 11
	mov yPos[2], 11
	mov yPos[3], 11
	mov yPos[4], 11			;reinitialize snake position
	mov score,0				;reinitialize score

	 ; Reset Player 2
    mov xPos2[0], 45
    mov xPos2[1], 44
    mov xPos2[2], 43
    mov xPos2[3], 42
    mov xPos2[4], 41
    mov yPos2[0], 17
    mov yPos2[1], 17
    mov yPos2[2], 17
    mov yPos2[3], 17
    mov yPos2[4], 17
    mov score2, 0

	mov lastInputChar, "+"
	mov lastInputChar2, "+"
	mov	inputChar, "+"			;reinitialize inputChar and lastInputChar
	dec yPosWall[3]			;reset wall position
	Call ClrScr
	jmp main				;start over the game
ReinitializeGame ENDP
END main
