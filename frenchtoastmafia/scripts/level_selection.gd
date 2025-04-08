extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", Callable(self, "_on_level_selection_pressed"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_level_selection_pressed():
	SceneTransition.change_scene_to_file("res://scenes/levelSelection.tscn") 
