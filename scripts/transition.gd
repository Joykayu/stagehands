extends Control

var moving := true
var speed := 1000


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
			%Title.text = "Outro"
			%Title.show()
			%Image.texture=load("res://assets/graphics/clocks/clock_16.png")
			%Image.show()
			$AnimationPlayer.play("slide")

		"epilogue":
			%Title.text = "Epilogue"
			%Title.show()
			$AnimationPlayer.play("slide")

		"credits":
			%CreditsText.text = "[center][b]Stagehands[/b]\nA GMTK Game Jam 2026 Entry\n\n[color=#cccccc]Game Design & Programming[/color]\nÉmile Gervais-Lalonde\n\n[color=#cccccc]Additional Programming[/color]\nAlexandre Paquette-Lessard\n\n[color=#cccccc]Art & UI Design[/color]\nÉmile Gervais-Lalonde\n\n[color=#cccccc]Character Design[/color]\nMyriam De Grandmont-Sauvé\n\n[color=#cccccc]Music[/color]\nKarl-Étienne Doré\n\n[color=#cccccc]Sound Design[/color]\nAlexandre Paquette-Lessard\n\n[color=#cccccc]Writing[/color]\nÉmile Gervais-Lalonde\n\n[color=#cccccc]Voice Acting[/color]\nMyriam De Grandmont-Sauvé\nGabriel St-Amant\nAlexandre Paquette-Lessard\nNicolas Renaud\n\n[color=#888888]Made with Godot Engine 4\nThank you for playing![/color][/center]"
			%CreditsText.show()
			$AnimationPlayer.play("slide_credits")
			

func _on_animation_player_animation_finished(_anim_name):
	transition_finished.emit()
	self.queue_free()
	
