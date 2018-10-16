.data

	str_dgt: 	.asciiz "digite o tamanho do vetor: "
	str_novaLinha:	.asciiz "\n"

.text


.globl inicio
	
	inicio:
		li $v0, 4		#chamada para escrever no console
		la $a0, str_dgt		#carrega a string para imprimir
		syscall			# executa a chamada do SO para ler
		
		
		li $v0, 4		#chamada para escrever no console
		la $a0, str_novaLinha	#carrega a string para imprimir
		syscall			# executa a chamada do SO para ler
		
		li $v0, 5		# código para ler um inteiro
		syscall			# executa a chamada do SO para ler
		la  $t7, 0($v0)		   # carrega o inteiro lido em $t7
		j   fim			   # encerra o programa
	
	
			

		
	fim:
		li $v0, 10	# código para encerrar o programa
syscall # executa a chamada do SO para encerrar
