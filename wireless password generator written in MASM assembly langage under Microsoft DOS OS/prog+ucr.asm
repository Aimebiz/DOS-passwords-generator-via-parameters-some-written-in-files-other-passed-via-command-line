

		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list
		.386                      ;So we can use extended registers
		option segment:use16      ; and addressing modes.



;*****************************************************************************

dseg		segment	para public 'data'

		PSP					word	?
		alphabettype				byte	4	dup (?)
		nullbyte				byte	0
		wordlength				byte	?

		nondesired				byte	'ndesired.txt'
		nullbyte1				byte	?			; a null byte must terminate the previous file name when dos shall access it
		nondesired_handle			word	?
		nondesired_length			word	0

		desired					byte	'imprtive.txt'
		nullbyte2				byte	?
		desired_handle				word	?
		desired_length				word	0

		nondesiredstatut			byte	?
		desiredstatut				byte	?

		WPA2_valid_alphabet_table		byte	95	dup (0) 	; WPA 95 permitted characters elements in which 1 mean the character is to be avoided
		avoid_alphabet				byte	'avoid.txt'
		nullbyte3				byte	?
		avoid_alphabet_handle			word	?
		avoid_alphabet_length			word	0

		non_permitted_position_table		byte	5985	dup (64)	; 63 WPA2 permitted position times WPA2 95 permitted characters corresponding position for non permitted position, 64 for non avoidance and 65 for overall avoidance

		imperative_position_table		byte	63	dup (0)		; 63 WPA2 permitted positions each corresponding to one of WPA2 95 permitted caracters to use and 0 for everything else

		non_combination_table			byte	9025	dup (0) 	; WPA 95 permitted characters raised to power twoo
		noncombine				byte	'ncombine.txt'
		nullbyte4				byte	?
		noncombine_handle			word	?
		noncombine_length			word	?

		non3combine_statut			byte	0

		non3_combination_table1			byte	9025	dup (0) 	; WPA 95 permitted characters raised to power two
		non3combine1				byte	'n3comb1.txt'
		nullbyte51				byte	?
		non3combine_handle1			word	?
		non3combine_length1			word	0

		non3_combination_table2			byte	9025	dup (0) 	; WPA 95 permitted characters raised to power two
		non3combine2				byte	'n3comb2.txt'
		nullbyte52				byte	?
		non3combine_handle2			word	?
		non3combine_length2			word	0

		non3_combination_table3			byte	9025	dup (0) 	; WPA 95 permitted characters raised to power two
		non3combine3				byte	'n3comb3.txt'
		nullbyte53				byte	?
		non3combine_handle3			word	?
		non3combine_length3			word	0

		non3_combination_table4			byte	9025	dup (0) 	; WPA 95 permitted characters raised to power two
		non3combine4				byte	'n3comb4.txt'
		nullbyte54				byte	?
		non3combine_handle4			word	?
		non3combine_length4			word	0

		buffer1					byte	12285	dup (0)		; 63 WPA2 permitted position times 195 used for parsing parameters files
		buffer3					byte	95	dup (64)

		temp					word	0

		password				byte	64 dup(?)		; 63+1 where the 1 does stand for the line feed
		password_copy				byte	64 dup(?)		; copy of password that shall serve to initialize password given element number x within the stages of macro that implements the for loop
		password_file				byte	'password.lst'
		nullbyte6				byte	?
		password_file_handle			word	?

		consonant_mark				byte	63 dup(0)		; used to manage consonants triple occurence

		entry_handlex_offsets_table		word	63 dup(?)

		consonant_lookup_table			byte	95 dup(0)
		position				word	0
		direction				byte	1

dseg		ends

;*****************************************************************************





cseg		segment	para public 'code'
		assume	cs:cseg, ds:dseg


;-----------------------------------------------------------------



;-----------------------------------------------------------------
;
; Main is the main program.  Program execution always begins here.
;
Main		proc


; get command line
				push	ds
				mov	ax, dseg
				mov	ds, ax
				pop	PSP

				meminit

				mov	es, PSP
				lea	bx, byte ptr es:[81h]		; store commandline address into es:[bx]
				dec	bx

		skip_spaces1:
				inc	bx
				mov	al, byte ptr es:[bx]
				cmp	al, 20h
				jz	skip_spaces1
				cmp	al, 72h
				jz	resume
				sub	al, 30h
				mov	ah, 4
				lea	di, alphabettype		; get the type of alphabet to use
		loop1:
				mov	ds:[di], al
				inc	di
				inc	bx
				mov	al, byte ptr es:[bx]
				sub	al, 30h
				dec	ah
				cmp	ah, 0
				jne	loop1


; get word length passphrase of 8 to 63 printable ASCII characters

		skip_spaces2:
				inc	bx
				mov	dl, byte ptr es:[bx]
				cmp	dl, 20h

				jz	skip_spaces2
				sub	dl, 30h
				xor	dh, dh
				mov	ax, dx
				imul	ax, 10d
				inc	bx
				mov	dl, byte ptr es:[bx]
				sub	dl, 30h
				xor	dh, dh
				add	ax, dx
				mov	wordlength, al
				cmp	al, 0
				je	error
; valid or no nondesired.txt

		skip_spaces3:
				inc	bx
				mov	al, byte ptr es:[bx]
				cmp	al, 20h
				jz	skip_spaces3
				cmp	al, 79h
				jz	loop3
				cmp	al, 6eh
				jne	error
				mov	nondesiredstatut, 0
				jmp	skip_spaces4
		loop3:		mov	nondesiredstatut, 1
				jmp	skip_spaces4
				


; valid or no desired.txt

		skip_spaces4:
				inc	bx
				mov	al, byte ptr es:[bx]
				cmp	al, 20h
				jz	skip_spaces4
				cmp	al, 79h
				jz	loopa
				cmp	al, 6eh
				jne	error
				mov	desiredstatut, 0
				jmp	next1
		loopa:		mov	desiredstatut, 1
				


		next1:

				mov	ax, dseg
				mov	es, ax



mov	ah, 0
mov	al, alphabettype
puti
mov	al, 20h
putc
mov	al, alphabettype[1]
puti
mov	al, 20h
putc
mov	ah, 0
mov	al, alphabettype[2]
puti
mov	al, 20h
putc
mov	al, alphabettype[3]
puti
mov	al, 20h
putc
mov	al, wordlength
puti
mov	al, 20h
putc
mov	al, nondesiredstatut
puti
mov	al, 20h
putc
mov	al, desiredstatut
puti
putcr
putcr
putcr



