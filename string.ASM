	; String library
	; NAMESPACE: "string"
	string:
	ret


; ###
; ### PROC: "teletype"
	; Prints the string using the TTY interrupt feature, scrolling and advancing the cursor as needed.
	;
	; param:
	;	si = pointer to string, null terminated
.teletype:
	push	ax
	push	si

	mov		ah, 0x0E			; 0x10 - teletype output

.teletype.nextChar:
	mov		al, [si]
	cmp		al, 0				; if char==0 then return
	jz		.teletype.return
	int		0x10				; write to screen
	inc		si					; next character
	jmp		.teletype.nextChar

.teletype.return:
	pop		si
	pop		ax
	ret


; ###
; ### PROC: "match"
	; Determines if the two strings are identical.
	;
	; param:
	;	si = pointer to primary string to be compared against, null terminated
	;	di = pointer to secondary string to be compared, null terminated
	; return:
	;	(flag) carry = set if match, clear if not.
.match:
	push	ax
	push	si
	push	di
	
.match.nextChar:
	mov		ah, [si]
	mov		al, [di]
	cmp		ah, al				; if char1 != char2 then goto notEqual
	jne		.match.notEqual
	cmp		al, 0				; elseif char2==0 then goto equal (end of strings)
	je		.match.equal
	inc		si					; else next character
	inc		di					; ...
	jmp		.match.nextChar
	
.match.notEqual:
	clc
	jmp		.match.return
	
.match.equal:
	stc
	jmp		.match.return
	
.match.return:
	pop		di
	pop		si
	pop		ax
	ret


; ###
; ### PROC: "getLength"
	; Determines the length of the string in number of characters, excluding the null termination character
	;
	; param:
	;	si = pointer to string, null terminated
	; return:
	;	al = number of characters
.getLength:
	push	si
	mov		al, 0
	
.getLength.nextChar:
	mov		ah, [si]
	cmp		ah, 0				; if char==0 then goto return
	je		.getLength.return
	inc		al					; else charCount++
	inc		si					; next character
	jmp		.getLength.nextChar
	
.getLength.return:
	pop		si
	ret
	
	
; ###
; ### PROC: "reverse"
	; Reverses the string, so that the last character is first and vice versa.
	;
	; param:
	;	si = pointer to string, null terminated
	;	di = pointer to new string, null terminated
	; return
	;	di = pointer to new string, null terminated
.reverse:
	push	ax
	push	cx
	push	si
	push	di
	
	xor		cx, cx
	
.reverse.gotoEnd:
	mov		al, [si]
	cmp		al, 0
	je		.reverse.nextChar.setup
	inc		si
	inc		cl
	jmp		.reverse.gotoEnd

.reverse.nextChar.setup:
	dec		si
	
.reverse.nextChar:
	mov		al, [si]
	mov		[di], al
	dec		si
	inc		di
	loop	.reverse.nextChar
	
.reverse.appendTerminator:
	mov		[di], byte 0
	
.reverse.return:
	pop		di
	pop		si
	pop		cx
	pop		ax
	ret