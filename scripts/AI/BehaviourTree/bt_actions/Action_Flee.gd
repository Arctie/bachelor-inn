extends BTNode
class_name ActionFlee

func tick(blackboard: BTBlackboard) -> BTNode.Status:
	var unit := blackboard.unit
	var state := blackboard.state
	var threat := blackboard.target

	if threat == null:
		return BTNode.Status.FAILURE
	
	# Generate all reachable move tiles
	var moves := MoveGenerator.generate(unit, state)
	var best_move: Move = null
	var best_dist: float = -1.0

	for cmd in moves:
		if not cmd is Move:
			continue
			# Find the tile that maximises distance from the threat
			var dist: float = abs(cmd.end_pos.x - threat.state.grid_position.x) + abs(cmd.end_pos.z - threat.state.grid_position.z)
			if dist > best_dist:
				best_dist = dist
				best_move = cmd
	
	if best_move == null:
		return BTNode.Status.FAILURE

	blackboard.chosen_command = best_move
	return BTNode.Status.SUCCESS
