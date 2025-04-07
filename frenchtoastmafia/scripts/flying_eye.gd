extends Node2D

@export var follow_radius := 500
@export var attack_radius := 200
@export var fly_speed := 50.0
@export var attack_speed := 300.0
@export var attack_duration := 0.5
@export var attack_cooldown := 2.5

var health = 60
var damage = 15
var player: Node2D
var attacking := false
var dashing := false
var attacking_direction := Vector2.ZERO

#@onready var anim_player := $AnimationPlayer
@onready var attack_timer := $AttackCoolDown
@onready var sprite := $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("player")
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_cooldown_finished)
	sprite.play("flying")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not player:
		return
		
	_update_facing()
	
	if dashing:
		global_position += attacking_direction * attack_speed * delta
		return
	
	if attacking:
		return
		
	var distance = global_position.distance_to(player.global_position)
	
	#if distance < attack_radius and not attack_timer.is_stopped():
	#	return
	
	if distance < attack_radius and attack_timer.is_stopped():
		_start_attack()
	elif distance < follow_radius:
		_follow_player(delta)
		
func _follow_player(delta):
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * fly_speed * delta
	
func _start_attack():
	attacking = true
	$HitBox.monitoring = true
	sprite.play("attack")
	await  sprite.animation_finished #wait for attack to finish
	
	sprite.pause()
	attacking_direction = (player.global_position - global_position).normalized()
	
	dashing = true
	attack_timer.start()
	await get_tree().create_timer(attack_duration).timeout # attack duration
	
	attacking = false
	dashing = false
	$HitBox.monitoring = false
	sprite.play("flying")
	attack_timer.start()
	

func _on_attack_cooldown_finished():
	pass

func _update_facing():
	if player: 
		$AnimatedSprite2D.flip_h = player.global_position.x < global_position.x
		



func _on_hit_box_body_entered(body: Node2D) -> void:
	#print("body entered:", body.name) for debugging
	if dashing and body.name == "player":
		if body.has_method("decreaseHealth"):
			body.decreaseHealth(damage)

func take_damage(amount: int):
	health -= amount
	print("Eye took", amount, "damage. Health now:", health)
	sprite.play("take damage")
	await sprite.animation_finished
	sprite.play("flying")

	if health <= 0:
		_die()  # De
		
func _die():
	attacking = false
	dashing = false
	$HitBox.monitoring = false
	sprite.play("dying")
	await sprite.animation_finished
	queue_free()
