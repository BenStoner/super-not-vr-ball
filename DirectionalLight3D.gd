@tool
class_name SkyLight
extends DirectionalLight3D

@export_range(0, 24) var time_of_day: float = 0


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		set_day_time()
	else:
		set_day_time()

		time_of_day += delta / 60


func set_day_time():
	var output = remap(time_of_day, 0, 24, -270, 90)
	rotation_degrees.x = lerp(rotation_degrees.x, output, 0.1)
