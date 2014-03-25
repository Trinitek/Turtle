	org	0x100

main:
	mov	si, text
	call	string.teletype

exit:
	mov	ax, 0x4C00
	int	0x21

text:
	db	"Hello world!", 0x00

include "string.asm"