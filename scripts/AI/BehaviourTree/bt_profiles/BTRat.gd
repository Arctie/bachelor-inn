extends RefCounted
class_name BTRat

static func build() -> BTNode:
	var root: BTSelector = BTSelector.new()
	
	## NOTE: Here, we create each branch
	var move_ability_explode_sequence: BTSequence = BTSequence.new()
	move_ability_explode_sequence.add_child(TaskGetReachableTilesNoFly.new())
	move_ability_explode_sequence.add_child(GetClosestTileAdjacentToPlayer.new())
	move_ability_explode_sequence.add_child(ActionMoveToPositionKillSelf.new())


	## NOTE: The order here top-down defines the left-to-right sequence the BT will search
	root.add_child(move_ability_explode_sequence)
	root.add_child(ActionMoveTowardClosest.new())
	root.add_child(ActionWait.new())

	return root
