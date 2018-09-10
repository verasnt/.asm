	.data

stri:	.word	'a','a','a','b','b','b','a','a','a'
tam:	.word	9

	.text

start:	la	$t0,stri			# Carrega o endereco do vetor no registrador $t0
	la	$t1,tam				# Carrega o endereco do tamanho do vetor no registrador $t1
	sub	$t1,$t1,4			# Coloca em $t1 a ultima positivo do vetor que sera analisado
	lw	$t2,tam				# Carrega o conteudo da memoria de tam no registrador $t2
	sra	$t2,$t2,1			# Realiza o deslocamento dos bits para a direita para dividir por dois o tamanho do vetor
loop:	lw	$v0,($t0)			# Carrega em $v0 o conteudo apontado pelo endereco contido em $t0
	lw	$v1,($t1)			# Carrega em $v1 o conteudo apontado pelo endereco contido em $t1
	bne	$v0,$v1,not_palindrome	# Compara os conteudos se nao forem iguais para a executado do programa
	beqz 	$t2,palindrome		# Verifica se a variavel $t2 e zero se for chegou ao final do teste 
	sub	$t1,$t1,4			# Subtrai 4 do endereco contido em $t1
	add	$t0,$t0,4			# Adiciona 4 ao endere�o contido em $t0
	sub	$t2,$t2,1			# Dimini 1  do contador de bytes da palavra
	j	loop				
	

palindrome:	li	$a0,0xffff		# Se a palavra for um palindrome escreve ffff no $a0
		j	fim

not_palindrome:	li $a0, 0xabcd		# Se a palavra nao for um palindrome escreve abcd no $a0
			j	fim

fim:
