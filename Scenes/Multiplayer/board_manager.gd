extends Node

const DIRECTION_ARR = [
					Vector3i(+1, 0, -1), #mid right
					Vector3i(+1, -1, 0), #top right
					Vector3i(0, -1, +1), #top left
					Vector3i(-1, 0, +1), #mid left
					Vector3i(-1, +1, 0), #bot left
					Vector3i(0, +1, -1) #bot right
					]

var hex_grid : Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_map():
	
	var curr_coords : Vector3i = Vector3i.ZERO
	
	for i in range(10):
		for j in range(10):
			#var hex = HEX.instantiate()
			#$Hexes.add_child(hex)
#
			#hex.coords = curr_coords
			#hex.position = 1.05 * cube_to_real_coords(curr_coords)
			#hex_grid[generate_hex_key(curr_coords)] = {"hex": hex, "combat_units": [], "work_units": []}
			
			curr_coords += DIRECTION_ARR[0]
		curr_coords += (DIRECTION_ARR[3] * 10)
		curr_coords += DIRECTION_ARR[5]
		if (i % 2 == 1):
			curr_coords += DIRECTION_ARR[3]
		

# hex board utility funcs
func generate_hex_keystr(coords: Vector3i):
	return str(coords.x) + ", " + str(coords.y) + ", " + str(coords.z)

func keystr_to_coords(coords_key: String):
	var coords_split = coords_key.split(",")
	return Vector3i(int(coords_split[0]), int(coords_split[1]), int(coords_split[2]))
	
func cube_to_real_coords(coords: Vector3i):
	var q = float(coords.x)
	var r = float(coords.y)
	var s = float(coords.z)

	var x = -sqrt(3) * ( r/2 + s )
	var z = r * 1.5
	return Vector3(x, 0, z)

func real_to_cube_coords(coords: Vector3): #may need to divide input by 1.05 (based on distance between tiles)
	var q = (sqrt(3)/3 * coords.x  -  1./3 * coords.z)
	var r = (                        2./3 * coords.z)
	var s = (-q - r)
	return cube_round(Vector3(q, r, s))
	
func cube_round(coords: Vector3):
	var q = roundi(coords.x)
	var r = roundi(coords.y)
	var s = roundi(coords.z)

	var q_diff = abs(q - coords.x)
	var r_diff = abs(r - coords.y)
	var s_diff = abs(s - coords.z)

	if q_diff > r_diff and q_diff > s_diff:
		q = -r-s
	elif r_diff > s_diff:
		r = -q-s
	else:
		s = -q-r
	
	return Vector3i(q, r, s)

func cube_distance(a: Vector3i, b: Vector3i):
	return (abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z)) / 2
	
	
func neighbors(coords_key: String):
	var base_coords = keystr_to_coords(coords_key)
	var found_neighbors = []
	for offset in DIRECTION_ARR:
		var new_coords_key = generate_hex_keystr(base_coords + offset)
		var neighbor_hex = hex_grid.get(new_coords_key)
		if (neighbor_hex != null):
			# add check if terrain impassible
			found_neighbors.append(new_coords_key)
			
	return found_neighbors

	
# player actions
@rpc("authority", "call_local")
func move_unit(unit, coords: Vector3i):
	var hex_dict = hex_grid[generate_hex_keystr(coords)]
	var pawn = $Pawn
	
	hex_grid[generate_hex_keystr(pawn.coords)]["work_units"].pop_back()
	hex_dict["work_units"].append(pawn)
	
	pawn.coords = coords
	pawn.position = cube_to_real_coords(coords) * 1.05 + Vector3(0, 1, 0)

func _on_player_select_hex(coords: Vector3i):
	var hex_dict = hex_grid[generate_hex_keystr(coords)]
	if (hex_dict["work_units"].size() > 0):
		pass
		# select unit
		#print("select unit")
		
	#print("moving unit")
	_on_player_move_unit($Pawn, coords)
	#rpc("move_unit", "", coords)
	#move_unit("", coords)
	
func _on_player_move_unit(unit, coords: Vector3i):
	pass
	#if move_valid(unit, coords):
		#rpc("move_unit", unit, coords)
		



	
