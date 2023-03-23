class_name Level
extends Node3D

signal level_finished

var next_level: int
var player_spawn_point: NodePath

@onready var finish := $Finish

func _ready() -> void:
	finish.body_entered.connect(finished.bind())


func finished(body):
	emit_signal("level_finished")
