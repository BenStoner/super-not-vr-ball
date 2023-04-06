extends Control


func _ready() -> void:
	hide()


@rpc("any_peer", "call_local")
func pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	show()


@rpc("any_peer", "call_local")
func unpause():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	hide()


func _on_resume_button_pressed() -> void:
	unpause()
	get_parent().paused = false
	


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($ColorRect, "color", Color.BLACK, 1)
	await tween.finished
	get_parent().remove_player(multiplayer.get_unique_id())
	get_parent().main_menu.show()
	multiplayer.
	hide()
