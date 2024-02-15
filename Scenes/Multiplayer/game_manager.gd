extends Node3D
class_name GameManager

@onready var gsr = GlobalStateReference

@export var board : BoardManager
@export var player : Player

var game_time_sec := 0.0
var tick_count := 0
var tick_time_sec := 2.0

var player_inventory := {}


# Called when the node enters the scene tree for the first time.
func _ready():
	gsr.game_manager = self
	
	for peer in Array(multiplayer.get_peers()) + [multiplayer.get_unique_id()]:
		player_inventory[str(peer)] = {}
		player_inventory[str(peer)]["food"] = 0
		player_inventory[str(peer)]["iron"] = 0
		player_inventory[str(peer)]["fuel"] = 0

func _physics_process(delta):
	game_time_sec += delta
	var new_ticks = int(game_time_sec / tick_time_sec)
	if new_ticks > tick_count:
		tick_count = new_ticks
		if multiplayer.get_unique_id() == 1:
			calc_tick()

func calc_tick():
	var output = gsr.board_manager.calc()
	
	
	for player_out in output:
		for key_out in output[player_out]:
			player_inventory[player_out][key_out] += output[player_out][key_out]
			
	update_player_resources_ui.rpc()
			
@rpc("authority", "call_local", "reliable")
func update_player_resources_ui():
	print("unique id:", str(multiplayer.get_unique_id()))
	print(player_inventory)
	player.receive_inventory_update(player_inventory[str(multiplayer.get_unique_id())])


@rpc("any_peer", "call_local", "reliable")
func build_action(building, location):
	print("build action")
	if multiplayer.get_unique_id() != 1:
		return
		
	var sender = str(multiplayer.get_remote_sender_id())
	
	var can_afford = true
	for resource in gsr.BUILD_CONSTS[building]["cost"]:
		if player_inventory[sender][resource] < gsr.BUILD_CONSTS[building]["cost"][resource]:
			can_afford = false
			break
			
	if can_afford:
		for resource in gsr.BUILD_CONSTS[building]["cost"]:
			player_inventory[sender][resource] -= gsr.BUILD_CONSTS[building]["cost"][resource]
				
		board.build(building, location, sender)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
