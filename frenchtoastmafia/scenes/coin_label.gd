extends Label



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str(CoinGlobal.total_coins)
	var GM = get_node("../../../../GameManager")
	GM.connect("coins_changed", self._on_coins_changed)

func _on_coins_changed(new_coin_count: int):
	text = str(new_coin_count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
