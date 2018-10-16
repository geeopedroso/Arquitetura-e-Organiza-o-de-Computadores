	.data
		vetor:	.space 40

		str_tamanho: 	.asciiz "digite o tamanho do vetor: "
		str_digite:	.asciiz "digite o elemento"
		str_novaLinha:	.asciiz "\n"
		
		
		
	.text
	
main:
	jal preencheVetor
	j	fimm
	
	
preencheVetor:
	
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	la $t3, vetor	#carrega vetor
	li $t0, 0	#indice em hexa
	li $t1, 0	#indice i
	
	
	li $v0, 4		#chamada para escrever no console
	la $a0, str_tamanho		#carrega a string para imprimir
	syscall			# executa a chamada do SO para ler
		
		
	li $v0, 4		#chamada para escrever no console
	la $a0, str_novaLinha	#carrega a string para imprimir
	syscall			# executa a chamada do SO para ler
		
	li $v0, 5		# código para ler um inteiro
	syscall			# executa a chamada do SO para ler
	la  $t2, 0($v0)		   # carrega o inteiro lido em $t7
	
carrega:

	beq $t1, $t2, fim
	add $t4, $t3, $t0
	
	li $v0, 4		#chamada para escrever no console
	la $a0, str_digite		#carrega a string para imprimir
	syscall			# executa a chamada do SO para ler
			
	li $v0, 5
	syscall
	sw $v0, 0($t4)
	
	addi $t0, $t0, 4
	addi $t1, $t1, 1
	
	j carrega
		
fim: 
	lw	$ra, 0($sp)		# carrega da pilha o endereço de retorno
	addi	$sp, $sp, 4		# apaga a pilha
	jr	$ra
fimm:

