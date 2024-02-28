extends Node

const RESOURCE_LIST := ["energy", "mineral", "nutrient", "material", "artifact"]

const STARTING_RESOURCES := {
	"energy": 0,
	"mineral": 10,
	"nutrient": 10,
	"material": 10,
	"artifact": 0	
}


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

@onready var BUILD_CONSTS : Dictionary = {
	"city": {
		"scene": preload("res://Scenes/Objects/improvement_city.tscn"),
		"cost": {"material": 5}
	},
	"harvester": {
		"scene": preload("res://Scenes/Objects/improvement_harvester.tscn"),
		"cost": {"material": 5}
	}
}



var game_manager : GameManager = null
var board_manager : BoardManager = null
