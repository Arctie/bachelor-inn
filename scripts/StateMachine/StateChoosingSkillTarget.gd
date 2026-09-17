extends LevelState
class_name StateChoosingSkillTarget

func _enter() -> void:
	print("ENTER STATE: StateChoosingSkillTarget.")

func _exit() -> void:
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
