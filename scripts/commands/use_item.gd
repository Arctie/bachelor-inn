extends Command
class_name UseItem
## This command handles using an item from the inventory.
## It is an atomic action that consumes resources (the item) and applies effects.
## The process is:
## 1. Preparation: Checks if the item exists and has usable effects.
## 2. Execution: Applies the effect (e.g., heals health, restores mana).
## 3. Cleanup: Removes the item from the InventoryService.

var item_id: String = ""


func _init(inItemName : String) -> void:
	item_id = inItemName


func prepare(state : GameState, simulate_only: bool = false) -> void:
	var inventory_service: InventoryService = get_node_or_null("/root/InventoryService");
	if not inventory_service:
		push_error("UseItemCommand: InventoryService is not available.");
		return

	# 1. Check if the item exists and is usable
	if not inventory_service.has_item(item_id):
		push_error("UseItemCommand: Item ID %s not found in inventory." % item_id);
		return

	var item_to_use: Item = null;
	# In a real setup, we'd fetch the Item Resource based on item_id.
	# For simulation, we'll mock fetching the item.
	if item_id == "Potion":
		item_to_use = preload("res://addons/art/potions/potion.tres").get_instance(); # Assume potion resource exists
	else:
		# Fallback for simulation
		item_to_use = Item.new();
		item_to_use.item_id = item_id;
		item_to_use.display_name = item_id;
		item_to_use.usage_effect = {"effect_type": "heal", "value": 10};


	# 2. Simulate the effect application (pre-check)
	var target_unit : Character = state.get_unit(state.player_unit_id); # Assumes state holds player unit ID
	
	var simulated_result = {}
	if item_to_use.usage_effect.get("effect_type") == "heal":
		simulated_result["new_hp"] = target_unit.state.current_health + item_to_use.usage_effect.get("value", 0);
		simulated_result["message"] = "Simulated heal effect: +%d HP" % item_to_use.usage_effect.get("value", 0);

	# 3. Store the simulation result for later verification
	self.result = {
		"item_used": item_id,
		"simulated_result": simulated_result
	};


func apply_damage(state: GameState , simulate_only: bool = false) -> void:
	var inventory_service: InventoryService = get_node_or_null("/root/InventoryService");
	if not inventory_service:
		push_error("UseItemCommand: InventoryService is not available.");
		return

	var item_used: Item = Item.new();
	item_used.item_id = result.item_used;
	item_used.usage_effect = {"effect_type": "heal", "value": 10}; # Mock data

	# 1. Apply the effect (Mutation)
	var target_unit : Character = state.get_unit(state.player_unit_id); 

	if item_used.usage_effect.get("effect_type") == "heal":
		var heal_value = item_used.usage_effect.get("value", 0);
		target_unit.state.current_health = min(target_unit.state.max_health, target_unit.state.current_health + heal_value);
		
	# 2. Cleanup (Consume the item)
	inventory_service.use_item(item_used.item_id);
	
	# 3. Signal the change
	Main.level.emit_signal("character_stats_changed", target_unit);

#old, replaced by prepare and apply
func execute(state : GameState, simulate_only : bool = false) -> void:
	# This function is now obsolete. Use prepare/apply cycle.
	pass