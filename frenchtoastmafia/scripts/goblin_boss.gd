extends CharacterBody2D

@export var speed: float = 95.0
@export var gravity: float = 800.0
@export var attack_range: float = 80.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player := get_tree().get_first_node_in_group("Player")
@onready var hit_sound = $HitSoundPlayer

var isHit = false
var health = 240
var attacking = false
var can_play = true
var last_attack

func _ready() -> void: #turns hitboxes off at start 
	$hitBoxLeft.monitoring = false
	$hitBoxLeft.get_node("CollisionShape2D").disabled = true
	
	$hitBoxRight.monitoring = false
	$hitBoxRight.get_node("CollisionShape2D").disabled = true
	
	
func _physics_process(delta: float) -> void:
	if not player:
		return

	var to_player = player.global_position - global_position
	var distance = to_player.length()

	# 🔄 Face player
	sprite.flip_h = to_player.x < 0

	# 🔽 Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# 🤺 Decide behavior
	if distance < attack_range:
		if not attacking:
			velocity.x = 0
			attack()
	else:
		chase_player(to_player.normalized())

	move_and_slide()

func chase_player(direction: Vector2) -> void:
	if attacking:
		return
	velocity.x = direction.x * speed
	sprite.play("running")
	
func play_hit_sound():
	if can_play and hit_sound:
		hit_sound.play()
		can_play = false
		await get_tree().create_timer(0.30).timeout
		can_play = true
		
func attack() -> void:
	if attacking:
		return
	attacking = true
	
	sprite.play("attack1")
	last_attack = "attack1"
	
	# Wait until halfway through the animation
	await get_tree().create_timer(0.9).timeout
	
	# Enable hitboxes
	$hitBoxLeft.monitoring = true
	$hitBoxLeft.get_node("CollisionShape2D").disabled = false
	$hitBoxRight.monitoring = true
	$hitBoxRight.get_node("CollisionShape2D").disabled = false
	
	# Camera shake (optional)
	var boss_level = get_tree().current_scene
	if boss_level.has_method("shake_camera") and last_attack == "jump_stomp":
		boss_level.shake_camera(10.0, 0.3)
	
	# ⏱️ Keep hitboxes on for a short moment to register collision
	await get_tree().create_timer(0.25).timeout
	
	# Disable hitboxes
	$hitBoxLeft.monitoring = false
	$hitBoxLeft.get_node("CollisionShape2D").disabled = true
	$hitBoxRight.monitoring = false
	$hitBoxRight.get_node("CollisionShape2D").disabled = true
	
	# Finish the animation if still running
	await sprite.animation_finished
	await get_tree().create_timer(0.2).timeout
	
	attacking = false

	
var isDead = false

func take_damage(amount: int)->void: 
	if(isDead == false):
		health -= amount
		print("Goblin took", amount, "damage. Health now:", health)
		sprite.play("hit")
		play_hit_sound()
	
	if health <= 0 and isDead == false:
		isDead = true
		sprite.play("death")
		await sprite.animation_finished
		await get_tree().create_timer(0.2).timeout  # small pause after swing
		queue_free()  # Destroy the goblin


func _on_hit_box_entered(body: Node2D) -> void:
	print("hitbox entered by: ", body.name)
	
	if body.is_in_group("Player") and isHit == false:
		player.decreaseHealth(5)
