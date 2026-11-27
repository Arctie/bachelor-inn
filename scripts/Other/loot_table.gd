extends Resource
class_name LootTable

const MAX_TIER: int = 5

@export var count_weights: Array[float] = [80.0, 15.0, 5.0]
@export var weapon_weight: float = 1.0
@export var skill_weight: float = 1.0
@export var item_weight: float = 1.0
@export_range(0.0, 1.0) var luck_chance: float = 0.15

func roll_loot_quantity() -> void:
	pass

func _roll_loot_type(chapter: int) -> void:# LootEntry.Type:
	pass

func _choose_loot_tier() -> void:
	pass

func _choose_loot_id() -> void:# LootEntry.Kind:
	pass

	
