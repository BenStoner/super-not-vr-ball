extends Control

const PLAYER = preload("res://Player/player.tscn")
const PORT = 9999

var ener_peer = ENetMultiplayerPeer.new()

@onready var address_entry := $MarginContainer/VBoxContainer/AddressEntry


func _on_host_button_pressed() -> void:
	get_parent().emit_signal("player_host")
	queue_free()


func _on_join_button_pressed() -> void:
	if address_entry.text.is_valid_ip_address():
		get_parent().emit_signal("player_join", address_entry.text)
		queue_free()
	else:
		shake_address_entry()


func shake_address_entry():
	var tween = create_tween()
	tween.tween_property(address_entry, "position:x", -5, 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(address_entry, "position:x", 5, 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.finished
	tween.tween_property(address_entry, "position:x", 0, 0.1).set_ease(Tween.EASE_IN_OUT)