; initialize buffer1 to ndesired.txt contents and save its number of elements into ax


				cmp	nondesiredstatut, 0
				je	imperative
				clc
				mov	ah, 3dh				; open the file ndesired.txt for reading
				mov	al, 0
				lea	dx, nondesired
				int 21h

				jc	error

				mov	nondesired_handle, ax

				mov	di, 0

				lea	dx, buffer1
				sub	dx, 1
				mov	bx, nondesired_handle
				mov	cx, 1

		loop16:
				inc	di

				cmp	di, 12159d
				jl	loop17
				dec	di
				jmp	loop15
		loop17:
				clc

				inc	dx

				mov	ah, 3fh

				int 21h

				cmp	ax, cx
				je	loop16

				dec	di
				mov	ax, di

				clc
push ax
puti
putcr
putcr
pop ax

; parse buffer1 and initialize the non_permitted_position_table with 63 WPA2 permitted position times WPA2 95 permitted characters elements to corresponding position for non permitted position, 65 for overall avoidance and conserve 64 for non avoidance

		loop15:
				mov	nondesired_length, ax
				cmp	ax, 0
				jz	imperative

				lea	di, buffer3
				lea	bx, buffer1

				mov	dx, 1				; a new line is reached after a character

				and	cx, 0				; the next value is a character
		loop12:


		loop5:
				mov	al, byte ptr ds:[bx]
				cmp	al, 09h				; cmp against horizontal tab characters
				jnz	loop4
				dec	nondesired_length
				cmp	nondesired_length, 0
				jz	loop20
				inc	bx
				mov	cx, 0				; state the next value is a character
				inc	temp
				jmp	loop5				; skip all horizontal tabs

		loop4:

				cmp	temp, 2				; check for at least double tabs which preceed the position
				jl	loop7
				mov	cx, 1				; state the next value is a position
				mov	temp, 0
		loop7:
				mov	al, byte ptr ds:[bx]
				cmp	ax, 0dh				; cmp against carriage return
				jnz	loop6
				dec	nondesired_length
				cmp	nondesired_length, 0
				jz	loop20
				inc	bx
				jmp	loop7				; skip all carriage returns

		loop6:

		loop9:
				mov	al, byte ptr ds:[bx]
				cmp	al, 0ah				; cmp against line feed
				jnz	loop8
				dec	nondesired_length
				cmp	nondesired_length, 0
				jz	loop20
				inc	bx
				and	cx, 0				; state the next value is a character
				cmp	dx, 1				; is a new line reached after a character? if so the next byte to read must be a character
				jnz	loop19
		loop19:
				jmp	loop9				; skip all line feeds


		loop8:

				mov	al, byte ptr ds:[bx]		; check if the next character is within the WPA2 alphabet
				cmp	al, 7eh
				jg	error
				cmp	al, 20h
				jl	error


	; is a position been reading? if so cx is 1. the next character must be a number


				cmp	cx, 1				; is the next value a position?
				jne	loop10
				cmp	al, 39h				; the next character must be a number
				jg	error
				cmp	al, 30h
				jl	error
				and	cx, 0				; the next value is a character


	; check for the avoidance position and save it into non_permitted_position_table


		loop18:
				mov	al, byte ptr ds:[bx]

				cmp	nondesired_length, 1
				je	loop13

				mov	dl, byte ptr ds:[bx+1]

				cmp	dl, 30h
				jl	loop13
				cmp	dl, 39h
				jg	loop13
				sub	al, 30h
				xor	ah, ah
				imul	ax, 10d
				sub	dl, 30h
				add	al, dl
				cmp	al, 63
				jg	error

				push	cx
				push	di
				push	bx

				mov	bp, ax
				dec	bp
				imul	bp, 95
				mov	bx, ax

				lea	di, non_permitted_position_table
				lea	si, buffer3
				mov	cx, 95

				cld

		loop24:

				lodsb
				cmp	ax, 65
				jnz	loop25
				mov	byte ptr ds:[bp+di], bl

				inc	bp
				dec	cx
				jz	loop23
				jmp	loop24
		loop25:

				inc	bp
				dec	cx
				jz	loop23
				jmp	loop24

		loop23:
				lea	di, buffer3				; reinitialize buffer3
				mov	cx,95
				mov	al,64
				rep	stosb

				pop	bx
				pop	di
				pop	cx

				inc	bx
				inc	bx

				dec	nondesired_length
				dec	nondesired_length
				cmp	nondesired_length, 0
				jnz	loop12

				jmp	loop20








		loop13:
				sub	al, 30h

				push	cx
				push	di
				push	bx

				mov	bp, ax
				dec	bp
				imul	bp, 95
				mov	bx, ax

				lea	di, non_permitted_position_table
				lea	si, buffer3
				mov	cx, 95

				cld

		loop27:

				lodsb
				cmp	ax, 65
				jnz	loop28
				mov	byte ptr ds:[bp+di], bl

				inc	bp
				dec	cx
				jz	loop26
				jmp	loop27

		loop28:
				inc	bp
				dec	cx
				jz	loop26
				jmp	loop27

		loop26:
				lea	di, buffer3				; reinitialize buffer3
				mov	cx,95
				mov	al,64
				rep	stosb

				pop	bx
				pop	di
				pop	cx

				inc	bx

				dec	nondesired_length
				cmp	nondesired_length, 0
				jnz	loop12


				jmp	loop20


		loop10:
				sub	al, 20h				; computes the alphabet symbol position into buffer3
				xor	ah, ah

				push	di

				lea	di, buffer3
				add	di, ax

				mov	byte ptr ds:[di], 65		; seemilarly overall avoidance of the caracter in ax within WPA2 alphabet unless a position is specified next it

				pop	di				; reinitialize di to buffer3 address to its previous value

				add	ax, 20h				; reinitialize ax to its previous value

				inc	bx
				mov	dx, 0

				dec	nondesired_length
				cmp	nondesired_length, 0

				jnz	loop12

	; close the file ndesired.txt

		loop20:
				mov	bx, nondesired_handle
				mov	ah, 3eh
				int 21h

				

; initialize the buffer1 to imprtive.txt contents and initialize desired_length

		imperative:

				cmp	desiredstatut, 0
				jz	non_combination

				clc
				mov	ah, 3dh				; open the file imprtive.txt for reading
				mov	al, 0
				lea	dx, desired
				int 21h
				jc	error
				mov	desired_handle, ax

				lea	dx, buffer1

				mov	bx, ax

				mov	cx, 1				; try to read one byte from the file

		loop30:
				mov	ah, 3fh
				int 21h

				cmp	ax, 1				; check if the reading operation succeed
				jnz	loop29				; if not close the file

				inc	desired_length
				inc	dx
				jmp	loop30

		loop29:
				mov	ah, 3eh				; close the file
				int 21h


