	org		0x100					; MS-DOS program

main:
	mov		si, stringData.hello
	call	string.teletype


; ###
; ### Compare strings

.compareStrings_1:
	mov		si, stringData.str1
	mov		di, stringData.str2
	call	string.match
	
	jc		.stringMatches_1		; if str1==str2 then goto .stringMatches_1
	mov		si, stringData.noMatch	; else
	call	string.teletype
	jmp		.compareStrings_2
	
.stringMatches_1:
	mov		si, stringData.match
	call	string.teletype
	
.compareStrings_2:
	mov		si, stringData.str2
	mov		di, stringData.str3
	call	string.match
	
	jc		.stringMatches_2		; if str2 == str3 then goto .stringMatches_2
	mov		si, stringData.noMatch	; else
	call	string.teletype
	jmp		.getStringLength
	
.stringMatches_2:
	mov		si, stringData.match
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
	db		"Hello world!", 0x0D, 0x0A, 0x00
.str1:
	db		"This is a string", 0x00
.str2:
	db		"This is a string", 0x00
.str3:
	db		"This is another string!", 0x00
.noMatch:
	db		"String doesn't match.", 0x0D, 0x0A, 0x00
.match:
	db		"String matches!", 0x0D, 0x0A, 0x00
.length16:
	db		"Length is 16 characters", 0x0D, 0x0A, 0x00
.length23:
	db		"Length is 23 characters", 0x0D, 0x0A, 0x00


include		"string.asm"