extends HBoxContainer

signal retry_pressed
signal skip_pressed

func _on_retry_button_pressed():
	retry_pressed.emit()

func _on_skip_button_pressed():
	skip_pressed.emit()
