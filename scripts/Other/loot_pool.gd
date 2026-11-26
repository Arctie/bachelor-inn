extends Resource
class_name LootPool

@export var type: LootEntry.Type = LootEntry.Type.WEAPON
@export_range(1,4) var tier_listL: int = 1
@export var ids: Array[String] = []
