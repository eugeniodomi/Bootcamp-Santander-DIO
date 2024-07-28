extends Node

@export var mob_spawner: MobSpawner
@export var initial_spawn_rate: float = 60.0
@export var spawn_rate_per_minute: float = 30.0
@export var wave_duration: float = 20.0
@export var break_intensity: float = 0.5

var time: float = 0.0


func _process(delta: float) -> void:
	time += delta
	
	#Dificuldade linear (linha verde)
	var spawn_rate = initial_spawn_rate + spawn_rate_per_minute * (time / 60.0)
	
	#Sitema de ondas (linhda rosa)
	var sin_wave = sin((time * TAU) / wave_duration) #Tau= 2 PI
	var wave_factor = remap(sin_wave, -1.0, 1.0, break_intensity, 1)
	spawn_rate += wave_factor
	
	# Aplica a dificuldade
	mob_spawner.mobs_per_minute = spawn_rate
	
#	print("Time: %.2f, Wave: %.2f" % [time, wave])
	

