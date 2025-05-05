extends Button

#@onready var skin_button = $skin_select#get_tree().root#.get_node("skin_select") 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(skin_button)
	#skin_button.visible = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	#skin_button.visible = true	
	var setin = find_parent("settings")
	if setin:
		var skin_menu = setin.get_node("skin_select")
		skin_menu.visible = true
