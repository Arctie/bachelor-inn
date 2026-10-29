extends LevelState
class_name StateFreeRoamAnimating

const WALK_SPEED: float = 8.0
const CATCH_UP_SPEED: float = 11.0
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

func enter(_level: Node) -> void:
	print("ENTER STATE: StateFreeRoamAnimating.")
	if not _party_confirmed:
		_build_party(_level)
	if is_instance_valid(_walker) and _walker.data.audio_move != null:
		AudioManager2d.play_character_loop(_walker.data.audio_move)

func exit(_level: Node) -> void:
	print("EXIT STATE: StateFreeRoamAnimating.")
	AudioManager2d.stop_character_loop()

func handle_input(_level: Node, event: InputEvent) -> void:
	# Block all input when animating
	pass

func update(level: Node, delta: float) -> void:
	if level._level_complete:
		return
	_move_leader(level, delta)
	for i in range(1, _party.size()):
		_move_follower(level, i, delta)
	if _leader_done() and _follower_idle():
		_finish(level)

func _build_party(level: Node) -> void:
	_party.append(_walker)
	for c: Character in level.player_characters:
		if c != _walker and is_instance_valid(c) and c.state.is_alive:
			_party.append(c)
			print("Added ", c.data.unit_name, " to _party.")
	for c: Character in _party:
		_trail.append(c.state.grid_position)
		_queues.append([])
	if not _party.is_empty():
		_party_confirmed = true
	print("party size: ", _party.size())

func _leader_done() -> bool:
	return not is_instance_valid(_walker) or _next >= _path.size()

func _follower_idle() -> bool:
	for i in range(1, _party.size()):
		var q: Array = _queues[i]
		if not q.is_empty():
			return false
	return true

func _move_leader(level: Node, delta: float) -> void:
	if _leader_done():
		return
	var target: Vector3 = level.grid_to_world(_path[_next])
	var dir: Vector3 = target - _walker.position
	var step: float = WALK_SPEED * delta
	if dir.length() <= step:
		_walker.position = target
		var tile: Vector3i = _path[_next]
		_next += 1
		if tile != _walker.state.grid_position:
			_walker.state.grid_position = tile
			_on_leader_arrived(level, tile)
		if _stopping:
			_next = _path.size()
	else:
		_walker.position += dir.normalized() * step
		_play_run(_walker, dir)

func _on_leader_arrived(level: Node, tile: Vector3i) -> void:
	if _stopping:
		return
	print("leader arrived: ", tile, " trail: ", _trail)
	_trail.push_front(tile)
	_trail.resize(_party.size())
	for i in range (1, _party.size()):
		_queue_follower(level, i, _trail[i])
	_check_aggro(level)

func _queue_follower(level: Node, i: int, destination: Vector3i) -> void:
	var f: Character = _party[i]
	var q: Array = _queues[i]
	var from: Vector3i = f.state.grid_position
	if not q.is_empty():
		from = q.back()
	if from == destination:
		return
	var p: Array[Vector3i] = MovementGrid.find_path(from, destination, level.movement_weights_map, level.occupancy_map)
	print("follower ", i, " from ", from, " to ", destination, " path size ", p.size())
	for tile: Vector3i in p:
		if tile != from:
			q.append(tile)

func _move_follower(level: Node, i: int, delta: float) -> void:
	var f: Character = _party[i]
	var q: Array = _queues[i]
	if not is_instance_valid(f):
		q.clear()
		return
	if q.is_empty():
		return
	var tile: Vector3i = q[0]
	var target: Vector3 = level.grid_to_world(tile)
	var dir: Vector3 = target - f.position
	var speed: float = CATCH_UP_SPEED if q.size() >2 else WALK_SPEED
	var step: float = speed * delta
	if dir.length() <= step:
		f.position = target
		f.state.grid_position = tile
		q.pop_front()
		if q.is_empty():
			f.pause_anim()
		_check_aggro(level)
	else:
		f.position += dir.normalized() * step
		_play_run(f, dir)

func _check_aggro(level: Node) -> void:
	if _stopping:
		return
	var alerted: Array[Character] = level.check_aggro()
	if alerted.is_empty():
		return
	_alerted = alerted
	_stopping = true
	for i in range(1, _party.size()): 
		var q: Array = _queues[i]
		if q.size() > 1:
			q.resize(1)
	#_walker.pause_anim()
	#level.camera_controller.end_roaming()
	#level.hide_inactive_characters()
	#level.state_machine.transition_to(StateAggroAlert.new(alerted, level.begin_combat))	


func _finish(level: Node) -> void:
	if is_instance_valid(_walker):
		_walker.pause_anim()
	if _stopping:
		level.camera_controller.end_roaming()
		level.hide_inactive_characters()
		level.state_machine.transition_to(StateAggroAlert.new(_alerted, level.begin_combat))
	else:
		level.state_machine.transition_to(StateFreeRoaming.new())

func _play_run(unit: Character, dir: Vector3) -> void:
	if dir.z > 0.01:
		unit.play(unit.run_down_animation)
	elif dir.z < -0.01:
		unit.play(unit.run_up_animation)
	elif dir.x > 0.01:
		unit.play(unit.run_right_animation)
	elif dir.x < -0.01:
		unit.play(unit.run_left_animation)
