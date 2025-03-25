extends Button

func _ready():
	connect("pressed", _on_start_button_pressed) 


func _process(delta: float) -> void:
	#pass
	if level_unlock_status.level0:
		set("theme_override_colors/font_color",Color(0,1,0))

func _on_start_button_pressed() -> void:
	if level_unlock_status.level0:
		level_unlock_status.currentLevel = 0;
		get_tree().change_scene_to_file("res://scenes/game.tscn") 
