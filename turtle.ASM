	org		0x100				; MS-DOS program
	
	jmp		start

	include	"screen.asm"
	include "string.asm"
	include "keyboard.asm"
	
	cursor.xPos	equ dl
	cursor.yPos	equ dh
	start.xPos	equ 20
	start.yPos	equ 12
	promptColor	equ 0x1F		; white on blue text
	fieldColor	equ 0x2F		; white on green text

; ==============================
; === ENTRY POINT ==============
; ==============================

start:
	.getScreenInfo:
		screen.getMode
		mov		di, data_state.screenMode
		mov		[di], al			; preserve screen mode
	
	.setScreenMode:
		mov		al, screen.mode.text.4025
		screen.setMode				; set screen to 40x25 text, 16 colors
	
createScreen:
	.fillGreen:
		mov		cx, 23				; number of rows to fill
		mov		bh, 0				; first page
		xor		dx, dx				; position at 0, 0
		mov		al, 0				; null character
		
	.fillGreen.nextLine:
		screen.text.setCursorPosition
		push 	cx
		mov		cx, 40				; characters to write
		mov		bl, fieldColor
		screen.text.setCharacter
		inc		dh					; next row
		pop		cx
		loop	.fillGreen.nextLine
		
	.fillPrompt:
		mov		cx, 2				; number of rows to fill
		mov		cursor.xPos, 0		; position at 0, 23
		mov		cursor.yPos, 23
		
	.fillPrompt.nextLine:
		screen.text.setCursorPosition
		push	cx
		mov		cx, 40				; characters to write
		mov		bl, promptColor
		screen.text.setCharacter
		inc		dh					; next row
		pop		cx
		loop	.fillPrompt.nextLine
		
	.createTurtle:
		mov		cursor.xPos, start.xPos
		mov		cursor.yPos, start.yPos
		screen.text.setCursorPosition
		mov		al, [data_turtle.face]
		string.putChar
	
	call	showHelp
	call	showPrompt

; ==============================
; === MAIN PROGRAM LOOP ========
; ==============================

main:
	; get command string from keyboard
	; ==============================
	mov		al, 8				; 23 max characters
	mov		ah, 1				; echo enabled
	mov		di, data_str.buffer	; pointer to string buffer
	call	keyboard.inputString
	
	; interpret string and perform the command
	; ==============================
	.checkInput:
		mov		si, data_str.buffer
		mov		di, data_command.up
		call	string.match		; == "up"
		jnc		@f					; no match? check the next command
		call	handler.goUp
		jmp		.checkInput.end
		
		@@:
		mov		di, data_command.down
		call	string.match		; == "down"
		jnc		@f					; no match? check the next command
		call	handler.goDown
		jmp		.checkInput.end
		
		@@:
		mov		di, data_command.left
		call	string.match		; == "left"
		jnc		@f					; no match? check the next command
		call	handler.goLeft
		jmp		.checkInput.end
		
		@@:
		mov		di, data_command.right
		call	string.match		; == "right"
		jnc		@f					; no match? check the next command
		call	handler.goRight
		jmp		.checkInput.end
		
		@@:
		mov		di, data_command.paint
		call	string.match		; == "paint"
		jnc		@f					; no match? check the next command
		call	handler.paint
		jmp		.checkInput.end
		
		@@:
		mov		di, data_command.exit
		call	string.match		; == "exit"
		jnc		@f					; no match? check the next command
		jmp		exit
		
		@@:
		call	showHelp
		
		.checkInput.end:
	
	call	showPrompt
	
	jmp		main

; ==============================
; === PROGRAM FUNCTION SECTION =
; ==============================
	
handler:
	.goUp:
		; TODO
		ret
	.goDown:
		; TODO
		ret
	.goLeft:
		; TODO
		ret
	.goRight:
		; TODO
		ret
	.paint:
		; TODO
		ret

exit:
	.restoreScreen:
		mov		di, data_state.screenMode
		mov		al, byte [di]
		screen.setMode
	
	.return:
		mov		ax, 0x4C00
		int		0x21

; ==============================
; === PROCEDURE SECTION ========
; ==============================

showHelp:
pusha

	mov		cursor.xPos, 0		; position at 0, 23
	mov		cursor.yPos, 23
	
	screen.text.setCursorPosition
	mov		si, data_str.help	; show help message
	call	string.teletype
	
popa
ret
	
showPrompt:
pusha

	mov		bh, 0				; position at 0, 24
	mov		cursor.xPos, 0
	mov		cursor.yPos, 24
	screen.text.setCursorPosition
	mov		al, ' '
	mov		bl, promptColor
	mov		cx, 40
	screen.text.setCharacter	; clear prompt line
	
	mov		cursor.xPos, 0		; position at 0, 24
	mov		cursor.yPos, 24
	screen.text.setCursorPosition
	mov		al, '>'
	string.putChar				; display carat
	
popa
ret

; ==============================
; === DATA SECTION =============
; ==============================

data_state:
	.screenMode:
		db		?

data_turtle:
	.xPos:
		db		?
	.yPos:
		db		?
	.face:
		db		0x02				; filled smiley face

data_command:
	.up:
		db		"up", 0
	.down:
		db		"down", 0
	.left:
		db		"left", 0
	.right:
		db		"right", 0
	.paint:
		db		"paint", 0
	.help:
		db		"help", 0
	.exit:
		db		"exit", 0

data_str:
	.help:
		db		"up, down, left, right, paint, help, exit", 0
	.paintOn:
		db		"Paint toggled on", 0
	.paintOff:
		db		"Paint toggled off", 0
	.bump:
		db		"Bump! Hit a wall", 0

	.newLine:
		db		0x0D, 0x0A, 0
	.buffer:
		db		10 dup (0)