extends Node3D

signal player_join(address)
signal player_host

const PLAYER = preload("res://Player/player.tscn")
const PORT = 9999

@export var levels: Array[PackedScene] = []
@export var start_level: PackedScene

var enet_peer = ENetMultiplayerPeer.new()

var current_level

var paused: bool = false

@onready var players := $Players
@onready var level := $Level
@onready var main_menu := $MainMenu
@onready var pause_menu := $PauseMenu


func _ready() -> void:
	player_host.connect(_on_player_host)
	player_join.connect(_on_player_join.bind())

	multiplayer.server_relay = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		if paused:
			print("unpause")
			pause_menu.unpause()
			paused = false
		else:
			print("pause")
			pause_menu.pause()
			paused = true


func _on_player_host():
	enet_peer.create_server(PORT, 4)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)

	add_player(multiplayer.get_unique_id())

	start_game()

	upnp_setup()


func _on_player_join(address):
	enet_peer.create_client(address, PORT)
	multiplayer.multiplayer_peer = enet_peer

	start_game()


# Add player to multiplayer lobby
func add_player(peer_id):
	var player_instance = PLAYER.instantiate()
	player_instance.name = str(peer_id)
	players.add_child(player_instance)

	if current_level != null:
		player_instance.rpc("respawn", current_level.player_spawn_pos.global_position)


# Remove player from multiplayer lobby
func remove_player(peer_id):
	var player = players.get_node_or_null(str(peer_id))

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
		var instance = start_level.instantiate()
		level.add_child(instance)
		current_level = instance
		instance.player_added.connect(player_entered_start.bind())
		instance.player_removed.connect(player_left_start)


func change_level(to: int):
	for child in level.get_children():
		child.call_deferred("queue_free")

	var level_instance = levels[to].instantiate()
	level.add_child(level_instance, true)
	current_level = level_instance

	for i in players.get_children():
		i.rpc("respawn", level_instance.player_spawn_pos.global_position)

	level_instance.level_finished.connect(_current_level_finished.bind())

	RaceTimer.rpc("reset_level_timer")
	RaceTimer.rpc("start")
	CountDownTimer.rpc("countdown", true, 3)


func player_entered_start(players_in):
	if players_in == multiplayer.get_peers().size() + 1:
		CountDownTimer.rpc("countdown", false, 5)
		await CountDownTimer.countdown_ended
		if players_in == multiplayer.get_peers().size() + 1:
			change_level(0)


func player_left_start():
	CountDownTimer.rpc("stop_countdown")


func _current_level_finished(next_level, body):
	body.finished_level = true
	for i in players.get_children():
		if i.finished_level == false:
			return

	change_level(next_level)
