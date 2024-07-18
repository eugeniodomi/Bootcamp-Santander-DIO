extends CharacterBody2D

@export var speed: float = 1



func _physics_process(delta: float) -> void:
	var player_position = Vector2(0, 0)
	var difference = player_position - position 
	var input_vector = difference.normalized() #diferenca normalizada
#	input vector = vector2 que varia entre -1 e 1 em ambos os eixos
#	velocity = input vector * speed * 100.8
	velocity = input_vector * speed * 100.0
	move_and_slide()

#script com calculos de vetores teste
