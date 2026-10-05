extends Control

@onready var next_level_button: Button = $ButtonContainer/VBoxContainer/NextLevelButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Main.current_game_location = Main.GameLocation.CAMP
	Main.save.save_progress(Main.current_save_slot, Main.current_level_index)

func _on_next_level_button_pressed() -> void:
	Main.next_level()
	#pass # Replace with function body.
