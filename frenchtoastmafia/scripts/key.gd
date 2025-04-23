extends Area2D

func _ready(): 
	#dont show key when replaying level if have already collected it
	match level_unlock_status.currentLevel:
		-1:
			if LevelCompletionStatus.shop_level == true:
				queue_free()
		0:
			if LevelCompletionStatus.level0 == true:
				queue_free()
		1:
			if LevelCompletionStatus.level1 == true:
				queue_free()
		2:
			if LevelCompletionStatus.level2 == true:
				queue_free()
		3:
			if LevelCompletionStatus.level3 == true:
				queue_free()
		4:
			if LevelCompletionStatus.level4 == true:
				queue_free()



func _on_body_entered(body: Node2D) -> void:
	print("key collected")
	LevelCompletionStatus.keyFlag = true
	queue_free()
