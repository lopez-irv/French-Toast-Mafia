extends PigActor

@export var super_fast: bool = false
@onready var bomb_scene = load("res://scenes/Bomb.tscn")
# NEW: pig health
var health := 100
func _ready() -> void:
	$AttackTime.wait_time = randf_range(0.1, 0.2)
	$AttackTime.start()
	
	if super_fast:
		$Color.play("Fast")
	else:
		$Color.play("Normal")

func set_flip() -> void:
	if velocity.x == 0:
		return
	var is_flipped = velocity.x > 0
	
	$Sprite.flip_h = is_flipped
	$CollisionShape2D.position.x = -1 if is_flipped else 1
	$StompDetector/CollisionShape2D.position.x = -1 if is_flipped else 1

func animation_after_attack() -> void:
	$ani.play("Idle")
	var bomb = bomb_scene.instantiate()
	bomb.position = $BombStart.position
	add_child(bomb)

func _on_Timer_timeout() -> void:
	$AttackTime.wait_time = randf_range(0.1, 1.0) if super_fast else randf_range(1.0, 3.0)
	if state == State.DEAD:
		return
	$ani.play("Throw")
func take_damage(amount: int):
	health -= amount
	print("Pig took", amount, "damage. Health now:", health)

	if health <= 0:
		queue_free()  # Destroy the pig
