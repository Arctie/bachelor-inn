extends LevelState
class_name StateFreeCameraMode

var _RMB_HELD: bool = false
var camera_move_speed: float = 5.0

func _init(node: Level) -> void:
	pass

func _enter(node: Level) -> void:
	CameraController.CameraStates.FREE_ROAM

func _unhandled_input(_level: Node, _event: InputEvent) -> void:
	# scroll up / down change speed value for input
	if _event is InputEventMouseButton:
		if _event.button_index == MOUSE_BUTTON_WHEEL_UP: #and _event.is_held():
			camera_move_speed += 1.0
		if _event.button_index == MOUSE_BUTTON_WHEEL_DOWN: #and _event.is_held():
			camera_move_speed -= 1.0
		#_RMB_HELD = true
	if _event is InputEventKey and not _event.echo and _RMB_HELD:
		if _event.pressed:
				match _event.keycode:
					KEY_W:
						#move camera forward
						#func _move_camera_free(input: InputEvent, speed: float) -> void:
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
