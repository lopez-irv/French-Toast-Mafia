extends Node

var total_coins: int
var coins_this_level: int 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _commit_coins():
	total_coins = coins_this_level
	
