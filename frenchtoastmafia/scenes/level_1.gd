extends Node

func _enter_tree():
	if Checkpoint.last_position:
		$player.global_position = Checkpoint.last_position
