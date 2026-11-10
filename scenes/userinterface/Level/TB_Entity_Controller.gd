extends Control
class_name TB_Entity_Controller

signal preview_selected(character: Character)

@onready var Portrait:= %Portrait
@onready var EvilBG:= %EvilBG
@onready var GoodBG:= %GoodBG
@onready var Selected_Indicator:= %Selected

var character: Character
var is_selected: bool = false : set =_set_is_selected;

func _set_is_selected(in_is_selected: bool) -> void:
	Selected_Indicator.visible = in_is_selected

func _on_button_pressed() -> void:
	emit_signal("preview_selected", character)

func apply_stats(stats: Dictionary, in_character: Character) -> void:
	character = in_character
	Portrait.texture = stats.portrait
	
	var is_enemy := character.state.faction == CharacterState.Faction.ENEMY
	EvilBG.visible = is_enemy
	GoodBG.visible = not is_enemy
