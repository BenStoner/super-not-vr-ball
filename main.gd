extends Node3D

@export var levels: Array[PackedScene] = []

var current_level
var start_level

func _ready() -> void:
	start_level = levels[0]
	var start_level_instance = start_level.instantiate()
	current_level = start_level_instance
	add_child(start_level_instance)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		change_level(1)


func change_level(to: int):
	current_level.queue_free()
	var level_instance = levels[to].instantiate()
	current_level = level_instance
	print(current_level)
	add_child(level_instance)
	$Ball.global_position = Vector3.ZERO
