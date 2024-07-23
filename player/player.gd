class_name Player
extends CharacterBody2D


@export_category("Movement") #categorias dentro do player
@export var speed: float = 3
@export_category("Sword")
@export var sword_damage: int = 2
@export_category("Ritual")
@export var ritual_damage: int = 1
@export var ritual_interval: float = 30
@export var ritual_scene: PackedScene
#Dano do ritual
#Intervalo
#Cena



@export_category("Life")
@export var health: int = 100
@export var max_health: int = 100
@export var death_prefab: PackedScene



@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer #filho do animation player
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea

var input_vector: Vector2 = Vector2(0, 0)
var is_running: bool = false #checkbox do space, se era sim vira nao, se nao vira sim
var was_running: bool = false #checkbox do space, se era sim vira nao, se nao vira sim
var is_attacking: bool = false
var attack_cooldown: float = 0.0 #temporizador de reinicio de ataque
var hitbox_cooldown: float = 0.0 #hitbox temporizador
var ritual_cooldown: float = 0.0

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
	if not is_attacking:
		rotate_sprite()
	
	# Processar dano
	update_hitbox_detection(delta)

	# Ritual
	update_ritual(delta)
	

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

func update_ritual(delta: float) -> void:
	#Atualizar temporizador
	ritual_cooldown -= delta
	if ritual_cooldown > 0: return
	#Resetar temporizador
	ritual_cooldown = ritual_interval
	
	#Criar ritual
	var ritual = ritual_scene.instantiate()
	#setar ritualdamage com damageamount 
	ritual.damage_amount = ritual_damage
	add_child(ritual) #ritual se mexe junto com player

	
	
	
	pass

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
	#funcao que busca todos inimigos na area, aplica o dano nos mesmos
	
	var bodies = sword_area.get_overlapping_bodies() #pegar corpos dentro das areas, como corpo de um pawn
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized() #vetor normalizado com 1 de movimento
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.3:
				enemy.damage(sword_damage)
			#print("Dot: ", dot_product)


#depreceated anterior teste colisao sword
#	var enemies = get_tree().get_nodes_in_group("enemies")
#	for enemy in enemies:
#		enemy.damage(sword_damage)
		
	#print("Enemies: ", enemies.size())
	# Acessar todos os inimigos
	# Chamar a função "damage"
	# Primeiro parametro com "sword_damage"

#colado de enemy


func update_hitbox_detection(delta: float) -> void:
	#Temporizador
	hitbox_cooldown -= delta # tira o tempo de cada frame para ir diminuindo
	if hitbox_cooldown > 0: return
	
	#Frequencia (2x por segundo)
	hitbox_cooldown = 0.5
	
	# HitboxArea
	
	# Detectar inimigos
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = 1 #processando dano recebido ao player
			damage(damage_amount)
			



func damage(amount: int) -> void:
	if health <= 0: return #caso personagem estiver morto, ta morto kkj
	
	
	# Caso contrario, processa os danos de vida:
	health -= amount
	print("Player recebeu dano de ", amount, ". A vida total é de ", health) 
	#verificar se der espadada, for chamado este metodo,
	#detectado os inimigos e chamado funcao de 1 script em outro
	
	# Piscar inimigo ao receber dano
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(tween.EASE_IN) #buscado a curva no site
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	# Processar morte
	if health <= 0:
		die()

func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	print('Player foi de arrasta pra cima!')
	queue_free()

func heal(amount: int) -> int: #funcao de curar com itens
	health += amount
	if health > max_health:
		health = max_health
	print('Player recebeu cura de ', amount, '. A vida total é de ', health, '/', max_health )
	return health
	
