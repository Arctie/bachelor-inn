extends RefCounted
class_name SkillOutcome

enum Type { DAMAGE, HEAL, BUFF }

var target: Character
var type: Type = Type.DAMAGE
var amount: int = 0

static func create_outcome(t: Character, type: Type, amount: int) -> SkillOutcome:
	var o: SkillOutcome = SkillOutcome.new()
	o.target = t
	o.type = type
	o.amount = amount
	return o
