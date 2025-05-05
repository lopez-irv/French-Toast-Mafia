extends Node2D
@onready var player_sprite: AnimatedSprite2D = $player/AnimatedSprite2D
@onready var npc_sprite: AnimatedSprite2D = $npc/AnimatedSprite2D
@onready var animation_player = $animations
@onready var player1 = $player
@onready var is_dead: bool 
@onready var players_text_box = $player/box2

#players text
#var text1: String = "Now what?"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	players_text_box.visible = false
	player1.controls_enabled = false
	#print("Setting sprite...")
	player_sprite.animation = "death"
	#print("Death frame count:", player_sprite.sprite_frames.get_frame_count("death"))
	player_sprite.stop()
	player_sprite.frame = 3
	player_sprite.visible = true  # ensure it's visible
	animation_player.play("arise")
	await animation_player.animation_finished
	animation_player.play("walk and talk")
	await animation_player.animation_finished
	animation_player.play("head out")
	#print("Animation:", player_sprite.animation)
	#print("Frame:", player_sprite.frame)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func play_player_animation(animation_name: String, order: int):
	if player_sprite:
		if order == 0:
			player1.controls_enabled = false
			player_sprite.play(animation_name)
			await player_sprite.animation_finished
			player1.controls_enabled = true
			#print("trying to play:", animation_name)
			#print("is_playing:", player_sprite.is_playing())
			#print("current animation:", player_sprite.animation)
		elif order == 1:
			player1.controls_enabled = false
			player_sprite.play_backwards(animation_name)
			await player_sprite.animation_finished
			player1.controls_enabled = true
		elif order == 3:
			player1.controls_enabled = false
			player_sprite.stop()
		else:
			print("sike thats the wrong number")
	else:
		print("player sprite not found")
		
func play_npc_animation(animation_name: String, order: int):
	if npc_sprite:
		if order == 0:
			npc_sprite.play(animation_name)
		elif order == 1:
			npc_sprite.play_backwards(animation_name)
		elif order == 3:
			npc_sprite.stop()
		else:
			print("sike thats the wrong number")
	else:
		print("player sprite not found")

func show_players_text(cur_text: String, time1: float):
	players_text_box.visible = true
	players_text_box.text = cur_text
	#print(box1.text)
	await get_tree().create_timer(time1).timeout
	players_text_box.visible = false
