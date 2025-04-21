extends Button


func _on_pressed() -> void:
	print("loading game")
	SaveManager.load_game();
