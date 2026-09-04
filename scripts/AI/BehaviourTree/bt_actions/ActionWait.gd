extends BTNode
class_name ActionWait

func tick(blackboard: BTBlackboard) -> BTNode.Status:
	var unit := blackboard.unit
	blackboard.chosen_command = Wait.new(unit.state.grid_position)
	print("Action fired: ", get_script().resource_path, " command: ", blackboard.chosen_command)
	return BTNode.Status.SUCCESS
