extends HBoxContainer

func _process(delta: float) -> void:
	if Input.is_action_pressed("reset"):
		print("Hi")
		get_tree().change_scene_to_file("res://scenes/game.tscn")
