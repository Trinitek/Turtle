	; Screen library
	; NAMESPACE: "screen"
	screen:
	ret

; ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
; ### MACRO: "setCursorPosition"
	;
	; param:
	;	bh = page number
	;		0-3 in modes 2, 3
	;		0-7 in modes 0, 1
	;		0 in graphics modes
	;	dh = row
	;	dl = column
	; destroyed:
	;	ah
macro screen.setCursorPosition
{
	mov		ah, 0x02			; 0x10 - set cursor position
	int		0x10
}


; ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
; ### MACRO: "getCursorPosition"
	;
	; param:
	;	bh = page number
	;		0-3 in modes 2, 3
	;		0-7 in modes 0, 1
	;		0 in graphics modes
	; return:
	;	ax = 0x0000 (Phoenix BIOS)
	;	dh = row
	;	dl = column
	; destroyed:
	;	ah
macro screen.getCursorPosition
{
	mov		ah, 0x03			; 0x10 - get cursor position
	push	cx					; discard cursor shape data
	int		0x10
	pop		cx
}


; ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
; ### MACRO: "setCharacter"
	;
	; param:
	;	al = character to display
	;	bh = page number
	;		0-3 in modes 2, 3
	;		0-7 in modes 0, 1
	;		0 in graphics modes
	;	bl = attribute data
	;	cx = number of times to write character
	; destroyed:
	;	ah
macro screen.setCharacter
{
	mov		ah, 0x09			; 0x10 - set cursor position
	int		0x10
}


; ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
; ### MACRO: "getCharacter"
	;
	; param:
	;	bh = page number
	;		0-3 in modes 2, 3
	;		0-7 in modes 0, 1
	;		0 in graphics modes
	; return:
	;	ah = character attribute
	;	al = character code
	; destroyed:
	;	ah
macro screen.getCharacter
{
	mov		ah, 0x08			; 0x10 - set cursor position
	int		0x10
}