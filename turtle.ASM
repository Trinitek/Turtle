	org		0x100				; MS-DOS program
	
	jmp		main

	include	"screen.asm"
	include "string.asm"

main:
	mov		bh, 0				; page 0
	mov		dl, 2				; X axis
	mov		dh, 2				; Y axis
	screen.setCursorPosition	; move cursor
	
	screen.getCursorPosition	; get cursor position
	mov		al, dl				; Xpos to string
	mov		ah, 0
	mov		di, data_str.empty
	call	string.numberToString
	
	mov		si, data_str.x		; X= prompt
	call	string.teletype
	
	mov		si, di				; Xpos string
	call	string.teletype
	
	mov		al, dh				; Ypos to string
	call	string.numberToString
	
	mov		al, ' '				; put space
	string.putChar
	mov		si, data_str.y		; Y= prompt
	call	string.teletype
	
	mov		si, di				; Ypos string
	call	string.teletype

exit:
	mov		ax, 0x4C00
	int		0x21
	

data_str:
.hello:
	db		"Hello world!", 0x0D, 0x0A, 0
	
.x:
	db		"x=", 0
.y:
	db		"y=", 0

.newLine:
	db		0x0D, 0x0A, 0
.space:
	db		" ", 0
.empty:
	db		64 dup (0)