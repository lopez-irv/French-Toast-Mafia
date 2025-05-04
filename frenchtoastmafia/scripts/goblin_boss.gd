extends CharacterBody2D

@export var speed: float = 95.0
@export var gravity: float = 800.0
@export var attack_range: float = 80.0
@export var max_health: int = 240

var health: int
var threshold_health: float
var has_crossed_half: bool = false
var attacking: bool = false
var can_play: bool = true

@onready var sprite: AnimatedSprite2D       = $AnimatedSprite2D
@onready var player  := get_tree().get_first_node_in_group("Player")
@onready var hit_sound: AudioStreamPlayer2D = $HitSoundPlayer

func _ready() -> void:
	health = max_health
	threshold_health = max_health * 0.5
	$hitBoxLeft.monitoring = false
	$hitBoxLeft.get_node("CollisionShape2D").disabled = true
	$hitBoxRight.monitoring = false
	$hitBoxRight.get_node("CollisionShape2D").disabled = true

func _physics_process(delta: float) -> void:
	if not player:
		return

	var to_player = player.global_position - global_position
	var distance = to_player.length()
	sprite.flip_h = to_player.x < 0

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	if distance < attack_range and not attacking:
		velocity.x = 0
		attack()
	elif not attacking:
		chase_player(to_player.normalized())

	move_and_slide()

func chase_player(direction: Vector2) -> void:
	velocity.x = direction.x * speed
	sprite.play("running")

func play_hit_sound() -> void:
	if can_play:
		hit_sound.play()
		can_play = false
		await get_tree().create_timer(0.30).timeout
		can_play = true

func attack() -> void:
	if attacking:
		return
	attacking = true
	sprite.play("attack1")
	await get_tree().create_timer(0.9).timeout

	$hitBoxLeft.monitoring = true
	$hitBoxLeft.get_node("CollisionShape2D").disabled = false
	$hitBoxRight.monitoring = true
	$hitBoxRight.get_node("CollisionShape2D").disabled = false

	await get_tree().create_timer(0.25).timeout

	$hitBoxLeft.monitoring = false
	$hitBoxLeft.get_node("CollisionShape2D").disabled = true
	$hitBoxRight.monitoring = false
	$hitBoxRight.get_node("CollisionShape2D").disabled = true

	await sprite.animation_finished
	await get_tree().create_timer(0.2).timeout
	attacking = false

func take_damage(amount: int) -> void:
	if health <= 0:
		return

	var prev = health
	health -= amount
	sprite.play("hit")
	play_hit_sound()

	if not has_crossed_half and prev > threshold_health and health <= threshold_health:
		has_crossed_half = true
		_on_reached_half_health()

	if health <= 0:
		sprite.play("death")
		await sprite.animation_finished
		await get_tree().create_timer(0.2).timeout
		queue_free()

func _on_reached_half_health() -> void:
	get_tree().paused = true
	var dlg = get_tree().root.get_node("Node2D/HUD/FireballDialog") as AcceptDialog
	dlg.popup_centered()
	if player and player.has_method("enable_fireball"):
		player.enable_fireball()

func _on_hit_box_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player.decreaseHealth(5)
