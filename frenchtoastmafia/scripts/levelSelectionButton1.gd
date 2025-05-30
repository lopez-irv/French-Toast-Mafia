extends Button

func _ready():
	connect("pressed", _on_start_button_pressed) 


func _process(delta: float) -> void:
	if level_unlock_status.level1:
		set("theme_override_colors/font_color",Color(0,1,0))
	
	if LevelCompletionStatus.level1:
		icon = ResourceLoader.load("res://customAssets/goldButton.png")	#do this to change the icon

func _on_start_button_pressed() -> void:
	GameState.current_level_path = "res://scenes/level_1.tscn"
	if level_unlock_status.level1:
		
		#reset checkpoint if switching to different level
		if level_unlock_status.currentLevel != 1:
			Checkpoint.last_position = null
			print("checkpoint reset")
			
		level_unlock_status.currentLevel = 1;
		SceneTransition.change_scene_to_file("res://scenes/level_1.tscn") 
