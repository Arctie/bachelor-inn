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
	if (holder != null):
		holder.orb = null
	
	holder = to_character
	to_character.orb = self

func drop() -> void:
	# Spawn on character's position
	pass 

func soothe_in_radius(radius : int) -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	hide()