mov	ax, desired_length
puti
putcr
putcr


; parse buffer1 and initialize imperative_position_table


				xor	bx, bx
		loop35:
				cmp	bx, desired_length
				ja	loop32

				mov	al, byte ptr buffer1[bx]			; fetch the relative first byte
				xor	ah, ah

				cmp	ax, 39h						; the first byte must be a number
				ja	error

				cmp	ax, 30h
				jz	error
				sub	ax, 30h

				mov	cx, ax						; save it into dx
				inc	bx

				mov	al, byte ptr buffer1[bx]			; fetch the next byte
				cmp	ax, 39h						; if it is not a number, jump to loop31
				ja	loop31						; and computes the position into bp
				cmp	ax, 30h
				jl	loop31

				sub	ax, 30h						; else computes the total position into bp
				imul	cx, 10d						; and jump to loop34
				add	ax, cx
				mov	bp, ax
				dec	bp
				inc	bx
				jmp	loop34
		loop31:
				mov	bp, cx
				dec	bp

		loop34:
				mov	al, byte ptr buffer1[bx]
				xor	ah, ah
				cmp	ax, 09h						; cmp againt horizontal tab
				jne	error
				inc	bx						; skip all horizontal tabs

		loop33:
				mov	al, byte ptr buffer1[bx]
				xor	ah, ah
				cmp	ax, 20h						; the relative second byte must belongs to wpA2 alphabet
				jb	error
				cmp	ax, 7eh
				ja	error

				mov	imperative_position_table[bp], al
				inc	bx

				cmp	bx, desired_length
				ja	loop32

				inc	bx
				inc	bx

				jmp	loop35

		loop32:




; print non_permitted_position_table

xor	bp, bp

cr	equ	13
lf	equ	10

mov	cx, 0
jmp	loop1000

loop1001:

push	ax
mov	al, 20h
putc
pop	ax
puti
mov	al, 20h
putc
putc
inc	bp
inc	cx
cmp	cx, 5985
jne	loop1000
jmp	Quit

loop1000:

mov	al, byte ptr non_permitted_position_table[bp]
cmp	al, 9
jle	loop1001
puti
mov	al, 20h
putc
putc
inc	bp
inc	cx
cmp	cx, 5985
jne	loop1000

putcr
putcr






; print desired

xor	bp, bp

loop1002:

mov	al, byte ptr imperative_position_table[bp]
putc
inc	bp
cmp	bp, 63
jne	loop1002
putcr
putcr


; initialize the non_combination_table in which at the cross of two characters in the WPA2 alphabet, a value 0 mean authorized, 1 mean to be avoided

		non_combination:


	; try to open ncombine.txt and if it fail jump to non3_combination


				mov	ah, 3dh				; open the file ncombine.txt for reading
				mov	al, 0
				lea	dx, noncombine
				int 21h

				jc	non3_combination1

				mov	noncombine_handle, ax

				lea	dx, buffer1

				mov	bx, ax

				mov	cx, 1				; try to read one byte from the file

		loop37:
				mov	ah, 3fh
				int 21h

				cmp	ax, 1				; check if the reading operation succeed
				jnz	loop36				; if not close the file

				inc	noncombine_length
				inc	dx
				jmp	loop37

		loop36:
				mov	ah, 3eh				; close the file
				int 21h


mov	ax, noncombine_length
puti
putcr
putcr


; parse buffer1 and initialize non_combination_table



				xor	bp, bp
		loop38:
				cmp	noncombine_length, 0
				je	loop39
				cmp	bp, noncombine_length
				ja	loop39
				mov	ax, word ptr buffer1[bp]
				cmp	al, 20h
				jb	error
				cmp	al, 7eh
				ja	error
				cmp	ah, 20h
				jb	error
				cmp	ah, 7eh
				ja	error

				sub	ah, 20h
				mov	bl, ah
				xor	ah, ah
				sub	al, 20h
				imul	ax, 95d
				xor	bh, bh

				add	bx, ax

				mov	byte ptr non_combination_table[bx], 1

				add	bp, 4
				cmp	bp, noncombine_length
				ja	loop39
				jmp	loop38

		loop39:


; print non_combination_table


xor	bp, bp
xor	di, di
xor	ah, ah

loop1003:

mov	al, byte ptr non_combination_table[bp+di]
puti
mov	al, 20h
putc
inc	bp
cmp	bp, 95
jne	loop1003
putcr
add	di, 95
xor	bp, bp
cmp	di, 9025
jne	loop1003
putcr
putcr






		inittable3		macro	x





;; initialize the non3_combination_table in which at the cross of two consonant in the WPA2 alphabet stand a third WPA2 consonant meaning any combination of the three consonants is authorized or 0 for nothing else


		non3_combination&x&:


	;; try to open n3comb&x&.txt and if it fail jump to avoid else save it into buffer1


				mov	ah, 3dh				;; open the file n3comb&x&.txt for reading
				mov	al, 0
				lea	dx, non3combine&x&
				int 21h

				jc	avoid

				mov	non3combine_statut, 1

				mov	non3combine_handle&x&, ax

				lea	dx, buffer1

				mov	bx, ax

				mov	cx, 1				;; try to read one byte from the file

		loop41&x&:
				mov	ah, 3fh
				int 21h

				cmp	ax, 1				;; check if the reading operation succeed
				jnz	loop40&x&			;; if not close the file

				inc	non3combine_length&x&
				inc	dx
				jmp	loop41&x&

		loop40&x&:
				cmp	non3combine_length&x&, 0

				mov	ah, 3eh				;; close the file
				int 21h


mov	ax, non3combine_length&x&
puti
putcr
putcr


;: parse buffer1 and initialize non3_combination_table&x&



				xor	bp, bp
		loop42&x&:
				cmp	non3combine_length&x&, 0
				je	loop43&x&
				cmp	bp, non3combine_length&x&
				ja	loop43&x&
				mov	ax, word ptr buffer1[bp]
				cmp	al, 20h
				jb	error
				cmp	al, 7eh
				ja	error
				cmp	ah, 20h
				jb	error
				cmp	ah, 7eh
				ja	error
				mov	cl, byte ptr buffer1[bp+2]
				cmp	cl, 20h
				jb	error
				cmp	cl, 7eh
				ja	error

				sub	al, 20h
				mov	bl, al
				mov	al, ah
				sub	al, 20h
				xor	ah, ah
				imul	ax, 95d
				xor	bh, bh

				add	bx, ax

				mov	byte ptr non3_combination_table&x&[bx], cl

				add	bp, 5
				cmp	bp, non3combine_length&x&
				ja	loop43&x&
				jmp	loop42&x&

		loop43&x&:


