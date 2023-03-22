extends Control

const PLAYER = preload("res://Player/player.tscn")
const PORT = 9999

var ener_peer = ENetMultiplayerPeer.new()

@onready var address_entry := $MarginContainer/VBoxContainer/AddressEntry


func _on_host_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	GameManager.emit_signal("player_host")


func _on_join_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	GameManager.emit_signal("player_join")
