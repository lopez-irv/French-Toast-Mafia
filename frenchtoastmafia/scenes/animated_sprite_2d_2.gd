extends AnimatedSprite2D

@export var player_path: NodePath
@onready var player = get_node(player_path)

func _process(delta):
	if player:
		# If player is to the left, flip the sprite to face left; otherwise, face right.
		if player.global_position.x < global_position.x:
			flip_h = true
		else:
			flip_h = false
