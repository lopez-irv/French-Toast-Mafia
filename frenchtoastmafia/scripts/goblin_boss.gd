extends CharacterBody2D

@export var speed: float = 95.0
@export var gravity: float = 800.0
@export var attack_range: float = 80.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player := get_tree().get_first_node_in_group("Player")
@onready var hit_sound = $HitSoundPlayer
@export var max_health: int = 1000
@onready var healthBar: ProgressBar = $healthBar


@onready var btext = $boss_text

var control: bool
var attackName
var isHit = false
var health = 1000
var attacking = false
var can_play = true
var last_attack
var has_crossed_half = false
var threshold_health: float


func _ready() -> void: #turns hitboxes off at start 

	control = false

	health = max_health
	threshold_health = max_health * 0.5
	healthBar.value = health
	healthBar.max_value = health
	
	$hitBoxLeft.monitoring = false
	$hitBoxLeft.get_node("CollisionShape2D").disabled = true
	
	$hitBoxRight.monitoring = false
	$hitBoxRight.get_node("CollisionShape2D").disabled = true
	
	
func _physics_process(delta: float) -> void:

	if isDead or isHit:
		return
	if not control or not player:
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
			attackName = determineAttack()
			if attackName == "attack1": 
				attack1()
			if attackName == "attack2": 
				attack2()	
			if attackName == "jump_stomp": 
				jump_stomp()
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
		
func determineAttack()->String:
	var attacks = ["attack1", "attack2", "jump_stomp"]
	return attacks[randi() % attacks.size()]

func attack1() -> void:
	if attacking:
		return
	attacking = true
	
	sprite.play("attack1")
	last_attack = "attack1"
	print("playing attack1 animation")
	# Wait until halfway through the animation
	await get_tree().create_timer(0.9).timeout
	
	# Enable hitboxes
	$hitBoxLeft.monitoring = true
	$hitBoxLeft.get_node("CollisionShape2D").disabled = false
	$hitBoxRight.monitoring = true
	$hitBoxRight.get_node("CollisionShape2D").disabled = false
	# ⏱️ Keep hitboxes on for a short moment to register collision
	await get_tree().create_timer(0.25).timeout
	
	# Disable hitboxes
	$hitBoxLeft.monitoring = false
	$hitBoxLeft.get_node("CollisionShape2D").disabled = true
	$hitBoxRight.monitoring = false
	$hitBoxRight.get_node("CollisionShape2D").disabled = true
	
	# Finish the animation if still running
	await sprite.animation_finished
	#await get_tree().create_timer(0.2).timeout
	
	attacking = false

func attack2() -> void:
	if attacking:
		return
	attacking = true
	
	sprite.play("attack2")
	print("playing attack2 animation")
	last_attack = "attack2"
	
	# Wait until halfway through the animation
	await get_tree().create_timer(.285).timeout
	
	# Enable hitboxes
	$hitBoxLeft.monitoring = true
	$hitBoxLeft.get_node("CollisionShape2D").disabled = false
	$hitBoxRight.monitoring = true
	$hitBoxRight.get_node("CollisionShape2D").disabled = false
	
	# ⏱️ Keep hitboxes on for a short moment to register collision
	await get_tree().create_timer(0.57).timeout
	
	# Disable hitboxes
	$hitBoxLeft.monitoring = false
	$hitBoxLeft.get_node("CollisionShape2D").disabled = true
	$hitBoxRight.monitoring = false
	$hitBoxRight.get_node("CollisionShape2D").disabled = true
	
	# Finish the animation if still running
	await sprite.animation_finished
	#await get_tree().create_timer(0.2).timeout
	
	attacking = false
	
var isDead = false

func jump_stomp() -> void:
	if attacking:
		return
	attacking = true

	sprite.play("jump_stomp")
	print("playing jump_stomp animation")
	last_attack = "jump_stomp"
	await get_tree().create_timer(1.875).timeout

	var boss_level = get_tree().current_scene
	if boss_level.has_method("shake_camera"):
		boss_level.shake_camera(10.0, 0.3)
	
	await sprite.animation_finished

	attacking = false

func _on_hit_box_entered(body: Node2D) -> void:
	print("hitbox entered by: ", body.name)
	
	if body.is_in_group("Player") and isHit == false:
		player.decreaseHealth(15)
		
func take_damage(amount: int) -> void:
	if health <= 0 or isDead:
		return

	var prev = health
	health -= amount
	isHit = true
	healthBar.value = health # update health bar

	# Cancel attack
	play_hit_sound()
	if attacking:
		attacking = false
		sprite.play("hit")  # Interrupt attack
		#await get_tree().create_timer(0.2667).timeout
		print("playing get hit animation1")
	else:
		sprite.play("hit")
		#await get_tree().create_timer(0.2667).timeout
		print("playing get hit animation2")

	#await get_tree().create_timer(0.3).timeout  # Instead of await animation_finished

	isHit = false

	if not attacking and not isDead:
		var to_player = player.global_position - global_position
		var distance = to_player.length()
		if distance < attack_range:
			sprite.play("idle")
		else:
			sprite.play("running")

	if not has_crossed_half and prev > threshold_health and health <= threshold_health:
		has_crossed_half = true
		_on_reached_half_health()

	if health <= 0:
		isDead = true
		sprite.play("death")
		print("playing death animation")
		await sprite.animation_finished
		await get_tree().create_timer(0.2).timeout
		queue_free()


func _on_reached_half_health() -> void:
	get_tree().paused = true
	var dlg = get_tree().root.get_node("Node2D/HUD/FireballDialog") as AcceptDialog
	dlg.popup_centered()
	if player and player.has_method("enable_fireball"):
		player.enable_fireball()
		
func play_boss_text(cur_text: String, time1: float):
	btext.visible = true
	btext.text = cur_text
	#print(box1.text)
	await get_tree().create_timer(time1).timeout
	btext.visible = false
