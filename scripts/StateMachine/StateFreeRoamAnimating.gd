extends Node
class_name StateFreeRoamAnimating

signal step_finished(grid_pos: Vector3i)
signal walk_finished
const WALK_SPEED: float = 8.0
var _walking: bool = false
var _stop_requested: bool = false
var _walker: Character
var _path: Array[Vector3i]
var _next: int = 0

func _inti(walker: Character, path: Array[Vector3i]) -> void:
	_walker = walker
	_path = path

func _enter() -> void:
	print("ENTER STATE: StateFreeRoamAnimating.")
	if is_instance_valid(_walker) and _walker.data.audio_move != null:
		AudioManager2d.play_character_loop(_walker.data.audio_move)

func exit() -> void:
	print("EXIT STATE: StateFreeRoamAnimating.")
	AudioManager2d.stop_character_loop()

func handle_input(_level: Node) -> void:
	# Block all input when animating
	pass

func update(level: Node, delta: float) -> void:
	if level._level_complete:
		return
	if not is_instance_valid(_walker) or _next >= _path.size():
		_finish(level)
		return
	var target: Vector3 = level.grid_to_world(_path[_next])
	var dir: Vector3 = target - _walker.position
	var step: float = WALK_SPEED * delta
	if dir.length() <= step:
		_walker.position = target
		_walker.state.grid_position = _path[_next]
		_next += 1
		_check_aggro(level)
	else:
		_walker.position += dir.normalized() * step
		_play_run(dir)

func _check_aggro(level: Node) -> void:
	var alerted: Array[Character] = level.check_aggro()
	if alerted.is_empty():
		return
	_walker.pause_anim()
	level.camera_controller.end_roaming()
	level.hide_inactive_characters()
	level.state_machine.transition_to(StateAggroAlert.new(alerted, level.begin_combat))	

func _finish(level: Node) -> void:
	if is_instance_valid(_walker):
		_walker.pause_anim()
	level.state_machine.transition_to(StateFreeRoaming.new())

func _play_run(dir: Vector3) -> void:
	if dir.z > 0.01:
		_walker.play(_walker.run_down_animation)
	elif dir.z < -0.01:
		_walker.play(_walker.run_up_animation)
	elif dir.x > 0.01:
		_walker.play(_walker.run_right_animation)
	elif dir.x < -0.01:
		_walker.play(_walker.run_left_animation)
