extends BTNode
class_name TaskGetReachableTilesNoFly

func tick(blackboard: BTBlackboard) -> BTNode.Status:
	var unit := blackboard.unit
	var state := blackboard.state
	var start : Vector3i = unit.state.grid_position
	
	var max_depth : int = unit.state.movement
	var min_depth : int = 0
	var consider_terrain_cost : bool = true
	var include_start_in_output : bool = true
	var go_through_heroes : bool = false
	var go_through_monsters : bool = true
	var include_hero_tiles_in_output : bool = false
	var include_monster_tiles_in_output : bool = false
	var go_through_empty_tiles : bool = true
	var include_empty_tiles_in_output : bool = true
	var store_path : bool = true
			
	blackboard.reachable_tiles = MoveGenerator.basic_dijkstra(
		state, start, max_depth, min_depth,
		consider_terrain_cost, include_start_in_output,
		go_through_heroes, go_through_monsters,
		include_hero_tiles_in_output, include_monster_tiles_in_output,
		go_through_empty_tiles, include_empty_tiles_in_output, store_path)
		
	#print("Action fired: ", get_script().resource_path, " command: ", blackboard.chosen_command)
	return BTNode.Status.SUCCESS
