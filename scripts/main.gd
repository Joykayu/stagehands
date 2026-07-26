extends Node

var transition_scene = load("res://scenes/transition.tscn")
var state := "dialogue"

var chara_res_list : Dictionary = {
	"Player" = "res://assets/graphics/characters/player/player.tres",
	"Boss" = "res://assets/graphics/characters/boss/boss.tres",
	"Annabelle" = "res://assets/graphics/characters/annabelle/annabelle.tres",
	"Sarah" = "res://assets/graphics/characters/sarah/sarah.tres",
	"Fred" = "res://assets/graphics/characters/fred/fred.tres"
	}
	
var chara_res_dict : Dictionary = {}

var curr_dialogue_idx := 0
var dialogue_list = [
	"dialogue1.json",
	"dialogue2.json",
	"dialogue3.json",
	"dialogue4.json",
	"dialogue5.json",
	"dialogue6.json"
	]
var dialogue_path = "res://assets/dialogues/"

var curr_transition_idx := 0
var transitions_list = [
	"intro",
	"chapter1",
	"puzzle1",
	"puzzle1",
	"chapter2",
	"puzzle2",
	"puzzle2",
	"chapter3",
	"puzzle3",
	"puzzle3",
	"outro",
	"epilogue",
	"end"
]


func _ready():
	for key in chara_res_list.keys():
		chara_res_dict[key] = load(chara_res_list[key])
	$Menu/TextureRect/PlayButton.connect("pressed",on_play_button_pressed)

func on_play_button_pressed():
	$Menu/TextureRect/PlayButton.disabled = true
	$AudioManager.start()
	next_transition("dialogue")

func next_transition(type):
	$DialogSystem.is_active = false
	spawn_transition(type)
	
	await get_tree().create_timer(1.0).timeout
	if curr_transition_idx == 0:
		$Menu.queue_free()
	
	
	match type:
		"dialogue" :
			$DialogSystem.get_dialogue(dialogue_path + dialogue_list[curr_dialogue_idx])
			curr_dialogue_idx +=1
		"puzzle_in" :
			state = "puzzle"
			$PuzzleSystem.load_puzzle(transitions_list[curr_transition_idx])
			set_mouse_filter_recursive($DialogSystem, Control.MOUSE_FILTER_IGNORE)
			$DialogSystem.is_active = false
			$AudioManager.enter_puzzle()
		"puzzle_out":
			state = "dialogue"
			$DialogSystem.disable_audio_playback()
			$DialogSystem.prepare_after_puzzle()
			$PuzzleSystem.kill_puzzle()
			$AudioManager.exit_puzzle()
	
	curr_transition_idx += 1


func spawn_transition(type):
	# Skip the bell for the very first transition (menu -> intro), for puzzle in/out
	# transitions, and for the epilogue transitions (the last two: "epilogue" and "end").
	var is_puzzle_transition = type == "puzzle_in" or type == "puzzle_out"
	var transition_key = transitions_list[curr_transition_idx]
	var is_epilogue_transition = transition_key == "epilogue" or transition_key == "end"
	if curr_transition_idx != 0 and !is_puzzle_transition and !is_epilogue_transition:
		$AudioManager.play_transition_bell()
	var instance = transition_scene.instantiate()
	add_child(instance)
	instance.connect("transition_finished",on_transition_finished)
	instance.begin_transition(transitions_list[curr_transition_idx])

func on_transition_finished():
	match state:
		"dialogue":
			# Only let mouse input reach the dialog system once the transition has
			# fully finished playing (same gate used for re-enabling voice audio),
			# so clicks never go through while a transition is still on screen.
			set_mouse_filter_recursive($DialogSystem, Control.MOUSE_FILTER_STOP)
			$DialogSystem.enable_audio_playback()
			$DialogSystem.is_active = true
		"puzzle":
			#puzzle is active
			pass

func set_mouse_filter_recursive(node: Node, filter: Control.MouseFilter) -> void:
	if node is Control:
		node.mouse_filter = filter
	for child in node.get_children():
		set_mouse_filter_recursive(child, filter)
