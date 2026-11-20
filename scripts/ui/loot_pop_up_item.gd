extends Control
class_name ItemLootPopup

@onready var item_name: Label = $Background/PanelContainer/VBoxContainer/VBoxContainer/NameLabel
@onready var quantity: Label = $Background/PanelContainer/VBoxContainer/VBoxContainer/QuantityLabel
@onready var description: Label = $Background/PanelContainer/VBoxContainer/VBoxContainer/DescriptionLabel
@onready var take_button: Button = $Background/PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/TakeButton
@onready var leave_button: Button = $Background/PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/LeaveButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_take_button_pressed() -> void:
	pass # Replace with function body.


func _on_leave_button_pressed() -> void:
	pass # Replace with function body.
