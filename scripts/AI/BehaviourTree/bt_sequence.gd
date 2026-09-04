extends BTNode
class_name BTSequence

var children: Array[BTNode] = []

func add_child(child: BTNode) -> BTNode:
	children.append(child)
	return self

# --- NOTE: Oposite of BTSelector
func tick(blackboard: BTBlackboard) -> BTNode.Status:
	print("BTSequence ticking, children count: ", children.size())
	for child in children:
		print("BTSequence child: ", child.get_script())
		var result := child.tick(blackboard)
		match result:
			BTNode.Status.FAILURE:
				return BTNode.Status.FAILURE
			BTNode.Status.RUNNING:
				return BTNode.Status.RUNNING
	return BTNode.Status.SUCCESS
