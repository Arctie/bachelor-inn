extends LevelState
class_name StateTurnTransition

var _to_player: bool
var _to_divine: bool = false

func _init(to_player: bool, to_divine: bool = false) -> void:
	_to_player = to_player
	_to_divine = to_divine

func enter(level: Node) -> void:
	print("ENTER STATE: StateTurnTransition.")
	if _to_divine:
		level.enemy_label.hide()
		level.player_label.hide()
		level.divine_label.show()
		#level.turn_transition_animation_player.play()
	elif _to_player:
		level.is_divine_turn = false
		level.enemy_label.hide()
		level.divine_label.hide()
		level.player_label.show()
		## Remove Divine Char from map
		Main.divine.character.state.grid_position = Vector3i(-999, -999, -999)
	else:
		level.enemy_label.show()
		level.player_label.hide()
		level.check_aggro()
		level.hide_inactive_characters()
	
	## TODO: add signal to remove UI while animating?
	
	level.turn_transition_animation_player.animation_finished.connect(
		_on_animation_finished.bind(level), CONNECT_ONE_SHOT ## Auto disconnect after fire'ing once
	)
	level.turn_transition_animation_player.play()

func exit(level: Node) -> void:
	print("EXIT STATE: StateTurnTransition.")
	pass

func handle_input(level: Node, event: InputEvent) -> void:
	## Block all input during animation (helps for Tutorial :D)
	pass 

func _on_animation_finished(anim_name: StringName, level: Node) -> void:
	print("TurnTransition finished - to_player: ", _to_player, 
		  " last_selected: ", level.last_selected_unit,
		  " selectables: ", level.get_selectable_characters().size())
	if level._level_complete:
		return
	if _to_divine:
		level.state_machine.transition_to(StateDivineTurn.new())
		return	
	elif _to_player:
		level.is_player_turn = true
		var selectables: Array[Character] = level.get_selectable_characters()
		
		if selectables.is_empty():
			level.state_machine.transition_to(StateSelectingUnit.new())
			return
		
		if level.last_selected_unit != null and selectables.has(level.last_selected_unit):
			level.camera_controller.free_camera()
			level.camera_controller.set_pivot_target_translate(level.last_selected_unit.position)
			level.select_unit(level.last_selected_unit)
			level.state_machine.transition_to(StateSelectingMove.new())
		else:
			level.camera_controller.free_camera()
			level.camera_controller.set_pivot_target_translate(selectables.front().position)
			if not Tutorial.in_tutorial:
				level.select_unit(selectables.front())
				level.state_machine.transition_to(StateSelectingMove.new())
			else:
				level.state_machine.transition_to(StateSelectingUnit.new())
	else:
		level.is_player_turn = false
		level.state_machine.transition_to(StateEnemyTurn.new())
