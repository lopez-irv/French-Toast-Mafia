extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_timer: Timer = $DashTimer
@onready var healthBar: ProgressBar = $healthBar
@onready var dash_cooldown: Timer = $dashCooldown
@onready var invincibilityTimer: Timer = $invincibilityTimer

@export var inv: Inv
@export var attacking = false # in the same animatedSprite2d as take_damage, 
# we have an animation called sword_attack   , i want to play this animation
# when the attack button is pressed. 

var facing_right = false 
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

#for other sound effects
@onready var sound_effect_player: AudioStreamPlayer2D = $SoundEffectPlayer

var dash_ready_sound = preload("res://assets/sounds/dashReady.wav")

func _ready():
	# Make sure sword hitbox is off at the start
	$SwordHitbox.monitoring = false
	$SwordHitbox.get_node("CollisionShape2D").disabled = true
	# Make sure sword hitbox is off at the start
	$SwordHitboxLeft.monitoring = false
	$SwordHitboxLeft.get_node("CollisionShape2D").disabled = true
	
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
	if direction > 0:
		facing_right = true
	elif direction < 0:
		facing_right = false
	
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
		# Flip the hitbox position
		# Flip the sword hitbox based on direction



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
func decreaseHealth(n, ignore_invincibility: bool = false):
	if ignore_invincibility or invincibilityTimer.is_stopped():
		if not ignore_invincibility:
			invincibilityTimer.start()
		animated_sprite.play("take_damage")
		health -= n
		healthBar.value = health
		if health <= 0:
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func attack():
	if not attacking:
		attacking = true
		
		# 🟢 Activate the hitbox
		if (facing_right): #moving right 
			$SwordHitbox.monitoring = true
			$SwordHitbox.get_node("CollisionShape2D").disabled = false
		if (!facing_right): # moving left
			$SwordHitboxLeft.monitoring = true
			$SwordHitboxLeft.get_node("CollisionShape2D").disabled = false
		animated_sprite.play("sword_attack")
		await animated_sprite.animation_finished
	

		# 🔴 Deactivate the hitbox
		$SwordHitbox.monitoring = false
		$SwordHitbox.get_node("CollisionShape2D").disabled = true
		$SwordHitboxLeft.monitoring = false
		$SwordHitboxLeft.get_node("CollisionShape2D").disabled = true

		attacking = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack()
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
	#print(body_last_collided)
	
	#knockback for enemies that have a velocity
	if body_last_collided.is_in_group("Enemy"):
		knockback(body_last_collided.velocity)
	
	#knockback for stationary obstacles like spikes
	#moved this to spikes bc wasnt registering the health decrease
	#might need to move health decrease here if want knockback handled here
	#if body_last_collided.is_in_group("Obstacle"):
		#print("obstacle collision")
		#knockback(Vector2(0,0))


func _on_area_2d_area_exited(area: Area2D) -> void:
	if body_last_collided.name == area.name:
		body_last_collided.name = ""
	#print(body_last_collided)


func collect(item):
	inv.insert(item)


#calculates and applies knockback to player 
#set y knockback manually so it will have less of a large effect
var knockbackPower_x = 400
var knockbackPower_y = -100	#only works for upward knockback
func knockback(enemyVelocity: Vector2):
	#print("og player velocity", velocity)
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower_x
	#velocity = knockbackDirection
	velocity.x = knockbackDirection.x	
	velocity.y = knockbackPower_y	#this will not work if enemy hits from above 
	#print("enemy velocity", enemyVelocity)
	#print("new player velocity", velocity)
	#print(" ")
	move_and_slide()
	

func _on_sword_hitbox_body_entered(body: Node2D) -> void:
	#print("Sword hit:", body.name)
	if body and body.has_method("take_damage"):
		print("Calling take_damage on", body.name)
		body.take_damage(30)



func _on_dash_cooldown_timeout() -> void:
	#play sound
	sound_effect_player.stream = dash_ready_sound
	sound_effect_player.play()
	
	#make player flash once
	modulate = Color(0.678431, 0.847059, 0.901961, 1)
	await get_tree().create_timer(0.25).timeout
	modulate = Color(1,1,1,1) #back to normal
