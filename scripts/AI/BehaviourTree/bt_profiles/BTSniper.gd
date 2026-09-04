extends RefCounted
class_name BTSniper

static func build() -> BTNode:
	var attack_sequence: BTSequence = BTSequence.new()
	attack_sequence.add_child(ConditionEnemyInRange.new())
	attack_sequence.add_child(ActionAttackClosest.new())

	var flee_sequence: BTSequence = BTSequence.new()
	flee_sequence.add_child(ConditionPlayerIsClose.new())
	flee_sequence.add_child(ActionFlee.new())

	var root: BTNode = BTSelector.new()
	root.add_child(flee_sequence)
	root.add_child(attack_sequence)
	root.add_child(ActionMoveTowardClosest.new())
	root.add_child(ActionWait.new())

	return root
