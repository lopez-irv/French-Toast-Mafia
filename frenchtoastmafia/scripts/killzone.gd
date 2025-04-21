extends Area2D

@onready var timer: Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	player_level_global.health = player_level_global.healthCap
	print("game over")
	#Engine.time_scale = 0.5 #slows down game
	#body.get_node("CollisionShape2D").queue_free() #makes player fall off map
	timer.start() 


#restarts game after short pause
func _on_timer_timeout() -> void:
	#Engine.time_scale = 1.0	 #set time back to normal
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


#make sure player is on layer 2 or killzone wont work