;; print non3_combination_table&x&


xor	bp, bp
xor	di, di
xor	ah, ah

loop1004&x&:

mov	al, byte ptr non3_combination_table&x&[bp+di]
puti
mov	al, 20h
putc
inc	bp
cmp	bp, 95
jne	loop1004&x&
putcr
add	di, 95
xor	bp, bp
cmp	di, 9025
jne	loop1004&x&
putcr
putcr




					endm



			i=0

			repeat 4

			i = i+1
			inittable3 %i

			endm


; adjust non3combine_statut according to non3combine_length&x& values

				mov	ax, non3combine_length1
				add	ax, non3combine_length2
				add	ax, non3combine_length3
				add	ax, non3combine_length4
				cmp	ax, 0
				jnz	avoid
				mov	non3combine_statut, 0


;initialize the WPA2_valid_alphabet_table of 95 elements each corresponding to a WPA2 valid character in which a value 1 instead of 0 mean the corresponding character is to be avoided


		avoid:


	; try to open avoid.txt and if it fail jump to afteravoid else save it into buffer1


				mov	ah, 3dh				; open the file avoid.txt for reading
				mov	al, 0
				lea	dx, avoid_alphabet
				int 21h

				jc	afteravoid

				mov	avoid_alphabet_handle, ax

				lea	dx, buffer1

				mov	bx, ax

				mov	cx, 1				; try to read one byte from the file

		loop45:
				mov	ah, 3fh
				int 21h

				cmp	ax, 1				; check if the reading operation succeed
				jnz	loop44				; if not close the file

				inc	avoid_alphabet_length
				inc	dx
				jmp	loop45

		loop44:
				mov	ah, 3eh				; close the file
				int 21h


mov	ax, avoid_alphabet_length
puti
putcr
putcr



; parse buffer1 and initialize WPA2_valid_alphabet_table


				xor	bp, bp

		loop47:
				cmp	avoid_alphabet_length, 0
				je	loop46
				cmp	bp, avoid_alphabet_length
				ja	loop46
				mov	al, byte ptr buffer1[bp]
				cmp	al, 20h
				jb	error
				cmp	al, 7eh
				ja	error

				sub	al, 20h
				mov	bx, ax
				mov	byte ptr WPA2_valid_alphabet_table[bx], 1
				add	bp, 2

				cmp	bp, avoid_alphabet_length
				ja	loop46
				jmp	loop47
		loop46:



; make correction to the WPA2_valid_alphabet_table according to the alphabettype

	; if special characters are not authorized, move 1 into WPA2_valid_alphabet_table positions 0-15, 26-32, 59-64 and 91-94

				mov	al, alphabettype[3]
				cmp	al, 1
				jz	loop_correction1

				mov	al, 1
				mov	bx, -1

		loop_correction5:
				inc	bx
				cmp	bx, 16
				jz	loop_correction4
				mov	WPA2_valid_alphabet_table[bx], al
				jmp	loop_correction5

		loop_correction4:
				mov	bx, 25

		loop_correction7:
				inc	bx
				cmp	bx, 33
				jz	loop_correction6
				mov	WPA2_valid_alphabet_table[bx], al
				jmp	loop_correction7

		loop_correction6:
				mov	bx, 58

		loop_correction9:
				inc	bx
				cmp	bx, 65
				jz	loop_correction8
				mov	WPA2_valid_alphabet_table[bx], al
				jmp	loop_correction9

		loop_correction8:
				mov	bx, 90

		loop_correction11:
				inc	bx
				cmp	bx, 95
				jz	loop_correction10
				mov	WPA2_valid_alphabet_table[bx], al
				jmp	loop_correction11

		loop_correction10:

	; if uppercases characters are not authorized, move 1 into WPA2_valid_alphabet_table positions 33-58

		loop_correction1:
				mov	al, alphabettype
				cmp	al, 1
				jz	loop_correction2

				mov	al, 1
				mov	bx, 32

		loop_correction13:
				inc	bx
				cmp	bx, 59
				jz	loop_correction12
				mov	WPA2_valid_alphabet_table[bx], al
				jmp	loop_correction13

		loop_correction12:


	; if lowercases characters are not authorized, move 1 into WPA2_valid_alphabet_table positions 65-90

		loop_correction2:
				mov	al, alphabettype[1]
				cmp	al, 1
				jz	loop_correction3

				mov	al, 1
				mov	bx, 64

		loop_correction15:
				inc	bx
				cmp	bx, 91
				jz	loop_correction14
				mov	WPA2_valid_alphabet_table[bx], al
				jmp	loop_correction15

		loop_correction14:

	; if digits are not authorized, move 1 into WPA2_valid_alphabet_table positions 16-25

		loop_correction3:
				mov	al, alphabettype[2]
				cmp	al, 1
				jz	loop_correctionend

				mov	al, 1
				mov	bx, 15

		loop_correction17:
				inc	bx
				cmp	bx, 26
				jz	loop_correction16
				mov	WPA2_valid_alphabet_table[bx], al
				jmp	loop_correction17

		loop_correction16:



		loop_correctionend:




; print WPA2_valid_alphabet_table


xor	bp, bp
xor	ah, ah

loop1005:

mov	al, byte ptr WPA2_valid_alphabet_table[bp]
puti
mov	al, 20h
putc
inc	bp
cmp	bp, 95
jne	loop1005
putcr
putcr


		afteravoid:


; prepare to generate password_file

; save line feed at the last position within password

				mov	password[63], 0ah

