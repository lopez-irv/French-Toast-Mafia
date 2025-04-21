extends Button




func _on_pressed() -> void:
	print("saving game")
	if SaveManager.inventory_ref:
		print("Inventory save data: ", SaveManager.inventory_ref.get_save_data())
	SaveManager.save_game()
