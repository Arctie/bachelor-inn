extends LevelState
class_name StateUIPopup

var _current_ui: Control

func _init(popup: Control) -> void:
	_current_ui = popup

func enter(level: Node) -> void:
	_current_ui.show()

func exit(level: Node) -> void:
	pass
