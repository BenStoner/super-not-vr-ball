extends RigidBody3D

@export var speed: float = 10
@export var max_speed: float = 20

var move_direction := Vector3.ZERO

@onready var camera := $InterpolatedCamera3D
@onready var camera_target := $CameraTarget



func _physics_process(_delta):
	# Movement
	move_direction = Vector3.ZERO
	move_direction.x = Input.get_axis("move_left", "move_right")
	move_direction.z = Input.get_axis("move_forward", "move_backward")
	move_direction = move_direction.rotated((Vector3.UP), camera.rotation.y).normalized()

	if not Input.is_action_pressed("brake"):
		apply_central_force(move_direction * speed)

	print(move_direction)

	# Braking
	if Input.is_action_pressed("brake"):
		linear_velocity.x = lerp(linear_velocity.x, 0.0, 0.1)
		linear_velocity.z = lerp(linear_velocity.z, 0.0, 0.1)
		rotation.x = lerp(rotation.x, 0.0, 0.1)
		rotation.z = lerp(rotation.z, 0.0, 0.1)

	# Small jump if not moving
	if linear_velocity.x <= 0.15 and linear_velocity.y <= 0.15 and linear_velocity.y <= 0.15 and linear_velocity.x >= -0.15 and linear_velocity.y >= -0.15 and linear_velocity.y >= -0.15:
		if Input.is_action_just_pressed("jump"):
			apply_central_force(Vector3.UP * 200)

	# Limits soeed
	if abs(get_linear_velocity().x) > max_speed or abs(get_linear_velocity().y) > max_speed or abs(get_linear_velocity().z) > max_speed\
	or abs(get_linear_velocity().x) < -max_speed or abs(get_linear_velocity().y) < -max_speed or abs(get_linear_velocity().z) < -max_speed:
		var new_speed = get_linear_velocity().normalized()
		new_speed *= max_speed
		set_linear_velocity(new_speed)

	camera_target.global_position.x = global_position.x
	camera_target.global_position.y = global_position.y + 3.5
	camera_target.global_position.z = global_position.z + 8
#	camera_target.look_at(global_position)

