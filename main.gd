extends Node3D

signal player_join(address)
signal player_host

const PLAYER = preload("res://Player/player.tscn")
const PORT = 9999

@export var start_level: PackedScene = null
@export var levels: Array[PackedScene] = []

var current_level
var current_level_number

var enet_peer = ENetMultiplayerPeer.new()


func _ready() -> void:
	player_host.connect(_on_player_host)
	player_join.connect(_on_player_join.bind())

	var start_level_instance = start_level.instantiate()
	add_child(start_level_instance)

	multiplayer.server_relay = false


# Multiplayer
func _on_player_host():
	enet_peer.create_server(PORT, 4)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)

	start_game()

	add_player(multiplayer.get_unique_id())

	upnp_setup()


func _on_player_join(address):
	enet_peer.create_client(address, PORT)
	multiplayer.multiplayer_peer = enet_peer

	start_game()


# Add player to multiplayer lobby
func add_player(peer_id):
	var player_instance = PLAYER.instantiate()
	player_instance.name = str(peer_id)
	$Players.add_child(player_instance)


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


func start_game():
	if multiplayer.is_server():
		change_level(0)


#@rpc("call_local", "any_peer")
func change_level(to: int):
	for child in $Level.get_children():
		child.call_deferred("queue_free")

	var level_instance = levels[to].instantiate()
	current_level = level_instance
	current_level_number = to

	$Level.add_child(level_instance, true)
	
	PlayerSpawnPosition.global_position = level_instance.player_spawn_pos.global_position

	current_level.level_finished.connect(_current_level_finished)


func _current_level_finished():
	change_level(current_level.next_level)


