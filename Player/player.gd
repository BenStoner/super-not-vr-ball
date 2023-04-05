class_name Player
extends RigidBody3D

@export var speed: float = 13
@export var max_speed: float = 20

var move_direction := Vector3.ZERO

@export var finished_level: bool = false

@onready var jump_timer := $JumpTimer
@onready var spring_arm := $SpringArm3D
@onready var camera := $SpringArm3D/Target/InterpolatedCamera3D


func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())


func _ready() -> void:
	if not is_multiplayer_authority(): return

	camera.make_current()


func _physics_process(_delta):
	if not is_multiplayer_authority(): return
	if get_tree().paused == false:
		# Movement
		move_direction = Vector3.ZERO
		move_direction.x = Input.get_axis("move_left", "move_right")
		move_direction.z = Input.get_axis("move_forward", "move_backward")
		move_direction = move_direction.rotated((Vector3.UP), spring_arm.rotation.y).normalized()

		if linear_velocity.x > 3 or linear_velocity.x < -3 or linear_velocity.z > 3 or linear_velocity.z < -3:
			$SmokeParticles.set_emitting(true)
		else:
			$SmokeParticles.set_emitting(false)

		if not Input.is_action_pressed("brake"):
			apply_central_force(move_direction * speed)

		# Braking
		if Input.is_action_pressed("brake"):
			linear_velocity.x = lerp(linear_velocity.x, 0.0, 0.1)
			linear_velocity.z = lerp(linear_velocity.z, 0.0, 0.1)
			rotation = lerp(rotation, Vector3.ZERO, 0.1)
			angular_velocity = lerp(angular_velocity, Vector3.ZERO, 0.1)

		# Small jump if not moving
		if jump_timer.is_stopped():
			if linear_velocity.x <= 0.15 and linear_velocity.y <= 0.15 and linear_velocity.y <= 0.15 and linear_velocity.x >= -0.15 and linear_velocity.y >= -0.15 and linear_velocity.y >= -0.15:
				if Input.is_action_just_pressed("jump"):
					jump_timer.start()
					apply_central_force(Vector3.UP * 200)

		# Limits soeed
		if abs(get_linear_velocity().x) > max_speed or abs(get_linear_velocity().y) > max_speed or abs(get_linear_velocity().z) > max_speed\
		or abs(get_linear_velocity().x) < -max_speed or abs(get_linear_velocity().y) < -max_speed or abs(get_linear_velocity().z) < -max_speed:
			var new_speed = get_linear_velocity().normalized()
			new_speed *= max_speed
			set_linear_velocity(new_speed)

	spring_arm.position = position

	$SmokeParticles.position.x = position.x
	$SmokeParticles.position.y = position.y -0.2
	$SmokeParticles.position.z = position.z


@rpc("any_peer", "call_local")
func respawn(new_position):
	global_position = new_position

	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO


func reset():
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
