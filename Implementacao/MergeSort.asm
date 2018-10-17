

.data
		vetor:	.space 40

		str_tamanho: 	.asciiz "digite o tamanho do vetor: "
		str_digite:	.asciiz "digite o elemento: "
		str_novaLinha:	.asciiz "\n"
		espaco: 	.asciiz ", "
		
		
		
	.text
	
main:
	jal preencheVetor
	j	Inicio
	
	
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
	
carrega:

	beq $t1, $t2, fimP
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
		
fimP: 
	lw	$ra, 0($sp)		# carrega da pilha o endereço de retorno
	addi	$sp, $sp, 4		# apaga a pilha
	jr	$ra









Inicio:
	la	$a0, vetor		# carregando o vetor
	add	$t0, $zero, $t2		# carrega o tamanho do vetor
	sll	$t0, $t0, 2		# shift � esquerda do tamanho do vetor
	add	$a1, $a0, $t0		# calcula o endere�o final do vetor
	jal	mergesort		# chama a fun��o  merge sort
  	j	Fim			# fim da ordena��o
	


##
#      Fun��o recursiva do mergesort 
#	Parametros
#      $a0 = primeiro endere�o do vetor
#      $a1 = ultimo endere�o do vetor
##

mergesort:

	addi	$sp, $sp, -16		# abrir espa�o na pilha
	sw	$ra, 0($sp)		# salvar o endere�o de retorno na pilha
	sw	$a0, 4($sp)		# salvando o inicio do vetor na pilha
	sw	$a1, 8($sp)		# salvando o fim do vetor na pilha
	
	sub 	$t0, $a1, $a0		# calcular a diferen�a ente o inicio e o fim 

	ble	$t0, 4, mergesortend	# se o vetor contem apenas 1 elemento, retorna
	
	srl	$t0, $t0, 3		# divide o tamanho do array por 8 para obter metade do numero de elementos
	sll	$t0, $t0, 2		# multiplique esse numero por 4 para obter a metade do tamanho do array
	add	$a1, $a0, $t0		# calcular o meio do vetor
	sw	$a1, 12($sp)		# salvar o meio do vetor na pilha
	
	jal	mergesort		# chama a fun��o recursiva com a primeira metade do vetor
	
	lw	$a0, 12($sp)		# carrega da pilha o meio do vetor
	lw	$a1, 8($sp)		# carrega da pilha o final do vetor
	
	jal	mergesort		# chama a fun��o recursiva com a segunda metade do vetor
	
	lw	$a0, 4($sp)		# carrega da pilha o come�o do vetor
	lw	$a1, 12($sp)		# carrega da pilha o meio do vetor
	lw	$a2, 8($sp)		# carrega da pilha o final do vetor
	
	jal	merge			# junta as duas partes
	
mergesortend:				

	lw	$ra, 0($sp)		# carrega da pilha o endere�o de retorno
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
	addi	$sp, $sp, -16		# abrir espa�o na pilha
	sw	$ra, 0($sp)		# salva na pilha o endere�o de retorno
	sw	$a0, 4($sp)		# salva na pilha o inicio do vetor
	sw	$a1, 8($sp)		# salva na pilha o meio do vetor
	sw	$a2, 12($sp)		# salva na pilha o final do vetor
	
	addu	$s0, $zero, $a0		# cria uma c�pia do inicio do primeiro vetor
	addu	$s1, $zero, $a1		# cria uma c�pia do inicio do segundo vetor
	
mergeloop:

	lw	$t0, 0($s0)		# carrega o ponteiro do inicio do primeiro vetor
	lw	$t1, 0($s1)		# carrega o ponteiro do inicio do segundo vetor
	add	$t0, $zero, $t0		# carrega o primeiro valor do primeiro vetor
	add	$t1, $zero, $t1		# carrega o primeiro valor do segundo vetor
	
	bgt	$t1, $t0, naoMudar	# se o menor valor ja � o primeiro, nao mude
	
	addu	$a0, $zero $s1		# carrega o elemento 2 para mover
	addu	$a1, $zero, $s0		# carrega o endere�o do argumento 1 para mover
	jal	Mudar			# move o elemento para a nova posi��o 
	
	addi	$s1, $s1, 4		# incrementa o idice


naoMudar:
	addi	$s0, $s0, 4		# Incrementa o indice 
	
	lw	$a2, 12($sp)		# recarrega o endere�o do final
	bge	$s0, $a2, mergeloopend	# encerra o loop quando as duas metades estao vazias
	bge	$s1, $a2, mergeloopend	# encerra o loop quando as duas metades estao vazias
	j	mergeloop

		
mergeloopend:
	
	lw	$ra, 0($sp)		# carrega o endere�o de retorno
	addi	$sp, $sp, 16		# apaga a pilha
	jr 	$ra			# Retorna

##
# 	Mover o elemento para a posi��o certa
#	Parametros
#	$a0 = endere�o do elemento a ser mudado  
#	$a1 = endere�o destino
##
Mudar:
	li	$t0, 10
	ble	$a0, $a1, shiftend	# se ja tiver no lugar, pare de mudar
	addi	$t6, $a0, -4		# encontra o endere�o anterior do vetor
	lw	$t7, 0($a0)		# pega o ponteiro atual
	lw	$t8, 0($t6)		# pega o ponteiro anterior
	sw	$t7, 0($t6)		# salva o ponteiro atual para o endere�o anterior
	sw	$t8, 0($a0)		# salva o ponteiro anterior no endere�o atual
	addu	$a0, $zero, $t6		# voltar a posi��o atual 
	j 	Mudar			
shiftend:
	jr	$ra			# retorna
	
Fim:				# ponto para pular quando a ordena��o terminar


# funcao que imprime o vetor
	
	add	$t1, $zero, $t2					# inicia o index com 0
	
	la	$t3, vetor	#carrega o ponteiro do vetor
	li 	$t4, 0		#ponteiro para o valor atual
	li	$t0, 0 		#indice i
	li	$t5, 0		#indice em hexa
prloop:
			
	bge	$t0,$t1,prdone		# se o indice chegar no fim, encerra
	add $t4, $t3, $t5		#pega o ponteiro para o valor atual
	
	lw	$a0, 0($t4)		#pega o valor para printar
	li	$v0,1			#chamada para imprimir inteiro
	syscall					
	
	la	$a0,espaco		#carrega a string			
	li	$v0,4			#chamada para imprimir string
	syscall					
	
	addi	$t0, $t0, 1		#incrementa o index i
	addi	$t5, $t5, 4		#incrementa o index em hexa
	j	prloop				
prdone:						
	li	$v0,10
	syscall
