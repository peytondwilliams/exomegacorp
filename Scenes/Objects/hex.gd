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
@export var player_owner := ""

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
