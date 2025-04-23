extends Area2D
@onready var door_sfx = $DoorSFX

func _ready(): 
	pass

func _input(event):      #KEY TO ENTER DOORS IS "i"
	if event.is_action_pressed("interact"): 
		if get_overlapping_bodies().size() > 0: 	
			#unlock next level based on which one was just at
			#and mark lvl complete if key was collected
			match level_unlock_status.currentLevel:
				-1:#shop level
					if LevelCompletionStatus.keyFlag == true:
						LevelCompletionStatus.shop_level = true
				0: 
					level_unlock_status.level1 = true #unlock next lvl
					if LevelCompletionStatus.keyFlag == true:
						LevelCompletionStatus.level0 = true #mark this lvl as completed if found key
				1: 
					level_unlock_status.level2 = true
					if LevelCompletionStatus.keyFlag == true:
						LevelCompletionStatus.level1 = true
				2: 
					level_unlock_status.level3 = true
					if LevelCompletionStatus.keyFlag == true:
						LevelCompletionStatus.level2 = true
				3: 
					level_unlock_status.level4 = true
					if LevelCompletionStatus.keyFlag == true:
						LevelCompletionStatus.level3 = true
				4: 
					level_unlock_status.level5 = true
					if LevelCompletionStatus.keyFlag == true:
						LevelCompletionStatus.level4 = true
				#add the ones for other levels later
				_: print("no current level")
			
			LevelCompletionStatus.keyFlag = false  #reset keyFlag
				
			Checkpoint.last_position = null
			print("checkpoint reset")
			
			CoinGlobal._commit_coins()
			door_sfx.play()
			next_level()
			
func next_level():                 #CHANGE ME LATER TO WORK FOR ALL SCENES
	
	SceneTransition.change_scene_to_file("res://scenes/levelSelection.tscn", "circle")
	
	#SceneTransition function returns void so cant do the error check below
	#var ERR = get_tree().change_scene_to_file("res://scenes/levelSelection.tscn")
	
	#if ERR != OK:
	#	print("something failed in this door scene")
