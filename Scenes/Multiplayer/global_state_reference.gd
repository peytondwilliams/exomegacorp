extends Node

var game_manager : GameManager = null
var board_manager : BoardManager = null

@onready var BUILD_CONSTS : Dictionary = {
	"city": {
		"scene": preload("res://Scenes/Objects/improvement_city.tscn"),
		"cost": {"food": 10}
	}
}
