extends Button

func _ready():
	connect("pressed", _on_start_button_pressed) 


func _process(delta: float) -> void:
	if level_unlock_status.level2:
		set("theme_override_colors/font_color",Color(0,1,0))
	
	if LevelCompletionStatus.level2:
		icon = ResourceLoader.load("res://customAssets/goldButton.png")	#do this to change the icon

func _on_start_button_pressed() -> void:
	if level_unlock_status.level2:
		
		#reset checkpoint if switching to different level
		if level_unlock_status.currentLevel != 2:
			Checkpoint.last_position = null
			print("checkpoint reset")
			
		level_unlock_status.currentLevel = 2;
		SceneTransition.change_scene_to_file("res://scenes/Levels/level2.tscn") 
