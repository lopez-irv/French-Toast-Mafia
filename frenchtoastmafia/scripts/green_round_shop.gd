extends Button

@export var shop_item: consumable_item
@onready var coin_text = $"../../../../../../HUD/HBoxContainer/Label"
# Called when the node enters the scene tree for the first time

func _on_pressed() -> void:
	if CoinGlobal.coins_this_level >= 1:
		var player1 = get_tree().current_scene.find_child("player", true, false)
		player1.collect(self.shop_item)
		CoinGlobal.coins_this_level -= 1
		CoinGlobal._commit_coins()
		coin_text.text = str(CoinGlobal.coins_this_level)
	else:
		_show_coin_error()
	
func _show_coin_error():
	var coin_label = get_parent().get_parent().get_node("coin_error")
	coin_label.visible = true
	await get_tree().create_timer(0.7).timeout
	coin_label.visible = false
