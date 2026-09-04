extends BTNode
class_name BTSelector

var children: Array[BTNode] = []

func add_child(child: BTNode) -> BTNode:
	children.append(child)
	return self

# --- NOTE: Oposite of BTSequence
func tick(blackboard: BTBlackboard) -> Status:
	print("BTSelector ticking, children count: ", children.size())
	for child in children:
		print("BTSelector child: ", child.get_script())
		var result := child.tick(blackboard)
		match result:
			Status.SUCCESS:
				return Status.SUCCESS
			Status.RUNNING:
				return Status.RUNNING	
	return Status.FAILURE
