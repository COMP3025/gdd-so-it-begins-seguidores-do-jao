extends Control

@onready var coins_count = $container/coins_container/coins_count as Label
@onready var timer_count = $container/timer_container/timer_count as Label
@onready var score_count = $container/score_container/score_count as Label
@onready var heart_count = $container/heart_container/heart_count as Label

# Called when the node enters the scene tree for the first time.
func _ready():
	coins_count.text = str("%03d"%Globals.coins)
	score_count.text = str("%06d"%Globals.score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
