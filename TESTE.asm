	.data
	

		str_dgt: 	.asciiz "digite o tamanho do vetor: "
		str_novaLinha:	.asciiz "\n"
		
		vetor:	.space 40
		
	.text
	
	
	

	
preencheVetor:
	
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	la $t4, vetor	#carrega vetor
	li $t0, 0	#indice em hexa
	li $t2, 0	#indice i
	
	
	li $v0, 4		#chamada para escrever no console
	la $a0, str_dgt		#carrega a string para imprimir
	syscall			# executa a chamada do SO para ler
		
		
	li $v0, 4		#chamada para escrever no console
	la $a0, str_novaLinha	#carrega a string para imprimir
	syscall			# executa a chamada do SO para ler
		
	li $v0, 5		# código para ler um inteiro
	syscall			# executa a chamada do SO para ler
	la  $t1, 0($v0)		   # carrega o inteiro lido em $t7
	
carrega:

	beq $t2, $t1, fimm
	add $t3, $t4, $t0
	
	li $v0, 5
	syscall
	sw $v0, 0($t3)
	
	addi $t0, $t0, 4
	addi $t2, $t2, 1
	
	j carrega
		
fim: 
	lw	$ra, 0($sp)		# carrega da pilha o endereço de retorno
	addi	$sp, $sp, 4		# apaga a pilha
	jr	$ra
fimm:

