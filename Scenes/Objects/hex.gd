extends Node3D
class_name Hex

const BIOMES = {
	"grass" : {
		"color": Color.LIME_GREEN
	},
	"mountain" : {
		"color": Color.GRAY
	},
	"desert" : {
		"color": Color.YELLOW
	},
	"clay" : {
		"color": Color.SADDLE_BROWN
	},
	"ruin" : {
		"color": Color.REBECCA_PURPLE
	},
}

@onready var gsr = GlobalStateReference

@export var mesh : MeshInstance3D
@export var output_label : Label3D

@export var coords = Vector3i.ZERO
@export var player_owner := ""

@export var biome = "grass" :
	set(new_b):
		biome = new_b
		
@export var output = 5
var improvement : Node3D = null


# Called when the node enters the scene tree for the first time.
func _ready():
	update_biome(biome, output)
	pass # Replace with function body.

#@rpc("authority", "call_local", "reliable")	
func update_biome(new_biome, new_output):
	biome = new_biome
	var mat : StandardMaterial3D = mesh.mesh.surface_get_material(0)
	mat.albedo_color = BIOMES[biome]["color"]
	output = new_output
	output_label.text = str(output)
	
@rpc("authority", "call_local", "reliable")	
func add_improvement(building: String, player: String):
	var new_improv = gsr.BUILD_CONSTS[building].scene.instantiate()
	add_child(new_improv, true)
	improvement = new_improv
	player_owner = player
	

func calc():
	if biome == "grass":
		return {"nutrient": output} 
	elif biome == "mountain":
		return {"mineral": output} 
	elif biome == "desert":
		return {"energy": output} 
	elif biome == "clay":
		return {"material": output} 
	elif biome == "ruin":
		return {"artifact": output} 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
