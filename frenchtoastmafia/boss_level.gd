extends Node2D

@onready var camera = get_viewport().get_camera_2d()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func shake_camera(intensity := 5.0, duration := 0.2):
	var original_offset = camera.offset
	var time = 0.0
	while time < duration:
		var random_offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		camera.offset = original_offset + random_offset
		await get_tree().process_frame
		time += get_process_delta_time()
	camera.offset = original_offset	
