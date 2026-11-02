extends Control

@onready var next_level_button: Button = $ButtonContainer/VBoxContainer/NextLevelButton
@onready var save_and_quit_button: Button = $ButtonContainer/VBoxContainer/SaveAndQuitButton
@onready var party_unit_panel: Panel = $PlayerUnitContainer/UnitRows/PartyMarginContainer/PartyGridContainer/PartyUnitPanel
@onready var party_unit_portrait: TextureRect = $PlayerUnitContainer/UnitRows/PartyMarginContainer/PartyGridContainer/PartyUnitPanel/UnitPortrait
@onready var party_grid: GridContainer = %PartyGridContainer
@onready var garrison_unit_panel: Panel = $PlayerUnitsContainer/UnitRows/GarrisonGridContainer/GarrisonUnitPanel
@onready var garrison_unit_portrait: TextureRect = $PlayerUnitsContainer/UnitRows/GarrisonGridContainer/GarrisonUnitPanel/GarrisonUnitPortrait
@onready var garrison_grid: GridContainer = %GarrisonGridContainer

## Any action or change done in here should trigger a save

func _ready() -> void:
	Main.current_game_location = Main.GameLocation.CAMP
	Main.save.save_progress(Main.current_save_slot, Main.current_level_index)

func _on_next_level_button_pressed() -> void:
	queue_free()
	Main.next_level()
	#pass # Replace with function body.

func _on_save_and_quit_button_pressed() -> void:
	queue_free()
	Main.save.save_progress(Main.current_save_slot, Main.current_level_index)
	get_tree().change_scene_to_file(
		"res://scenes/userinterface/Menus/main_menu.tscn");

func _get_drag_data(at_position: Vector2) -> Variant:
	if party_unit_portrait.texture == null:
		print("PartyUnitPortrait is null.")
		return
	var preview: TextureRect = duplicate()
	var c: Node = Control.new()
	c.add_child(preview)
	preview.position -= Vector2(45,45)
	preview.self_modulate = Color.TRANSPARENT
	c.modulate = Color(c.modulate, 0.5)
	print("Initiated drag with texture ", party_unit_portrait)
	set_drag_preview(c)
	return party_unit_portrait

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	party_unit_portrait.texture = data.texture

func _fill_party_grid_container() -> void:
	# for c: Character in Main.active_party
	#	if c != null and is_instance_valid(c):
	#		
	pass

func _fill_garrison_grid_container() -> void:
	pass
