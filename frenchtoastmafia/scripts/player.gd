extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var canDoubleJump: bool
	

func _physics_process(delta: float) -> void:		
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		canDoubleJump = true
		velocity.y = JUMP_VELOCITY

	#double jump
	if canDoubleJump and Input.is_action_just_pressed("jump") and not is_on_floor():
		canDoubleJump = false
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
		
	if direction:
		if Input.is_action_pressed("run"):
			velocity.x = (direction * SPEED)
		else:
			velocity.x = (direction * SPEED)/2
		if direction > 0:
			# moving right
			animated_sprite.flip_h = false
		elif direction < 0:
			# moving left
			animated_sprite.flip_h = true

	if direction and Input.is_action_pressed("run"):
		velocity.x = (direction * SPEED)
	elif direction:
		velocity.x = (direction * SPEED)/2
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
