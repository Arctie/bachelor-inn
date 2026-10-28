extends CanvasLayer
class_name StoryCards

## Change ImageTexture to CompressedTexture2D?
@export var card_1: ImageTexture
@export var card_2: ImageTexture
@export var card_3: ImageTexture
@export var card_4: ImageTexture
@export var intro_card_array: Array[ImageTexture] = []
@export var outro_card_array: Array[ImageTexture] = []

@onready var continue_button: Button = $Control/Button
@onready var story_cards_player: AnimationPlayer = $Control/AnimationPlayer

func _ready() -> void:
	## Fill array with non-empty card slots.
	card_2.hide()
	card_3.hide()
	card_4.hide()
	pass

func _update() -> void:
	pass

func _on_continue_button_pressed() -> void:
	#Hide Story Cards
	# if not level.is_complete:
	#Trigger turntransition	Statemachine.transition(State.TurnTransition.new())
	# else: trigger level up screen. 
	pass # Replace with function body.
