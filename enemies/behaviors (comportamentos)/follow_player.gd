extends Node

@export var speed: float = 1

#@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D #variavel carregada apenas quando este node estiver completo

var enemy: Enemy #var criada para puxar comportamentos do parent node2d
var sprite: AnimatedSprite2D


func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")


#comportamento do objeto: seguir o personagem player

func _physics_process(delta: float) -> void:
	#var player_position = Vector2(0, 0) / depreceated
	
	# Calcula a direcao 
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position 
	var input_vector = difference.normalized() #diferenca normalizada
	
	# Movimento
	enemy.velocity = input_vector * speed * 100.0
	enemy.move_and_slide()


#script com calculos de vetores teste

	# Girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
