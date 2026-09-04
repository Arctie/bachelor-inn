extends RefCounted
class_name BTBlackboard

var unit: Character
var state: GameState
var context: MissionContext # For mission objectives
var chosen_command: Command = null
var target: Character = null
var target_pos: Vector3i = Vector3i.ZERO

func _init(in_unit: Character, in_state: GameState, in_context: MissionContext) -> void:
	unit = in_unit
	state = in_state
	context = in_context
	#pass
