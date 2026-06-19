extends Resource
class_name Item

# Defines a single item in the game.
var item_id: String = ""
var display_name: String = ""
var description: String = ""
var stackable: bool = true
var icon_path: String = ""
var item_type: String = "Resource" # e.g., "Potion", "Equipment", "Resource"

# Usage data if applicable
var usage_effect: Dictionary = {}
# Example: {"effect_type": "heal", "value": 50, "target": "self"}


extends Resource
class_name Inventory

# Represents the storage container for items.
var items: Dictionary = {} # Key: ItemID, Value: Dictionary (containing Item object and Quantity)

# Helper function to add an item to the inventory, handling stacking.
func add_item(item: Item, quantity: int) -> bool:
	if quantity <= 0: return false

	var current_stack: Dictionary = items.get(item.item_id, {"item": item, "quantity": 0});
	var total_quantity = current_stack.quantity + quantity;
	
	# Simple logic: if stackable, update quantity.
	if item.stackable:
		items[item.item_id] = {"item": item, "quantity": total_quantity};
		return true
	else:
		# Not stackable, treat as a new slot
		var new_slot_key = item.item_id + "_" + str(items.keys().size() + 1);
		items[new_slot_key] = {"item": item, "quantity": 1};
		return true

# Gets the total quantity of a specific item ID.
func get_quantity(item_id: String) -> int:
	for key in items:
		if items[key].item.item_id == item_id:
			return items[key].quantity
	return 0

# Removes one unit of an item by ID.
func remove_item(item_id: String) -> bool:
	# This logic is complex because we might remove a stacked item or a unique slot.
	# For simplicity in this test, we assume stackable items are removed first.
	var key_to_remove: String = null;
	for key in items:
		if items[key].item.item_id == item_id:
			key_to_remove = key;
			break;
			
	if key_to_remove == null:
		return false;

	var current: Dictionary = items[key_to_remove];
	
	if current.item.stackable:
		items[key_to_remove].quantity -= 1;
		if items[key_to_remove].quantity <= 0:
			items.delete(key_to_remove);
	else:
		# Unique item, just delete the slot
		items.delete(key_to_remove);
		
	return true


extends Node
class_name InventoryService

# The central service responsible for all inventory logic.
var inventory: Inventory = Inventory.new();

# --- Public Interface ---

# Attempts to add items. Returns true on success.
func add_items(items_to_add: Array[Item], quantities: Array[int]) -> bool:
	if items_to_add.size() != quantities.size():
		push_error("Item list and quantity list must be the same size.");
		return false;

	for i in range(items_to_add.size()):
		var item = items_to_add[i];
		var quantity = quantities[i];
		
		if not inventory.add_item(item, quantity):
			push_error("Failed to add item %s." % item.display_name);
			return false;
	
	print("InventoryService: Successfully added items to inventory.");
	return true;

# Attempts to use an item by ID. Returns the boolean success/fail.
func use_item(item_id: String) -> bool:
	var item_to_use: Item = null;
	
	# Find the item first
	for key in inventory.items:
		var item: Item = inventory.items[key].item;
		if item.item_id == item_id:
			item_to_use = item;
			break;
			
	if item_to_use == null:
		print("InventoryService: Item %s not found." % item_id);
		return false;

	# Check if we have any quantity left
	if not inventory.remove_item(item_id):
		print("InventoryService: Cannot use item %s, out of stock." % item_id);
		return false;
	
	# If removal was successful, process the use effect
	if item_to_use.usage_effect.has("effect_type"):
		var effect = item_to_use.usage_effect;
		print("--- Applying Item Effect: %s ---" % effect.effect_type);
		# In a real scenario, we would call a separate EffectHandler here.
		# e.g., EffectHandler.apply_effect(effect, self);
		
	print("InventoryService: Item %s used successfully and removed." % item_id);
	return true;

# Checks if the inventory contains at least one item of the given ID.
func has_item(item_id: String) -> bool:
	return inventory.get_quantity(item_id) > 0;
