extends Resource
class_name DivineData

@export var divine_resource: int = 0
@export var divine_resource_cap: int = 100
@export var divine_skills: Array[Skill] = []

const DIVINE_CHAR_SCENE = preload("res://scenes/Characters/Player/Divine_character.tscn")
var character: Character = null

func setup() -> void:
	character = DIVINE_CHAR_SCENE.instantiate()
