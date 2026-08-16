extends Command
class_name TransferOrb

# Constructor
func _init(in_start_pos: Vector3i, inTargetPos: Vector3i) -> void:
	print("INIT TRANFER ORB")
	start_pos = in_start_pos
	end_pos = inTargetPos

# Execute the orb transfer
func execute(state: GameState, simulate_only: bool = false) -> void:
	print("TRANFER ORB")
	var holder := state.get_unit(start_pos)
	var target := state.get_unit(end_pos)
	
	if holder == null or target == null:
		push_warning("Transfer orb: no unit at position " + str(end_pos))
		return
	
	if not simulate_only:
		target.state.orb.transfer(holder)

# Undo the orb transfer
func undo(state: GameState, simulate_only: bool = false) -> void:
	var holder := state.get_unit(start_pos)
	var target := state.get_unit(end_pos)
	
	if holder == null or target == null:
		push_warning("Transfer orb: no unit at position " + str(end_pos))
		return
	
	if not simulate_only:
		holder.state.orb.transfer(target)
