extends Area2D

@export var speed:  float      = 40.0
@export var damage: int        = 20

var velocity: Vector2 = Vector2.ZERO
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	anim.play("fly")

func _physics_process(delta: float) -> void:
	global_position += velocity * speed * delta

func _on_Area2D_body_entered(body: Node) -> void:
	print("Arrow collided with: ", body.name)
	if body.has_method("decreaseHealth"):
		body.decreaseHealth(damage)
	queue_free()
