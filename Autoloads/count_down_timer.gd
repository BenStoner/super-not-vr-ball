extends Label

signal countdown_ended

var total_counted: int = 0

@onready var timer := $Timer


func _ready() -> void:
	timer.timeout.connect(timeout)


@rpc("any_peer", "call_local")
func countdown(pause: bool, length):
	get_tree().paused = pause

	timer.wait_time = length
	timer.start()

	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "scale", Vector2.ONE, 0.5)


@rpc("any_peer", "call_local")
func stop_countdown():
	timer.stop()
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	get_tree().paused = false


func _process(delta: float) -> void:
	if timer.is_stopped(): return

	text = str(round(timer.time_left))


func timeout():
	hide()
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	get_tree().paused = false
	emit_signal("countdown_ended")
	show()
