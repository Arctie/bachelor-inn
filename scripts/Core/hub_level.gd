extends Control

@onready var next_level_button: Button = $ButtonContainer/VBoxContainer/NextLevelButton
@onready var save_and_quit_button: Button = $ButtonContainer/VBoxContainer/SaveAndQuitButton
@onready var party_grid: GridContainer = $UnitsPanel/VBoxContainer/PartyMarginContainer/PartyGridContainer
@onready var garrison_grid: GridContainer = $UnitsPanel/VBoxContainer/GarrisonMarginContainer/GarrisonGridContainer

var selected_unit: Character = null
var _party: Array[String] = []
var _garrison: Array[String] = []

## NOTE: !!! Any action or change done in here should trigger a save !!!

func init() -> void:
	_party = Main.active_party
	_garrison = Main.current_garrison
	
func _ready() -> void:
	Main.current_game_location = Main.GameLocation.CAMP
	Main.save.save_progress(Main.current_save_slot, Main.current_level_index)
	for grid: GridContainer in [party_grid, garrison_grid]:
		for slot: UnitPortraitSlot in grid.get_children():
			slot.unit_dropped.connect(_on_unit_dropped)
	_fill_grid(party_grid, Main.active_party)

func _on_next_level_button_pressed() -> void:
	queue_free()
	Main.next_level()

func _on_save_and_quit_button_pressed() -> void:
	queue_free()
	Main.save.save_progress(Main.current_save_slot, Main.current_level_index)
	get_tree().change_scene_to_file(
		"res://scenes/userinterface/Menus/main_menu.tscn");

func _fill_grid(grid: GridContainer, ids: Array[String]) -> void:
	var slots: Array[Node] = grid.get_children()
	for i in slots.size():
		var slot: Panel = slots[i] as Panel
		if i < ids.size():
			slot.set_unit_id(ids[i])
			#print("slot ", i, " char ", c)
		else:
			slot.clear()
		print("slot ", i, " char ", ids)
		
func _refresh_grids() -> void:
	_fill_grid(party_grid, Main.active_party)
	_fill_grid(garrison_grid, Main.current_garrison)

func _on_unit_dropped(data: Dictionary, target: UnitPortraitSlot) -> void:
	var source: UnitPortraitSlot = data["from"]
	var moving_id: String = data["unit_id"]
	var target_id: String = target.unit_id
	var party: Array[String] = Main.active_party
	var garrison: Array[String] = Main.current_garrison
	
	# Check for empty party - this should never happen
	if source.slot_kind == UnitPortraitSlot.SlotKind.PARTY and target.slot_kind == UnitPortraitSlot.SlotKind.GARRISON \
			and target_id == "" and party.size() <= 1:
		return

	source.set_unit_id(target_id) if target_id != "" else source.clear()
	target.set_unit_id(moving_id)
	_commit()

func _place(id: String, slot: UnitPortraitSlot, replaces: String) -> void:
	_remove_everywhere(id)
	var list: Array[String] = Main.active_party if slot.slot_kind == UnitPortraitSlot.SlotKind.PARTY else Main.current_garrison
	var idx: int = list.find(replaces)
	if idx >= 0:
		list.insert(idx, id)
	else:
		list.append(id)
	_remove_everywhere(replaces) if replaces != "" and replaces != id else null

func _remove_everywhere(id: String) -> void:
	Main.active_party.erase(id)
	Main.current_garrison.erase(id)

func _after_change() -> void:
	#Main.full_roster = 
	_refresh_grids()
	Main.save.save_progress(Main.current_save_slot, Main.current_level_index)

func _ids_in(grid: GridContainer) -> Array[String]:
	var out: Array[String] = []
	for slot: UnitPortraitSlot in grid.get_children():
		if slot.unit_id != "":
			out.append(slot.unit_id)
	return out

func _commit() -> void:
	Main.active_party = _ids_in(party_grid)
	Main.current_garrison = _ids_in(garrison_grid)
	print("commit party: ", _ids_in(party_grid), " garrison: ", _ids_in(garrison_grid))
	_refresh_grids()
	Main.save.save_progress(Main.current_save_slot, Main.current_level_index)
