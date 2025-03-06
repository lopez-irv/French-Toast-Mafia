extends Control

var consumable = 0
var current_fruit

func _ready():
	$AnimationPlayer.play("RESET")
	visible = false

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	visible = false

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	visible = true
	
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
	if event.is_action_pressed("interact") and visible:
		toggle_menu();

func _on_eat_pressed() -> void:
	var player1 = get_tree().current_scene.find_child("player", true, false)
	player1.increaseHealth(consumable)
	current_fruit = player1.body_last_collided
	print(current_fruit)
	_delete_fruit(current_fruit.name)
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
	_delete_fruit(current_fruit.name)
	resume()  # Close menu after eating