; initialize password others bytes according to alphabettype

	; check if only lowercases are authorized if so initialize password others bytes to ...caracter a ascii code minus

				cmp	alphabettype[1], 1
				jnz	loop_init_password1
				cmp	alphabettype[0], 0
				jnz	loop_init_password1
				cmp	alphabettype[2], 0
				jnz	loop_init_password1
				cmp	alphabettype[3], 0
				jnz	loop_init_password1

				mov	cx, 63
				cld
				mov	al, 60h
				lea	di, password
	loop_init_password2:	stosb
				loop	loop_init_password2

				jmp	loop_init_password10


	; check if only uppercases are authorized if so initialize password others bytes to ...caracter A ascii code minus one

	loop_init_password1:
				cmp	alphabettype[0], 1
				jnz	loop_init_password3
				cmp	alphabettype[1], 0
				jnz	loop_init_password3
				cmp	alphabettype[2], 0
				jnz	loop_init_password3
				cmp	alphabettype[3], 0
				jnz	loop_init_password3

				mov	cx, 63
				cld
				mov	al, 40h
				lea	di, password
	loop_init_password4:	stosb
				loop	loop_init_password4

				jmp	loop_init_password10


	; check if only	digits are authorized if so initalize password others bytes to ...caracter 0 ascii code minus one

	loop_init_password3:
				cmp	alphabettype[2], 1
				jnz	loop_init_password5
				cmp	alphabettype[0], 0
				jnz	loop_init_password5
				cmp	alphabettype[1], 0
				jnz	loop_init_password5
				cmp	alphabettype[3], 0
				jnz	loop_init_password5

				mov	cx, 63
				cld
				mov	al, 2fh
				lea	di, password
	loop_init_password6:	stosb
				loop	loop_init_password6

				jmp	loop_init_password10

	; check if only others characters are authorized if so initialize password others bytes to ...space character ascii that is 20h minus one

	loop_init_password5:
				cmp	alphabettype[3], 1
				jnz	loop_init_password7
				cmp	alphabettype[0], 0
				jnz	loop_init_password7
				cmp	alphabettype[1], 0
				jnz	loop_init_password7
				cmp	alphabettype[3], 0
				jnz	loop_init_password7

				mov	cx, 63
				cld
				mov	al, 1fh
				lea	di, password
	loop_init_password8:	stosb
				loop	loop_init_password8

				jmp	loop_init_password10

	; at this point initialize password others bytes to space character ascii code that is 20h

	loop_init_password7:
				mov	cx, 63
				cld
				mov	al, 1fh
				lea	di, password
	loop_init_password9:	stosb
				loop	loop_init_password9


	loop_init_password10:






; using imperative_position_table, adjust corresponding element of password to the specified character minus one and set consonant_mark to 1 if the character is a consonant

				mov	bx, -1
		loop_adjust1:
				inc	bx
				cmp	bx, 63
				jz	loop_password_copy

				mov	bp, 63
				xor	ah, ah
				mov	al, wordlength
				sub	bp, ax
				add	bp, bx

				cmp	imperative_position_table[bx], 0
				jz	loop_adjust1
				mov	al, imperative_position_table[bx]
				mov	password[bp], al

				cmp	al, 41h
				jge	loop_adjust2
				mov	consonant_mark[bp], 0
				jmp	loop_adjust_end

		loop_adjust2:
				cmp	al, 5bh
				jge	loop_adjust3
		vowel_test:
				cmp	al, 41h
				je	state_vowel
				cmp	al, 45h
				je	state_vowel
				cmp	al, 49h
				je	state_vowel
				cmp	al, 4fh
				je	state_vowel
				cmp	al, 55h
				je	state_vowel
				cmp	al, 59h
				je	state_vowel
				cmp	al, 61h
				je	state_vowel
				cmp	al, 65h
				je	state_vowel
				cmp	al, 69h
				je	state_vowel
				cmp	al, 6fh
				je	state_vowel
				cmp	al, 75h
				je	state_vowel
				cmp	al, 79h
				je	state_vowel

				mov	consonant_mark[bp], 1
				jmp	loop_adjust_end
		state_vowel:
				mov	consonant_mark[bp], 0

				jmp	loop_adjust_end

		loop_adjust3:
				cmp	al, 61h
				jge	loop_adjust4
				mov	consonant_mark[bp], 0
				jmp	loop_adjust_end

		loop_adjust4:
				cmp	al, 7bh
				jge	loop_adjust5
				jmp	vowel_test
				jmp	loop_adjust_end
		loop_adjust5:
				mov	consonant_mark[bp], 0

		loop_adjust_end:

				jmp	loop_adjust1

; make a copy of password into password_copy 

	loop_password_copy:
				lea	si, password
				lea	di, password_copy
				mov	cx, 63
	loop_password_copy2:
				movsb
				dec	cx
				cmp	cx, 0
				jnz	loop_password_copy2


; for test purposes show password initial value

mov	bx, -1
xor	ah, ah

loop1006:

inc	bx
cmp	bx, 63
jz	loop1007
mov	al, password[bx]
puti
mov	al, 20h
putc
jmp	loop1006

loop1007:

putcr
putcr


; for test purposes show password_copy initial value

mov	bx, -1

loop1008:

inc	bx
cmp	bx, 63
jz	loop1009
mov	al, password_copy[bx]
puti
mov	al, 20h
putc
jmp	loop1008

loop1009:

putcr
putcr


; for test purposes show consonant_mark initial value

mov	bx, -1
xor	ah, ah

loop1010:

inc	bx
cmp	bx, 63
jz	loop1011
mov	al, consonant_mark[bx]
puti
mov	al, 20h
putc
jmp	loop1010

loop1011:

putcr
putcr


; make consonant_lookup_table


				mov	al, 1fh

				mov	bx, -1
		loop_make_begin:
				inc	al
				inc	bx
				cmp	al, 7fh
				je	loop_make_end

				cmp	al, 41h
				jge	loop_make2
				mov	consonant_lookup_table[bx], 0
				jmp	loop_make_6

		loop_make2:
				cmp	al, 5bh
				jge	loop_make3
		make_vowel_test:
				cmp	al, 41h
				je	make_state_vowel
				cmp	al, 45h
				je	make_state_vowel
				cmp	al, 49h
				je	make_state_vowel
				cmp	al, 4fh
				je	make_state_vowel
				cmp	al, 55h
				je	make_state_vowel
				cmp	al, 59h
				je	make_state_vowel
				cmp	al, 61h
				je	make_state_vowel
				cmp	al, 65h
				je	make_state_vowel
				cmp	al, 69h
				je	make_state_vowel
				cmp	al, 6fh
				je	make_state_vowel
				cmp	al, 75h
				je	make_state_vowel
				cmp	al, 79h
				je	make_state_vowel

				mov	consonant_lookup_table[bx], 1
				jmp	loop_make_6
		make_state_vowel:
				mov	consonant_lookup_table[bx], 0

				jmp	loop_make_6

		loop_make3:
				cmp	al, 61h
				jge	loop_make4
				mov	consonant_lookup_table[bx], 0
				jmp	loop_make_6

		loop_make4:
				cmp	al, 7bh
				jge	loop_make5
				jmp	make_vowel_test
		loop_make5:
				mov	consonant_lookup_table[bx], 0

		loop_make_6:

				jmp	loop_make_begin
		loop_make_end:


