extends BTNode
class_name ActionMoveTowardClosest

func tick(blackboard: BTBlackboard) -> BTNode.Status:
	var unit := blackboard.unit
	var state := blackboard.state

	# Find closest player unit
	var closest: Character = null
	var closest_dist := 99999
	
	for other in state.units:
		if other.state.is_enemy():
			continue
		if not other.state.is_alive:
			continue
		var dist : float = abs(other.state.grid_position.x - unit.state.grid_position.x) \
					+ abs(other.state.grid_position.z - unit.state.grid_position.z)
		if dist < closest_dist:
			closest_dist = dist
			closest = other
	
	if closest == null:
		return BTNode.Status.FAILURE

	# Find reachable move tile closest to the target
	var moves := MoveGenerator.generate(unit, state)
	var best_move: Move = null
	var best_dist := 99999
	
	for cmd in moves:
		if not cmd is Move:
			continue
		var dist : float = abs(cmd.end_pos.x - closest.state.grid_position.x) \
				  + abs(cmd.end_pos.z - closest.state.grid_position.z)
		if dist < best_dist:
			best_dist = dist
			best_move = cmd
	
	if best_move == null:
		return BTNode.Status.FAILURE
	
	blackboard.target = closest
	blackboard.chosen_command = best_move
	print("Action fired: ", get_script().resource_path, " command: ", blackboard.chosen_command)
	return BTNode.Status.SUCCESS
