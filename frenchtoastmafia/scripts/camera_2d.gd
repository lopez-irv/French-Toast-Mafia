extends Camera2D

@export var scroll_speed: float = 50.0  # pixels per second
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x += scroll_speed * delta


func _on_killzone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body. decreaseHealth(1000)
