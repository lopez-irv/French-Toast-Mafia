extends Button

func _ready():
	connect("pressed", _on_start_button_pressed) 


func _process(delta: float) -> void:
	check_level4_unlock_status()
	if level_unlock_status.level4:
		set("theme_override_colors/font_color",Color(0,1,0))
	
	if LevelCompletionStatus.level4:
		icon = ResourceLoader.load("res://customAssets/goldButton.png")	#do this to change the icon

func _on_start_button_pressed() -> void:
	GameState.current_level_path = "res://boss_level.tscn"
	if level_unlock_status.level4:
		
		#reset checkpoint if switching to different level
		if level_unlock_status.currentLevel != 4:
			Checkpoint.last_position = null
			print("checkpoint reset")
			
		level_unlock_status.currentLevel = 4;
		SceneTransition.change_scene_to_file("res://boss_level.tscn") 

#checks if all keys were found in previous levels
func check_level4_unlock_status():
	if LevelCompletionStatus.shop_level && LevelCompletionStatus.level1 && LevelCompletionStatus.level2 && LevelCompletionStatus.level3:
		level_unlock_status.level4 = true
