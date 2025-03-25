extends Area2D

func _ready(): 
	pass

func _input(event):      #KEY TO ENTER DOORS IS "ENTER/RETURN"
	if event.is_action_pressed("ui_accept"): 
		if get_overlapping_bodies().size() > 0: 	
			#unlock next level based on which one was just at
			match level_unlock_status.currentLevel:
				0: level_unlock_status.level1 = true
				1: level_unlock_status.level2 = true
				2: level_unlock_status.level3 = true
				#add the ones for other levels later
				_: print("no current level")
				
			Checkpoint.last_position = null
			print("checkpoint reset")
			
			next_level()
			
				
			
func next_level():                 #CHANGE ME LATER TO WORK FOR ALL SCENES
	var ERR = get_tree().change_scene_to_file("res://scenes/levelSelection.tscn")
	
	if ERR != OK:
		print("something failed in this door scene")
