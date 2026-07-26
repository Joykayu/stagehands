extends Control

## Small overlay shown during puzzles: the character portrait giving the
## puzzle plus a short line of instructions/hints. Press the skip/close
## button (top-right) to dismiss it and reveal the puzzle underneath.
##
## set_hint() can be called at any time (including while the puzzle is
## running) so a puzzle script can update the hint as the player progresses,
## e.g. get_parent().update_hint("Almost there!") from inside a puzzle scene.
## Calling set_hint() brings the box back if it was already dismissed.

var _dismissed := false

func _on_close_button_pressed() -> void:
	_dismissed = true
	hide()

func set_character(character: Character) -> void:
	if character == null:
		%CharaPortrait.texture = null
		%CharaNameLabel.text = ""
		return
	%CharaPortrait.texture = character.head
	%CharaNameLabel.text = character.chara_name
	%CharaNameLabel.add_theme_color_override("font_outline_color", character.main_color)
	%HintLabel.add_theme_color_override("font_outline_color", character.secondary_color)

func set_hint(text: String) -> void:
	%HintLabel.text = text
	_dismissed = false
	show()
