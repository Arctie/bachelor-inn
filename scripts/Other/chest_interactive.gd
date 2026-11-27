extends Node3D
class_name Chest

enum LootType {WEAPON, SKILL, ITEM}

@export var loot_type : LootType = LootType.WEAPON
@export var weapon_id: String = ""
@export var skill_id_1: String = ""
@export var skill_id_2: String = ""
@export var skill_id_3: String = ""
@export var item_id: String = ""
@export var item_amount: int = 1
@export var dialogue_timeline: String = ""
var is_opened: bool = false
var is_looted: bool = false

func _ready() -> void:
	add_to_group("chests")
	#var table: LootTable = load("res://scripts/Other/loot_table.gd")
	#for i in 20:
		#var rolled: Array[LootEntry] = table.roll(1)
		#print(rolled.map(func(e: LootEntry) -> String: return "%d:%s" % [e.kind, e.id]))
	#if not body_entered.is_connected(_on_body_entered):
		#body_entered.connect(_on_body_entered)

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Chest area entered by: ", body.name)
	if is_opened or is_looted:
		return
	var level: Level = Main.level
	if level == null or body != level.selected_unit:
		return
	var cur: LevelState = level.state_machine.current
	if not (cur is StateFreeRoamAnimating or cur is StateFreeRoaming):
		return
	level.request_chest_open(self)
