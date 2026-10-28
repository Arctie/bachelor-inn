extends LevelState
class_name StateStoryCards

var _cards: StoryCards
var _is_outro: bool

func _init(cards: StoryCards, is_outro: bool = false) -> void:
	_cards = cards
	_is_outro = is_outro

func enter(level: Node) -> void:
	print("ENTER STATE: StateStoryCards.")
	_cards.finished.connect(_on_cards_finished.bind(level), CONNECT_ONE_SHOT)
	if _is_outro:
		_cards.play_outro()
	else:
		_cards.play_intro()

func exit(level: Node) -> void:
	print("EXIT STATE: StateStoryCards.")

func handle_input(level: Node, event: InputEvent) -> void:
	## Block all input during animation (helps for Tutorial :D)
	pass 

func _on_cards_finished(level: Node) -> void:
	if _is_outro:
		Main.go_to_transition_screen() ## Go to level up screen if outro
	else:
		level.state_machine.transition_to(StateTurnTransition.new(true)) ## Start playing if intro
