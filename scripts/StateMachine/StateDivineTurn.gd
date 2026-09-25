extends LevelState
class_name StateDivineTurn

func enter(level: Node) -> void:
	print("ENTER STATE: StateDivineTurn.")
	level.is_player_turn = false
	## TODO: Hide player card bottom right
	level.divine_label.show()
	level.enemy_label.hide()
	#level.MoveSingleAI()

func exit(level: Node) -> void:
	print("EXIT STATE: StateDivineTurn.")
	pass

func handle_input(level: Node, event: InputEvent) -> void:
	if not level._can_handle_input(event):
		return
	var pos: Vector3i = level.get_grid_cell_from_mouse()
	level._update_cursor(pos)
	
	# Key inputs
	if event is InputEventKey and not event.echo and event.pressed:
		match event.keycode:
			#KEY_TAB:
				#level._exit_skill_target_mode()
				#print("Key Input TAB registered in SelectingMove.")
				#level.select_next_character()
				#level.state_machine.transition_to(StateSelectingMove.new())
				#return
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
	
	if not level.valid_skill_target_tiles.has(pos):
		_cancel(level)
		return
	
	level.skill_target_pos = pos
	level._show_skill_origin_tiles(pos, level.active_skill)
	level.state_machine.transition_to(StateChoosingSkillOrigin.new())

func _cancel(level: Node) -> void:
	var caster: Character = level.skill_caster
	level._exit_skill_target_mode()
	if is_instance_valid(caster):
		level.state_machine.transition_to(StateSelectingMove.new())
	else:
		level.state_machine.transition_to(StateSelectingUnit.new())
