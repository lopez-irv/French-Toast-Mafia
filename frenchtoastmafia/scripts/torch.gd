extends Node2D

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var flicker_timer: Timer = $FlickerTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var base_energy: float = 1.2
var flicker_range: float = 0.2


func _ready() -> void:
	flicker_timer.timeout.connect(_on_flicker_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_flicker_timer_timeout() -> void:
	var random_energy = randf_range(-flicker_range, flicker_range)
	point_light_2d.energy = base_energy + random_energy
	
func flip_torch_left():
	position.x = -8
	rotation = -0.4031710999999273	#-23.1 in radians
	$AnimatedSprite2D.flip_h = true
	
func flip_torch_right():
	position.x = 8
	rotation = 0.4031710999999273
	$AnimatedSprite2D.flip_h = false
