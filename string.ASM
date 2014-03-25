	; String library
	; NAMESPACE: "string"
	string:
	ret

	; PROC: "teletype"
	; param:
	;	si = string pointer
.teletype:
	push	ax
	push	si

	mov	ah, 0x0E	; 0x10 - teletype output

.teletype.nextChar:
	mov	al, [si]
	cmp	al, 0x00	; if char==0 then return
	jz	.teletype.return
	int	0x10		; write character
	inc	si		; next...
	jmp	.teletype.nextChar

.teletype.return:
	pop	si
	pop	ax
	ret