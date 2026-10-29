extends LevelState
class_name StateFreeRoaming

var _level: Level
var _leader: Character

func _init() -> void:
	# Build array
	# Set camera settings to FREE_ROAM
	pass

func enter(level: Node) -> void:
	print("ENTER STATE: StateFreeRoaming")
	_level = level as Level
	_level.is_player_turn = true
	
	var ui := level.get_tree().get_first_node_in_group("ui_controller")
	if ui:
		ui.hide_end_turn_button()
		
	if not is_instance_valid(_leader):
		_leader = _pick_leader()
	if _leader == null:
		return # This should not be possible
	for c: Character in _level.player_characters:
		if is_instance_valid(c):
			_level.occupancy_map.set_cell_item(c.state.grid_position, GridMap.INVALID_CELL_ITEM)
	_level.selected_unit = _leader
	_level.last_selected_unit = _leader
	_level.camera_controller.start_roaming(_leader)
	_level.movement_map.clear()
	_level.path_map.clear()
	_level.aoe_preview_map.clear()
	#print("Selected unit is: ", _leader, ". And camera is following.")

func exit(level: Node) -> void:
	print("EXIT STATE: StateFreeRoaming")

func _set_path(pos: Vector3i) -> void:
	if not is_instance_valid(_leader):
		return
	if _level.occupancy_map.get_cell_item(pos) != GridMap.INVALID_CELL_ITEM:
		return
	var path: Array[Vector3i] = MovementGrid.find_path(
		_leader.state.grid_position, pos, _level.movement_weights_map, _level.occupancy_map)
	if path.is_empty():
		return
	_level.state_machine.transition_to(StateFreeRoamAnimating.new(_leader, path))


func _pick_leader() -> Character:
	if is_instance_valid(_level.last_selected_unit):
		return _level.last_selected_unit
	for c: Character in _level.player_characters:
		if is_instance_valid(c) and c.state.is_alive:
			return c
	return null

func _next_leader() -> void:
	var party: Array[Character] = []
	for c: Character in _level.player_characters:
		if is_instance_valid(c) and c.state.is_alive:
			party.append(c)
	if party.size() < 2:
		return
	var i: int = party.find(_leader)
	_leader = party[(i + 1) % party.size()]     # find() returns -1 if missing, which wraps to index 0
	_level.selected_unit = _leader
	_level.last_selected_unit = _leader
	_level.camera_controller.set_roam_target(_leader)
	_level.emit_signal("character_selected", _leader)

func handle_input(level: Node, event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_TAB:
			_next_leader()
			return
	if not (event is InputEventMouseMotion or event is InputEventMouseButton):
		return
	if not level._can_handle_input(event):
		return
	var pos: Vector3i = level.get_grid_cell_from_mouse()
	level._update_cursor(pos)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_set_path(pos)
	#if not level._can_handle_input(event):
		#return
	#
	#var pos: Vector3i = level.get_grid_cell_from_mouse()
	#level._update_cursor(pos)
	#
	## Key inputs
	#if event is InputEventKey and not event.echo and event.pressed:
		#match event.keycode:
			#KEY_TAB:
				#print("Key Input TAB registered in SelectingMove.")
				#level.select_next_character()
				##level.state_machine.transition_to(StateSelectingMove.new())
				#return
			### TODO: Add check to only allow items.
			#KEY_1:
				#var ui := level.get_tree().get_first_node_in_group("ui_controller")
				#if ui:
					#ui.ribbon.trigger_skill_by_index(0)
				#return
			#KEY_2:
				#var ui := level.get_tree().get_first_node_in_group("ui_controller")
				#if ui:
					#ui.ribbon.trigger_skill_by_index(1)
				#return
			#KEY_3:
				#var ui := level.get_tree().get_first_node_in_group("ui_controller")
				#if ui:
					#ui.ribbon.trigger_skill_by_index(2)
				#return
			#KEY_4:
				#var ui := level.get_tree().get_first_node_in_group("ui_controller")
				#if ui:
					#ui.ribbon.trigger_skill_by_index(3)
				#return
			#KEY_5:
				#var ui := level.get_tree().get_first_node_in_group("ui_controller")
				#if ui:
					#ui.ribbon.trigger_skill_by_index(4)
				#return
	#
	#if not event is InputEventMouseButton:
		#return
	#if not event.pressed:
		#return
		#
	#if level._is_invalid_tile(pos): ## TODO: This checks for water tiles. Should be renamed.
		#return
	#
	## Click another player unit
	#if level.get_unit_name(pos) == CharacterStates.Player:
		#level._handle_player_click(pos)
		#level.state_machine.transition_to(StateSelectingMove.new())
		#return
		#
	## Click movement tile or enemy unit
	#if level.movement_map.get_cell_item(pos) != GridMap.INVALID_CELL_ITEM:
		#var result: String = level._handle_action_tile_click(pos)
		#match result:
			#"move":
				#level.state_machine.transition_to(StateAnimating.new())
				#pass
			#"attack":
				#level.state_machine.transition_to(StateChoosingAttack.new())
				#pass
		#return
	
	# Click empty tile /anything else
	#level._clear_selection()
	#level.state_machine.transition_to(StateSelectingUnit.new())
