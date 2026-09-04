extends BTNode
class_name ConditionEnemyInRange

func tick(blackboard: BTBlackboard) -> BTNode.Status:
	var unit := blackboard.unit
	var state := blackboard.state
	
	var min_range := unit.state.weapon.min_range 
	var max_range := unit.state.weapon.max_range 
	
	var closest_target: Character = null
	var closest_dist := 99999
	
	for other in state.units:
		if other.state.is_enemy():
			continue
		if not other.state.is_alive:
			continue
		var dist : float = abs(other.state.grid_position.x - unit.state.grid_position.x) + abs(other.state.grid_position.z - unit.state.grid_position.z)
		if dist >= min_range and dist <= max_range:
			if dist < closest_dist:
				closest_dist = dist
				closest_target = other
	
	if closest_target == null:
		return BTNode.Status.FAILURE
	blackboard.target = closest_target
	return BTNode.Status.SUCCESS

## SPELL RANGE CHECK
	
	# for skill in unit.state.skills:
	#     for other in state.units:
	#         if not _is_valid_skill_target(other, skill, unit):
	#             continue
	#         var dist := manhattan_distance(unit.state.grid_position, other.state.grid_position)
	#         if dist >= skill.min_range and dist <= skill.max_range:
	#             if dist < closest_dist:
	#                 closest_dist = dist
	#                 closest = other
	#                 blackboard.chosen_skill = skill  # store which skill to use
	#
	## ActionAttackClosest would then check blackboard.chosen_skill:
	## if not null → build CastSkill command
	## if null → build Attack command (weapon)
