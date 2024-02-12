extends Node3D

@onready var gsr = GlobalStateReference

var board_ref : BoardManager

var game_time := 0.0
var tick_count := 0
var tick_time := 2.0

var player_inventory := {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for peer in Array(multiplayer.get_peers()) + [1]:
		player_inventory[str(peer)] = {}
		player_inventory[str(peer)]["food"] = 0
		player_inventory[str(peer)]["iron"] = 0
		player_inventory[str(peer)]["fuel"] = 0

func _physics_process(delta):
	game_time += delta
	var new_ticks = game_time / tick_time
	if new_ticks > tick_count:
		tick_count = new_ticks
		if multiplayer.get_unique_id() == 1:
			calc_tick()

func calc_tick():
	var output = gsr.board_manager.calc()
	
	for player_out in output:
		for key_out in output[player_out]:
			player_inventory[player_out][key_out] += output[player_out][key_out]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
