extends AbilityOffensive
class_name KillSelf


func _init(inStartPos : Vector3i, attackFromPos : Vector3i) -> void:
	_targets = [attackFromPos]
	start_pos = inStartPos;
	end_pos = attackFromPos;

#inherited functions
func prepare(_state: GameState, _simulate_only : bool = false) -> void:
	result = AttackResult.new()

	#var aggressor : Character = state.get_unit(start_pos);
	var ability_user : Character = _state.get_unit(end_pos);
	if ability_user == null:
		ability_user = _state.get_unit(start_pos)
	var victim : Character = ability_user;
	
	result.aggressor = ability_user
	result.victim = victim
	
	
	if ability_user.state.is_playable():
		ability_user.state.is_ability_used = true
	ability_user.state.is_moved = true;
	

	var attack_strength :int = ability_user.state.current_health
	
	result.damage = attack_strength
	pass;
	
func apply_damage(_state: GameState, _simulate_only: bool = false) -> void:
	var aggressor : Character = result.aggressor;
	var victim : Character = result.victim;
	
	result.killed = victim.apply_damage(result.damage, _simulate_only, aggressor, "Attack")
	print("Agressor " + str(aggressor.data.unit_name) + " dealt " + str(result.damage)
	 + " to " + str(victim.data.unit_name) + " with " + str(aggressor.state.weapon.weapon_name))
	Main.level.emit_signal("character_stats_changed", aggressor)
	
	pass;
