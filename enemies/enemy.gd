class_name Enemy
extends Node2D


@export var health: int = 10

func damage(amount: int) -> void:
	health -= amount
	print('Inimigo recebeu dano de ', amount, '. A vida total é de ', health) 
	#verificar se der espadada, for chamado este metodo,
	#detectado os inimigos e chamado funcao de 1 script em outro
	


