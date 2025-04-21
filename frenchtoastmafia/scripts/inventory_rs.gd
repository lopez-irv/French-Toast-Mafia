extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot]


func insert(item: consumable_item):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
		
	else:
		var emptyslots = slots.filter(func(slots): return slots.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()
	
func remove(slot: int):
	slots[slot].amount -= 1
	if slots[slot].amount <= 0:
		slots[slot].item = null
	update.emit()
		
	
# inventory_rs.gd
func get_save_data() -> Array:
	
	var data := []
	for slot in slots:
		if slot.item:
			data.append({
				"name": slot.item.name,
				"amount": slot.amount
			})
		else:
			data.append(null)  # Empty slot
	return data

func load_from_data(data: Array):
	for i in range(slots.size()):
		if i < data.size() and data[i] != null:
			var item_name = data[i].get("name", "")
			var amount = data[i].get("amount", 1)
			
			var item = load_item_by_name(item_name)
			slots[i].item = item
			slots[i].amount = amount
		else:
			slots[i].item = null
			slots[i].amount = 0
	update.emit()

func load_item_by_name(name: String) -> consumable_item:
	match name:
		"green_round":
			return preload("res://Resources/green_round.tres")
		"orange_round":
			return preload("res://Resources/orange_round.tres")
		_:
			print("Unknown item name: ", name)
			return null
