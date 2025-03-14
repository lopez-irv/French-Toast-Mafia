extends Button

func _ready():
	connect("pressed", _on_start_button_pressed) 


func _process(delta: float) -> void:
	#pass
	if level_unlock_status.level1:
		set("theme_override_colors/font_color",Color(0,1,0))
		#icon = ResourceLoader.load("res://customAssets/button.png")	#do this to change the icon

func _on_start_button_pressed() -> void:
	if level_unlock_status.level1:
		get_tree().change_scene_to_file("res://scenes/level_1.tscn") 

func unlock():
	if level_unlock_status.level1:
		set("theme_override_colors/font_color",Color(0,1,0))
