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
	get_game_timer(delta)
	get_level_timer(delta)


func get_game_timer(delta):
	if(game_timer_on):
		game_time += delta

	var mils = fmod(game_time,1)*1000
	var secs = fmod(game_time,60)
	var mins = fmod(game_time, 60*60) / 60

	var time_passed = "%02d:%02d:%03d" % [mins,secs,mils]
	game_timer.text = time_passed


func get_level_timer(delta):
	if(level_timer_on):
		level_time += delta

	var mils = fmod(level_time,1)*1000
	var secs = fmod(level_time,60)
	var mins = fmod(level_time, 60*60) / 60

	var time_passed = "%02d:%02d:%03d" % [mins,secs,mils]
	level_timer.text = time_passed


func start_game_timer():
	show()
	game_timer_on = true

func start_level_timer():
	show()
	level_timer_on = true


func stop():
	game_timer_on = false
	level_timer_on = false


func reset_game_timer():
	game_time = 0
	level_time = 0


func reset_level_timer():
	level_time = 0
