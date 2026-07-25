extends Control

var moving := true
var speed := 1000

var clock_texture = preload("res://assets/graphics/clock_v1.png")

signal transition_finished

func begin_transition(type = "default"):
	match type:
		"default":
			$AnimationPlayer.play("slide")
			
		"intro":
			%Title.text = "Intro"
			%Title.show()
			$AnimationPlayer.play("slide")
			
		"chapter1":
			%Title.text = "Chapter 1  -  Annabelle"
			%Title.add_theme_color_override(
				"font_outline_color",
				get_node("/root/Main").chara_res_dict["Annabelle"].main_color
				)
			%Title.show()
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
			pass
			

func _on_animation_player_animation_finished(_anim_name):
	transition_finished.emit()
	#reset title
	%Title.remove_theme_color_override("font_outline_color")
	%Title.hide()
	
	#reset subtitle
	%Subtitle.hide()
	
	#reset image
	%Image.hide()
	
	#reset stripes
	%Stripes.modulate = Color.WHITE
	%Stripes.hide()
	
