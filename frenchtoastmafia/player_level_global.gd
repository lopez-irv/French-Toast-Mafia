extends Node

signal level_changed(new_level: int)

var playerLevel: int = 0
var xp: int = 0
func level_up():
	playerLevel += 1
	emit_signal("level_changed", playerLevel)
