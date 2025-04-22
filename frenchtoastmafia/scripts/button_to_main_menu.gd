extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", _on_main_menu_button_pressed) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_main_menu_button_pressed() -> void:
	SceneTransition.change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
