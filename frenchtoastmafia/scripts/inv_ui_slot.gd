extends Panel

@onready var inv: Inv = preload("res://Resources/players_inventory.tres")
@onready var item_visuals: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var choose_button: Button = $CenterContainer/Panel/choose

var tmp_name
enum item_name {green_round, orange_round}

func _ready():
	choose_button.pressed.connect(_on_choose_pressed)

func get_grid_container() -> GridContainer:
	return get_parent()  # Move up to the GridContainer

func get_slot_index() -> int:
	var grid_container = get_grid_container()
	if grid_container:
		return grid_container.get_children().find(self)  # Find slot's index in GridContainer
	return -1  # Return -1 if not found

func update(slot: InvSlot):
	if !slot.item:
		item_visuals.visible = false
		amount_text.visible = false
		choose_button.visible = false
		
	else:
		item_visuals.visible = true
		item_visuals.texture = slot.item.texture
		amount_text.visible = true
		amount_text.text = str(slot.amount)
		choose_button.visible = true
		

func _on_choose_pressed() -> void:
	print("button pushed")
	var grid_container = get_grid_container()
	if grid_container:
		var columns = grid_container.columns  # Get number of columns
		var slot_index = get_slot_index()  # Get index inside GridContainer
		print(slot_index)
		
		if slot_index >= 0:
			tmp_name = inv.slots[slot_index].item.name
			action_decide(tmp_name, slot_index)
	

func action_decide(item_name: String, inv_index: int):
	print("in action decide")
	inv.remove(inv_index)
	var player1 = get_tree().current_scene.find_child("player", true, false)
	if item_name == "green_round":
		player1.increaseHealth(10)
	elif item_name == "orange_round":
		player1.increaseHealth(40)
	elif item_name == "shield":
		print("is shield")
		player1.increaseShield(30)
	else:
		print("no type found")
	#inv.slots[inv_index].ampunt
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("🖱️ Button clicked at all")
