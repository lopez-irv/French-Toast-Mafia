# Archer.gd
extends CharacterBody2D
@export var player: Node2D = null
@export var aggro_range: float     = 300.0
@export var attack_range: float    = 200.0
@export var move_speed: float      = 100.0
@export var gravity: float         = 980.0
@export var attack_cooldown: float = 1.5
@export var archer_health: int     = 20
@export var arrow_scene: PackedScene = preload("res://Arrow.tscn")

var can_attack: bool    = true
var is_attacking: bool  = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D  = $CollisionShape2D

func _ready() -> void:
	if player == null:
		var s = get_tree().current_scene
		if s:
			player = s.get_node("player") as Node2D
			if player == null:
				push_error("Player node not found!")
	animated_sprite.play("idle")
	collision_shape.position = Vector2(0, 15)

func _physics_process(delta: float) -> void:
	if player == null:
		return

	# Face the player
	animated_sprite.flip_h = (player.global_position.x < global_position.x)
	var dist = player.global_position.distance_to(global_position)
	var vx = 0.0

	# Chase
	if dist < aggro_range and dist > attack_range:
		var dir = (player.global_position - global_position).normalized()
		vx = dir.x * move_speed

	# Attack
	if dist <= attack_range and can_attack:
		vx = 0
		attack()

	velocity.x = vx

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	move_and_slide()

	# Idle/Run animations
	if not is_attacking:
		if abs(vx) > 0.1:
			if animated_sprite.animation != "run":
				animated_sprite.play("run")
		else:
			if animated_sprite.animation != "idle":
				animated_sprite.play("idle")


func attack() -> void:
	if is_attacking:
		return
	is_attacking = true
	can_attack = false

	# pick one attack animation at random
	var attacks = ["attack_low", "attack_normal", "attack_high"]
	var choice = attacks[randi() % attacks.size()]
	animated_sprite.play(choice)

	# wait until the bow-release frame
	await get_tree().create_timer(0.3).timeout

	if arrow_scene == null:
		push_error("❌ arrow_scene is null! Check your preload path or Inspector assignment.")
		return

	# spawn & fire arrow
	var arrow = arrow_scene.instantiate() as Area2D
	
	var flip_mul = -1 if animated_sprite.flip_h else 1
	arrow.global_position = global_position + Vector2(flip_mul * 20, -10)
	arrow.velocity = (player.global_position - global_position).normalized()
	get_parent().add_child(arrow)

	# cooldown
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	is_attacking = false


func take_damage(amount: int) -> void:
	archer_health -= amount
	if archer_health <= 0:
		animated_sprite.play("death")
		await get_tree().create_timer(0.5).timeout
		queue_free()
func decreaseHealth(amount: int) -> void:
	take_damage(amount)


func _on_AnimatedSprite2D_animation_finished(name: String) -> void:
	if name.begins_with("attack"):
		animated_sprite.play("idle")
	elif name == "death":
		queue_free()
