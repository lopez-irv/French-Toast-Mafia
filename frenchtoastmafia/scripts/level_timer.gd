extends Node

@onready var label = $Label
@onready var timer = $Timer

func _ready():
	timer.start()
	
func timeLeft():
	var timeLeft = timer.time_left
	var minute = floor(timeLeft / 60)
	var second = int(timeLeft) % 60
	return [minute, second]

#updates the timer display
func _process(delta):
	label.text = "%02d:%02d" % timeLeft()

func _on_timer_timeout():
	print("time over")
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
