extends Node2D

var player = null
var damage_ticks = 0
@onready var healthbar: Node = $Healthbar
@onready var damage_timer: Timer = $Area2D/DamageTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]  # Assign the first player found.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("hit player")
	if body.is_in_group("Player"):
		player = body
		damage_ticks = 0
		damage_timer.start()

func _on_damage_timer_timeout() -> void:
	if player and damage_ticks < 5:
		print("🔥 Timer ticked!")
		player.decreaseHealth(1)
		if player.has_node("healthBar"):
			var healthBar = player.get_node("healthBar") as ProgressBar
			healthBar.value = player_level_global.health
		damage_ticks += 1
	else:
		print("🔥 Done burning or no player")
		damage_timer.stop()
