	org		0x100					; MS-DOS program

main:
	mov		si, stringData.hello
	call	string.teletype


; ###
; ### Reverse strings

.reverseStrings:
	mov		si, stringData.str1
	mov		di, stringData.strEmpty
	call	string.reverse
	mov		si, di
	call	string.teletype
	mov		si, stringData.strNewLine
	call	string.teletype
	
	mov		si, stringData.str3
	mov		di, stringData.strEmpty
	call	string.reverse
	mov		si, di
	call	string.teletype
	mov		si, stringData.strNewLine
	call	string.teletype
	

; ###
; ### Get string length

.getStringLength:
	mov		si, stringData.str1
	call	string.getLength
	cmp		al, 16					; if stringLength==16 then goto .stringLength16
	je		.stringLength16
	jmp		.nextStringLength
	
.stringLength16:
	mov		si, stringData.length16
	call	string.teletype
	
.nextStringLength:
	mov		si, stringData.str3
	call	string.getLength
	cmp		al, 23					; if stringLength==23 then goto .stringLength23
	je		.stringLength23
	jmp		exit
	
.stringLength23:
	mov		si, stringData.length23
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
	
.strNewLine:
	db		0x0D, 0x0A, 0
.strEmpty:
	db		64 dup 0


include		"string.asm"