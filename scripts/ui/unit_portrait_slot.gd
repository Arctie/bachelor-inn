extends Panel
class_name UnitPortraitSlot

signal unit_dropped(data: Dictionary, target: UnitPortraitSlot)

enum SlotKind { PARTY, GARRISON }
@export var slot_kind: SlotKind = SlotKind.PARTY
@onready var unit_portrait: TextureRect = $UnitPortrait

var unit_id: String = ""

func _get_drag_data(_at_position: Vector2) -> Variant:
	if unit_id == "":
		return
	var preview: Panel = duplicate()
	var c: Control = Control.new()
	c.add_child(preview)
	preview.self_modulate = Color.TRANSPARENT
	c.modulate = Color(c.modulate, 0.8)
	preview.position -= Vector2(60,60)
	set_drag_preview(c)
	return { "unit_id": unit_id, "from": self } #unit_portrait

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return _data is Dictionary and _data.has("unit_id")

func _drop_data(_at_position: Vector2, _data: Variant) -> void:
	if _data is Dictionary and _data.has("unit_id"):
		unit_dropped.emit(_data, self)

func set_unit_id(id: String) -> void:
	unit_id = id
	var def: CharacterDefinition = Main.save.registry.characters.get(id)
	var texture: Texture2D = null
	if def != null and def.base_data != null:
		texture = def.base_data.portrait
	unit_portrait.texture = texture

func clear() -> void:
	unit_id = ""
	unit_portrait.texture = null
