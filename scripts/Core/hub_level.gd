extends Control

@onready var next_level_button: Button = $ButtonContainer/VBoxContainer/NextLevelButton
@onready var save_and_quit_button: Button = $ButtonContainer/VBoxContainer/SaveAndQuitButton

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
