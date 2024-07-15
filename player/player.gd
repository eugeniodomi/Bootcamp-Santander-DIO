extends CharacterBody2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer #filho do animation player

var is_running: bool = false #checkbox do space, se era sim vira nao, se nao vira sim

#troca animacao do player
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"): 
		if is_running:
			animation_player.play("idle")
			is_running = false
		else:
			animation_player.play('run')
			is_running = true
