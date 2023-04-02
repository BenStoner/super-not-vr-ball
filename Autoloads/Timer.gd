extends Control

var game_time = 0
var game_timer_on = false

var level_time = 0
var level_timer_on = false

@onready var game_timer := $GameTimer
@onready var level_timer := $LevelTimer


func _ready() -> void:
	hide()


func _process(delta):
	if(game_timer_on):
		game_time += delta

	var mils_game = fmod(game_time,1)*1000
	var secs_game = fmod(game_time,60)
	var mins_game = fmod(game_time, 60*60) / 60

	var time_passed_game = "%02d:%02d:%03d" % [mins_game,secs_game,mils_game]
	game_timer.text = time_passed_game

	if(level_timer_on):
		level_time += delta

	var mil_level = fmod(level_time,1)*1000
	var secs_level = fmod(level_time,60)
	var mins_level = fmod(level_time, 60*60) / 60

	var time_passed_level = "%02d:%02d:%03d" % [mins_level,secs_level,mil_level]
	level_timer.text = time_passed_level


@rpc("any_peer", "call_local")
func start():
	show()
	game_timer_on = true
	level_timer_on = true


@rpc("any_peer", "call_local")
func start_game_timer():
	show()
	game_timer_on = true


@rpc("any_peer", "call_local")
func start_level_timer():
	show()
	level_timer_on = true


func stop():
	game_timer_on = false
	level_timer_on = false


@rpc("any_peer", "call_local")
func reset_game_timer():
	game_time = 0


@rpc("any_peer", "call_local")
func reset_level_timer():
	level_time = 0
