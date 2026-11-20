extends PopupBase
class_name ItemLootPopup

@onready var item_name: Label = %NameLabel
@onready var icon_texture: TextureRect = %IconTexture
@onready var quantity_label: Label = %QuantityLabel
@onready var description_label: Label = %DescriptionLabel
@onready var take_button: Button = %TakeButton
@onready var leave_button: Button = %LeaveButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not visible:
		hide()

func show_item(item: Skill, amount: int, unit: Character) -> void:
	show()
	item_name.text = item.skill_name
	icon_texture.texture = item.icon
	description_label.text = item.tooltip
	var owned: int = 0
	if is_instance_valid(unit):
		owned = int(unit.state.item_quantities.get(item.skill_id, 0))
	quantity_label.text = "Found: x%d   (In stock: %d)" % [amount, owned]

func open() -> void:
	take_button.disabled = false
	leave_button.disabled = false
	show()

func close() -> void:
	hide()
	
func _on_take_button_pressed() -> void:
	_choose("take")


func _on_leave_button_pressed() -> void:
	_choose("leave")

func _choose(result: String) -> void:
	take_button.disabled = true
	leave_button.disabled = true
	closed.emit(result)
