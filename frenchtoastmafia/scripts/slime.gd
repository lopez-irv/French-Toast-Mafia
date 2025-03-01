extends Node2D

const SPEED = 60
var direction = 1
var player = null

@onready var ray_cast_right: RayCast2D = $rayCastRight
@onready var ray_cast_left: RayCast2D = $rayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager = %GameManager

#@onready var players = get_tree().get_nodes_in_group("Player")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]  # Assign the first player found.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#makes slime move between 2 walls
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * SPEED * delta
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("hit player")
	if body.is_in_group("Player"):
		player.decreaseHealth(10);
		
