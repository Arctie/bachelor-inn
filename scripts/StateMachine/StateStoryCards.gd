extends LevelState
class_name StateStoryCards

func _init() -> void:
	pass

func enter(level: Node) -> void:
	print("ENTER STATE: StateStoryCards.")
	## Play StoryCards

func exit(level: Node) -> void:
	print("EXIT STATE: StateStoryCards.")
	

func handle_input(level: Node, event: InputEvent) -> void:
	## Block all input during animation (helps for Tutorial :D)
	pass 

func _on_cards_finished(level: Node) -> void:
	#print("TurnTransition finished - to_player: ", _to_player, 
		  #" last_selected: ", level.last_selected_unit,
		  #" selectables: ", level.get_selectable_characters().size())
	pass