; print consonant_lookup_table

mov	bp, -1
xor	ah, ah

loop1012:

inc	bp
mov	al, consonant_lookup_table[bp]
puti
mov	ax, 20h
putc
cmp	bp, 94
jz	consonant_lookup_table_end
jmp	loop1012

consonant_lookup_table_end:

putcr
putcr




;____________________________________________________________________________________________________



	macro_entry_handle		macro	x, y



		entry_handle&x&:

				mov	bp, y			; save away the actual index into array password

				mov	si, position		; save away the actual password byte position minus one. the hole behave as an index that will be used to access arrays

				xor	bh, bh


; note: within the program, entry_handlex goes from entry_handle1 to entry_handle63


;check to see if a character is obligatory at this position if so it might already have been stored and consonant_mark migth already have been set jump to entry_handle&x&blast

				mov	al, imperative_position_table[si]
				cmp	al, 0
				jz	entry_handle&x&a
				cmp	direction, 0
				jnz	entry_handle&x&blast
				dec	position
				jmp	entry_handle&y&



	entry_handle&x&a:


; increment password byte number x
				inc	byte ptr password[bp]

; save the byte byte ptr password[bp] into bl

				mov	bl, byte ptr password[bp]

; set consonant_mark to 1 if the actual byte is a consonant weither uppercase or lowercase else set it to 0

				mov	di, bx
				sub	di, 20h
				mov	al, consonant_lookup_table[di]
				cmp	al, 1
				jnz	entry_handle&x&c1
				mov	consonant_mark[si], 1
				jmp	entry_handle&x&c2
		entry_handle&x&c1:
				mov	consonant_mark[si], 0
		entry_handle&x&c2:


; check to see if the alphabet cycle 1 round if so reinitialize the password using password_copy or something else except for position=0 where the program must leave the stages of macro implementing the for loop

	; check if only lowercases are authorized if so compare byte ptr password[bx] against ...caracter z ascii code and if greater reinitialize the password[bx] to a ascii code and jump if position is deferent of 1 to entry_handle&x_1& else jump to the end of the stages of macro that implement the for loop

				mov	eax, dword ptr alphabettype			; temporary save

				cmp	eax, 00000100h
				jnz	entry_handle&x&b1
				cmp	bl, 7ah
				jg	entry_handle&x&b2

				jmp	entry_handle&x&b10

	entry_handle&x&b2:
				cmp	si, 0
				jz	point_after_for_macro_stages
				mov	byte ptr password[bp], 60h
				dec	position
				mov	direction, 0
				jmp	entry_handle&y&

	entry_handle&x&b1:

	; check if only uppercases are authorized if so compare byte ptr password[bx] against ...caracter Z ascii code and if greater reinitialize the password[bx] to A ascii code and jump if x if deferent of 1 to entry_handlex-1 else jump to the end of the stages of macro that implement the for loop

				cmp	eax, 00000001h
				jnz	entry_handle&x&b4
				cmp	bl, 5ah
				jg	entry_handle&x&b3
				jmp	entry_handle&x&b10

	entry_handle&x&b3:
				cmp	si, 0
				jz	point_after_for_macro_stages
				mov	byte ptr password[bp], 40h
				dec	position
				mov	direction, 0
				jmp	entry_handle&y&
	entry_handle&x&b4:


	; check if only digits are authorized if so compare byte ptr password[bx] against ...9 ascii code and if greater reinitialize the password[bx] to A ascii code and jump if x if deferent of 1 to entry_handlex-1 else jump to the end of the stages of macro that implement the for loop

				cmp	eax, 00010000h
				jnz	entry_handle&x&b6
				cmp	bl, 39h
				jg	entry_handle&x&b5
				jmp	entry_handle&x&b10

	entry_handle&x&b5:
				cmp	si, 0
				jz	point_after_for_macro_stages
				mov	byte ptr password[bp], 2fh
				dec	position
				mov	direction, 0
				jmp	entry_handle&y&

	entry_handle&x&b6:


	; check if only others caracters are authorized if so compare byte ptr password[bx] against 7eh and if greater reinitialize the password[bx] to 20h and jump if x if deferent of 1 to entry_handlex-1 else jump to the end of the stages of macro that implement the for loop

				cmp	eax, 01000000h
				jnz	entry_handle&x&b8
				cmp	bl, 7eh
				jg	entry_handle&x&b7
				jmp	entry_handle&x&b10

		; at this point try to boost the program by jumping cause others caracters boundary are discontinuous

; ...

	entry_handle&x&b7:
				cmp	si, 0
				jz	point_after_for_macro_stages
				mov	byte ptr password[bp], 1fh
				dec	position
				mov	direction, 0
				jmp	entry_handle&y&

	entry_handle&x&b8:

				cmp	bl, 7eh
				jg	entry_handle&x&b9
				jmp	entry_handle&x&b10

	entry_handle&x&b9:
				cmp	si, 0
				jz	point_after_for_macro_stages
				mov	byte ptr password[bp], 1fh
				dec	position
				mov	direction, 0
				jmp	entry_handle&y&

	entry_handle&x&b10:


; check if the actual byte is authorized using the WPA2_valid_alphabet_table else increment the byte by jumping to entry_handle&x&a

				mov	al, byte ptr WPA2_valid_alphabet_table[bx-32]
				cmp	al, 1
				jz	entry_handle&x&a

; check if the actual byte is authorized at this position using the table non_permitted_position_table else increment the byte by jumping to entry_handle&x&a

				mov	di, si
				imul	di, 95
				add	di, bx
				sub	di, 20h
				mov	al, byte ptr non_permitted_position_table[di]
				sub	al, 1
				xor	ah, ah
				cmp	ax, si
				jz	entry_handle&x&a


; check if the actual byte combination with the previous one is authorized using the table non_combination_table else increment the byte by jumping to entry_handle&x&a

	; first check if the actual position is greater than or equal to 2. if not jmp to entry_handle&x&blast

				cmp	si, 1
				jl	entry_handle&x&blast

				mov	al, byte ptr password[bp-1]
				xor	ah, ah
				mov	di, ax
				sub	di, 32
				imul	di, 95
				add	di, bx
				sub	di, 32
				mov	al, byte ptr non_combination_table[di]
				cmp	al, 1
				jz	entry_handle&x&a


