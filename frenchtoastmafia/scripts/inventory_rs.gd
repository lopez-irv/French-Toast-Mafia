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
		
	
