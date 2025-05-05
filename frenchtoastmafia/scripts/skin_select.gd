extends Control




# Called when the node enters the scene tree for the first time.
func _ready():
	#var skin_menu = preload("res://scenes/skin_select.tscn").instantiate()
	#add_child(skin_menu)  # Must be added to the scene tree
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_default_pressed() -> void:
	SkinGlobal.current_skin = "res://Resources/skins/default.tres"
	#print(SkinGlobal.current_skin)
	visible = false

func _on_blue_pressed() -> void:
	#print("test")
	SkinGlobal.current_skin = "res://Resources/skins/blue-red-aqua.tres"
	#print(SkinGlobal.current_skin)
	visible = false
	

func _on_green_pressed() -> void:
	pass # Replace with function body.


func _on_pink_pressed() -> void:
	pass # Replace with function body.
