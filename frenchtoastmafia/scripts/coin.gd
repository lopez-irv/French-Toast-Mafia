extends Area2D

#signal coins_changed(new_coin_count: int)

@onready var game_manager = %GameManager
@onready var coin_counter = %HUD/CoinLabel

func _on_body_entered(body: Node2D) -> void:
	game_manager.add_point()
	
	queue_free()
