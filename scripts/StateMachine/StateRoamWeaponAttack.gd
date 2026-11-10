extends LevelState
class_name StateRoamWeaponAttack

func enter(level: Node) -> void:
	print("ENTER STATE: StateRoamWeaponAttack.")
	#TODO: Set mouse cursor to attack?

func exit(level: Node) -> void:
	print("Exit State: StateRoamWeaponAttack.")
	level.path_map.clear()
	level.valid_attack_tiles.clear()
	Input.set_custom_mouse_cursor(null)
	
func handle_input(level: Node, event: InputEvent) -> void:
	if not level._can_handle_input(event):
		return
	
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_TAB or event.keycode == KEY_6:
			_cancel(level)
			return
		var index: int = event.keycode - KEY_1
		if index >= 0 and index <= 4:
			_cancel(level)
			var ui := level.get_tree().get_first_node_in_group("ui_controller")
			if ui:
				ui.ribbon.trigger_skill_by_index(index)
			return
		return

	if not (event is InputEventMouseMotion or event is InputEventMouseButton):
		return

	var pos: Vector3i = level.get_grid_cell_from_mouse()
	level._update_cursor(pos)
	# TODO: change the cursor when hovering an attackable target
	if not (event is InputEventMouseButton and event.pressed):
		return

	if event.button_index == MOUSE_BUTTON_RIGHT:
		_cancel(level)
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	if not level.valid_attack_tiles.has(pos):
		_cancel(level)
		return

	var attacker: Character = level.selected_unit
	if not is_instance_valid(attacker):
		_cancel(level)
		return
	var tile: Vector3i = attacker.state.grid_position
	level.moves_stack.append(Attack.new(tile, pos, tile))
	level.valid_attack_tiles.clear()
	level.path_map.clear()
	level.state_machine.transition_to(StateAnimating.new(true))
		
func _cancel(level: Node) -> void:
	level.valid_attack_tiles.clear()
	level.path_map.clear() 
	level.state_machine.transition_to(StateFreeRoaming.new())
