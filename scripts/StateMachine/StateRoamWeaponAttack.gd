extends LevelState
class_name StateRoamWeaponAttack


func _init() -> void:
	pass

func enter(level: Node) -> void:
	print("ENTER STATE: StateRoamWeaponAttack.")
	#TODO: Set mouse cursor to attack?

func exit(level: Node) -> void:
	print("Exit State: StateRoamWeaponAttack.")
	

func handle_input(level: Node, event: InputEvent) -> void:
	if not level._can_handle_input(event):
		return
	
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_TAB:
			level.state_machine.transition_to(StateFreeRoaming.new())
			return
		var index: int = event.keycode - KEY_1
		if index >= 0 and index <= 4:
			level.state_machine.transition_to(StateFreeRoaming.new())
			return
		if event.keycode == KEY_6:
			level.state_machine.transition_to(StateFreeRoaming.new())
			return
			
	if not (event is InputEventMouseMotion or event is InputEventMouseButton):
		return
	var pos: Vector3i = level.get_grid_cell_from_mouse()
	level._update_cursor(pos)
	## TODO: Add on hover of attackable target
	if event.button_index == MOUSE_BUTTON_RIGHT:
		_cancel(level)
		return
	
	if level.path_map.get_cell_item(pos) == GridMap.INVALID_CELL_ITEM:
		_cancel(level)
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pass
		#level._handle_attack_choice(pos)
		
func _cancel(level: Node) -> void:
	pass
