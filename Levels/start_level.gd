extends Node3D

signal player_added(amount)
signal player_removed()

@export var next_level: int = 0

@onready var player_spawn_pos := $PlayerSpawnPos

var players_in_start: int = 0


func _ready() -> void:
	$DeathZone.body_entered.connect(_kill.bind())
	$StartArea.body_entered.connect(add_player.bind())
	$StartArea.body_exited.connect(remove_player.bind())


func _kill(body):
	if body is Player:
		body.respawn(player_spawn_pos.global_position)


func add_player(body):
	if body is Player:
		players_in_start += 1
		emit_signal("player_added", players_in_start)


func remove_player(body):
	if body is Player:
		players_in_start -= 1
		emit_signal("player_removed")
