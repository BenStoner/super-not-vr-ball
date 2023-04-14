@tool
class_name SkyLight
extends DirectionalLight3D

@export var day_speed: float = 1

@export var day_cycle: bool = false
@export_range(0, 24) var time_of_day: float = 0


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		set_day_time()
	elif day_cycle == true:
		set_day_time()
		time_of_day += delta / 60 * day_speed


func set_day_time():
	var output = remap(time_of_day, 0, 24, -270, 90)
	rotation_degrees.x = lerp(rotation_degrees.x, output, 0.1)
