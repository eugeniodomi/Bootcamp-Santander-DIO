extends Node2D

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene

func _ready():
	GameManager.game_over.connect(trigger_game_over) 
	#assim que o signal do gamemanager for emitido, conectar nele funcao trigger

func trigger_game_over():
	# Deletar GameUI
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	
	#Criar GameOverUI
	var game_over_ui: GameOverUI = game_over_ui_template.instantiate()
	add_child(game_over_ui)
