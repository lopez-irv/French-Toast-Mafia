extends Node

var total_coins: int
var coins_this_level: int 

var red_coins_collected: int = 0
var secret_skin_unlocked: bool = false #unlocks after all red coins are found

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _commit_coins():
	total_coins = coins_this_level
	
