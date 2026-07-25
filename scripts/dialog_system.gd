extends Node

@export_file("*.json") var source : String

var is_active := false
var end_dialogue := false

var scene_script : Dictionary
var current_line : Dictionary

var chara_list : Dictionary[String,Character]

var current_speaking

var time_count := 0.0
var rotation_sign = +1

func _process(delta):
	var theta = 5 #degrees
	var freq = 1.5 #hertz
	
	if current_speaking != null:
		time_count += delta
		if time_count > 1/freq:
			time_count = 0
			current_speaking.rotation = rotation_sign * deg_to_rad(RandomNumberGenerator.new().randf_range(0,+theta))
			rotation_sign *= -1


func _input(event):
	if !is_active:
		return
	#if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
	if event is InputEventMouseButton  and event.is_pressed():
		if end_dialogue :
			get_parent().next_transition("dialogue")
			end_dialogue = false
			return
		load_next_line()
		if current_line["type"] == "line" :
			load_block_to_ui(current_line)
		elif current_line["type"] == "puzzle":
			get_parent().next_transition("puzzle_in")
			await get_tree().create_timer(1.0).timeout
			load_next_line()
			load_block_to_ui(current_line)

func get_dialogue(src:String) -> void:
	scene_script = JSON.parse_string( FileAccess.get_file_as_string(src) )
	current_line = scene_script["start"]
	for c in scene_script["metadata"]["chara_list"]:
		chara_list.set(c,get_parent().chara_res_dict[c])
	load_block_to_ui(current_line)



func load_next_line():
	if current_line["next"] != "end" :
		current_line = scene_script[current_line["next"]]
	else :
		end_dialogue = true

func load_block_to_ui(block : Dictionary):
	var left = block["left"]
	var right = block["right"]
	var line = block["line"]
	# set left character
	set_chara("left",left["chara"],left["mood"],left["focus"])
	
	#set right character
	set_chara("right",right["chara"],right["mood"],right["focus"])
	
	match line["speaker"]:
		"left":
			current_speaking = %DialogControl/CharaLeftSprite
		"right":
			current_speaking = %DialogControl/CharaRightSprite
	
	#set text
	%CharaNameLabel.text = block[line["speaker"]]["chara"]
	%CharaNameLabel.add_theme_color_override(
		"font_outline_color",
		chara_list[block[line["speaker"]]["chara"]].main_color
		)
	
	
	%DialogLineLabel.text = line["text"]
	%DialogLineLabel.add_theme_color_override(
		"font_outline_color",
		chara_list[block[line["speaker"]]["chara"]].secondary_color
		)



func set_chara(loc, chara = null, pose = null, focus := false):
	var current_sprite
	match loc:
		"left":
			current_sprite = %DialogControl/CharaLeftSprite
		"right":
			current_sprite = %DialogControl/CharaRightSprite
	if chara != null :
		if pose!= null :
			current_sprite.texture = chara_list[chara].chara_poses[pose]
		else:
			current_sprite.texture = chara_list[chara].chara_poses["idle"]

	else:
		current_sprite.texture = null
	if !focus:
		current_sprite.self_modulate.a = 0.5
	else:
		current_sprite.self_modulate.a = 1
