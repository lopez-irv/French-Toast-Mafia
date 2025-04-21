extends Button

func _ready():
	connect("pressed", _on_start_button_pressed) 


func _process(delta: float) -> void:
	if level_unlock_status.level13:
		set("theme_override_colors/font_color",Color(1,0,0))
	
	if LevelCompletionStatus.level13:
		icon = ResourceLoader.load("res://customAssets/goldButton.png")	#do this to change the icon

func _on_start_button_pressed() -> void:
	if level_unlock_status.level13:
		
		#reset checkpoint if switching to different level
		if level_unlock_status.currentLevel != 13:
			Checkpoint.last_position = null
			print("checkpoint reset")
			
		level_unlock_status.currentLevel = 13;
		SceneTransition.change_scene_to_file("res://scenes/level_devHell.tscn") 
