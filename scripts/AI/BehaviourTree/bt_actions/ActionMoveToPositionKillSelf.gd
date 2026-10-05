extends BTNode
class_name ActionMoveToPositionKillSelf

func tick(blackboard: BTBlackboard) -> BTNode.Status:
	if blackboard.unit == null:
		return BTNode.Status.FAILURE
	if blackboard.stored_generic_position == null:
		return BTNode.Status.FAILURE
	var start_pos : Vector3i = blackboard.unit.state.grid_position
	var end_pos : Vector3i = blackboard.stored_generic_position
	blackboard.chosen_command = KillSelf.new(start_pos, end_pos)
	return BTNode.Status.SUCCESS
