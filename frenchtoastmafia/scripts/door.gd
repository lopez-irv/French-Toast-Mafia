extends Area2D

func _ready(): 
	pass

func _input(event):      #KEY TO ENTER DOORS IS "ENTER/RETURN"
	if event.is_action_pressed("ui_accept"): 
		if get_overlapping_bodies().size() > 0: 	
			#unlock next level based on which one was just at
			match level_unlock_status.currentLevel:
				0: 
					level_unlock_status.level1 = true #unlock next lvl
					LevelCompletionStatus.level0 = true #mark this lvl as completed
				1: 
					level_unlock_status.level2 = true
					LevelCompletionStatus.level1 = true
				2: 
					level_unlock_status.level3 = true
					LevelCompletionStatus.level2 = true
				#add the ones for other levels later
				_: print("no current level")
				
			Checkpoint.last_position = null
			print("checkpoint reset")
			
			CoinGlobal._commit_coins()
			next_level()
			
				
			
func next_level():                 #CHANGE ME LATER TO WORK FOR ALL SCENES
	
	SceneTransition.change_scene_to_file("res://scenes/levelSelection.tscn", "circle")
	
	#SceneTransition function returns void so cant do the error check below
	#var ERR = get_tree().change_scene_to_file("res://scenes/levelSelection.tscn")
	
	#if ERR != OK:
	#	print("something failed in this door scene")
