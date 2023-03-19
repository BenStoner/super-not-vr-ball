extends Node3D

@export var speed: float = 10
@export var max_speed: float = 10

var move_direction := Vector3.ZERO

@onready var ball := $Ball
@onready var camera := $ControlCamera3D


func _physics_process(_delta):
	# Movement
	move_direction = Vector3.ZERO
	move_direction.x = Input.get_axis("move_left", "move_right")
	move_direction.z = Input.get_axis("move_forward", "move_backward")
	move_direction = move_direction.rotated((Vector3.UP), rotation.y).normalized()

	if not Input.is_action_pressed("brake"):
		if Input.is_action_pressed("move_forward"):
			ball.apply_central_force(move_direction * speed)
		if Input.is_action_pressed("move_backward"):
			ball.apply_central_force(move_direction * speed)
		if Input.is_action_pressed("move_left"):
			ball.apply_central_force(move_direction * speed)
		if Input.is_action_pressed("move_right"):
			ball.apply_central_force(move_direction * speed)

	# Braking
	if Input.is_action_pressed("brake"):
		ball.linear_velocity.x = lerp(ball.linear_velocity.x, 0.0, 0.2)
		ball.linear_velocity.z = lerp(ball.linear_velocity.z, 0.0, 0.2)

	# Small jump if not moving
	if ball.linear_velocity.x <= 0.15 and ball.linear_velocity.y <= 0.15 and ball.linear_velocity.y <= 0.15 and ball.linear_velocity.x >= -0.15 and ball.linear_velocity.y >= -0.15 and ball.linear_velocity.y >= -0.15:
		if Input.is_action_just_pressed("jump"):
			ball.apply_central_force(Vector3.UP * 200)

	# Limits soeed
	if abs(ball.get_linear_velocity().x) > max_speed or abs(ball.get_linear_velocity().y) > max_speed or abs(ball.get_linear_velocity().z) > max_speed\
	or abs(ball.get_linear_velocity().x) < -max_speed or abs(ball.get_linear_velocity().y) < -max_speed or abs(ball.get_linear_velocity().z) < -max_speed:
		var new_speed = ball.get_linear_velocity().normalized()
		new_speed *= max_speed
		ball.set_linear_velocity(new_speed)

	camera.global_position.x = ball.global_position.x
	camera.global_position.z = ball.global_position.z + 10
	camera.global_position.y = ball.global_position.y + 6
	camera.pivot_pos = ball.global_transform.origin
