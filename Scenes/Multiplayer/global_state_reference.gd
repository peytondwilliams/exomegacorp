extends Node

const RESOURCE_LIST := ["energy", "mineral", "nutrient", "material", "artifact"]

const STARTING_RESOURCES := {
	"energy": 0,
	"mineral": 10,
	"nutrient": 10,
	"material": 10,
	"artifact": 0	
}

@onready var BUILD_CONSTS : Dictionary = {
	"city": {
		"scene": preload("res://Scenes/Objects/improvement_city.tscn"),
		"cost": {"material": 5}
	}
}

var game_manager : GameManager = null
var board_manager : BoardManager = null
