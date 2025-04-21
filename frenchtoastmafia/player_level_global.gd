extends Node

signal level_changed(new_level: int)
var healthCap: int = 100
var attackDamage: int = 30
var playerLevel: int = 0
var health: int = 100
var xp: int = 0
func level_up():
	playerLevel += 1
	if playerLevel %2 == 0: # if is even
		attackDamage += 1
		print("attack damage increased ", attackDamage)
	if playerLevel %2 == 1: # if is even
		healthCap += 2
		print("health cap increased ", healthCap)
	emit_signal("level_changed", playerLevel)
