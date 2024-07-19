extends CharacterBody2D

@export var speed: float = 1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D #variavel carregada apenas quando este node estiver completo



func _physics_process(delta: float) -> void:
	#var player_position = Vector2(0, 0) / depreceated
	
	# Calcula a direcao 
	var player_position = GameManager.player_position
	var difference = player_position - position 
	var input_vector = difference.normalized() #diferenca normalizada
	
	# Movimento
	velocity = input_vector * speed * 100.0
	move_and_slide()


#script com calculos de vetores teste

	# Girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
