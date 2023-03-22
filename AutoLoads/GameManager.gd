extends Node

signal player_join
signal player_host

const PLAYER = preload("res://Player/player.tscn")
const PORT = 9999

var ener_peer = ENetMultiplayerPeer.new()

func _ready() -> void:
	player_host.connect(_on_player_host)
	player_join.connect(_on_player_join)


func _on_player_host():
	if get_tree().current_scene.name == "Main":
		print(get_tree().current_scene)
		ener_peer.create_server(PORT)
		multiplayer.multiplayer_peer = ener_peer
		multiplayer.peer_connected.connect(add_player)

		add_player(multiplayer.get_unique_id())
		print(get_tree().current_scene)
	


func _on_player_join():
	ener_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = ener_peer


func add_player(peer_id):
	var player_instance = PLAYER.instantiate()
	player_instance.name = str(peer_id)
#	get_tree().root.get_node("Main").add_child(player_instance)
	print("asdasdasd")
