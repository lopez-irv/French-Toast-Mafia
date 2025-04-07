extends Label

func _ready() -> void:
	update_level_display()

	# Listen to the level_changed signal
	if player_level_global.has_signal("level_changed"):
		player_level_global.connect("level_changed", self._on_level_changed)

func _on_level_changed(new_level: int) -> void:
	text = "Player level: " + str(new_level)

func update_level_display() -> void:
	text = "player level: " + str(player_level_global.playerLevel)
