extends BTNode
class_name BTSequence

var children: Array[BTNode] = []

func add_children(child: BTNode) -> BTNode:
	children.append(child)
	return self

# --- NOTE: Oposite of BTSelector
func tick(blackboard: BTBlackboard) -> BTNode.Status:
	for child in children:
		var result := child.tick(blackboard)
		match result:
			BTNode.Status.FAILURE:
				return BTNode.Status.FAILURE
			BTNode.Status.RUNNING:
				return BTNode.Status.RUNNING
	return BTNode.Status.SUCCESS
