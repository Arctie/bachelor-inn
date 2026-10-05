extends BTNode
class_name GetClosestTileAdjacentToPlayer

func tick(blackboard: BTBlackboard) -> BTNode.Status:
	if MoveGenerator.movement_path.is_empty():
		return BTNode.Status.FAILURE
	var unit := blackboard.unit
	var game_state := blackboard.state
	
	var tiles_adjacent_to_player_characters : Array [Vector3i] = []
	
	for player_unit in game_state.units:
		if unit == null:
			continue
		if player_unit.state.is_enemy():
			continue
		tiles_adjacent_to_player_characters.append_array(
			_get_adjacent_positions(unit.state.grid_position)
		)
	
	if tiles_adjacent_to_player_characters.is_empty():
		return BTNode.Status.FAILURE
	
	var lowest_cost : int = -1
	var found_position : Vector3i = unit.state.grid_position
	for pos : Vector3i in tiles_adjacent_to_player_characters:
		if !MoveGenerator.movement_path.has(pos):
			continue
		var cost : int = MoveGenerator.get_move_cost(unit.state.grid_position, pos, game_state)
		if(lowest_cost == -1):
			lowest_cost = cost
			found_position = pos
			continue
		if cost >= lowest_cost:
			continue
		lowest_cost = cost
		found_position = pos
	if lowest_cost == -1:
		return BTNode.Status.FAILURE
	blackboard.stored_generic_position = found_position
	return BTNode.Status.SUCCESS

static func _get_adjacent_positions(from : Vector3i) -> Array[Vector3i]:
	var return_value : Array[Vector3i] = []
	return_value.resize(14)
	
	return_value.insert(0, Vector3i(from.x, from.y+1, from.z))
	return_value.insert(1, Vector3i(from.x-1, from.y+1, from.z))
	return_value.insert(2, Vector3i(from.x, from.y+1, from.z-1))
	return_value.insert(3, Vector3i(from.x+1, from.y+1, from.z))
	return_value.insert(4, Vector3i(from.x, from.y+1, from.z+1))
	
	return_value.insert(5, Vector3i(from.x-1, from.y, from.z))
	return_value.insert(6, Vector3i(from.x, from.y, from.z-1))
	return_value.insert(7, Vector3i(from.x+1, from.y, from.z))
	return_value.insert(8, Vector3i(from.x, from.y, from.z+1))
	
	return_value.insert(9, Vector3i(from.x, from.y-1, from.z))
	return_value.insert(10, Vector3i(from.x-1, from.y-1, from.z))
	return_value.insert(11, Vector3i(from.x, from.y-1, from.z-1))
	return_value.insert(12, Vector3i(from.x+1, from.y-1, from.z))
	return_value.insert(13, Vector3i(from.x, from.y-1, from.z+1))
	
	return return_value
