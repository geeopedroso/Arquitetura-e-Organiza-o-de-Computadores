.data

		vetor:	.space 40
		tamanho: 	.word 0x00000000

		str_tamanho: 	.asciiz "digite o tamanho do vetor: "
		str_digite:	.asciiz "digite o elemento"
		str_novaLinha:	.asciiz "\n"
		str_espaco: 	.asciiz ", "
		
		
	.text
	
main:
	jal preencheVetor
	jal Inicio
	
	
	
	
preencheVetor:
	
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	la $t3, vetor	#carrega vetor
	li $t0, 0	#indice em hexa
	li $t1, 0	#indice i
	
	
	li $v0, 4		#chamada para escrever no console
	la $a0, str_tamanho	#carrega a string para imprimir
	syscall			# executa a chamada do SO para ler
		
		
	li $v0, 4		#chamada para escrever no console
	la $a0, str_novaLinha	#carrega a string para imprimir
	syscall			# executa a chamada do SO para ler
		
	li $v0, 5		# código para ler um inteiro
	syscall			# executa a chamada do SO para ler
	la  $t2, 0($v0)		# carrega o inteiro lido em $t2
	la  $t6, tamanho
	sw  $t2, 0($t6)
	
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




.text


#inicio mergesort
Inicio:
	la	$a0, vetor		# carregando o vetor
	lw 	$t6, tamanho
	add	$t0, $zero, 0($t6) 		# carrega o tamanho do vetor
	sll	$t0, $t0, 2		# shift para� esquerda do tamanho do vetor
	add	$a1, $a0, $t0		# calcula o endereço final do vetor
	jal	mergesort		# chama a função  merge sort
  	b	Fim			# fim da ordenação
	


##
#      Funcao recursiva do mergesort 
#	Parametros
#      $a0 = primeiro endereco do vetor
#      $a1 = ultimo endereço do vetor
##

mergesort:

	addi	$sp, $sp, -16		# abrir espaço na pilha
	sw	$ra, 0($sp)		# salvar o endereço de retorno na pilha
	sw	$a0, 4($sp)		# salvando o inicio do vetor na pilha
	sw	$a1, 8($sp)		# salvando o fim do vetor na pilha
	
	sub 	$t0, $a1, $a0		# calcular a diferença ente o inicio e o fim 

	ble	$t0, 4, mergesortend	# se o vetor contem apenas 1 elemento, retorna
	
	srl	$t0, $t0, 3		# divide o tamanho do array por 8 para obter metade do numero de elementos
	sll	$t0, $t0, 2		# multiplique esse numero por 4 para obter a metade do tamanho do array
	add	$a1, $a0, $t0		# calcular o meio do vetor
	sw	$a1, 12($sp)		# salvar o meio do vetor na pilha
	
	jal	mergesort		# chama a função recursiva com a primeira metade do vetor
	
	lw	$a0, 12($sp)		# carrega da pilha o meio do vetor
	lw	$a1, 8($sp)		# carrega da pilha o final do vetor
	
	jal	mergesort		# chama a função recursiva com a segunda metade do vetor
	
	lw	$a0, 4($sp)		# carrega da pilha o começo do vetor
	lw	$a1, 12($sp)		# carrega da pilha o meio do vetor
	lw	$a2, 8($sp)		# carrega da pilha o final do vetor
	
	jal	merge			# junta as duas partes
	
mergesortend:				

	lw	$ra, 0($sp)		# carrega da pilha o endereço de retorno
	addi	$sp, $sp, 16		# apaga a pilha
	jr	$ra			# retorna
	
##
#  Juntar  os dois vetores ordenadamente
#   Parametros
#  $a0 inicio do primeiro vetor
#  $a1 inicio do segundo vetor
#  $a2 fim do segundo vetor
##

merge:
	addi	$sp, $sp, -16		# abrir espaço na pilha
	sw	$ra, 0($sp)		# salva na pilha o endereço de retorno
	sw	$a0, 4($sp)		# salva na pilha o inicio do vetor
	sw	$a1, 8($sp)		# salva na pilha o meio do vetor
	sw	$a2, 12($sp)		# salva na pilha o final do vetor
	
	move	$s0, $a0		# cria uma cópia do inicio do primeiro vetor
	move	$s1, $a1		# cria uma cópia do inicio do segundo vetor
	
mergeloop:

	lw	$t0, 0($s0)		# carrega o ponteiro do inicio do primeiro vetor
	lw	$t1, 0($s1)		# carrega o ponteiro do inicio do segundo vetor
	lw	$t0, 0($t0)		# carrega o primeiro valor do primeiro vetor
	lw	$t1, 0($t1)		# carrega o primeiro valor do segundo vetor
	
	bgt	$t1, $t0, naoMudar	# se o menor valor ja é o primeiro, nao mude
	
	move	$a0, $s1		# carrega o elemento 2 para mover
	move	$a1, $s0		# carrega o endereço do argumento 1 para mover
	jal	Mudar			# move o elemento para a nova posição 
	
	addi	$s1, $s1, 4		# incrementa o idice


naoMudar:
	addi	$s0, $s0, 4		# Incrementa o indice 
	
	lw	$a2, 12($sp)		# recarrega o endereço do final
	bge	$s0, $a2, mergeloopend	# encerra o loop quando as duas metades estao vazias
	bge	$s1, $a2, mergeloopend	# encerra o loop quando as duas metades estao vazias
	b	mergeloop

		
mergeloopend:
	
	lw	$ra, 0($sp)		# carrega o endereço de retorno
	addi	$sp, $sp, 16		# apaga a pilha
	jr 	$ra			# Retorna

##
# 	Mover o elemento para a posição certa
#	Parametros
#	$a0 = endereço do elemento a ser mudado  
#	$a1 = endereço destino
##
Mudar:
	li	$t0, 10
	ble	$a0, $a1, shiftend	# se ja tiver no lugar, pare de mudar
	addi	$t6, $a0, -4		# encontra o endereço anterior do vetor
	lw	$t7, 0($a0)		# pega o ponteiro atual
	lw	$t8, 0($t6)		# pega o ponteiro anterior
	sw	$t7, 0($t6)		# salva o ponteiro atual para o endereço anterior
	sw	$t8, 0($a0)		# salva o ponteiro anterior no endereço atual
	move	$a0, $t6		# voltar a posição atual 
	b 	Mudar			
shiftend:
	jr	$ra			# retorna
	
Fim:				# ponto para pular quando a ordenação terminar


# funcao que imprime o vetor
	li	$t0, 0				# inicializa o index
printar:
	lw	$t1, tamanho	# carrega o tamanho do vetor
	bge	$t0,$t1,final_Print			# verifica se chegou no final do vetor
	sll	$t2,$t0,2			# acresenta +4 no index hexa
	lw	$t3,vetor($t2)			# pega o ponteiro do vetor
	lw	$a0,0($t3)			# pega o valor para printar
	li	$v0,1				
	syscall					# printa
	la	$a0,str_espaco				# seta o espa�o
	li	$v0,4				
	syscall					# Print the value
	addi	$t0,$t0,1			# Increment the current index
	b	printar				# Run through the print block again
final_Print:						# We are finished
	li	$v0,10
	syscall
	
