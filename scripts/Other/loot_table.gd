extends Resource
class_name LootTable

const MAX_TIER: int = 5

@export var count_weights: Array[float] = [80.0, 15.0, 5.0]
@export var weapon_weight: float = 1.0
@export var skill_weight: float = 1.0
@export var item_weight: float = 1.0

func roll_loot() -> void:
	pass

func _chose_loot_type() -> void:# LootEntry.Type:
	pass

func _chose_loot_tier() -> void:
	pass

func _chose_loot_id() -> void:# LootEntry.Kind:
	pass
