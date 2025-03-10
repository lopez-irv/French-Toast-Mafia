extends Node2D

@export var item: consumable_item

var player_in_area = false;


const health_value = 20

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = true  # Player entered the area

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = false  # Player left the area
		

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("interact") and player_in_area:
		open_interact_menu();
		

func open_interact_menu():
	print("opening interact menu")
	var interact_menu = get_tree().current_scene.find_child("fruit_interact", true, false)
	if interact_menu == null:
		print("❌ ERROR: Interact menu not found in the scene tree!")
		return  # Stop execution if the node is null
	if get_tree().current_scene.has_node("InteractMenu"):
		print("1")
		return  # Prevent multiple menus
	if interact_menu.visible:
		print("2")
		return
	interact_menu.consumable = health_value
	interact_menu.pause()
	print("3")
