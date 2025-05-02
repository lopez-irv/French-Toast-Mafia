extends CharacterBody2D
class_name PigActor

@export var flip_on_start: bool = false
@export var disable_move: bool = false
@export var run_right: bool = false
@export var body_free: bool = false
@export var disable_collision: bool = false
@export var coin_scene: PackedScene

@export var basic_speed: int = -185

enum State {
	STOP,
	MOVING,
	DEAD
}

var gravity: float = 1000.0
var state: State = State.MOVING

func _ready() -> void:
	velocity = Vector2(basic_speed, 0)
	if run_right:
		velocity.x = -basic_speed
	if disable_move:
		state = State.STOP
	if disable_collision:
		$PlayerDetector.monitorable = false
		$PlayerDetector.monitoring = false

func _physics_process(delta: float) -> void:
	if state == State.STOP:
		return
	if state == State.DEAD:
		velocity.x = 0
	
	velocity.y += gravity * delta
	if is_on_wall():
		velocity.x *= -1
	
	move_and_slide()
	
	if state == State.MOVING:
		set_animation()
		#set_flip()

func _on_StompDetector_body_entered(body: Node) -> void:
	var stomp_y = $StompDetector/CollisionShape2D.global_position.y + $StompDetector/CollisionShape2D.shape.extents.y
	if body.global_position.y < stomp_y:
		if body.has_method("calculate_stomp_velocity"):
			body.calculate_stomp_velocity(300)
		call_die()

func _on_PlayerDetector_body_entered(body: Node) -> void:
	if $ani:
		$ani.play("Attack")
	#if body.global_position.x > global_position.x:
	#	flip(true)
	#else:
		#flip(false)

	state = State.STOP
	if body.has_method("die"):
		body.die()

func call_die() -> void:
	if state == State.DEAD:
		return
	call_deferred("die")

func die() -> void:
	if coin_scene:
		var coin_instance = coin_scene.instantiate()
		coin_instance.position = Vector2(5, -8)
		add_child(coin_instance)

	if $StompDetector:
		if $StompDetector.has_node("CollisionShape2D"):
			$StompDetector.get_node("CollisionShape2D").disabled = true
		$StompDetector.monitoring = false
		$StompDetector.monitorable = false

	if $PlayerDetector:
		if $PlayerDetector.has_node("CollisionShape2D"):
			$PlayerDetector.get_node("CollisionShape2D").disabled = true
		$PlayerDetector.monitoring = false
		$PlayerDetector.monitorable = false
	
	collision_layer = 0
	state = State.DEAD
	
	if $ani:
		$ani.play("Dead")
	if has_node("Color"):
		$Color.play("Normal")

func run() -> void:
	state = State.MOVING

func check_body_free() -> void:
	if body_free:
		queue_free()

func set_animation() -> void:
	if not $ani or state != State.MOVING:
		return
	
	var anim_name := "Idle"
	if velocity.x != 0:
		anim_name = "Run"
	if not is_on_floor():
		anim_name = "Jump"

	anim_play(anim_name)

func set_flip(force: bool = false) -> void:
	if not force and velocity.x == 0:
		return
	var is_flipped = velocity.x > 0
	flip(is_flipped)

func flip(is_flipped: bool) -> void:
	if $Sprite:
		$Sprite.flip_h = is_flipped
	if $CollisionShape2D:
		$CollisionShape2D.position.x = -1 if is_flipped else 5
	if $StompDetector.has_node("CollisionShape2D"):
		$StompDetector.get_node("CollisionShape2D").position.x = -1 if is_flipped else 5
	if $PlayerDetector.has_node("CollisionShape2D"):
		$PlayerDetector.get_node("CollisionShape2D").position.x = -1 if is_flipped else 5

func attack() -> void:
	pass

func anim_play(new_animation: String) -> void:
	if not $ani:
		return
	if $ani.current_animation == "Attack":
		return
	if $ani.current_animation == new_animation:
		return
	$ani.play(new_animation)
