extends Node
class_name StateFreeRoaming

var _level: Level
var _leader: Character

func _init() -> void:
	# Build array
	# Set camera settings to FREE_ROAM
	pass

func enter(level: Node) -> void:
	print("ENTER STATE: StateFreeRoaming")
	if is_instance_valid(level.last_selected_unit):
		level.select_unit(level.last_selected_unit)
	else:
		var unit: Character
		for n in range(level.player_characters.size()):
			if is_instance_valid(level.player_characters[n]):
				level.select_unit(level.player_characters[n])
			return 

func exit(level: Node) -> void:
	print("EXIT STATE: StateFreeRoaming")
	# Set all player units to free_pathing = false <-- Might be handeled in StateAggroAlert
	pass

func handle_input(level: Node, event: InputEvent) -> void:
	if not level._can_handle_input(event):
		return
	
	var pos: Vector3i = level.get_grid_cell_from_mouse()
	level._update_cursor(pos)
	
	# Key inputs
	if event is InputEventKey and not event.echo and event.pressed:
		match event.keycode:
			KEY_TAB:
				print("Key Input TAB registered in SelectingMove.")
				level.select_next_character()
				#level.state_machine.transition_to(StateSelectingMove.new())
				return
			## TODO: Add check to only allow items.
			KEY_1:
				var ui := level.get_tree().get_first_node_in_group("ui_controller")
				if ui:
					ui.ribbon.trigger_skill_by_index(0)
				return
			KEY_2:
				var ui := level.get_tree().get_first_node_in_group("ui_controller")
				if ui:
					ui.ribbon.trigger_skill_by_index(1)
				return
			KEY_3:
				var ui := level.get_tree().get_first_node_in_group("ui_controller")
				if ui:
					ui.ribbon.trigger_skill_by_index(2)
				return
			KEY_4:
				var ui := level.get_tree().get_first_node_in_group("ui_controller")
				if ui:
					ui.ribbon.trigger_skill_by_index(3)
				return
			KEY_5:
				var ui := level.get_tree().get_first_node_in_group("ui_controller")
				if ui:
					ui.ribbon.trigger_skill_by_index(4)
				return
	
	if not event is InputEventMouseButton:
		return
	if not event.pressed:
		return
		
	if level._is_invalid_tile(pos): ## TODO: This checks for water tiles. Should be renamed.
		return
	
	# Click another player unit
	if level.get_unit_name(pos) == CharacterStates.Player:
		level._handle_player_click(pos)
		level.state_machine.transition_to(StateSelectingMove.new())
		return
		
	# Click movement tile or enemy unit
	if level.movement_map.get_cell_item(pos) != GridMap.INVALID_CELL_ITEM:
		var result: String = level._handle_action_tile_click(pos)
		match result:
			"move":
				level.state_machine.transition_to(StateAnimating.new())
				pass
			"attack":
				level.state_machine.transition_to(StateChoosingAttack.new())
				pass
		return
	
	# Click empty tile /anything else
	#level._clear_selection()
	#level.state_machine.transition_to(StateSelectingUnit.new())
