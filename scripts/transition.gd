extends Control

var moving := true
var speed := 1000


signal transition_finished

func begin_transition(type = "default"):
	match type:
		"default":
			$AnimationPlayer.play("slide")

		"intro":
			%Title.text = "Prologue"
			%Title.show()
			$AnimationPlayer.play("slide")

		"chapter1":
			%Title.text = "Chapter 1  -  Annabelle"
			%Title.add_theme_color_override(
				"font_outline_color",
				get_node("/root/Main").chara_res_dict["Annabelle"].main_color
				)
			%Title.show()
			%Image.texture=load("res://assets/graphics/clocks/clock_10.png")
			%Image.show()
			%Subtitle.text = " H - 6 "
			%Subtitle.show()
			$AnimationPlayer.play("slide")

		"puzzle1":
			%Stripes.modulate = get_node("/root/Main").chara_res_dict["Annabelle"].main_color
			%Stripes.show()
			%Image.texture = get_node("/root/Main").chara_res_dict["Annabelle"].head
			%Image.show()
			$AnimationPlayer.play("slide")

		"chapter2":
			%Title.text = "Chapter 2  -  Fred"
			%Title.add_theme_color_override(
				"font_outline_color",
				get_node("/root/Main").chara_res_dict["Fred"].main_color
				)
			%Title.show()
			%Image.texture=load("res://assets/graphics/clocks/clock_12.png")
			%Image.show()
			%Subtitle.text = " H - 4 "
			%Subtitle.show()
			$AnimationPlayer.play("slide")

		"puzzle2":
			%Stripes.modulate = get_node("/root/Main").chara_res_dict["Fred"].main_color
			%Stripes.show()
			%Image.texture = get_node("/root/Main").chara_res_dict["Fred"].head
			%Image.show()
			$AnimationPlayer.play("slide")

		"chapter3":
			%Title.text = "Chapter 3  -  Sarah"
			%Title.add_theme_color_override(
				"font_outline_color",
				get_node("/root/Main").chara_res_dict["Sarah"].main_color
				)
			%Title.show()
			%Image.texture=load("res://assets/graphics/clocks/clock_14.png")
			%Image.show()
			%Subtitle.text = " H - 2 "
			%Subtitle.show()
			$AnimationPlayer.play("slide")

		"puzzle3":
			%Stripes.modulate = get_node("/root/Main").chara_res_dict["Sarah"].main_color
			%Stripes.show()
			%Image.texture = get_node("/root/Main").chara_res_dict["Sarah"].head
			%Image.show()
			$AnimationPlayer.play("slide")

		"outro":
			%Title.text = "Time's up !!!"
			%Title.show()
			%Image.texture=load("res://assets/graphics/clocks/clock_16.png")
			%Image.show()
			%Subtitle.text = " H - 0 "
			%Subtitle.show()
			$AnimationPlayer.play("slide")

		"epilogue":
			%Title.text = "Epilogue"
			%Title.show()
			$AnimationPlayer.play("slide")

		"end":
			%Title.text = "The End"
			%Title.show()
			$AnimationPlayer.play("slide")

		"credits":
			%Title.text = "[font_size=40]All assets, art, music, scenario and voices made by:[/font_size]"
			%Title.show()
			%Subtitle.text = "[font_size=56]Joykayu, Biboteur and ClemziClemz[/font_size]"
			%Subtitle.show()
			_show_credits_portraits()
			_show_fixed_screen()


# Adds the main characters' head portraits flanking the credits text so the
# screen doesn't look like bare text on a black background.
func _show_credits_portraits():
	var main = get_node("/root/Main")
	var portraits := [
		{"character": "Annabelle", "anchor_x": 0.08, "anchor_y": 0.3},
		{"character": "Fred", "anchor_x": 0.08, "anchor_y": 0.68},
		{"character": "Sarah", "anchor_x": 0.92, "anchor_y": 0.5},
	]
	for p in portraits:
		var rect := TextureRect.new()
		rect.texture = main.chara_res_dict[p["character"]].head
		rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		rect.custom_minimum_size = Vector2(220, 220)
		rect.anchor_left = p["anchor_x"]
		rect.anchor_right = p["anchor_x"]
		rect.anchor_top = p["anchor_y"]
		rect.anchor_bottom = p["anchor_y"]
		rect.grow_horizontal = Control.GROW_DIRECTION_BOTH
		rect.grow_vertical = Control.GROW_DIRECTION_BOTH
		$BlackScreen.add_child(rect)


# Slides the screen in and leaves it there for good: no auto slide-out, no
# self-destruction, no transition_finished signal. Used for a final screen
# (like the credits) that should stay up as a permanent, non-interactive scene
# instead of a normal transition that plays through and disappears.
func _show_fixed_screen():
	moving = false
	var tween = create_tween()
	tween.tween_property($BlackScreen, "position:x", -480.0, 1.0)


func _on_animation_player_animation_finished(_anim_name):
	transition_finished.emit()
	self.queue_free()
