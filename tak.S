/*
 * Copyright (c) 2013 Kyle Isom <kyle@tyrfingr.is>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

	.data
result:	.asciiz	"takeuchi(x=%d, y=%d, z=%d) = %d\n"
args:	.word	18, 12, 6

	.text
	.globl	main

swap:
	xor	$a0,	$a0,	$a1
	xor	$a1,	$a1,	$a0
	xor	$a0,	$a0,	$a1
	j	$ra

/*
 * stack allocation: 32B (8 words)
 *	 0($sp):	x	(32b signed int)
 *	 4($sp):	y	(32b signed int)
 *	 8($sp):	z	(32b signed int)
 *	16($sp):	$ra	(64b unsigned address)
 *				must be aligned, so we have
 *				a 32b gap in the stack.
 *	24($sp):	first branch (32b signed int)
 *	28($sp):	second branch (32b signed int)
 *
 * note that the third branch is returned in $v0 already, so we
 * can shuffle it into $a2 easily.
 */
tak:
	ble	$a0,	$a1,	takexit
	addiu	$sp,	$sp,	-32
	sw	$a0,	0($sp)
	sw	$a1,	4($sp)
	sw	$a2,	8($sp)
	sd	$ra,	16($sp)

	addi	$a0,	$a0,	-1
	jal	tak
	sw	$v0,	24($sp)

	lw	$a0,	4($sp)
	lw	$a1,	8($sp)
	lw	$a2,	0($sp)
	addi	$a0,	$a0,	-1
	jal	tak
	sw	$v0,	28($sp)

	lw	$a0,	8($sp)
	addi	$a0,	$a0,	-1
	lw	$a1,	0($sp)
	lw	$a2,	4($sp)
	jal	tak
	
	lw	$a0,	24($sp)
	lw	$a1,	28($sp)
	move	$a2,	$v0
	ld	$ra,	16($sp)
	addiu	$sp,	$sp,	32
	j	tak
takexit:
	move	$v0,	$a2
	j	$ra

main:
	dla	$t0,	args
	lw	$a0,	0($t0)
	lw	$a1,	4($t0)
	lw	$a2,	8($t0)
	jal	tak

	dla	$a0,	result
	dla	$t0,	args
	lw	$a1,	0($t0)
	lw	$a2,	4($t0)
	lw	$a3,	8($t0)
	move	$a4,	$v0
	jal	printf

	ori	$v0,	$0,	1
	ori	$a0,	$0,	0
	syscall
