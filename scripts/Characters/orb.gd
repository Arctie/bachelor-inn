extends Character
class_name Orb
## The orb is Noble Night's wrinkle on the classic tactical RPG formula
## 
## The orb should be an object which a character can hold,
## transfer and protect. When a player holding the orb is defeated,
## the orb is lost and another player character can pick it up.
##
## TODO: Orb healing nearby player characters sanity
## TODO: Enemy characters turn to allies over time by being close to the orb

## Variables
var holder : Character = null

## Functions
func transfer(to_character : Character) -> void:
	if holder != null:
		holder.state.orb = null
		
		# Remove ability to transfer orb
		holder.state.skills.remove_at(0)
	
	# Hide orb and remove from map
	if visible:
		hide()
		Main.level.occupancy_map.set_cell_item(state.grid_position, GridMap.INVALID_CELL_ITEM)
		state.orb = null
	
	holder = to_character
	to_character.state.orb = self
	
	# Add ability to transfer orb
	holder.state.skills.insert(0, SkillRegistry.get_skill("transfer_orb"))

func drop() -> void:
	show()
	state.grid_position = holder.state.grid_position
	position = holder.position
	state.skills.insert(0, SkillRegistry.get_skill("transfer_orb"))
	state.orb = self
	holder = null

func soothe_in_radius(radius : int) -> void:
	pass

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	hide()
