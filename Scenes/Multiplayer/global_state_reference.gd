extends Node

const RESOURCE_LIST = ["energy", "mineral", "nutrient", "material", "artifact"]

@onready var BUILD_CONSTS : Dictionary = {
	"city": {
		"scene": preload("res://Scenes/Objects/improvement_city.tscn"),
		"cost": {"nutrient": 10}
	}
}

var game_manager : GameManager = null
var board_manager : BoardManager = null
