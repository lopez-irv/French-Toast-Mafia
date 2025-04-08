extends CanvasLayer

#Usage:
#Instead of loading scenes with 
#get_tree().change_scene_to_file("res://scenes/scene_name.tscn")
#use 
#SceneTransition.change_scene_to_file("res://scenes/scene_name.tscn", "name of transition")
#if nothing is given for 2nd parameter, it will do dissolve effect by default
func change_scene_to_file(target: String, type: String = 'dissolve') -> void:
	if type == 'dissolve':
		transition_dissolve(target)
	else:
		transition_circle(target)



func transition_dissolve(target: String) -> void:
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards('dissolve')



func transition_circle(target: String) -> void:
	$AnimationPlayer.play('circle')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards('circle')
