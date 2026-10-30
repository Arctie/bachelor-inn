extends Control
class_name PopupBase

signal closed(result: String)

func open() -> void:
	show()

func close() -> void:
	hide()
