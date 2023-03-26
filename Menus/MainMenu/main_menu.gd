extends Control

const PLAYER = preload("res://Player/player.tscn")
const PORT = 9999

var ener_peer = ENetMultiplayerPeer.new()

@onready var address_entry := $AddressEntryMenu/VBoxContainer/AddressEntry


func _process(delta: float) -> void:
	if address_entry.text.is_valid_ip_address():
		if Input.is_action_just_pressed("ui_accept"):
			get_parent().emit_signal("player_join", address_entry.text)
			queue_free()


func shake_address_entry():
	var tween = create_tween()
	tween.tween_property(address_entry, "position:x", -5, 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(address_entry, "position:x", 5, 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(address_entry, "position:x", 0, 0.1).set_ease(Tween.EASE_IN_OUT)


func _on_host_button_pressed() -> void:
	get_parent().emit_signal("player_host")
	queue_free()


func _on_join_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($JoinHostMenu, "modulate", Color.TRANSPARENT, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	move_child($AddressEntryMenu, $JoinHostMenu.get_index())
	tween.tween_property($AddressEntryMenu, "modulate", Color.WHITE, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)


func _on_back_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($JoinHostMenu, "modulate", Color.TRANSPARENT, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	move_child($JoinHostMenu, $Main.get_index())
	tween.tween_property($Main, "modulate", Color.WHITE, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)


func _on_play_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($Main, "modulate", Color.TRANSPARENT, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	move_child($Main, $JoinHostMenu.get_index())
	tween.tween_property($JoinHostMenu, "modulate", Color.WHITE, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($ColorRect, "color", Color.BLACK, 1)
	await tween.finished
	get_tree().quit()


func _on_address_back_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($AddressEntryMenu, "modulate", Color.TRANSPARENT, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	move_child($JoinHostMenu, $AddressEntryMenu.get_index())
	tween.tween_property($JoinHostMenu, "modulate", Color.WHITE, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)


func _on_enter_pressed() -> void:
	if address_entry.text.is_valid_ip_address():
		get_parent().emit_signal("player_join", address_entry.text)
		queue_free()
	else:
		shake_address_entry()
