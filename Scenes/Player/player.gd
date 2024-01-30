extends Node3D

const RAY_LENGTH = 100
const CAMERA_HORZ_SPEED := 20.0
const COLLISION_MASK = 1

@onready var gsr = GlobalStateReference

@export var camera : Camera3D

var raycast_result : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction := Input.get_vector("input_left", "input_right", "input_up", "input_down")
	
	if direction:
		var new_position_flat = Vector2(position.x, position.z) + direction * delta * CAMERA_HORZ_SPEED
		position = Vector3(new_position_flat.x, position.y, new_position_flat.y)
		
	if Input.is_action_just_pressed("input_click"):

		if "collider" in raycast_result:
			var hex_coords: Vector3i = raycast_result.collider.get_parent().coords
			#select_hex.emit(hex_coords)
			#if (player == 1):
			#	click(hex_coords)
			#else:
			print("click coords:", hex_coords)

func _physics_process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * RAY_LENGTH
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collision_mask = COLLISION_MASK
	raycast_result = space.intersect_ray(ray_query)
