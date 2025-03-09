extends Button

var arrowControls = true #Default controls are arrow keys

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", _on_controls_button_pressed) 
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_controls_button_pressed():
	
	#erase current mappings
	InputMap.action_erase_events("jump")
	InputMap.action_erase_events("move_left")
	InputMap.action_erase_events("move_right")
	
	#remap the controls
	if (arrowControls):
		arrowControls = false
		createWASD()
		text = " CONTROLS: WASD "
	else:	
		arrowControls = true
		createArrow()
		text = "CONTROLS: ARROW"
	
func createWASD():
	#InputMap.add_action("jump")
	var key = InputEventKey.new()
	key.physical_keycode = KEY_W
	InputMap.action_add_event("jump", key)
	
	key = InputEventKey.new()
	key.physical_keycode = KEY_A
	InputMap.action_add_event("move_left", key)
	
	key = InputEventKey.new()
	key.physical_keycode = KEY_D
	InputMap.action_add_event("move_right", key)

func createArrow():
	var key = InputEventKey.new()
	key.physical_keycode = KEY_UP
	InputMap.action_add_event("jump", key)
	
	key = InputEventKey.new()
	key.physical_keycode = KEY_LEFT
	InputMap.action_add_event("move_left", key)
	
	key = InputEventKey.new()
	key.physical_keycode = KEY_RIGHT
	InputMap.action_add_event("move_right", key)
