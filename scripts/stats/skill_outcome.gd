extends RefCounted
class_name SkillOutcome

enum Type { DAMAGE, HEAL, EFFECT }

var target: Character
var type: Type = Type.DAMAGE
var amount: int = 0
var is_primary_target: bool = false

static func create_outcome(t: Character, type: Type, amount: int, primary: bool) -> SkillOutcome:
	var o: SkillOutcome = SkillOutcome.new()
	o.target = t
	o.type = type
	o.amount = amount
	o.is_primary_target = primary
	return o
