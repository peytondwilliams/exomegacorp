extends Node3D 
class_name Player

const RAY_LENGTH = 100
const CAMERA_HORZ_SPEED := 20.0
const COLLISION_MASK = 1

@onready var gsr = GlobalStateReference

@export var camera : Camera3D
@export var nutrient_label : Label
@export var mineral_label : Label
@export var energy_label : Label
@export var material_label : Label
@export var artifact_label : Label

var raycast_result := {}

var select := "none" 

var inventory_copy := {}

var mouse_in_ui := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction := Input.get_vector("input_left", "input_right", "input_up", "input_down")
	
	if direction:
		var new_position_flat = Vector2(position.x, position.z) + direction * delta * CAMERA_HORZ_SPEED
		position = Vector3(new_position_flat.x, position.y, new_position_flat.y)

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
	
func _unhandled_input(event: InputEvent):
	pass
			

func _input(event: InputEvent):
	if event.is_action_released("input_click") and not mouse_in_ui: # TODO fix mouse_in_ui
		if  select != "none":
			if "collider" in raycast_result:
				var hex_coords: Vector3i = raycast_result.collider.get_parent().coords

				print("click coords:", hex_coords)
				var select_hex = gsr.board_manager.get_hex(hex_coords)
				gsr.game_manager.build_action.rpc_id(1, select, select_hex.coords)
					
		select = "none"

func _on_city_button_pressed():
	select = "city"

func _on_harvester_button_pressed():
	select = "harvester"
	
	
func receive_inventory_update(new_inv : Dictionary):
	inventory_copy = new_inv
	
	nutrient_label.text = "Nutrient: " + str(inventory_copy["nutrient"])
	mineral_label.text = "Mineral: " + str(inventory_copy["mineral"])
	energy_label.text = "Energy: " + str(inventory_copy["energy"])
	material_label.text = "Material: " + str(inventory_copy["material"])
	artifact_label.text = "Artifact: " + str(inventory_copy["artifact"])

func _on_building_h_box_mouse_entered():
	mouse_in_ui = true
	print("yess")


func _on_building_h_box_mouse_exited():
	mouse_in_ui = false
	print("noo")
