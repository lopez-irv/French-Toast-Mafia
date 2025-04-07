extends AnimatedSprite2D

@export var player: Node = null
@export var interact_range: float = 100.0
@export var interact_range_press_e: float = 40.0

# New variables for enemy behavior:
@export var aggro_range: float = 200.0  # When the knight starts chasing the player
@export var attack_range: float = 50.0   # When the knight is close enough to attack
@export var move_speed: float = 80.0     # Movement speed of the knight

var has_interacted: bool = false
var can_attack: bool = true

func _ready():
	play("Idle")
	# Enable input processing so this node receives input events.
	set_process_input(true)
	$DialogueBubble.visible = false
	$PressE.visible = false

func _process(delta):
	if player:
		# Flip horizontally so the knight faces the player.
		flip_h = player.global_position.x < global_position.x

		var distance = player.global_position.distance_to(global_position)

		# Show the dialogue "PressE" prompt if the player is within interact range.
		if not has_interacted:
			$PressE.visible = distance <= interact_range_press_e

		# If the player is within the aggro range, move toward them.
		if distance < aggro_range:
			var direction = (player.global_position - global_position).normalized()
			global_position += direction * move_speed * delta

			# If close enough to attack and not on cooldown, perform an attack.
			if distance < attack_range and can_attack:
				attack()

func _input(event):
	if event.is_action_pressed("interact"):
		if player:
			var distance = player.global_position.distance_to(global_position)
			# Only interact if within the interact range.
			if distance <= interact_range:
				$DialogueBubble.visible = true
				$PressE.visible = false  # Hide prompt.
				has_interacted = true   # Prevent prompt from reappearing.
				hide_dialogue_after_timeout()

func hide_dialogue_after_timeout() -> void:
	# Wait for 3 seconds, then hide the dialogue bubble.
	await get_tree().create_timer(3.0).timeout
	$DialogueBubble.visible = false

func attack() -> void:
	can_attack = false
	# Call the player's decreaseHealth function if it exists.
	if player.has_method("decreaseHealth"):
		player.decreaseHealth(10)  # Adjust the damage value as needed.
	print("Knight attacked the player!")
	# Wait for 1 second before allowing the next attack.
	await get_tree().create_timer(1.0).timeout
	can_attack = true
