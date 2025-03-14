extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_timer: Timer = $DashTimer
@onready var healthBar: ProgressBar = $healthBar
@onready var dash_cooldown: Timer = $dashCooldown

@export var inv: Inv

var health = 100.0
var body_last_collided

var speed = 130.0	#current speed
const DEFAULT_SPEED = 130.0
const JUMP_VELOCITY = -300.0
var canDoubleJump: bool

var wall_pushback = speed
const WALL_SLIDE_GRAVITY = 100
var isWallSliding = false

const DASH_WHILE_STILL = 800	#what to change velocity to when dashing while not moving
const DASH_WHILE_MOVING = 800	#what to change speed to when dashing while moving
const DASH_LENGTH = .1

# Footstep sound and tilemap for footsteps
@onready var tilemap = $"../TileMap"
@onready var footstep_sound = $FootstepAudioPlayer
var footstep_grass = preload("res://assets/sounds/grass-footsteps.wav")
var is_walking = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		canDoubleJump = true
		velocity.y = JUMP_VELOCITY

	#double jump
	if canDoubleJump and Input.is_action_just_pressed("jump") and not is_on_floor():
		canDoubleJump = false
		velocity.y = JUMP_VELOCITY
	
	
	#get direction
	var direction := Input.get_axis("move_left", "move_right")
	
	
	#dash 
	dash(direction)


	#handle the movement/deceleration.	
	if direction:
		if Input.is_action_pressed("run"):
			velocity.x = (direction * speed)
		else:
			velocity.x = (direction * speed)/2
		if direction > 0:
			# moving right
			animated_sprite.flip_h = false
		elif direction < 0:
			# moving left
			animated_sprite.flip_h = true


	if direction and Input.is_action_pressed("run"):
		velocity.x = (direction * speed)
	elif direction:
		velocity.x = (direction * speed)/2
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	
	#wall jump
	if is_on_wall_only() and Input.is_action_just_pressed("move_right"):
		velocity.y = JUMP_VELOCITY
		velocity.x = -wall_pushback
	if is_on_wall_only() and Input.is_action_just_pressed("move_left"):
		velocity.y = JUMP_VELOCITY
		velocity.x = wall_pushback
		
	wallSlide(delta)
	
	move_and_slide()
	
		# Check if walking for footsteps
	if is_on_floor() and abs(velocity.x) > 0.1:
		is_walking = true
		play_footstep_sound()
	else:
		is_walking = false
	
#if player is on a wall and holding down keys for l or r movement
#they will fall down the wall slowly
func wallSlide(delta):
	if is_on_wall_only():
		if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			isWallSliding = true
		else:
			isWallSliding = false
	else: 
		isWallSliding = false;
	
	if isWallSliding:
		velocity.y += (WALL_SLIDE_GRAVITY * delta)
		velocity.y = min(velocity.y, WALL_SLIDE_GRAVITY)
	
var can_play = true
func play_footstep_sound():
	if is_walking and can_play:		
		var tile_pos = tilemap.local_to_map(global_position)
		var atlas_coords = tilemap.get_cell_atlas_coords(0, tile_pos)
		
		if atlas_coords == Vector2i(0, 0):
			footstep_sound.stream = footstep_grass
			footstep_sound.play()
			can_play = false
			await get_tree().create_timer(0.30).timeout  # Timer for allowing sound to play again
			can_play = true
	
#lunges player forward in direction they are facing	
func dash(direction):
	
	if not dash_cooldown.on_cooldown():	#change to if true for unlimited dashing
		#if player is moving, change speed
		if Input.is_action_just_pressed("Dash") and direction:
			dash_timer.start_dash(DASH_LENGTH)
			dash_cooldown.start()
	
		#if player not moving, change velocity
		elif Input.is_action_just_pressed("Dash") and !direction:
			dash_cooldown.start()
			if animated_sprite.flip_h:
				velocity.x = -DASH_WHILE_STILL
			else:
				velocity.x = DASH_WHILE_STILL

	
	#this is for dashing while moving
	if dash_timer.is_dashing():	
		speed = DASH_WHILE_MOVING
	else:
		speed = DEFAULT_SPEED 

	#health and damage
func decreaseHealth(n):
	animated_sprite.play("take_damage")
	health -= n
	print("health droped to:", health)
	healthBar.value = health
	if (health <= 0):
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
func _process(delta: float) -> void:
	# If no animation is playing, ensure the default animation plays
	if not animated_sprite.is_playing():
		animated_sprite.play("idle")

func increaseHealth(n):
	health += n
	if health > 100:
		health = 100
	healthBar.value = health
	print("health raised to: ", health)

func _on_area_2d_area_entered(area: Area2D) -> void:
	body_last_collided = area.get_parent()
	print(body_last_collided)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if body_last_collided.name == area.name:
		body_last_collided.name = ""
	print(body_last_collided)

func collect(item):
	inv.insert(item)
