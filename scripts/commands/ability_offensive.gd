extends Command
class_name AbilityOffensive
## Offensive ability for the new player ability design

var _targets : Array[Vector3i] = [];

## Set targets for offensive ability. prepare, apply, and execute will not work without targets
func _init(inStartPos : Vector3i, attackFromPos : Vector3i, targets : Array[Vector3i]) -> void:
	_targets = targets
	start_pos = inStartPos;
	end_pos = attackFromPos;

func check_bonus_prerequisite(_state : GameState, _simulate_only : bool = false) -> bool:
	return false

#inherited functions
func execute(_state : GameState, _simulate_only : bool = false) -> void:
	prepare(_state, _simulate_only)
	apply_damage(_state, _simulate_only)

func prepare(_state: GameState, _simulate_only : bool = false) -> void:
	pass;
	
func apply_damage(_state: GameState, _simulate_only: bool = false) -> void:
	pass;

func undo(_state : GameState, _simulate_only : bool = false) -> void:
	pass;
