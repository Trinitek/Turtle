	org		0x100				; MS-DOS program
	
	jmp		main

	include	"screen.asm"
	include "string.asm"
	include "keyboard.asm"
	
	cursor.xPos	equ dl
	cursor.yPos	equ dh
	start.xPos	equ 20
	start.yPos	equ 12

main:
	.getScreenInfo:
		screen.getMode
		mov		di, data_state.screenMode
		mov		[di], al			; preserve screen mode
	
	.setScreenMode:
		mov		al, screen.mode.text.4025
		screen.setMode				; set screen to 40x25 text, 16 colors

paintScreen:
	.fillGreen:
		mov		cx, 23				; number of rows to fill
		mov		bh, 0				; first page
		xor		dx, dx				; position at 0, 0
		mov		al, 0				; null character
		
	.fillGreen.nextLine:
		screen.text.setCursorPosition
		push 	cx
		mov		cx, 40				; characters to write
		mov		bl, 0x2F			; white on green text
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
		mov		bl, 0x1F			; white on blue text
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
		
		
	.showHelp:
		mov		cursor.xPos, 0		; position at 0, 23
		mov		cursor.yPos, 23
		
		screen.text.setCursorPosition
		mov		si, data_str.help	; show help message
		call	string.teletype
		
	.showPrompt:
		mov		cursor.xPos, 0		; position at 0, 24
		mov		cursor.yPos, 24
		screen.text.setCursorPosition
		mov		al, '>'
		string.putChar
	
	.waitForInput:
		call	keyboard.waitForKey
	

exit:
	.restoreScreen:
		mov		di, data_state.screenMode
		mov		al, byte [di]
		screen.setMode
	
	.return:
		mov		ax, 0x4C00
		int		0x21

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
		db		38 dup (0)