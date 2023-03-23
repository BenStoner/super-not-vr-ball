extends Node3D

signal player_join
signal player_host

const PLAYER = preload("res://Player/player.tscn")
const PORT = 9999

@export var levels: Array[PackedScene] = []

var enet_peer = ENetMultiplayerPeer.new()

var current_level
var start_level


func _ready() -> void:
	player_host.connect(_on_player_host)
	player_join.connect(_on_player_join)

	start_level = levels[0]
	var start_level_instance = start_level.instantiate()
	current_level = start_level_instance
	add_child(start_level_instance)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		change_level.rpc(2)


# Multiplayer
@rpc("call_local")
func change_level(to: int):
	current_level.queue_free()
	var level_instance = levels[to].instantiate()
	current_level = level_instance
	add_child(level_instance)


func _on_player_host():
	change_level(1)

	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)

	add_player(multiplayer.get_unique_id())


func _on_player_join():
	change_level(1)

	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer



func add_player(peer_id):
	var player_instance = PLAYER.instantiate()
	player_instance.name = str(peer_id)
	add_child(player_instance)
