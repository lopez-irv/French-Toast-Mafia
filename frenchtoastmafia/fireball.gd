extends Area2D

@export var speed: float = 50.0
@export var damage: int  = 50

var direction: Vector2 = Vector2.RIGHT

func _ready():
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play()

func _physics_process(delta):
	position += direction * speed * delta
	var win_w = get_viewport().get_visible_rect().size.x
	if position.x < -200 or position.x > win_w + 200:
		queue_free()

func _on_Fireball_body_entered(body):
	if body.has_method("take_damage"):
		print("Fireball hit", body.name, "for", damage, "damage")
		body.take_damage(damage)
	queue_free()
