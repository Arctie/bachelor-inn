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
var _skip_pressed: bool = false
var valid: Array[Texture2D] = []

func _ready() -> void:
	hide()

func play_intro() -> void:
	var title: String = Main.level.level_name if is_instance_valid(Main.level) else ""
	await _play(intro)
	
func play_outro() -> void:
	await _play(outro, "The journey continues..")

func _play(cards: Array[Texture2D], title: String = "") -> void:
	if _playing:
		return
	valid.clear()
	for t: Texture2D in cards:
		if t != null:
			valid.append(t)
	if valid.is_empty():
		finished.emit() #
		return
	
	_playing = true
	level_title.text = title
	level_title.visible = not title.is_empty()
	continue_button.text = "Skip Cards"
	continue_button.disabled = false
	root.modulate.a = 1.0
	card_image.modulate.a = 0.0
	show()

	for i in valid.size():
		if _skip_pressed:
			break
		card_image.texture = valid[i]
		await _fade(card_image, 1.0)
		if _skip_pressed:
			break
		await _hold(hold_time)      # the last card also holds, then closes on its own
		if _skip_pressed:
			break
		if i < valid.size() - 1:
			await _fade(card_image, 0.0)
	await _close()

func _close() -> void:
	continue_button.disabled = true
	await _fade(root, 0.0)
	hide()
	_playing = false
	finished.emit()

func _hold(t: float) -> void:
	var elapsed: float = 0.0
	while elapsed < t and not _skip_pressed:
		await get_tree().process_frame
		elapsed += get_process_delta_time()

func _on_button_pressed() -> void:
	_skip_pressed = true

func _fade(node: CanvasItem, target_alpha: float, duration: float = -1.0) -> void:
	var d: float = fade_time if duration < 0.0 else duration
	var tween: Tween = create_tween()
	tween.tween_property(node, "modulate:a", target_alpha, d)
	await tween.finished
