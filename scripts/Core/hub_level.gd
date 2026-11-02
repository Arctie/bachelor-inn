extends Control

#signal connect(selected_unit_in_grid)

@onready var next_level_button: Button = $ButtonContainer/VBoxContainer/NextLevelButton
@onready var save_and_quit_button: Button = $ButtonContainer/VBoxContainer/SaveAndQuitButton
@onready var party_grid: GridContainer = $UnitsPanel/VBoxContainer/PartyMarginContainer/PartyGridContainer
#@onready var garrison_grid: GridContainer = $UnitsPanel/VBoxContainer/PartyMarginContainer/GarrisonGridContainer

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
	_fill_grid(party_grid, Main.active_party)

func _on_next_level_button_pressed() -> void:
	queue_free()
	Main.next_level()
	#pass # Replace with function body.

func _on_save_and_quit_button_pressed() -> void:
	queue_free()
	Main.save.save_progress(Main.current_save_slot, Main.current_level_index)
	get_tree().change_scene_to_file(
		"res://scenes/userinterface/Menus/main_menu.tscn");

func _fill_grid(grid: GridContainer, ids: Array[String]) -> void:
	var slots: Array[Node] = party_grid.get_children()
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
	#_fill_grid(garrison_grid, Main.current_garrison)
