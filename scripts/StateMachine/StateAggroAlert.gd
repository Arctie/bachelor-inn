extends LevelState
class_name StateAggroAlert

var _units: Array[Character]
var _next: Callable

func _init(units: Array[Character], next: Callable) -> void:
	_units = units
	_next = next

func enter(level: Node) -> void:
	print("ENTER STATE: StateAggroAlert.")
	var valid: Array[Character] = []
	var avg: Vector3 = Vector3.ZERO
	for u: Character in _units:
		if is_instance_valid(u) and u.state.is_alive:
			valid.append(u)
			avg += u.global_position
	if valid.is_empty():
		_next.call()
		return
	avg /= float(valid.size())
	level.camera_controller.free_camera()
	level.camera_controller.set_pivot_target_translate(avg)
	await level.get_tree().create_timer(0.6).timeout
	for u: Character in valid:
		_spawn_alert(level, u)
	await level.get_tree().create_timer(0.8).timeout
	if not level._level_complete:
		_next.call()

func exit(level: Node) -> void:
	print("EXIT STATE: StateAggroAlert.")

func handle_input(level: Node, event: InputEvent) -> void:
	pass  # block everything during the alert

func _spawn_alert(level: Node, unit: Character) -> void:
	var mark: Label3D = Label3D.new() ## TODO: Replace with desired VFX
	mark.text = "!"
	mark.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	mark.pixel_size = 0.02
	mark.modulate = Color(1, 0.3, 0.2)
	level.add_child(mark)
	mark.global_position = unit.global_position + Vector3(0, 2.2, 0)
	var tween: Tween = level.create_tween()
	tween.tween_property(mark, "global_position:y", mark.global_position.y + 0.5, 0.8)
	tween.parallel().tween_property(mark, "modulate:a", 0.0, 0.8)
	tween.tween_callback(mark.queue_free)
