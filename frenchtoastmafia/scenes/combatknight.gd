extends CharacterBody2D

@export var player: Node2D = null
@export var interact_range: float = 100.0

# Enemy behavior variables:
@export var aggro_range: float = 200.0   # When the knight starts chasing the player
@export var attack_range: float = 50.0   # When the knight is close enough to attack
@export var move_speed: float = 80.0     # Movement speed of the knight

var can_attack: bool = true
var is_attacking: bool = false
var gravity: float = 980.0  # Adjust this value as needed

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	# Find player node
	if player == null:
		var scene = get_tree().current_scene
		if scene:
			player = scene.get_node("player") as Node2D
			if player == null:
				print("Player node not found!")
		else:
			print("No current scene found!")
	animated_sprite.play("idle")
	collision_shape.position = Vector2(0, 15) # Change location of hitbox

func _physics_process(delta: float) -> void:
	if player:
		# Face the player
		animated_sprite.flip_h = player.global_position.x < global_position.x
		var distance = player.global_position.distance_to(global_position)
		
		# Horizontal movement
		var intended_velocity_x: float = 0.0
		if distance < aggro_range:
			var direction = (player.global_position - global_position).normalized()
			intended_velocity_x = direction.x * move_speed
		
		# Attack if within range
		if distance < attack_range and can_attack:
			intended_velocity_x = 0
			attack()
		velocity.x = intended_velocity_x
		
		# Keep knight on ground
		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			velocity.y = 0
		
		move_and_slide()
		
		# run / idle animation if not attacking
		if not is_attacking:
			if abs(intended_velocity_x) > 0.1:
				if animated_sprite.animation != "run":
					animated_sprite.play("run")
			else:
				if animated_sprite.animation != "idle":
					animated_sprite.play("idle")
	else:
		velocity = Vector2.ZERO
		move_and_slide()

func _input(event: InputEvent) -> void:
	# Old interaction code, there are no more interactions with the version of knight currently in the game
	if event.is_action_pressed("interact") and player:
		var distance = player.global_position.distance_to(global_position)
		if distance <= interact_range:
			pass

func attack() -> void:
	if is_attacking:
		return

	is_attacking = true
	can_attack = false
	animated_sprite.play("attack")
	
	# Wait for animation to complete before attacking again
	await get_tree().create_timer(0.5).timeout

	if player.has_method("decreaseHealth"):
		player.decreaseHealth(10)
	
	await get_tree().create_timer(1.0).timeout  # Timer
	can_attack = true
	is_attacking = false