; in case non3combine_statut value is 1 if the actual byte is a consonant check if its combination with the two previous ones in case they are also consonants is authorized using the table non3_combination_table 1, 2 and 3 and consonant_mark table else increment the byte by jumping to entry_handle&x&a

	; first check if the actual position is greater than or equal to 3. if not jmp to entry_handle&x&blast

				cmp	si, 2
				jl	entry_handle&x&blast

				cmp	non3combine_statut, 1
				jnz	entry_handle&x&b11

				mov	ax, word ptr consonant_mark[si-2]
				cmp	ax, 0101h
				jnz	entry_handle&x&d1
				cmp	byte ptr consonant_mark[si], 01h
				jnz	entry_handle&x&b11

				mov	al, password[bp-2]
				sub	al, 20h
				xor	ah, ah
				imul	ax, 95
				add	al, password[bp-1]
				sub	al, 20h						; try to keep di from now on
				mov	di, ax
				cmp	non3_combination_table1[di], bl
				jne	entry_handle&x&b12
				jmp	entry_handle&x&b11
	entry_handle&x&b12:
				cmp	non3_combination_table2[di], bl
				jne	entry_handle&x&b13
				jmp	entry_handle&x&b11
	entry_handle&x&b13:
				cmp	non3_combination_table3[di], bl
				jne	entry_handle&x&b14
				jmp	entry_handle&x&b11
	entry_handle&x&b14:
				cmp	non3_combination_table4[di], bl				
				jne	entry_handle&x&a

; in case non3combine_statut value is 1 if the actual byte is a vowel check if its combination with the two previous ones in case they are also vowels is authorized using the table non3_combination_table 1, 2 and 3 and consonant_mark table else increment the byte by jumping to entry_handle&x&a

	entry_handle&x&d1:

				mov	ax, word ptr consonant_mark[si-2]
				cmp	ax, 0000h
				jnz	entry_handle&x&b11
				cmp	byte ptr consonant_mark[si], 00h
				jnz	entry_handle&x&b11

				mov	al, password[bp-2]
				sub	al, 20h
				xor	ah, ah
				imul	ax, 95
				add	al, password[bp-1]
				sub	al, 20h						; try to keep di from now on
				mov	di, ax
				cmp	non3_combination_table1[di], bl
				jne	entry_handle&x&d2
				jmp	entry_handle&x&b11
	entry_handle&x&d2:
				cmp	non3_combination_table2[di], bl
				jne	entry_handle&x&d3
				jmp	entry_handle&x&b11
	entry_handle&x&d3:
				cmp	non3_combination_table3[di], bl
				jne	entry_handle&x&d4
				jmp	entry_handle&x&b11
	entry_handle&x&d4:
				cmp	non3_combination_table4[di], bl				
				jne	entry_handle&x&a


	entry_handle&x&b11:


	entry_handle&x&blast:



; at this point just continue the program execution with the macro call that implement the entries parts of the 63 for loop stages and then with the middle_handle macro call that save the word and then with the exit_handle macro call that implement the exit parts of the 63 stages of the for loop





					endm



;________________________________________________________________________________________________________



; print initial entry_handlex_offsets_table

mov	bp, -1

loop1014:

inc	bp
mov	di, bp
add	di, bp
mov	ax, entry_handlex_offsets_table[bp]
puti
mov	ax, 20h
putc
cmp	bp, 62
jz	make_a_table_end2
jmp	loop1014

make_a_table_end2:

putcr
putcr



; make a table of 63 elements and initialize each one to the corresponding entry_handle&x& address usefull to know where to jump into the stages of macros implementing the for loop according to passwords length prestored in the variable wordlength

			j = 1
			k = 0

			repeat	63

			lea	ax, @catstr (entry_handle, <%j>)
			mov	@catstr(<entry_handlex_offsets_table>,<[%(2*k)]>), ax
			j = j+1
			k = k+1

			endm


; print entry_handlex_offsets_table

mov	bp, 0
xor	eax, eax
cld

loop1013:

mov	di, bp
add	di, bp

mov	ax, word ptr ds:entry_handlex_offsets_table[di]
puti
mov	al, 20h
putc
inc	bp
cmp	bp, 63
jz	make_a_table_end
jmp	loop1013

make_a_table_end:

putcr
putcr


; create the password_file and open it for writing


				mov	ah, 3ch						;create new file named password.lst
				lea	dx, password_file
				mov	cx, 0
				int 21h

				jc	error
				mov	password_file_handle, ax

				mov	ah, 3dh						; open the file password.lst for writing
				mov	al, 1
				int 21h

				jc	error


; initialize dx to password address usefull to save passwords using int 21h

				xor	ah, ah
				mov	al, wordlength
				lea	dx, password
				add	dx, 63
				sub	dx, ax


; jump into the stages of macro implementing the for loop using the previous table and the password length specified and prestored in variable wordlength


				mov	bx, 63
				sub	bl, wordlength
xor	ah, ah
mov	al, wordlength
puti
putcr
				add	bx, bx
				mov	di, ds:entry_handlex_offsets_table[bx]
mov	ax, di
puti
putcr
				jmp	di



;__________________________________________________________________________________________________________







; at this point begin the for loop

		generate:


		entry_handle1:

				mov	bp, 0			; save away the actual index into array password

				mov	si, position		; save away the actual password byte position minus one. the hole behave as an index that will be used to access arrays

				xor	bh, bh


; note: within the program, entry_handlex goes from entry_handle1 to entry_handle63


;check to see if a character is obligatory at this position if so it might already have been stored and consonant_mark migth already have been set jump to entry_handle1blast

				mov	al, imperative_position_table[si]
				cmp	al, 0
				jz	entry_handle1a
				cmp	direction, 0
				jnz	entry_handle1blast
				jmp	point_after_for_macro_stages



	entry_handle1a:


; increment password byte number x
				inc	byte ptr password[bp]

; save the byte byte ptr password[bp] into bl

				mov	bl, byte ptr password[bp]

; set consonant_mark to 1 if the actual byte is a consonant weither uppercase or lowercase else set it to 0

				mov	di, bx
				sub	di, 20h
				mov	al, consonant_lookup_table[di]
				cmp	al, 1
				jnz	entry_handle1c1
				mov	consonant_mark[si], 1
				jmp	entry_handle1c2
		entry_handle1c1:
				mov	consonant_mark[si], 0
		entry_handle1c2:


