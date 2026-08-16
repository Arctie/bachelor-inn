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

# Variables
var holder : Character = null

# Orb animation variables
var t : float = 0.0
@export_category("Circling Character Animation")
@export var amp : float = 0.9   
@export var speed : float = -2.0
@export var offset : Vector3 = Vector3(0,0.2,-0.4)

# Functions
func transfer(to_character : Character) -> void:
	state.skills.clear()
	
	if holder != null:
		holder.state.orb = null
		
		# Remove ability to transfer orb
		holder.state.skills.remove_at(0)
	else:
		Main.level.occupancy_map.set_cell_item(state.grid_position, GridMap.INVALID_CELL_ITEM)
		state.orb = null
	
	holder = to_character
	to_character.state.orb = self
	
	# Add ability to transfer orb
	holder.state.skills.insert(0, SkillRegistry.get_skill("transfer_orb"))

func drop() -> void:
	show()
	if holder == null:
		Main.level.trigger_game_over()
		return
	state.grid_position = holder.state.grid_position
	position = holder.position
	state.skills.insert(0, SkillRegistry.get_skill("transfer_orb"))
	state.orb = self
	holder = null
	Main.level.game_state.units.append(self)

func soothe_in_radius(radius : int) -> void:
	pass

func _process(delta: float) -> void:
	if holder:
		position = holder.position
		state.grid_position = holder.state.grid_position
		
		# Animate
		t += delta * speed
		position += offset
		position.x += sin(t) * amp
		position.z += cos(t) * amp

func _ready() -> void:
	super()
	state.movement = 0
	state.aggro_range = 0
