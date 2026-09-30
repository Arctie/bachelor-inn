extends Resource
class_name DivineData

signal divine_resource_changed(new_value: int, cap: int)

@export var divine_resource: int = 50:
	set(value):
		divine_resource = clamp(value, 0, divine_resource_cap)
		emit_signal("divine_resource_changed", divine_resource, divine_resource_cap)
		
@export var divine_resource_cap: int = 100
@export var divine_skills: Array[Skill] = []

const DIVINE_CHAR_SCENE = preload("res://scenes/Characters/Player/Divine_character.tscn")
var character: Character = null

func setup() -> void:
	character = DIVINE_CHAR_SCENE.instantiate()
