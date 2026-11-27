extends RefCounted
class_name LootEntry

enum Type { WEAPON, SKILL, ITEM }

var type: Type = Type.WEAPON
var id: String = ""
var amount: int = 1
var resolved: bool = false
var taken: bool = false

## Func for making a loot type?
