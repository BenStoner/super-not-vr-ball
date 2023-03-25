extends Node3D

signal player_join(address)
signal player_host

const PLAYER = preload("res://Player/player.tscn")
const PORT = 9999

@export var start_level: PackedScene = null
@export var levels: Array[PackedScene] = []

var current_level

var enet_peer = ENetMultiplayerPeer.new()


func _ready() -> void:
	player_host.connect(_on_player_host)
	player_join.connect(_on_player_join.bind())

	var start_level_instance = start_level.instantiate()
	add_child(start_level_instance)


@rpc("call_local")
func change_level(to: int, free: bool):
	if free == true:
		current_level.queue_free()

	var level_instance = levels[to].instantiate()
	current_level = level_instance
	add_child(level_instance)

	current_level.level_finished.connect(_current_level_finished)

	for i in get_children():
		if i is Player:
			i.global_position.y += 5


# Multiplayer
func _on_player_host():
	change_level(0, false)

	enet_peer.create_server(PORT, 4)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)

	add_player(multiplayer.get_unique_id())

	upnp_setup()


func _on_player_join(address):
	change_level(0, false)

	enet_peer.create_client(address, PORT)
	multiplayer.multiplayer_peer = enet_peer


# Add player to multiplayer lobby
func add_player(peer_id):
	var player_instance = PLAYER.instantiate()
	player_instance.name = str(peer_id)
	add_child(player_instance)


# Remove player from multiplayer lobby
func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))

	if player:
		player.queue_free()


func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)

	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), 
		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)

	print("Success! Join Address: %s" % upnp.query_external_address())


func _current_level_finished():
	change_level(current_level.next_level, true)
