extends LevelState
class_name StateUIPopup

var _current_ui: Control
var _level: Node

func _init(popup: Control) -> void:
	_current_ui = popup
	Main.level.is_in_menu = true

func enter(level: Node) -> void:
	_current_ui.show()

func exit(level: Node) -> void:
	pass
