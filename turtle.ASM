	org		0x100					; MS-DOS program

main:
	mov		si, stringData.hello
	call	string.teletype


; ###
; ### Convert numbers into strings
.numbersToStrings:
	mov		di, stringData.strEmpty
	mov		ax, 65535
	call	string.numberToString
	mov		si, di
	call	string.teletype
	
	mov		si, stringData.strOctothorpe
	call	string.teletype

exit:
	mov		ax, 0x4C00
	int		0x21


stringData:
.hello:
	db		"Hello world!", 0x0D, 0x0A, 0
.str1:
	db		"This is a string", 0
.str2:
	db		"This is a string", 0
.str3:
	db		"This is another string!", 0
.noMatch:
	db		"String doesn't match.", 0x0D, 0x0A, 0
.match:
	db		"String matches!", 0x0D, 0x0A, 0
.length16:
	db		"Length is 16 characters", 0x0D, 0x0A, 0
.length23:
	db		"Length is 23 characters", 0x0D, 0x0A, 0
	
.strOctothorpe:
	db		"#", 0
.strNewLine:
	db		0x0D, 0x0A, 0
.strEmpty:
	db		64 dup (0)


include		"string.asm"