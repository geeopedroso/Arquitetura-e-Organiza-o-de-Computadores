
	.data
	
_spaces: 	.asciiz" "

Array1: 	.word	7	16	3	1	5	9	8	2	6
	4	10	15	19	13	14	17	20	18	12	11
	
Array2: 	.word	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0
	
	.text
	.globl main

main:

	addi	$sp, $sp, -4	#alocar espaço na pilha para o endereço de retorno
	sw	$ra, 0($sp)	#salvar o endereço de retorno
	
	#carregar endereço do array
	la	$a0, Array2	#endereçp do array temporario	
	la	$a1, Array1	#carregar endereço do array a ser ordenado
	addi	$a2, $zero, 20	#carrega o tamanho do array para o $a2
	and 	$a3 $zero, $zero

	or 	$t0, $a1, $zero
	or 	$t3, $a2, $zero
	
	and 	$t4, $zero, $zero
	j 	Imprime
	
	
	
Imprime:

	slt	$t6, $t4, $a2
	beq	$t6, $zero, IniciaMergSort
	
	sll 	$t0, $t4, 2
	add	$t6, $a1, $t0
	
	li	$v0, 1
	lw 	$a0, 0($t6)
	syscall
	
	li	$v0, 4
	la	$a0, _spaces
	syscall
	
	addi 	$t4, $t4, 1
	j 	Imprime
	

IniciaMergSort:
	
	 addi	$sp, $sp, -16	#abrindo espaço na pilha
	 sw	$ra, 0($sp)	#retorna o endereço
	 sw	$a1, 8($sp)	#salva endereço do array nao ordenado
	 add	$a2, $a2, -1	#muda $a2 para tamanho -1
	 sw	$a2, 4($sp)	#salva o tamanho do (array-1)
	 sw	$a3, 0($sp)
	 jal	MSort
	 
	 
MSort:

	addi	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw 	$s1, 12($sp)
	sw	$s2, 8($sp)
	
	
	 
	 
	 
	  	


