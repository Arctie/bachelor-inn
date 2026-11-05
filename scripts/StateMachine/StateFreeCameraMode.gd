extends LevelState
class_name StateFreeCameraMode

#var _RMB_HELD: bool = false ##NOTE: Not needed. Only input is wasd + mouse drag
var base_speed: float = 5.0
var _camera_move_speed: float

func _init(node: Level) -> void:
	_camera_move_speed = base_speed

func _enter(node: Level) -> void:
	CameraController.CameraStates.FREE
	# Hide the UI in level.

func _unhandled_input(_level: Node, _event: InputEvent) -> void:
	# scroll up / down change speed value for input
	if _event is InputEventMouseButton:
		if _event.button_index == MOUSE_BUTTON_WHEEL_UP: #and _event.is_held():
			_camera_move_speed += 0.5
		if _event.button_index == MOUSE_BUTTON_WHEEL_DOWN: #and _event.is_held():
			_camera_move_speed -= 0.5
		#_RMB_HELD = true
	if _event is InputEventKey and not _event.echo:
		if _event.pressed:
				match _event.keycode:
					KEY_W:
						#move camera forward
						#func _move_camera_free(Vector3i(0,1,)speed: float) -> void:
						pass
					KEY_A:
						#move camera forward
						pass
					KEY_S:
						#move camera forward
						pass
					KEY_D:
						#move camera forward
						pass
