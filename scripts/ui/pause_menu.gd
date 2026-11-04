extends CanvasLayer
class_name PauseMenu

@onready var options: Button = %Options
@onready var resume_button: Button = %ResumeButton
@onready var back_to_main_menu: Button = %BackToMainMenu
@onready var finish_level_button: Button = %FinishLevelButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_resume_button_pressed() -> void:
	print("Resume Button pressed.")
	Main.level.state_machine.pop()

func _on_back_to_main_menu_pressed() -> void:
	if is_instance_valid(Main.level):
		Main.level.is_in_menu = false
		Main.level.cleanup_level()
		Main.level.queue_free()
		Main.level = null
	Main.unload_units()
	get_tree().paused = false
	get_tree().change_scene_to_file(
		"res://scenes/userinterface/Menus/main_menu.tscn");

func _on_options_pressed() -> void:
	print("Options Menu Button pressed from in game.")

func show_finish_level_button() -> void:
	finish_level_button.show()

func _on_finish_level_button_pressed() -> void:
	Main.level.state_machine.pop()
	finish_level_button.show()
	Main.level.next_level()
