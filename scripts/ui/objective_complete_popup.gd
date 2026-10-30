extends PopupBase
class_name ObjectiveCompletePopup

@onready var dim_background: ColorRect = %DimBackground
@onready var finish_button: Button = %FinishButton
@onready var roam_button: Button = %RoamButton

func _ready() -> void:
	hide()
	# TODO: Add dim effect via ColorRect etc.

func _choose(result: String) -> void:
	finish_button.disabled = true
	roam_button.disabled = true
	closed.emit(result)

func open() -> void:
	finish_button.disabled = false
	roam_button.disabled = false
	show()
	print("popup open, size: ", size, " visible: ", visible)

func close() -> void:
	hide()

func _on_finish_button_pressed() -> void:
	_choose("finish")

func _on_roam_button_pressed() -> void:
	_choose("roam")
