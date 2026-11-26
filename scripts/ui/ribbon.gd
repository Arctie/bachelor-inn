extends Control
class_name Ribbon

signal skill_pressed(skill: Skill)
signal roam_attack_pressed


@onready var skills: HBoxContainer = %Skills
@onready var roaming_attack_button: TextureButton = $NinePatchRect/Skills/RoamingAttackButton

var show_button_six: bool = false
var _skill_buttons: Array[TextureButton] = []
var _skill_buttons_dict: Array[Dictionary] = []

func _make_empty_dict() ->Dictionary:
	return {
		"selection_indicator": null,
		"button":null,
		"icon_holder":null,
		"is-selected": false
	}
#^^Make
#get the names of each item and put them into the dictionary :3
func _build_button_dict() -> void:
	_skill_buttons_dict.clear()
	for i in range(5):
		var num := i + 1
		var slot := _make_empty_dict()

		var control_name := "Control" if num == 1 else "Control%d" % num
		var sel_path := "Button_Container/%s/Button_%d_Selected" % [control_name, num]
		var icon_path := "Button_Container/%s/Button%d-BG/Button%d-Icon" % [control_name, num, num]

		slot["button"] = get_node_or_null("%%Button%d_button" % num) as Button
		slot["Selection_indicator"] = get_node_or_null(sel_path) as NinePatchRect
		slot["icon_holder"] = get_node_or_null(icon_path) as TextureRect
		slot["is-selected"] = false
		_skill_buttons_dict.append(slot)

func _ready() -> void:
	Main.level.ability_used.connect(_on_ability_used)
	_build_button_dict()
	_connect_slot_buttons()

	var attack: Skill = SkillRegistry.get_skill("basic_attack")
	roaming_attack_button.set_meta("skill", attack)
	roaming_attack_button.texture_normal = attack.icon
	roaming_attack_button.tooltip_text = "%s\n%s" % [attack.skill_name, attack.tooltip]
	roaming_attack_button.pressed.connect(trigger_roaming_attack)
	set_skills([])
	

func _connect_slot_buttons() -> void:
	for i in range(_skill_buttons_dict.size()):
		var b: Button = _skill_buttons_dict[i]["button"]
		if b == null:
			push_warning("Ribbon: Missing button for slot %d" % (i + 1))
			continue
		var cb := _on_skill_button_pressed.bind(i)
		if not b.pressed.is_connected(cb):
			b.pressed.connect(cb)


func set_skills(in_skills: Array[Skill]) -> void:
	for i in range(_skill_buttons_dict.size()):
		var slot: Dictionary = _skill_buttons_dict[i]
		var b: Button = slot["button"]
		var icon: TextureRect = slot["icon_holder"]
		if b == null:
			continue

		if i < in_skills.size() and in_skills[i] != null:
			var s: Skill = in_skills[i]
			b.show()
			b.disabled = false
			b.tooltip_text = "%s\n%s" % [s.skill_name, s.tooltip]
			b.set_meta("skill", s)
			if icon != null:
				icon.texture = s.icon
				icon.show()

			var unit: Character = Main.level.selected_unit
			if unit != null:
				var cur: LevelState = Main.level.state_machine.current
				var in_roam: bool = cur is StateFreeRoaming or cur is StateFreeRoamAnimating
				var no_qty: bool = s.has_quantity and unit.state.item_quantities.get(s.skill_id, 0) <= 0
				var no_ap: bool = s.uses_action and not in_roam and unit.state.action_points_remaining <= 0
				var on_cooldown: bool = unit.state.skill_cooldowns.get(s.skill_id, 0) > 0
				var should_gray: bool = no_qty or no_ap or on_cooldown
				b.disabled = should_gray
				var tint := Color(0.4, 0.4, 0.4, 1.0) if should_gray else Color(1, 1, 1, 1)
				b.modulate = tint
				if icon != null:
					icon.modulate = tint
			else:
				b.disabled = false
				b.modulate = Color(1, 1, 1, 1)
				if icon != null:
					icon.modulate = Color(1, 1, 1, 1)
		else:
			b.hide()
			b.disabled = true
			b.tooltip_text = ""
			b.set_meta("skill", null)
			if icon != null:
				icon.texture = null
				icon.hide()

func _on_skill_button_pressed(slot_index: int) -> void:
	if Main.level.is_choosing_skill_attack_origin:
		return
	if Main.level.is_choosing_skill_target:
		return
	var b: Button = _skill_buttons_dict[slot_index]["button"]
	if b == null:
		return
	var s: Skill = b.get_meta("skill") as Skill
	if s != null:
		skill_pressed.emit(s)

func _on_ability_used() -> void:
	print("_on_ability_used() called, but it does nothing.")
	pass

### TODO: Fix? Faied attempt to gray out ability buttons after use (Commented for now)
#func gray_out_abilities_used(used: bool) -> void:
	#for b in _skill_buttons:
		#b.disabled = used
		#b.modulate = Color(0.4, 0.4, 0.4, 1.0) if used else Color(1, 1, 1, 1)

func trigger_skill_by_index(index: int) -> void:
	if index < 0 or index >= _skill_buttons_dict.size():
		return
	var button: Button = _skill_buttons_dict[index]["button"]
	if button == null or button.disabled or not button.visible:
		return
	var s: Skill = button.get_meta("skill") as Skill
	if s != null:
		skill_pressed.emit(s)

func set_roaming_attack_visible(on: bool) -> void:
	if on:
		roaming_attack_button.show()
	else:
		roaming_attack_button.hide()

func trigger_roaming_attack() -> void:
	if not roaming_attack_button.visible or roaming_attack_button.disabled:
		return
	roam_attack_pressed.emit()
