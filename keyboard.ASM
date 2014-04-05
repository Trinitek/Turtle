	; String library
	; NAMESPACE: "keyboard"
	; REQUIRES: "string"
	keyboard:
	ret

; ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
; ### MACRO: "getKey"
	;
	; return:
	;	ah = BIOS scan code
	;	al = ASCII character
	;	(flag) zf = clear if key available, set otherwise
macro keyboard.getKey
{
	mov		ah, 0x10			; 0x16 - get enhanced keyboard character
	int		0x16
}


; ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
; ### PROC: "waitForKey"
	;
	; return:
	;	ah = BIOS scan code
	;	al = ASCII code
.waitForKey:
	keyboard.getKey
	cmp		ax, 0
	jz		.waitForKey
	
.waitForKey.return:
	ret
	

; ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
; ### PROC: "inputString"
	; Catches input from the keyboard into a string. Terminated when ENTER pressed.
	;
	; param:
	;	al = maximum string length, excluding null terminator
	;	ah = 0: no echo, 1: echo (via string.teletype)
	;	di = pointer to new string destination
	; return:
	;	di = pointer to new string, null terminated
.inputString:
	push	ax
	push	bx
	push	cx
	push	di
	
	mov		cl, al				; hold AX values elsewhere - will be destroyed by .getKey
	mov		ch, 0
	mov		bl, ah

.inputString.getNextKey:
	call	.waitForKey
	cmp		al, 0x0D			; enter key pressed? stop accepting input and return string
	je		.inputString.appendTerminator
	mov		[di], al			; store character
	inc		di
	
	cmp		bl, 0				; echo enabled?
	jz		.inputString.nextIteration
								; loopz doesn't want to work for some reason? always decrements cx by 2.
								; loopnz is horribly broken, too. infinite loop.
	
	string.putChar				; display character on screen
	
.inputString.nextIteration:
	loop	.inputString.getNextKey
	
.inputString.appendTerminator:
	mov		al, 0
	mov		[di], al
	
.inputString.return:
	pop		di
	pop		cx
	pop		bx
	pop		ax
	ret
	