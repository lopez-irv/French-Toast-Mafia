extends Node

const SAVE_PATH := "user://save_data.json"

var inventory_ref: Inv = null  # Assigned from inventory_ui.gd

func save_game():
	if inventory_ref == null:
		print("Inventory reference not set. Cannot save inventory.")
		return

	var unlocked_levels_data = {
		"level0": level_unlock_status.level0,
		"level1": level_unlock_status.level1,
		"level2": level_unlock_status.level2,
		"level3": level_unlock_status.level3,
		"level4": level_unlock_status.level4,
		"level5": level_unlock_status.level5,
		"level6": level_unlock_status.level6,
		"level7": level_unlock_status.level7,
		"level8": level_unlock_status.level8,
		"level9": level_unlock_status.level9,
		"level10": level_unlock_status.level10,
		"level11": level_unlock_status.level11,
		"level12": level_unlock_status.level12,
		"level13": level_unlock_status.level13,
		"level14": level_unlock_status.level14,
	}

	var data = {
		"player_level": player_level_global.playerLevel,
		"coins": CoinGlobal.total_coins,
		"unlocked_levels": unlocked_levels_data,
		"inventory": inventory_ref.get_save_data(),
		"health_cap": player_level_global.healthCap,
		"exp": player_level_global.xp,
		"attack_damage": player_level_global.attackDamage
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

	file.close()
	print("Game saved.")


func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var data = JSON.parse_string(content)
	if data is Dictionary:
		player_level_global.playerLevel = data.get("player_level", 1)
		player_level_global.attackDamage = data.get("attack_damage", 30)
		player_level_global.healthCap = data.get("health_cap", 100)
		player_level_global.xp = data.get("exp", 0)
		CoinGlobal.total_coins = data.get("coins", 0)

		var unlocked = data.get("unlocked_levels", {})
		level_unlock_status.level0 = unlocked.get("level0", true)
		level_unlock_status.level1 = unlocked.get("level1", false)
		level_unlock_status.level2 = unlocked.get("level2", false)
		level_unlock_status.level3 = unlocked.get("level3", false)
		level_unlock_status.level4 = unlocked.get("level4", false)
		level_unlock_status.level5 = unlocked.get("level5", false)
		level_unlock_status.level6 = unlocked.get("level6", false)
		level_unlock_status.level7 = unlocked.get("level7", false)
		level_unlock_status.level8 = unlocked.get("level8", false)
		level_unlock_status.level9 = unlocked.get("level9", false)
		level_unlock_status.level10 = unlocked.get("level10", false)
		level_unlock_status.level11 = unlocked.get("level11", false)
		level_unlock_status.level12 = unlocked.get("level12", false)
		level_unlock_status.level13 = unlocked.get("level13", false)
		level_unlock_status.level14 = unlocked.get("level14", false)

		if inventory_ref:
			inventory_ref.load_from_data(data.get("inventory", []))
		else:
			print("Inventory reference not set. Cannot load inventory.")

		print("Game loaded successfully.")
	else:
		print("Error parsing save data.")
		
func delete_save():
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		print("Save file deleted.")
	else:
		print("No save file to delete.")
