extends Area2D

@onready var game_manager = %GameManager
@onready var coin_counter = %HUD/CoinLabel
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]  # Assign the first player found.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	#game_manager.add_point()
	
	queue_free()
