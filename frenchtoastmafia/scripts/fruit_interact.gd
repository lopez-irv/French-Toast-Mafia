extends Control

var consumable = 0
var current_fruit
var input_locked := false  # prevent toggling right after opening


func _ready():

	$AnimationPlayer.play("RESET")
	visible = false

func resume():
	#print("resume called")
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	visible = false

func pause():
	$PanelContainer/VBoxContainer/eat.grab_focus()
	#print("💬 Interact menu pause() called — visible set to true")
	visible = true
	#raise()
	input_locked = true
	await get_tree().create_timer(0.15).timeout  # small delay before accepting input
	input_locked = false
	get_tree().paused = true
	$AnimationPlayer.play("blur")

	
func testInteract():
	if Input.is_action_just_pressed("interact") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("interact") and get_tree().paused == true:
		resume()
		
func toggle_menu():
	if visible:
		resume()
	else:
		pause()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if input_locked:
		return
	if event.is_action_pressed("interact") and visible:
		toggle_menu()



func _on_eat_pressed() -> void:
	var player1 = get_tree().current_scene.find_child("player", true, false)
	current_fruit = player1.body_last_collided
	if current_fruit.name == "shield":
		player1.increaseShield(consumable)
	else:
		player1.increaseHealth(consumable)
	print(current_fruit.name)
	#_delete_fruit(current_fruit.name)
	current_fruit.queue_free()
	resume()  # Close menu after eating
	
func _delete_fruit(name: String):
	var toDelete = get_tree().current_scene.find_child(name, true, false)
	toDelete.queue_free()

func _on_exit_pressed() -> void:
	toggle_menu()

func add_to_inventory(cur_node: Node2D):
	print("adding to inventory")
	var invent = get_tree().current_scene.find_child("inventory", true, false)
	if invent == null:
		print("inventory not found")


func _on_stash_pressed() -> void:
	var player1 = get_tree().current_scene.find_child("player", true, false)
	current_fruit = player1.body_last_collided
	player1.collect(current_fruit.item)
	#_delete_fruit(current_fruit.name)
	current_fruit.queue_free()
	resume()  # Close menu after eating
