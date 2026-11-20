extends Node3D
class_name Chest

enum LootType {WEAPON, SKILL, ITEM}

@export var loot_type : LootType = LootType.WEAPON
@export var weapon_id: String = ""
@export var skill_id_1: String = ""
@export var skill_id_2: String = ""
@export var skill_id_3: String = ""
@export var dialogue_timeline: String = "chest_tutorial"
var is_opened: bool = false
var is_looted: bool = false


func _on_body_entered(body: Node3D) -> void:
	if is_opened or is_looted:
		return
	var level: Level = Main.level
	if level == null or body != level.selected_unit:
		return
	var cur: LevelState = level.state_machine.current
	if not (cur is StateFreeRoamAnimating or cur is StateFreeRoaming):
		return
	level.request_chest_open(self)
