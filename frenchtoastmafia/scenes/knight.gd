extends AnimatedSprite2D

@export var player: Node = null
@export var interact_range: float = 100.0
@export var interact_range_press_e: float = 40.0
var has_interacted: bool = false

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
		
		# Only show the "PressE" prompt if the player hasn't already interacted.
		if not has_interacted:
			var distance = player.global_position.distance_to(global_position)
			$PressE.visible = distance <= interact_range_press_e

func _input(event):
	if event.is_action_pressed("Interact"):
		if player:
			var distance = player.global_position.distance_to(global_position)
			# Only interact if within range.
			if distance <= interact_range:
				$DialogueBubble.visible = true
				$PressE.visible = false  # Hide prompt.
				has_interacted = true  # Prevent prompt from reappearing.
				hide_dialogue_after_timeout()

func hide_dialogue_after_timeout() -> void:
	# Wait for 3 seconds.
	await get_tree().create_timer(3.0).timeout
	$DialogueBubble.visible = false
