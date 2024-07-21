extends CharacterBody2D

@export var speed: float = 3
@export var sword_damage: int = 2

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer #filho do animation player
@onready var sword_area: Area2D = $SwordArea

var input_vector: Vector2 = Vector2(0, 0)
var is_running: bool = false #checkbox do space, se era sim vira nao, se nao vira sim
var was_running: bool = false #checkbox do space, se era sim vira nao, se nao vira sim
var is_attacking: bool = false
var attack_cooldown: float = 0.0 #temporizador de reinicio de ataque


func _process(delta: float) -> void:
	#leitura de onde esta o player
	GameManager.player_position = position
	
	# Ler input
	read_input()
	
	# Processar ataque
	update_attack_cooldown(delta)
	
	# Ataque
	if Input.is_action_just_pressed("attack"):
		attack()

	#Processar animacao e rotacao de sprite
	play_run_idle_animation()
	rotate_sprite()


#troca animacao do player (depreceated)
#func _process(delta: float) -> void:
#if Input.is_action_just_pressed("move_up"): 
		#if is_running:
			#animation_player.play("idle")
			#is_running = false
		#else:
			#animation_player.play('run')
			#is_running = true

func _physics_process(delta: float) -> void: #executado em frequencia fixa, melhora desempenho
	# Modificar a velocidade
	var target_velocity = input_vector * speed * 100.0
	if is_attacking: #velocidade para atk
		target_velocity = target_velocity * 0.25
	velocity = lerp(velocity, target_velocity, 0.85)
	move_and_slide()

func update_attack_cooldown(delta: float) -> void:
	#atualizar temporizador do ataque
	if is_attacking:
		attack_cooldown -= delta # a cada atualizacao do jogo, temporizador diminui (cooldown) / 0.6 - 0.016 diminuindo ate ficar menor que 0
		if attack_cooldown <= 0.0:#temporizador quando menor que 0 nao esta mais atacando
			is_attacking = false
			is_running = false
			animation_player.play('idle')

func read_input() -> void:
	
		# Obter o input vector
	input_vector = Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')

	# Apagar deadzone do input vector
	var deadzone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.0

		# Atualizar o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func play_run_idle_animation() -> void:
# Tocar animacao
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play('run')
			else:
				animation_player.play('idle')

func rotate_sprite() -> void:
		# Girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
		#desmarcar flip_h do Spride2d
	elif input_vector.x < 0:
		sprite.flip_h = true
		#marcar flip_h do Spride2d

func attack() -> void:
	if is_attacking:
		return
	#attack_side_1
	# attack_side_2
	#tocar animacao
	animation_player.play("attack_side_1")
	
	#configurar temporizador 
	attack_cooldown = 0.6
	# Marcar ataque
	is_attacking = true
	
	
	# Aplicar dano nos inimigos
	#deal_damage_to_enemies()

func deal_damage_to_enemies() -> void:
	var bodies = sword_area.get_overlapping_bodies() #pegar corpos dentro das areas, como corpo de um pawn
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			enemy.damage(sword_damage)

#depreceated anterior teste colisao sword
#	var enemies = get_tree().get_nodes_in_group("enemies")
#	for enemy in enemies:
#		enemy.damage(sword_damage)
		
	#print("Enemies: ", enemies.size())
	# Acessar todos os inimigos
	# Chamar a função "damage"
	# Primeiro parametro com "sword_damage"
