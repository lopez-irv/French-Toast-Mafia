extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#makes the buttons navigable with keys, starting at restart
	$MarginContainer/HBoxContainer/VBoxContainer/restart_button.grab_focus()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
