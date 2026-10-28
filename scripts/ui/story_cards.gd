extends CanvasLayer
class_name StoryCards

## TODO: Consider having a label with level name or something similar displayed. 

signal finished

@export var intro: Array[Texture2D] = []
@export var outro: Array[Texture2D] = []
@export var fade_time: float = 0.5
@export var hold_time: float = 3.0

@onready var root: Control = $Control
@onready var card_image: TextureRect = %CardImage
@onready var continue_button: Button = %ContinueButton
@onready var level_title: Label = $Control/LevelTitleLabel

var _playing: bool = false

func _ready() -> void:
	hide()
	continue_button.disabled = false

func play_intro() -> void:
	var title: String = Main.level.level_name if is_instance_valid(Main.level) else ""
	await _play(intro)
	
func play_outro() -> void:
	await _play(outro, "The journey continues..")

func _play(cards: Array[Texture2D], title: String = "") -> void:
	if _playing:
		return
	var valid: Array[Texture2D] = []
	for t: Texture2D in cards:
		if t != null:
			valid.append(t)
	if valid.is_empty():
		finished.emit() #
		return
	
	_playing = true
	continue_button.hide()
	continue_button.disabled = false
	root.modulate.a = 0.0
	card_image.modulate.a = 0.0
	show()
	await _fade(root, 1.0)

	for i in valid.size():
		card_image.texture = valid[i]
		await _fade(card_image, 1.0)
		if i < valid.size() - 1:
			await get_tree().create_timer(hold_time).timeout
			await _fade(card_image, 0.0)
	continue_button.show()  # last card stays up until the player continues
	

func _on_continue_button_pressed() -> void:
	continue_button.disabled = true   # blocks double presses
	await _fade(root, 0.0)
	hide()
	_playing = false
	finished.emit()

func _fade(node: CanvasItem, target_alpha: float, duration: float = -1.0) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(node, "modulate:a", target_alpha, fade_time)
	await tween.finished
