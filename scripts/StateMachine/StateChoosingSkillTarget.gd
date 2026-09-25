extends LevelState
class_name StateChoosingSkillTarget
## This is where we decide target tile to cast a skill on

func enter(level: Node) -> void:
	print("ENTER STATE: StateChoosingSkillTarget.")
	#if level.state_machine.current is StateDivineTurn or Main.divine.character == level.skill_caster:
		#level.skill_caster = Main.divine.character
	print("StateChoosingSkillTarget handle_input - divine char: ", Main.divine.character, " skill_caster: ", level.skill_caster)

func _exit(level: Node) -> void:
	level.clear_aoe_preview()
	print("EXIT STATE: StateChoosingSkillTarget.")

func update(level: Node, delta: float) -> void:
	var pos: Vector3i = level.get_grid_cell_from_mouse()
	#if pos == level._last_hovered_pos:
		#return
	#level._last_hovered_pos = pos
	
	if level.valid_skill_target_tiles.has(pos):
		Input.set_custom_mouse_cursor(level.cursor_wand, Input.CURSOR_ARROW, Vector2(8, 8))
		level.show_aoe_preview(pos, level.active_skill)
	else:
		Input.set_custom_mouse_cursor(null)
		level.clear_aoe_preview()

func handle_input(level: Node, event: InputEvent) -> void:
	if not level._can_handle_input(event):
		return
	var pos: Vector3i = level.get_grid_cell_from_mouse()
	level._update_cursor(pos)
	
	# Key inputs
	if event is InputEventKey and not event.echo and event.pressed:
		match event.keycode:
			KEY_TAB:
				level._exit_skill_target_mode()
				print("Key Input TAB registered in SelectingMove.")
				level.select_next_character()
				level.state_machine.transition_to(StateSelectingMove.new())
				return
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
	
	# Divine turn — skip origin selection, cast right away
	if level.is_divine_turn:
		level.skill_caster = Main.divine.character
	if level.skill_caster == Main.divine.character:
		level.divine_cast_position = pos
		var cast := CastSkill.new(pos, pos, pos, level.active_skill)
		level.moves_stack.append(cast)
		level.create_path(pos, pos)
		level.active_skill = null
		level.valid_skill_target_tiles.clear()
		level.state_machine.transition_to(StateAnimating.new())
		return
		
	level._show_skill_origin_tiles(pos, level.active_skill)
	level.state_machine.transition_to(StateChoosingSkillOrigin.new())
	
func _cancel(level: Node) -> void:
	var caster: Character = level.skill_caster
	level._exit_skill_target_mode()
	if is_instance_valid(caster):
		level.state_machine.transition_to(StateSelectingMove.new())
	else:
		level.state_machine.transition_to(StateSelectingUnit.new())
