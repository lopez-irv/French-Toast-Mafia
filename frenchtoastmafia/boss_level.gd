extends Node2D

@onready var camera = get_viewport().get_camera_2d()
@onready var pText = $player/player_text
@onready var player1 = $player
@onready var anim_player = $AnimationPlayer
@onready var goble = $goblinBoss
#@onready var btext = $goblinBoss/boss_text
# Called when the node enters the scene tree for the first time.
#var control: bool

func _ready() -> void:
	pText.visible = false
	player1.controls_enabled = false
	goble.control = false
	anim_player.play("initial dialog")
	await anim_player.animation_finished
	player1.controls_enabled = true
	goble.control = true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func shake_camera(intensity := 5.0, duration := 0.2):
	var original_offset = camera.offset
	var time = 0.0
	while time < duration:
		var random_offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		camera.offset = original_offset + random_offset
		await get_tree().process_frame
		time += get_process_delta_time()
	camera.offset = original_offset	
	
func show_players_text(cur_text: String, time1: float):
	pText.visible = true
	pText.text = cur_text
	#print(box1.text)
	await get_tree().create_timer(time1).timeout
	pText.visible = false

func flip_goblin_x():
	if goble.sprite.flip_h:
		goble.sprite.flip_h = false
	else:
		goble.sprite.flip_h = true
