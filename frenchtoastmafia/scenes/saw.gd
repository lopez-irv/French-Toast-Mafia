extends Area2D

@export var damage: int = 20
@export var damage_interval: float = 0.2  # seconds between damage ticks

var damage_timer: Timer

func _ready() -> void:
	# Start the saw animation.
	$sawAnimation.play("spin")
	
	# Connect the immediate damage when first entering.
	body_entered.connect(_on_body_entered)
	
	# Create and configure a Timer to repeatedly apply damage.
	damage_timer = Timer.new()
	damage_timer.wait_time = damage_interval
	damage_timer.one_shot = false
	damage_timer.autostart = true
	add_child(damage_timer)
	damage_timer.timeout.connect(_on_damage_timer_timeout)

# Immediately apply damage when something enters.
func _on_body_entered(body: Node) -> void:
	if body.has_method("decreaseHealth"):
		body.decreaseHealth(damage, true)

# On every timer tick, damage all overlapping bodies.
func _on_damage_timer_timeout() -> void:
	for body in get_overlapping_bodies():
		if body.has_method("decreaseHealth"):
			body.decreaseHealth(damage, true)
