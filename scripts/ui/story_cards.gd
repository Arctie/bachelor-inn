extends CanvasLayer
class_name StoryCards

@export var card_1 : ImageTexture
@export var card_2 : ImageTexture
@export var card_3 : ImageTexture
@export var card_4 : ImageTexture

@onready var continue_button: Button = $Control/Button

var story_card_array : Array = []

func _ready() -> void:
	## Fill array with non-empty card slots.
	pass

func _update() -> void:
	pass

func _on_continue_button_pressed() -> void:
	#Hide Story Cards
	#Trigger turntransition	Statemachine.transition(State.TurnTransition.new())
	pass # Replace with function body.
