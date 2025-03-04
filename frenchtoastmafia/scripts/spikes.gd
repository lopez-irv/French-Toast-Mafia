extends Node2D

var player = null
@onready var healthbar: Node = $Healthbar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]  # Assign the first player found.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("hit player")
	if body.is_in_group("Player"):
		player.decreaseHealth(30);
		if body.has_node("healthBar"):
			var healthBar = body.get_node("healthBar") as ProgressBar
			healthBar.value = player.health  # update health bar visually
