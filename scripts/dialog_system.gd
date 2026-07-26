extends Node

@export_file("*.json") var source : String

const AUDIO_ROOT := "res://assets/audio/"

var is_active := false
var end_dialogue := false

var scene_script : Dictionary
var current_line : Dictionary

var dialogue_audio_cache : Dictionary = {}
var audio_playback_enabled := false
var pending_audio_name := ""
var waiting_for_puzzle_resume := false

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
		stop_voice()
		if end_dialogue :
			get_parent().next_transition("dialogue")
			end_dialogue = false
			return
		load_next_line()
		if current_line["type"] == "line" :
			load_block_to_ui(current_line)
		elif current_line["type"] == "puzzle":
			waiting_for_puzzle_resume = true
			get_parent().next_transition("puzzle_in")

func get_dialogue(src:String) -> void:
	stop_voice()
	audio_playback_enabled = false
	pending_audio_name = ""
	scene_script = JSON.parse_string( FileAccess.get_file_as_string(src) )
	if typeof(scene_script) != TYPE_DICTIONARY:
		push_error("Invalid dialogue JSON: %s" % src)
		return
	preload_dialogue_audio()
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
	var speaker_key = line.get("speaker", "")
	if speaker_key == "" or not block.has(speaker_key):
		push_warning("Dialogue line is missing a valid speaker key")
		return
	# set left character
	set_chara("left",left["chara"],left["mood"],left["focus"])
	
	#set right character
	set_chara("right",right["chara"],right["mood"],right["focus"])
	
	match speaker_key:
		"left":
			current_speaking = %DialogControl/CharaLeftSprite
		"right":
			current_speaking = %DialogControl/CharaRightSprite
	
	#set text
	%CharaNameLabel.text = block[speaker_key]["chara"]
	%CharaNameLabel.add_theme_color_override(
		"font_outline_color",
		chara_list[block[speaker_key]["chara"]].main_color
		)
	
	
	%DialogLineLabel.text = line["text"]
	%DialogLineLabel.add_theme_color_override(
		"font_outline_color",
		chara_list[block[speaker_key]["chara"]].secondary_color
		)

	play_voice(line.get("audio"))

func set_chara(loc, chara = null, pose = null, focus := false):
	var current_sprite
	match loc:
		"left":
			current_sprite = %DialogControl/CharaLeftSprite
		"right":
			current_sprite = %DialogControl/CharaRightSprite
	if chara != null :
		if pose!= null :
			if !focus:
				current_sprite.texture = chara_list[chara].chara_poses[pose+"_inactive"]
			else:
				current_sprite.texture = chara_list[chara].chara_poses[pose]
			
		else:
			current_sprite.texture = chara_list[chara].chara_poses["idle"]

	else:
		current_sprite.texture = null

func preload_dialogue_audio() -> void:
	dialogue_audio_cache.clear()
	if scene_script.is_empty():
		return
	for key in scene_script.keys():
		var block = scene_script[key]
		if typeof(block) != TYPE_DICTIONARY:
			continue
		if not block.has("line"):
			continue
		var audio_name = block["line"].get("audio")
		if audio_name == null or audio_name == "":
			continue
		get_audio_stream(audio_name)


func get_audio_stream(audio_name:String) -> AudioStream:
	if dialogue_audio_cache.has(audio_name):
		return dialogue_audio_cache[audio_name]

	var audio_path = AUDIO_ROOT + audio_name
	if not ResourceLoader.exists(audio_path):
		push_warning("Missing dialogue audio: %s" % audio_path)
		dialogue_audio_cache[audio_name] = null
		return null

	var stream = load(audio_path)
	dialogue_audio_cache[audio_name] = stream
	return stream

func play_voice(audio_name) -> void:
	if audio_name == null or audio_name == "":
		pending_audio_name = ""
		return
	if !audio_playback_enabled:
		pending_audio_name = audio_name
		return
	var stream = get_audio_stream(audio_name)
	if stream == null:
		return
	pending_audio_name = ""
	%VoicePlayer.stop()
	%VoicePlayer.stream = stream
	%VoicePlayer.play()


func stop_voice() -> void:
	if %VoicePlayer.playing:
		%VoicePlayer.stop()


func enable_audio_playback() -> void:
	audio_playback_enabled = true
	if pending_audio_name != "":
		play_voice(pending_audio_name)


func disable_audio_playback() -> void:
	audio_playback_enabled = false


func prepare_after_puzzle() -> void:
	if !waiting_for_puzzle_resume:
		return
	waiting_for_puzzle_resume = false
	load_next_line()
	load_block_to_ui(current_line)
