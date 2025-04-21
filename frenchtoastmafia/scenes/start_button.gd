extends Button

func _ready():
	pass#connect("pressed", _on_start_button_pressed) 


func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	print(GameState.current_level_path)
	get_tree().change_scene_to_file(GameState.current_level_path) 


func _on_pressed() -> void:
	print("1")
	print(GameState.current_level_path)
	get_tree().change_scene_to_file(GameState.current_level_path) 