; check to see if the alphabet cycle 1 round if so reinitialize the password using password_copy or something else except for position=0 where the program must leave the stages of macro implementing the for loop

	; check if only lowercases are authorized if so compare byte ptr password[bx] against ...caracter z ascii code and if greater reinitialize the password[bx] to a ascii code and jump if position is deferent of 1 to entry_handle&x_1& else jump to the end of the stages of macro that implement the for loop

				mov	eax, dword ptr alphabettype			; temporary save

				cmp	eax, 00003100h
				jnz	entry_handle1b1
				cmp	bl, 7ah
				jg	entry_handle1b2

				jmp	entry_handle1b10

	entry_handle1b2:
				jmp	point_after_for_macro_stages

	entry_handle1b1:

	; check if only uppercases are authorized if so compare byte ptr password[bx] against ...caracter Z ascii code and if greater reinitialize the password[bx] to A ascii code and jump if x if deferent of 1 to entry_handlex-1 else jump to the end of the stages of macro that implement the for loop

				cmp	eax, 00000031h
				jnz	entry_handle1b4
				cmp	bl, 5ah
				jg	entry_handle1b3
				jmp	entry_handle1b10

	entry_handle1b3:
				jmp	point_after_for_macro_stages
	entry_handle1b4:


	; check if only digits are authorized if so compare byte ptr password[bx] against ...9 ascii code and if greater reinitialize the password[bx] to A ascii code and jump if x if deferent of 1 to entry_handlex-1 else jump to the end of the stages of macro that implement the for loop

				cmp	eax, 00310000h
				jnz	entry_handle1b6
				cmp	bl, 39h
				jg	entry_handle1b5
				jmp	entry_handle1b10

	entry_handle1b5:
				jmp	point_after_for_macro_stages

	entry_handle1b6:


	; check if only others caracters are authorized if so compare byte ptr password[bx] against 7eh and if greater reinitialize the password[bx] to 20h and jump if x if deferent of 1 to entry_handlex-1 else jump to the end of the stages of macro that implement the for loop

				cmp	eax, 31000000h
				jnz	entry_handle1b8
				cmp	bl, 7eh
				jg	entry_handle1b7
				jmp	entry_handle1b10

		; at this point try to boost the program by jumping cause others caracters boundary are discontinuous

; ...

	entry_handle1b7:
				jmp	point_after_for_macro_stages

	entry_handle1b8:

				cmp	bl, 7eh
				jg	entry_handle1b9
				jmp	entry_handle1b10

	entry_handle1b9:
				jmp	point_after_for_macro_stages

	entry_handle1b10:


; check if the actual byte is authorized using the WPA2_valid_alphabet_table else increment the byte by jumping to entry_handle1a

				mov	al, byte ptr WPA2_valid_alphabet_table[bx-32]
				cmp	al, 1
				jz	entry_handle1a

; check if the actual byte is authorized at this position using the table non_permitted_position_table else increment the byte by jumping to entry_handle1a

				mov	di, si
				imul	di, 95
				add	di, bx
				sub	di, 20h
				mov	al, byte ptr non_permitted_position_table[di]
				sub	al, 1
				xor	ah, ah
				cmp	ax, si
				jz	entry_handle1a


; check if the actual byte combination with the previous one is authorized using the table non_combination_table else increment the byte by jumping to entry_handle1a

	; first check if the actual position is greater than or equal to 2. if not jmp to entry_handle1blast

				cmp	si, 1
				jl	entry_handle1blast

				mov	al, byte ptr password[bp-1]
				xor	ah, ah
				mov	di, ax
				sub	di, 32
				imul	di, 95
				add	di, bx
				sub	di, 32
				mov	al, byte ptr non_combination_table[di]
				cmp	al, 1
				jz	entry_handle1a


; in case non3combine_statut value is 1 if the actual byte is a consonant check if its combination with the two previous ones in case they are also consonants is authorized using the table non_combination_table and consonant_mark table else increment the byte by jumping to entry_handle1a

	; first check if the actual position is greater than or equal to 3. if not jmp to entry_handle1blast

				cmp	si, 2
				jl	entry_handle1blast

				cmp	non3combine_statut, 1
				jnz	entry_handle1b11

				mov	ax, word ptr consonant_mark[si-2]
				cmp	ax, 3131h
				jnz	entry_handle1b11
				cmp	consonant_mark[si], 1
				jnz	entry_handle1b11

				mov	al, password[bp-2]
				sub	al, 20h
				xor	ah, ah
				imul	ax, 95
				add	al, password[bp-1]
				sub	al, 20h					; try to keep ax from now on
				lea	di, non3_combination_table1
				add	di, ax
				cmp	non3_combination_table1[di], bl
				jne	entry_handle1b12
				jmp	entry_handle1b11
	entry_handle1b12:
				lea	di, non3_combination_table2
				add	di, ax
				cmp	non3_combination_table2[di], bl
				jne	entry_handle1b13
				jmp	entry_handle1b11
	entry_handle1b13:
				lea	di, non3_combination_table3
				add	di, ax
				cmp	non3_combination_table3[di], bl
				jne	entry_handle1b14
				jmp	entry_handle1b11
	entry_handle1b14:
				lea	di, non3_combination_table4
				add	di, ax
				cmp	non3_combination_table4[di], bl
				je	entry_handle1b11				
				jmp	entry_handle1a

	entry_handle1b11:


	entry_handle1blast:
				inc	position


; at this point stand the macro calls that terminates the for loop and that generate the password file contents

			l = 2
			m =1

			repeat	61

			macro_entry_handle	%l, %m
				inc	position
				mov	direction, 1
			l = l+1
			m = m+1

			endm



			macro_entry_handle	63, 62


				xor	cx, cx
				mov	cl, wordlength
				add	cx, 1
				mov	bx, password_file_handle
				mov	ah, 40h
				int 21h

				jc	error

				mov	direction, 0

				jmp	entry_handle63

; close the file



	point_after_for_macro_stages:



				mov	ax, 3eh						; close the file
				mov	bx, password_file_handle
				int 21h

				jc	error




;resume case r

		resume:




getc

		error:

		Quit:		mov ah, 4ch ;DOS opcode to quit program.
				int 21h ;Call DOS.


Main		endp

cseg            ends



sseg		segment	para stack 'stack'
stk		db	1024 dup ("stack   ")
sseg		ends



zzzzzzseg	segment	para public 'zzzzzz'
LastBytes	db	16 dup (?)
zzzzzzseg	ends
		end	Main