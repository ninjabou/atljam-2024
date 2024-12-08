extends Node

signal player_kill
signal register_player(player: CharacterBody2D)

var player: CharacterBody2D = null

func _ready() -> void:
	self.register_player.connect(on_register_player)

func kill_player():
	self.player_kill.emit()

func on_register_player(the_player):
	player = the_player
