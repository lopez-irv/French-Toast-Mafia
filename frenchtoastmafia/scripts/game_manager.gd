extends Node

var score = 0

signal  coins_changed(new_coin_count: int)

@onready var score_label: Label = $score_label



func add_point():
	CoinGlobal.coins_this_level += 1
	score += 1
	score_label.text = "You collected " + str(score) + " coins."
	emit_signal("coins_changed", CoinGlobal.coins_this_level)
