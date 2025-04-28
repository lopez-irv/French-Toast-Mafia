extends CharacterBody2D

@export var fly_left: bool = true

var player = null
var gravity: float = 150.0
var is_boom: bool = false
var can_boom: bool = false

func _ready() -> void:
	#add_to_group("Player")
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]  # Assign the first player found.
	velocity = Vector2(-100, -100) if fly_left else Vector2(0, -1)

func boom() -> void: # used after "On" animation
	$BoomDetector.monitorable = true
	$BoomDetector.monitoring = true
	$Ani.play("Boom")

func turn_off_detector() -> void:
	$BoomDetector.monitorable = false
	$BoomDetector.monitoring = false
	collision_mask = 6

func call_die() -> void:
	is_boom = true
	call_deferred("boom")

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()

func _on_StartDetector_body_entered(body: Node) -> void:
	if can_boom:
		velocity.x = 0

	if not is_boom and can_boom:
		$Ani.play("On")
		is_boom = true

func _on_BoomDetector_body_entered(body: Node) -> void:
	#print("im in _on_BoomDetector_body_entered ", body)
	if body.has_method("take_damage"): #enemies will also take damage from bombs
		body.take_damage(100)
	if body.is_in_group("Player") and body.has_method("decreaseHealth"):
		#print("player should decrease health now")
		body.decreaseHealth(20)

func _on_StartDetecting_timeout() -> void:
	can_boom = true
	# $CollisionShape2D.disabled = false
