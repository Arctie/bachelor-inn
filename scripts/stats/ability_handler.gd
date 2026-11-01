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
	
	return outcomes
# apply the outcome

# check if valid
static func _valid(t: Character, s: Skill, c: Character) -> bool:
	return Main.level._is_valid_target(t, s, c) ## TODO: Move into main?
# check for scaling effects
