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


func is_walking() -> bool:
	return _walking

func stop_walking() -> void:
	_stop_requested = true

func walk_along(path: Array[Vector3i], with_audio: bool = false) -> void:
	if _walking:
		return
	_walking = true
	_stop_requested = false
	if with_audio and data.audio_move != null:
		AudioManager2d.play_character_loop(data.audio_move)
	for tile: Vector3i in path:
		if _stop_requested:
			break
		if tile == state.grid_position:
			continue
		var target: Vector3 = Main.level.grid_to_world(tile)
		var dir: Vector3 = target - position
		_play_run(dir)
		var tween: Tween = create_tween()
		tween.tween_property(self, "position", target, dir.length() / WALK_SPEED)
		await tween.finished
		state.grid_position = tile
		step_finished.emit(tile)
	if with_audio:
		AudioManager2d.stop_character_loop()
	pause_anim()
	_walking = false
	walk_finished.emit()

func _play_run(dir: Vector3) -> void:
	if dir.z > 0.01:
		play(run_down_animation)
	elif dir.z < -0.01:
		play(run_up_animation)
	elif dir.x > 0.01:
		play(run_right_animation)
	elif dir.x < -0.01:
		play(run_left_animation)
