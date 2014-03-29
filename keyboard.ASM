	; String library
	; NAMESPACE: "keyboard"
	keyboard:
	ret

	; MACRO: "getKey"
	; return:
	;	ah = BIOS scan code
	;	al = ASCII character
	;	(flag) zf = clear if key available, set otherwise
macro keyboard.getKey
{
	mov		ah, 0x10			; 0x16 - get enhanced keyboard character
	int		0x16
}

	; PROC: "teletype"
	; param:
	;	si = string pointer