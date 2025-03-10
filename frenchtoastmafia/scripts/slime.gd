extends Node2D

const SPEED = 60
var direction = 1
var player = null
var player_in_contact = false
var damage_task_running = false

@onready var ray_cast_right: RayCast2D = $rayCastRight
@onready var ray_cast_left: RayCast2D = $rayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# 3D slime sound player node (AudioStreamPlayer3D)
@onready var slime_sound: AudioStreamPlayer2D = $SlimeSoundPlayer
var slime_sound_stream = preload("res://assets/sounds/slime-sound.mp3")

#@onready var players = get_tree().get_nodes_in_group("Player")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]  # Assign the first player found.
		
	# Set the slime sound stream to the 3D audio player.
	slime_sound.stream = slime_sound_stream
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#makes slime move between 2 walls
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * SPEED * delta
	
	if can_play:
		play_slime_sound()
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		player_in_contact = true
		if not damage_task_running:
			start_damage_over_time()
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_contact = false

func start_damage_over_time():
	damage_task_running = true
	var duration := 15
	var interval := 1.0  # Deal damage every second
	var total_ticks := int(duration / interval)
	var damage_per_tick := 15.0 / total_ticks  # This gives -20 health total over 20s

	for i in range(total_ticks):
		if not player_in_contact:
			break
		if player:
			player.decreaseHealth(damage_per_tick)
			player.healthBar.value = player.health
		await get_tree().create_timer(interval).timeout

	damage_task_running = false

var can_play = true
func play_slime_sound():
	if can_play:
		slime_sound.play()
		can_play = false
		await get_tree().create_timer(0.30).timeout  # Delay before allowing the sound to play again.
		can_play = true
