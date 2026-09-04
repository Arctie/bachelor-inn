extends RefCounted
class_name BTBlackboard

var unit: Character
var state: GameState
#var context: MissingContext # For objectives
var chosen_command: Command = null
var target: Character = null
