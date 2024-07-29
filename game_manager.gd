extends Node
#Singleton segurando a posicao do jogador
#jogdador vai falar para este satelite onde esta e inimigos vao procurar aqui o mesmo

signal game_over #para ouvir o gamover e ser chamado

var player: Player #variavel para segurar player
var player_position: Vector2
var is_game_over: bool = false

func end_game():
	if is_game_over: return
	is_game_over = true
	game_over.emit()


func reset():
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
