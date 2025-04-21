extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_timer: Timer = $DashTimer
@onready var healthBar: ProgressBar = $healthBar
@onready var dash_cooldown: Timer = $dashCooldown
@onready var invincibilityTimer: Timer = $invincibilityTimer

@onready var torch: Node2D = $Torch

@export var inv: Inv
@export var attacking = false # in the same animatedSprite2d as take_damage, 
# we have an animation called sword_attack   , i want to play this animation
# when the attack button is pressed. 
var hurt_sound = preload("res://assets/sounds/hurt.wav")
var facing_right = false 
#var health = player_level_global.healthCap
var body_last_collided
var playerLevel = 0
var threshold = 100

var speed = 130.0	#current speed
const DEFAULT_SPEED = 130.0
const JUMP_VELOCITY = -300.0
var canDoubleJump: bool

var wall_pushback = speed
const WALL_SLIDE_GRAVITY = 100
var isWallSliding = false

const ROLL_SPEED = 10
const ROLL_DURATION = .7
var is_rolling = false

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
var dash_sound = preload("res://assets/sounds/dash-sound-effect.wav")
var torch_on = preload("res://assets/sounds/torch_on.wav")
var torch_off = preload("res://assets/sounds/torch_off.wav")

func _ready():
	#print("health is", )
	# Make sure sword hitbox is off at the start
	$SwordHitbox.monitoring = false
	$SwordHitbox.get_node("CollisionShape2D").disabled = true
	# Make sure sword hitbox is off at the start
	$SwordHitboxLeft.monitoring = false
	$SwordHitboxLeft.get_node("CollisionShape2D").disabled = true
	
	torch.visible = false
	
	healthBar.max_value = player_level_global.healthCap
	healthBar.value = player_level_global.health
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_rolling:
		move_and_slide()
		return
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		canDoubleJump = true
		#velocity.y = 0
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
	# Roll input check
	if Input.is_action_just_pressed("roll") and not is_rolling and is_on_floor():
		start_roll()
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
			torch.flip_torch_right()
		elif direction < 0:
			# moving left
			animated_sprite.flip_h = true
			torch.flip_torch_left()
			
			
		# Flip the hitbox position
		# Flip the sword hitbox based on direction


	if direction:
		if Input.is_action_pressed("run"):
			velocity.x = (direction * speed)
			if not attacking:
				animated_sprite.play("run")
		elif isWallSliding:
			if not attacking:
				animated_sprite.play("wall_slide")
		else:
			velocity.x = (direction * speed) / 2
			if not attacking:
				animated_sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if is_on_floor() and not attacking:
			animated_sprite.play("idle")


	
	#wall jump
	if is_on_wall_only() and Input.is_action_just_pressed("move_right"):
		velocity.y = JUMP_VELOCITY
		velocity.x = -wall_pushback
	if is_on_wall_only() and Input.is_action_just_pressed("move_left"):
		velocity.y = JUMP_VELOCITY
		velocity.x = wall_pushback
		
	wallSlide(delta)
	
	
	if not attacking and animated_sprite.animation in ["idle", "run","wall_slide"]:
		if isWallSliding:
			animated_sprite.play("wall_slide")
		elif direction:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")


	
	move_and_slide()
	
		# Check if walking for footsteps
	if is_on_floor() and abs(velocity.x) > 0.1:
		is_walking = true
		play_footstep_sound()
	else:
		is_walking = false
		
	#torch toggle
	if Input.is_action_just_pressed("equip_torch"):
		equip_torch()
	
func start_roll():
	is_rolling = true
	attacking = true  # Optional: Prevent attack during roll
	print("rolling...")
	animated_sprite.play("roll")
	# Set initial roll velocity
	if facing_right:
		velocity.x = ROLL_SPEED
	else:
		velocity.x = -ROLL_SPEED

	await get_tree().create_timer(ROLL_DURATION).timeout

	is_rolling = false
	attacking = false
	
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
	
	if not dash_cooldown.on_cooldown():	 #change to if true for unlimited dashing
		#if player is moving, change speed
		if Input.is_action_just_pressed("Dash") and direction:
			dash_timer.start_dash(DASH_LENGTH)
			dash_cooldown.start()
			# Play dash sound
			sound_effect_player.stream = dash_sound
			sound_effect_player.play()
	
		#if player not moving, change velocity
		elif Input.is_action_just_pressed("Dash") and !direction:
			dash_cooldown.start()
			# Play dash sound
			sound_effect_player.stream = dash_sound
			sound_effect_player.play()
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
		
		#plays hurt sound
		sound_effect_player.stream = hurt_sound
		sound_effect_player.play()
		
		player_level_global.health -= n
		healthBar.value = player_level_global.health
		if player_level_global.health <= 0:
			player_level_global.health = player_level_global.healthCap
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func attack():
	if not attacking:
		attacking = true
		
		# 🟢 Activate the correct hitbox
		if facing_right:
			$SwordHitbox.monitoring = true
			$SwordHitbox.get_node("CollisionShape2D").disabled = false
		else:
			$SwordHitboxLeft.monitoring = true
			$SwordHitboxLeft.get_node("CollisionShape2D").disabled = false

		# 🔥 Play attack animation
		animated_sprite.play("sword_attack")

		# Wait for the animation OR a short timeout as a fallback
		var timer := get_tree().create_timer(0.4)
		await animated_sprite.animation_finished or timer.timeout

		# 🔴 Cleanup
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
	player_level_global.health += n
	if player_level_global.health > player_level_global.healthCap:
		player_level_global.health = player_level_global.healthCap
	if(player_level_global.health > 100): 
		healthBar.max_value = player_level_global.health
		print("health bar max value: ", healthBar.max_value)
	healthBar.value = player_level_global.health
	print("health raised to: ", player_level_global.health)


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
		body.take_damage(player_level_global.attackDamage)
		player_level_global.xp += 50 #NEW XP STUFF
		print("XP increased to ", player_level_global.xp)
		if player_level_global.xp %100 == 0: 
			player_level_global.level_up()
			print ("Player Level is: ", player_level_global.playerLevel)
		



func _on_dash_cooldown_timeout() -> void:
	#play sound
	sound_effect_player.stream = dash_ready_sound
	sound_effect_player.play()
	
	#make player flash once
	modulate = Color(0.678431, 0.847059, 0.901961, 1)
	await get_tree().create_timer(0.25).timeout
	modulate = Color(1,1,1,1) #back to normal


func _on_sword_hitbox_area_entered(area: Area2D) -> void:
	print("Sword hit:", area.name)
	if area and area.has_method("take_damage"):
		print("Calling take_damage on", area.name)
		area.take_damage(30)


func equip_torch():
	if torch.visible:
		torch.visible = false
		sound_effect_player.stream = torch_off
		sound_effect_player.play()
	else:
		torch.visible = true
		sound_effect_player.stream = torch_on
		sound_effect_player.play()
