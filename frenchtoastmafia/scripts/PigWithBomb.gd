extends PigActor

@export var super_fast: bool = false
@onready var bomb_scene = load("res://scenes/Bomb.tscn")
@onready var player := get_tree().get_first_node_in_group("Player")
@onready var sprite: Sprite2D = $Sprite
# NEW: pig health
var health := 100
func _ready() -> void:
	super._ready()  # ✅ run PigActor's setup too

	$AttackTime.wait_time = randf_range(0.1, 0.2)
	$AttackTime.start()

	if super_fast:
		$Color.play("Fast")
	else:
		$Color.play("Normal")
		
func _physics_process(delta: float) -> void:
	if not player:
		return

	var to_player = player.global_position - global_position
	var distance = to_player.length()

	# 🔄 Face player
	sprite.flip_h = to_player.x < 0

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
