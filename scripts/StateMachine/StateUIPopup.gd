extends LevelState
class_name StateUIPopup

var _current_ui: PopupBase
var _on_closed: Callable

func _init(popup: PopupBase, on_closed: Callable) -> void:
	_current_ui = popup
	_on_closed = on_closed

func enter(level: Node) -> void:
	print("ENTER STATE: StateUIPopup.")
	level.is_in_menu = true
	_current_ui.connect(_on_popup_closed.bind(level), CONNECT_ONE_SHOT)
	_current_ui.show()

func exit(level: Node) -> void:
	print("EXIT STATE: StateUIPopup.")
	level.is_in_menu = false
	_current_ui.close()

func _on_popup_closed(result: String, _level: Node) -> void:
	_on_closed.call(result)

func handle_input(_level: Node, _event: InputEvent) -> void:
	pass
