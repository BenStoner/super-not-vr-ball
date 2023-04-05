class_name Level
extends Node3D

signal level_finished(next_level, body)

@export var next_level: int = 0

@onready var finish := $Finish
@onready var player_spawn_pos := $PlayerSpawnPos


func _ready() -> void:
	finish.body_entered.connect(finished.bind())
	$DeathZone.body_entered.connect(_body_entered.bind())


func finished(body):
	emit_signal("level_finished", next_level, body)


func _body_entered(body):
	if body is Player:
		body.respawn(player_spawn_pos.global_position)
