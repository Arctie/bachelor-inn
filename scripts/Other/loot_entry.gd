extends Resource
class_name LootEntry

enum kind { WEAPON, SKILL, ITEM }

var id: String = ""
var amount: int = 1
var resolved: bool = false
var taken: bool = false
