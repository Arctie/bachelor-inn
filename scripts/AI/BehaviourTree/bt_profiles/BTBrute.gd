extends RefCounted
class_name BTBrute

static func build() -> BTNode:
	var attack_sequence : BTSequence = BTSequence.new()
	attack_sequence.add_child(ConditionEnemyInRange.new())
	attack_sequence.add_child(ActionAttackClosest.new())
	
	var root : BTSelector = BTSelector.new()
	root.add_child(attack_sequence)
	root.add_child(ActionMoveTowardClosest.new())
	root.add_child(ActionWait.new())
	
	return root
