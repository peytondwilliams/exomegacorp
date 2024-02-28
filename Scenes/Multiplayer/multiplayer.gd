extends Node

const PORT = 4433

#@onready var player_scn = preload("res://scenes/core/player.tscn")
@onready var game_scn = preload("res://Scenes/Multiplayer/game_manager.tscn")

@export var server_ui : Control
@export var ip_input : LineEdit

@export var lobby_ui : Control
@export var player_list_ui : VBoxContainer

var spawn_pos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# Start paused.
	#get_tree().paused = true
	# You can save bandwidth by disabling server relay and peer notifications.
	#multiplayer.server_relay = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_button_pressed():
	print("click host")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(connect_player)
	multiplayer.peer_disconnected.connect(disconnect_player)
	connect_player(1)
	
	join_lobby()


func _on_connect_button_pressed():
	print("click connect")
	var ip_str : String = ip_input.text
	if ip_str == "":
		OS.alert("Need a remote to connect to.")
		return	
	
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_str, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
		
	multiplayer.multiplayer_peer = peer
	join_lobby()
	
		
func join_lobby():
	# Hide the UI and unpause to start the game.
	server_ui.hide()
	lobby_ui.show()
	#get_tree().paused = false
	#spawn_player.rpc_id(1, multiplayer.get_unique_id())
	

func connect_player(new_id: int):
	generate_player_list_ui.rpc(Array(multiplayer.get_peers()) + [1]) 

func disconnect_player(id: int):
	generate_player_list_ui.rpc(Array(multiplayer.get_peers()) + [1])
	
@rpc("authority", "call_local", "reliable")
func generate_player_list_ui(new_player_list):
	for n in player_list_ui.get_children():
		player_list_ui.remove_child(n)
		n.queue_free()
	
	for player in new_player_list:
		var player_label = Label.new()
		player_label.text = str(player)
		player_list_ui.add_child(player_label)


func _on_start_button_pressed():
	var new_game = game_scn.instantiate()
	$Level.add_child(new_game, true)
	hide_lobby_ui.rpc()
	
@rpc("authority", "call_local", "reliable")	
func hide_lobby_ui():
	lobby_ui.hide()
