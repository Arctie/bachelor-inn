extends RefCounted
class_name BTNode

enum Status { SUCCESS, FAILURE, RUNNING }

# Evaluates the node's logic. Returns one out of three Statuses.
func tick(blackboard: Dictionary) -> Status:
	#return Status.SUCCESS
	return Status.FAILURE
