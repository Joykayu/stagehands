extends Control

signal puzzle_completed

func _on_button_pressed():
	puzzle_completed.emit()
