extends RefCounted
class_name AIController
## This checks if the enemy should run minimax or bt to create a move.

static func choose_move(enemy: Character, state: GameState, context: MissionContext) -> Command:
	match enemy.state.ai_mode:
		CharacterState.AIMode.BEHAVIOUR_TREE:
			return _run_bt(enemy, state, context)
		CharacterState.AIMode.MINIMAX:
			return _run_minimax(enemy, state) ## context not added to minimax yet
		_:
			return Wait.new(enemy.state.grid_position)

static func _run_bt(enemy: Character, state: GameState, context: MissionContext) -> Command:
	var cmd := BTRunner.run(enemy, state, context)
	if cmd == null:
		print("Running BT failed. Initiating Wait at Position.")
		return Wait.new(enemy.state.grid_position)
	return cmd

static func _run_minimax(enemy: Character, state: GameState) -> Command:
	var ai := MinimaxAI.new()
	var cmd := ai.choose_best_move(state, enemy.state.search_depth, enemy)
	if cmd == null:
		print("Running MiniMax failed. Initiating Wait at Position.")
		return Wait.new(enemy.state.grid_position)
	return cmd
# func run_minimax()
# func run_bt()
