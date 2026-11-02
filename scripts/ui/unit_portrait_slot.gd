extends Panel

#signal unit_dropped(data: Dictionary, unit: UnitSlot)
#signal units_swapped(data: Dictionary, unit_a: UnitSlot, unit_b: UnitSlot)

@onready var unit_portrait: TextureRect = $UnitPortrait
var unit_id: String = ""

func _get_drag_data(_at_position: Vector2) -> Variant:
	if unit_portrait == null:
		return
	var preview: Panel = duplicate()
	var c: Control = Control.new()
	c.add_child(preview)
	preview.self_modulate = Color.TRANSPARENT
	c.modulate = Color(c.modulate, 0.8)
	preview.position -= Vector2(60,60)
	set_drag_preview(c)
	return unit_portrait#{ "unit_id": unit_id, "from": slot_kind } #unit_portrait

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var temp: Texture2D = unit_portrait.texture
	unit_portrait.texture = data.texture
	data.texture = temp

func set_unit_id(id: String) -> void:
	unit_id = id
	var def: CharacterDefinition = Main.save.registry.characters.get(id)
	print(id, " base_data: ", def.base_data, " script: ", def.base_data.get_script().resource_path if def.base_data else "none")
	if def != null and def.base_data != null:
		unit_portrait.texture = def.base_data.portrait
	else:
		unit_portrait.texture = null

func clear() -> void:
	unit_id = ""
	unit_portrait = null
