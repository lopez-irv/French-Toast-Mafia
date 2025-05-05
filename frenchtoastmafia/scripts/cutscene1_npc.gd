extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var box1 = $box1
@onready var target = get_tree().get_root().find_child("player", true, false)

@onready var me = $AnimatedSprite2D



#func _process(delta):
#	if target:
#		if target.global_position.x > global_position.x:
#			# target is to the right
#			$AnimatedSprite2D.flip_h = true
#		else:
#			# target is to the left
#			$AnimatedSprite2D.flip_h = false


func _ready() -> void:
	$AnimatedSprite2D.flip_h = true
	box1.visible = false



func play_npc_text(text_name: String, time1: float):
	box1.visible = true
	box1.text = text_name
	await get_tree().create_timer(time1).timeout
	box1.visible = false
	
func flip_npc_x():
	if me.flip_h:
		me.flip_h = false
	else:
		me.flip_h = true
		
		
		
		
