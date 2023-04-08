extends Control


func _ready() -> void:
	hide()


func pause_receive():
	rpc("pause")


func unpause_receive():
	rpc("unpause")


@rpc("any_peer", "call_local")
func pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()


@rpc("any_peer", "call_local")
func unpause():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()


func _on_resume_button_pressed() -> void:
	unpause()


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($ColorRect, "color", Color.BLACK, 1)
#	await tween.finished
#	get_tree().root.get_node("Main").remove_player(multiplayer.get_unique_id())
#	get_tree().root.get_node("Main").main_menu.show()
#	hide()
