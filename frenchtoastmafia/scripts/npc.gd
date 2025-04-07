extends Node2D

@onready var label = $TextLabel
@onready var timer = $DialogTimer
@onready var type_timer = $TypeTimer
@onready var shop_ui = $shop_ui
@onready var coinerr = $shop_ui/Panel/VBoxContainer/coin_error

#dialog stores in a dictionary
var dialog_lines := {
	"npc1" : [
		"Hey there little fella. What can I get for you?",
		"You know i'm a busy giant, if you're not buying anything you can leave.",
		"OK, i'm sorry. I was a little harsh back there. I will still take your money if you want.",
		"NOW YOUR JUST WASTING MY TIME!! See what you get, now im gonna ignore you."
	]
}

var current_npc_id := "npc1"
var current_line_index := 0
var full_text = ""
var char_index := 0
var is_typing := false
var dialog_active := false
var player_in_range := false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$InteractionZone.connect("body_entered", self._on_body_entered)
	$InteractionZone.connect("body_exited", self._on_body_exited)
	label.visible = false
	timer.connect("timeout", self._on_DialogTimer_timeout)
	type_timer.connect("timer", self._on_type_timer_timeout)
	shop_ui.visible = false
	coinerr.visible = false

func _process(delta: float) -> void:
	if player_in_range and shop_ui.visible == false and Input.is_action_just_pressed("interact"):
		stop_dialog_and_open_shop()
	
	elif player_in_range and shop_ui.visible and Input.is_action_just_pressed("interact"):
		shop_ui.visible = false
	
	if not player_in_range:
		stop_dialog_and_close_shop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func start_dialog():
	current_line_index = 0
	label.visible = true
	dialog_active = true
	start_typewriter(dialog_lines[current_npc_id][current_line_index])
	#timer.start()
	
func start_typewriter(text):
	full_text = text
	label.text = ""
	char_index = 0
	is_typing = true
	type_timer.start()
	
func _on_type_timer_timeout():
	if char_index < full_text.length():
		label.text += full_text[char_index]
		char_index += 1
	else:
		type_timer.stop()
		is_typing = false
		timer.start()
	
func _on_DialogTimer_timeout():
	current_line_index +=1
	
	if current_line_index < dialog_lines[current_npc_id].size():
		start_typewriter(dialog_lines[current_npc_id][current_line_index])
		#label.text = dialog_lines[current_npc_id][current_line_index]
	else:
		timer.stop()
		label.visible = false
		dialog_active = false
		
func _on_body_entered(body):
	print("someone is here: ", body.name)
	if body.name == "player":
		player_in_range = true
		start_dialog()
		
func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false

func open_shop():
	shop_ui.visible = true
	
func stop_dialog_and_open_shop():
	type_timer.stop()
	timer.stop()
	label.visible = false
	dialog_active = false
	is_typing = false
	shop_ui.visible = true

func stop_dialog_and_close_shop():
	type_timer.stop()
	timer.stop()
	label.visible = false
	dialog_active = false
	is_typing = false
	shop_ui.visible = false
