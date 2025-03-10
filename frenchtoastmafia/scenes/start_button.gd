extends Button

func _ready():
	connect("pressed", _on_start_button_pressed) 


func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	print(get_tree().root.name)
	get_tree().change_scene_to_file("res://scenes/game.tscn") 
