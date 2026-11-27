extends Resource
class_name LootDrop

@export var type: LootEntry.Type = LootEntry.Type.ITEM
@export var id: String = ""
@export_range(1,5) var tier: int = 1
@export var weight: float = 1.0
