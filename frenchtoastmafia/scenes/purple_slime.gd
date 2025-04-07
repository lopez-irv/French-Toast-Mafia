extends Node2D

const SPEED = 160
var direction = 1
var player = null

@onready var ray_cast_right: RayCast2D = $rayCastRight
@onready var ray_cast_left: RayCast2D = $rayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# 3D slime sound player node (AudioStreamPlayer3D)
@onready var slime_sound: AudioStreamPlayer2D = $SlimeSoundPlayer
var slime_sound_stream = preload("res://assets/sounds/slime-sound.mp3")

#@onready var players = get_tree().get_nodes_in_group("Player")

var velocity: Vector2 #for use with knockback for player

# NEW: Slime health
var health := 90

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
	
	#this is to determine velocity for knockback
	velocity[0] = direction * SPEED # x velocity
	velocity[1] = 0 # y velocity
	
	if can_play:
		play_slime_sound()
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("hit player")
	if body.is_in_group("Player"):
		player.decreaseHealth(10)
		
		#if body.has_node("healthBar"):
			#var healthBar = body.get_node("healthBar") as ProgressBar
			#healthBar.value = player.health  # update health bar visually
		
var can_play = true
func play_slime_sound():
	if can_play:
		slime_sound.play()
		can_play = false
		await get_tree().create_timer(0.30).timeout  # Delay before allowing the sound to play again.
		can_play = true
		
# NEW: Handle taking damage
func take_damage(amount: int):
	health -= amount
	print("Slime took", amount, "damage. Health now:", health)

	if health <= 0:
		queue_free()  # Destroy the slime
