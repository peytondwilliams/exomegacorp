extends Node3D

const CAMERA_HORZ_SPEED := 20.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction := Input.get_vector("input_left", "input_right", "input_up", "input_down")
	
	if direction:
		var new_position_flat = Vector2(position.x, position.z) + direction * delta * CAMERA_HORZ_SPEED
		position = Vector3(new_position_flat.x, position.y, new_position_flat.y)
