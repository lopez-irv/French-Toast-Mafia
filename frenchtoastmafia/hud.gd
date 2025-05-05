extends CanvasLayer

func _on_FireballDialog_confirmed() -> void:
	get_tree().paused = false

func _on_FireballDialog_popup_hide() -> void:
	get_tree().paused = false
