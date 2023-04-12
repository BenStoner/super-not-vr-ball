extends SpringArm3D


@export var sensitivity: float = 0.05


func _ready() -> void:
	top_level = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 3.0)
		
		rotation_degrees.y -= event.relative.x * sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
