extends Control
class_name ObectiveCompletePopup

@onready var finish_button: Button = $DimBackground/BoxBackground/VBoxContainer/FinishButton
@onready var roam_button: Button = $DimBackground/BoxBackground/VBoxContainer/RoamButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	# TODO: Add dim effect via ColorRect etc.

func _on_finish_button_pressed() -> void:
	pass # Replace with function body.


func _on_roam_button_pressed() -> void:
	pass # Replace with function body.
