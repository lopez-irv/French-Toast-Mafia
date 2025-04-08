extends Button

func _ready():
	connect("pressed", _on_start_button_pressed) 


func _process(delta: float) -> void:
	#pass
	if level_unlock_status.level0:
		set("theme_override_colors/font_color",Color(0,1,0))
	
	if LevelCompletionStatus.level0:
		icon = ResourceLoader.load("res://customAssets/goldButton.png")

func _on_start_button_pressed() -> void:
	if level_unlock_status.level0:
		
		#reset checkpoint if switching to different level
		if level_unlock_status.currentLevel != 0:
			Checkpoint.last_position = null
			print("checkpoint reset")
			
		level_unlock_status.currentLevel = 0;	#update currentLevel
		SceneTransition.change_scene_to_file("res://scenes/game.tscn") 
