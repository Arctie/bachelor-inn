extends Panel

@onready var unit_portrait: TextureRect = $UnitPortrait

func _get_drag_data(_at_position: Vector2) -> Variant:
	if unit_portrait == null:
		return
	var preview: Panel = duplicate()
	var c: Control = Control.new()
	c.add_child(preview)
	preview.position -= Vector2(60,60)
	set_drag_preview(c)
	return unit_portrait
