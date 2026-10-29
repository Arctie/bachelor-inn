extends LevelState
class_name StateFreeRoamAnimating

const WALK_SPEED: float = 8.0
var _walker: Character
var _path: Array[Vector3i]
var _next: int = 0
var _party: Array[Character] = []
var _trail: Array[Vector3i] = []
var _queues: Array[Array] = []
var _alerted: Array[Character] = []
var _stopping: bool = false
var _party_confirmed: bool = false

func _init(walker: Character, path: Array[Vector3i]) -> void:
	_walker = walker
	_path = path

func _enter(_level: Node) -> void:
	print("ENTER STATE: StateFreeRoamAnimating.")
	#if not party_confirmed:
		#build_party()
	if is_instance_valid(_walker) and _walker.data.audio_move != null:
		AudioManager2d.play_character_loop(_walker.data.audio_move)

func exit(_level: Node) -> void:
	print("EXIT STATE: StateFreeRoamAnimating.")
	AudioManager2d.stop_character_loop()

func _build_party(level: Node) -> void:
	pass

func handle_input(_level: Node, event: InputEvent) -> void:
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
