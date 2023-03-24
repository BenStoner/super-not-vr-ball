class_name Level
extends Node3D

signal level_finished

var next_level: int = 2

@onready var finish := $Finish


func _ready() -> void:
	finish.body_entered.connect(finished.bind())


func finished(_body):
	emit_signal("level_finished")
