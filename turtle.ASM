	org		0x100				; MS-DOS program
	
	jmp		main

	include	"string.asm"
	include	"keyboard.asm"

main:
	mov		si, stringData.hello
	call	string.teletype
	
	mov		si, stringData.inputPrompt
	call	string.teletype
	
	mov		al, 12				; string length
	mov		ah, 1				; enable echo
	mov		di, stringData.strEmpty
	call	keyboard.inputString
	
	mov		si, stringData.strNewLine
	call	string.teletype
	
	mov		si, stringData.outputPrompt
	call	string.teletype
	
	mov		si, di
	call	string.teletype
	
	jmp		exit


exit:
	mov		ax, 0x4C00
	int		0x21
	

stringData:
.hello:
	db		"Hello world!", 0x0D, 0x0A, 0
	
.bios:
	db		"BIOS=", 0
.ascii:
	db		"ASCII=", 0
	
.inputPrompt:
	db		"Input: ", 0
.outputPrompt:
	db		"Output: ", 0
	
.strOctothorpe:
	db		"#", 0
.strNewLine:
	db		0x0D, 0x0A, 0
.strSpace:
	db		" ", 0
.strEmpty:
	db		64 dup (0)