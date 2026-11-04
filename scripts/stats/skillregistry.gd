extends Node

const S_NO_SKILL: String = "no skill"#preload("res://Data/Abilities/no_skill.tres")
#const SKILL_LIST: SkillList = preload("res://Data/Abilities/skill_list.tres")
const SKILL_LIST_PATH: String = "res://Data/Abilities/SkillList/skill_list.tres"
var _by_id: Dictionary = {}
#const S_HEAL_BASIC = preload("res://Data/Abilities/heal_basic.tres")
#const S_HEAL_SANITY_BASIC = preload("res://Data/Abilities/heal_sanity_basic.tres")
#const S_FIREBALL_BASIC = preload("res://Data/Abilities/fireball_basic.tres")
#const S_MELEE_SWEEP = preload("res://Data/Abilities/melee_sweep.tres")
#const S_HASTE_BASIC = preload("res://Data/Abilities/haste_basic.tres")
#const S_DEFENCE_BASIC = preload("res://Data/Abilities/defence_basic.tres")
#const S_TRAP_BASIC = preload("res://Data/Abilities/trap_basic.tres")
#const S_BOMB_BASIC = preload("res://Data/Abilities/bomb_basic.tres")
#const S_WHIRLWIND = preload("res://Data/Abilities/whirlwind.tres")
#const S_CAUTERIZING_HEAL = preload("res://Data/Abilities/divine_cauterizing_heal.tres")


func _ready() -> void:
	_by_id.clear()
	var list: Resource = load(SKILL_LIST_PATH)
	var all: Array = list.get("skills")
	for entry: Skill in all:
		_register(entry)
	#_register(S_NO_SKILL)
	#_register(S_HEAL_BASIC)
	#_register(S_FIREBALL_BASIC)
	#_register(S_MELEE_SWEEP)
	#_register(S_HASTE_BASIC)
	#_register(S_BOMB_BASIC)
	#_register(S_HEAL_SANITY_BASIC)
	#_register(S_TRAP_BASIC)
	#_register(S_DEFENCE_BASIC)
	#_register(S_WHIRLWIND)
	#_register(S_CAUTERIZING_HEAL)
	
func _register(s: Skill) -> void:
	if s == null:
		push_error("SkillRegister: Tried to reg NULL skill.")
		return
	
	if s.skill_id == "":
		push_error("SkillRegister: Skill '" + str(s.skill_name) + "' has EMPTY skill_id (fix the .tres file).")
		return
	
	if _by_id.has(s.skill_id):
		push_warning("SkillRegister: duplicate skill_id '" + s.skill_id+ "' found. Overwriting.")
	
	_by_id[s.skill_id] = s;

func get_skill(id: String) -> Skill:
	if _by_id.has(id):
		return _by_id[id];
	push_warning("SkillRegister: unknown skill_id found: '" + id + "'. Known: " + str(_by_id.keys()) + ". Returning NOTHING")
	return _by_id.get(S_NO_SKILL)#S_NO_SKILL;

func get_all_skills(_id: String) -> Array[Skill]:
	var out: Array[Skill] = []
	for s: Skill in _by_id.values():
		out.append(s)
	return out
