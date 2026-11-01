extends RefCounted
class_name AbilityHandler

# Calculate ability/skill outcome
static func calculate_outcome(skill: Skill, caster: Character, 
target_tile: Vector3i,state: GameState, caster_moved: bool) -> Array[SkillOutcome]:
	var outcomes: Array[SkillOutcome] = []
	if skill == null or caster == null:
		return outcomes
	
	var primary_target: Character = state.get_unit(target_tile)
	if primary_target == caster and caster_moved:
		primary_target = null
	var targets: Array[Character] = []
	if primary_target != null and _valid(primary_target, skill, caster):
		targets.append(primary_target)
	if skill.AoEShape != skill.AoE_shape.NONE:
		for tile: Vector3i in Main.level._get_aoe_tiles(target_tile, skill, caster):
			if tile == target_tile:
				continue
			var unit: Character = state.get_unit(tile)
			if unit != null and not targets.has(unit) and _valid(unit, skill, caster):
				targets.append(unit)
	
	var dmg: int = _stat_scaled(skill, caster, "damage")
	var heal: int = _stat_scaled(skill, caster, "current_health")
	for t: Character in targets:
		var is_primary: bool = t == primary_target
		if dmg > 0:
			outcomes.append(SkillOutcome.create_outcome(t, SkillOutcome.Type.DAMAGE, dmg, is_primary))
		if heal > 0:
			outcomes.append(SkillOutcome.create_outcome(t, SkillOutcome.Type.HEAL, heal, is_primary))
		if skill.duration_turns > 0:
			outcomes.append(SkillOutcome.create_outcome(t, SkillOutcome.Type.EFFECT, 0, is_primary))
		
	return outcomes

static func apply_outcome(o: SkillOutcome, skill: Skill, caster: Character, simulate_only: bool) -> void:
	if not is_instance_valid(o.target):
		return
	match o.type:
		SkillOutcome.Type.DAMAGE:
			o.target.apply_damage(o.amount, simulate_only, caster, skill.skill_name)
		SkillOutcome.Type.HEAL:
			o.target.state.current_health = mini(o.target.state.current_health + o.amount, o.target.state.max_health)
		SkillOutcome.Type.EFFECT:
			o.target.state.apply_skill_effect(skill)
# apply the outcome

# check if valid
static func _valid(t: Character, s: Skill, c: Character) -> bool:
	return Main.level._is_valid_target(t, s, c) ## TODO: Move into main?

# check for scaling effects
static func _stat_scaled(skill: Skill, caster: Character, key: String) -> int:
	if skill.effect_mods == null or not skill.effect_mods.has(key):
		return 0
	var total: float = float(skill.effect_mods[key])
	if total > 0.0:
		for stat: String in skill.scaling.keys():
			var v: Variant = caster.data.get(stat)
			if v != null:
				total += float(v) * float(skill.scaling[stat])
	return roundi(total)
