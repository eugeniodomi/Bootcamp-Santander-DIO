extends CharacterBody2D

@export var speed: float = 3

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer #filho do animation player


var is_running: bool = false #checkbox do space, se era sim vira nao, se nao vira sim

#troca animacao do player
#func _process(delta: float) -> void:
#if Input.is_action_just_pressed("move_up"): 
		#if is_running:
			#animation_player.play("idle")
			#is_running = false
		#else:
			#animation_player.play('run')
			#is_running = true

func _physics_process(delta: float) -> void: #executado em frequencia fixa, melhora desempenho
	# Obter o input vector
	var input_vector = Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')
	
	# Apagar deadzone do input vector
	var deadzone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.0
	
	# Modificar a velocidade
	var target_velocity = input_vector * speed * 100.0
	velocity = lerp(velocity, target_velocity, 0.85)
	move_and_slide()
	
		# Atualizar o is_running
	var was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
	# Tocar animacao
	if was_running != is_running:
		if is_running:
			animation_player.play('run')
		else:
			animation_player.play('idle')
			
	# Girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
		#desmarcar flip_h do Spride2d
		pass
	elif input_vector.x < 0:
		sprite.flip_h = true
		#marcar flip_h do Spride2d
		pass
