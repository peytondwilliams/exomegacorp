extends Node3D
class_name Hex

const BIOMES = {
	"grass" : {
		"color": Color.DARK_GREEN
	},
	"mountain" : {
		"color": Color.SADDLE_BROWN
	},
	"desert" : {
		"color": Color.SANDY_BROWN
	}
}

@onready var gsr = GlobalStateReference

@export var mesh : MeshInstance3D

@export var coords = Vector3i.ZERO
@export var player_owner := "1"

var biome = "grass"
var output = 5
var improvement : Node3D = null


# Called when the node enters the scene tree for the first time.
func _ready():
	update_biome(biome)
	pass # Replace with function body.

func update_biome(new_biome):
	biome = new_biome
	var mat : StandardMaterial3D = mesh.mesh.surface_get_material(0)
	mat.albedo_color = BIOMES[biome]["color"]
	
@rpc("authority", "call_local", "reliable")	
func add_improvement(building: String, player: String):
	var new_improv = gsr.BUILD_CONSTS[building].scene.instantiate()
	add_child(new_improv, true)
	improvement = new_improv
	player_owner = player
	

func calc():
	if biome == "grass":
		return {"nutrient": output} 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
