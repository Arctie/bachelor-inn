extends Node
class_name StateFreeRoaming

func _init() -> void:
	# Build array
	pass

func enter(level: Node) -> void:
	# Set all player units to free_pathing = true
	pass

func exit(level: Node) -> void:
	# Set all player units to free_pathing = false <-- Might be handeled in StateAggroAlert
	pass

func handle_input(level: Node, event: InputEvent) -> void:
	## Block all input during animation (helps for Tutorial :D)
	pass 
