extends RefCounted
class_name BTRunner

static func run(unit: Character, state: GameState, context: MissionContext) -> Command:
	var tree: BTNode = _get_profile(unit.state.bt_profile)
	var blackboard := BTBlackboard.new(unit, state, context)
	var result := tree.tick(blackboard)
	
	match result:
		BTNode.Status.SUCCESS:
			return blackboard.chosen_command
		_:
			return Wait.new(unit.state.grid_position)

static func _get_profile(profile: int) -> BTNode:
	match profile:
		CharacterState.BTProfile.BRUTE:
			return BTBrute.build()
		#CharacterState.BTProfile.SNIPER:
			#return BTSniper.build()
		#_:
			#return BTDefault.build()
