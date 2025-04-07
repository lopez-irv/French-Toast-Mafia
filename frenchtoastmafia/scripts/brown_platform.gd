extends RigidBody2D
var delay_before_fall := 0.25


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_body_entered(body: CharacterBody2D) -> void:
	print(body.name)
	if body.name == "player":
		await get_tree().create_timer(delay_before_fall).timeout
		freeze = false
