extends Area2D

func _ready(): 
	pass

func _input(event):      #KEY TO ENTER DOORS IS "ENTER/RETURN"
	if event.is_action_pressed("ui_accept"): 
		if get_overlapping_bodies().size() > 0: 
			next_level()
func next_level():                 #CHANGE ME LATER TO WORK FOR ALL SCENES
	var ERR = get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	
	if ERR != OK:
		print("something failed in this door scene")
