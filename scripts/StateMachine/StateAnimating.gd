extends LevelState
class_name StateAnimating

var _is_processing: bool = false
var _cancelled: bool = false
var _move_sound_playing: bool = false

func enter(level: Node) -> void:
	print("ENTER STATE: StateAnimating. instance: ", get_instance_id())
	#_cancelled = false
	_is_processing = false
	_move_sound_playing = false

func exit(level: Node) -> void:
	print("EXIT STATE: StateAnimating. instance: ", get_instance_id())	
	_cancelled = true
	_is_processing = false
	#level.moves_stack.clear()
	#level.animation_path.clear()
	level.active_move = null
	level.wait_for_camera = false

func handle_input(level: Node, event: InputEvent) -> void:
	## Ignore all inputs except pause, which runs from level.gd
	pass 

func update(level: Node, delta: float) -> void:
	#print("update - wait_for_camera: ", level.wait_for_camera)
	if _cancelled:
		return
	if level._level_complete:
		return
	if level.wait_for_camera:
		return
		
	if not level.animation_path.is_empty():
		#print("StateAnimating's update() - _move_along_path initated.")
		_move_along_path(level, delta)
		return
	
	if not level.moves_stack.is_empty() and not _is_processing:
		#print("StateAnimating's update() - _process_next_move initated.")
		_process_next_move(level)
		return
	
	if level.moves_stack.is_empty() and not _is_processing:
		_finish_animation(level)

func _move_along_path(level: Node, delta: float) -> void:
	#print("_move_along_path from instance: ", get_instance_id())
	if not _move_sound_playing:# and not level.animation_path.is_empty():
		pass
		AudioManager2d.play_character_loop(level.selected_unit.data.audio_move)
		_move_sound_playing = true
	var movement_speed: float = 8.0
	var target: Vector3 = level.animation_path.front()
	var dir: Vector3 = target - level.selected_unit.position
	var step: = movement_speed * delta
	
	if dir.length() <= step:
		level.selected_unit.position = target
		level.animation_path.pop_front()
		if level.animation_path.is_empty():
			AudioManager2d.stop_character_loop()
			_move_sound_playing = false
	else:
		level.selected_unit.position += dir.normalized() * step
		if dir.z > 0:
			level.selected_unit.play(level.selected_unit.run_down_animation)
		elif dir.z < 0:
			level.selected_unit.play(level.selected_unit.run_up_animation)
		elif dir.x > 0:
			level.selected_unit.play(level.selected_unit.run_right_animation)
		elif dir.x < 0:
			level.selected_unit.play(level.selected_unit.run_left_animation)


func _process_next_move(level: Node) -> void:
	print("Process_next_move started.")
	_is_processing = true
	level.active_move = level.moves_stack.pop_front()
	if level.selected_unit != null:
		level.selected_unit.state.just_teleported = false
	level.active_move.prepare(level.game_state)
	
	if level.active_move is CastSkill:
		var cast: CastSkill = level.active_move
		if cast.skill != null and cast.skill.audio_cast != null:
			level.selected_unit.audio_player.stream = cast.skill.audio_cast
			level.selected_unit.audio_player.play()
		await level.combat_vfx.play_skill(level.active_move.result)
		# Deduct AP for player action
		if level.is_player_turn and level.selected_unit != null:
			level.selected_unit.state.action_points_remaining = 0
		if _cancelled:
			return
	elif level.active_move is Attack:
		var weapon: Weapon = level.selected_unit.state.weapon
		if weapon != null and weapon.audio_attack != null:
			level.selected_unit.audio_player.stream = weapon.audio_attack
			level.selected_unit.audio_player.play()
		await level.combat_vfx.play_attack(level.active_move.result)
		# Deduct AP for player action
		if level.is_player_turn and level.selected_unit != null:
			level.selected_unit.state.action_points_remaining = 0
		if _cancelled:
			return
	else:
		pass
		
	level.active_move.apply_damage(level.game_state)
	if _cancelled:
		return
		
	if level.is_player_turn:
		level.active_move = Wait.new(level.active_move.end_pos)
	
	var code: int = level.enemy_code
	if level.is_player_turn:
		code = level.player_code_done
	level.occupancy_map.set_cell_item(level.active_move.start_pos, GridMap.INVALID_CELL_ITEM)
	level.occupancy_map.set_cell_item(level.active_move.end_pos, code)
	#print("move_to called on: ", level.selected_unit.data.unit_name if level.selected_unit else "null",
	  #" end_pos: ", level.active_move.end_pos)
	level.selected_unit.move_to(level.active_move.end_pos)
	level.selected_unit.pause_anim()
	level.camera_controller.free_camera()
	
	if not level.is_player_turn:
		level._clear_selection()
	level.completed_moves.append(level.active_move)
	
	if Tutorial.in_tutorial:
		Tutorial.tutorial_unit_moved()
	
	if not level.is_player_turn:
		if level.active_move is Attack:
			level.wait_for_camera = true
			level.timer.start(level.post_enemy_attack_wait)
			await level.timer.timeout
			level.wait_for_camera = false
			if _cancelled:
				return
		for character: Character in level.characters:
			if character == null:
				continue
			if not is_instance_valid(character):
				continue
			level.emit_signal("character_stats_changed", character)
	
	if not level.is_player_turn and level.selected_unit != null:
		level.selected_unit.state.is_moved = true
	_is_processing = false

func _finish_animation(level: Node) -> void:
	#print("_finish_animation called, _level_complete: ", level._level_complete)
	if _cancelled:
		return
	if level._level_complete:
		return
	
	level.check_trigger_conditions()
	level.check_victory_conditions()
	
	var teleporters := level.get_tree().get_nodes_in_group("teleporters")
	print("Teleporters in group: ", teleporters.size())
	for portal in teleporters:
		var portal_grid: Vector3i = portal.get("teleporter_grid_position")
		print("Portal: ", portal.name, " grid: ", portal_grid)
		for c: Character in level.player_characters:
			if not is_instance_valid(c):
				continue
			print("  checking: ", c.data.unit_name, " at: ", c.state.grid_position)
			if c.state.grid_position == portal_grid and not c.state.just_teleported:
				c.state.just_teleported = true
				await level._execute_teleport(portal, c)
				return
	
	if not level.is_player_turn:
		if not _is_processing:
			level.call_deferred("MoveSingleAI")
	else:
		if is_instance_valid(level.last_selected_unit):
			var unit: Character = level.last_selected_unit
			if unit.state.is_playable() and (unit.state.movement_points_remaining > 0 or unit.state.action_points_remaining > 0):
				level.select_unit(level.last_selected_unit)
				level.state_machine.transition_to(StateSelectingMove.new())
			else:
				# Last selected unit is done - find a new one
				var selectables: Array = level.get_selectable_characters()
				if not selectables.is_empty():
					level.select_unit(selectables.front())
					level.state_machine.transition_to(StateSelectingMove.new())
				else:
					level.state_machine.transition_to(StateSelectingUnit.new())
		else:
			var selectables: Array = level.get_selectable_characters()
			if not selectables.is_empty():
				level.select_unit(selectables.front())
				level.state_machine.transition_to(StateSelectingMove.new())
			else:
				level.state_machine.transition_to(StateSelectingUnit.new())
