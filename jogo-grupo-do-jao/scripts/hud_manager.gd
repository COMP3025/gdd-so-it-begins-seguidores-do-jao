extends Control

@onready var coins_count = $container/coins_container/coins_count as Label
@onready var timer_count = $container/timer_container/timer_count as Label
@onready var score_count = $container/score_container/score_count as Label
@onready var heart_count = $container/heart_container/heart_count as Label
@onready var clock_timer = $clock_timer as Timer

var minutes = 0
var seconds = 0
@export_range(0,5) var default_minutes := 1
@export_range(0,59) var default_seconds := 0

signal time_is_up()

# Called when the node enters the scene tree for the first time.
func _ready():
	coins_count.text = str("%03d"%Globals.coins)
	score_count.text = str("%06d"%Globals.score)
	heart_count.text = str("%02d"%Globals.player_heart)
	timer_count.text = str("%02d"%default_minutes) +":"+ str("%02d"%default_seconds)
	reset_clock_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coins_count.text = str("%03d"%Globals.coins)
	score_count.text = str("%06d"%Globals.score)
	heart_count.text = str("%02d"%Globals.player_heart)

	if minutes == 0 and seconds == 0:
		emit_signal("time_is_up")

func _on_clock_timer_timeout():
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 60
	seconds -= 1
	
	timer_count.text = str("%02d"% minutes) +":"+ str("%02d"% seconds)

func reset_clock_timer():
	minutes = default_minutes
	seconds = default_seconds
