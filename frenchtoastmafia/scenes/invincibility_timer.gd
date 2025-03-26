extends Timer
@onready var player: CharacterBody2D = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_stopped():
		player.modulate.a = 0.5 #turns player transparent
	else:
		player.modulate.a = 1 #undo transparent
