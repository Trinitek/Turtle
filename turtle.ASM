	org		0x100					; MS-DOS program
	
	jmp		main

	include	"string.asm"
	include	"keyboard.asm"

main:
	mov		si, stringData.hello
	call	string.teletype


; ###
; ### Get keyboard code and display the code to the screen
.getKeyboardCode:
	keyboard.getKey
	cmp		al, 0
	jz		.getKeyboardCode
	mov		al, ah
	mov		ah, 0
	
	mov		di, stringData.strEmpty
	call	string.numberToString
	mov		si, di
	call	string.teletype
	
	mov		si, stringData.strSpace
	call	string.teletype
	jmp		.getKeyboardCode
	

exit:
	mov		ax, 0x4C00
	int		0x21
	

stringData:
.hello:
	db		"Hello world!", 0x0D, 0x0A, 0
	
.strOctothorpe:
	db		"#", 0
.strNewLine:
	db		0x0D, 0x0A, 0
.strSpace:
	db		" ", 0
.strEmpty:
	db		64 dup (0)