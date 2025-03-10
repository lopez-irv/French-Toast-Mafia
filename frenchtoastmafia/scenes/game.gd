extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _enter_tree():
	if Checkpoint.last_position:
		$player.global_position = Checkpoint.last_position
		
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print(1)
		var pos = event.position
		var clicked_nodes = get_tree().get_nodes_in_group("UI")
		for node in clicked_nodes:
			if node is Control and node.get_global_rect().has_point(pos):
				print("Clicked UI node:", node)
