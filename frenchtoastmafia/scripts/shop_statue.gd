extends CollisionShape2D

var health := 150
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(amount: int):
	health -= amount
	print("Statue took damage", amount, "damage. Health now:", health)

	#if health <= 0:
		  # Destroy the slime
