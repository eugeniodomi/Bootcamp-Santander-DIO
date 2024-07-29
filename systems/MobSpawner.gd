class_name MobSpawner
extends Node2D

@export var creatures: Array[PackedScene]
var mobs_per_minute: float = 60.0

@onready var path_follow_2d: PathFollow2D = %PathFollow2D
var cooldown: float = 0.0


func _process(delta: float):
		# Ignorar GameOver
	if GameManager.is_game_over: return
	
		# Temporizador (cooldown)
	cooldown -= delta
	if cooldown > 0: return
	
	# Frequencia: Monstros por minuto
	var interval = 60.0 / mobs_per_minute
	cooldown = interval

	# Checar se o ponto é válido
	var point = get_point()
	var world_state = get_world_2d().direct_space_state #pegar o mundo 2d do game, acessando o estado do mundo (sabe se tem colisoes de obj)
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1000 #ulitzando bits para testar colisao
	var result: Array = world_state.intersect_point(parameters, 1) #array, perguntando colisoes
	if not result.is_empty(): return
	# Perguntar pro jo se esse ponto tem colisão


	# Instanciar uma criatura aleatória
	var index = randi_range(0, creatures.size() - 1)
	var creature_scene = creatures[index]
	var creature = creature_scene.instantiate()
	creature.global_position = point #ponto aleatorio para spawn
	get_parent().add_child(creature)

func get_point() -> Vector2: #criar mo0nstro aleatorio
	path_follow_2d.progress_ratio = randf() # Random Float
	return path_follow_2d.global_position
	

	#else:
	#		print("O array creatures está vazio!")
	
		# - Pegar ponto aleatório
	# - Instanciar cena
	# - Colocar na posição
	

	#Logica
	# 60 monstros/min = 1 monstro por segundo
	# 120 monstos/ min = 2 monstro por segundo
	#intervalo em segundos entre monstros => 60 / frequencia
	# 60 /60 = 1
	# 60 / 120 = 0.5
	# 60 / 30 = 2

#voltar em 10:46
