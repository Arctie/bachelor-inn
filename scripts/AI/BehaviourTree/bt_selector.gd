extends BTNode
class_name BTSelector

var children: Array[BTNode] = []

func add_child(child: BTNode) -> BTSelector:
	children.append(child)
	return self

func tick(blackboard: Dictionary) -> Status:
	for child in children:
		var result := child.tick(blackboard)
		match result:
			Status.SUCCESS:
				return Status.SUCCESS
			Status.RUNNING:
				return Status.RUNNING	
	return Status.FAILURE
