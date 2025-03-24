extends Node

signal coins_changed(new_coin_count: int)
var score = 0
@onready var score_label: Label = $score_label


func add_point():
	CoinGlobal.coins_this_level += 1
	score += 1
	score_label.text = "You collected " + str(score) + " coins."
	print("total coins: " ,str(score))
	emit_signal("coins_changed", CoinGlobal.coins_this_level)
