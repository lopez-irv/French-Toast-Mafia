extends Button

func _ready():
	connect("pressed", _on_start_button_pressed) 


func _process(delta: float) -> void:
	#pass
	set("theme_override_colors/font_color",Color(0,1,0))

func _on_start_button_pressed() -> void:
	level_unlock_status.currentLevel = -1;
	SceneTransition.change_scene_to_file("res://scenes/shop.tscn") 
