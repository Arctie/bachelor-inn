extends CanvasLayer
class_name StoryCards

signal finished
## Change ImageTexture to CompressedTexture2D?

@export var intro: Array[Texture2D] = []
@export var outro: Array[Texture2D] = []
@export var fade_time: float = 0.5
@export var hold_time: float = 3.0

@onready var root: Control = $Control
@onready var card_image: TextureRect = %CardImage
@onready var continue_button: Button = %ContinueButton
#@onready var story_cards_player: AnimationPlayer = $Control/AnimationPlayer

var _playing: bool = false

func _ready() -> void:
	hide()
	continue_button.hide()

func play_intro() -> void:
	if _playing:
		return
	var is_valid: Array[Texture2D] = []
	for t: Texture2D in intro:
		if t != null:
			is_valid.append(t)
	if is_valid.is_empty():
		finished.emit() #
		return
	
	_playing = true
	continue_button.hide()
	continue_button.disabled = false
	root.modulate.a = 0.0
	card_image.modulate.a = 0.0
	show()
	await _fade(root, 1.0, 0.5)

	for i in is_valid.size():
		card_image.texture = is_valid[i]
		await FadeToBlack._fade(card_image, 1.0)
		if i < is_valid.size() - 1:
			await get_tree().create_timer(hold_time).timeout
			await FadeToBlack._fade(card_image, 0.0, 0.5)
	continue_button.show()  # last card stays up until the player continues
	

func _on_continue_button_pressed() -> void:
	continue_button.disabled = true   # blocks double presses
	await _fade(root, 0.0, 0.5)
	hide()
	_playing = false
	finished.emit()

func _fade(node: CanvasItem, target_alpha: float, fade_time: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(node, "modulate:a", target_alpha, fade_time)
	await tween.finished
